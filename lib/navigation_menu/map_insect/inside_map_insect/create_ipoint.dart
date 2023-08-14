import 'dart:convert';
import 'dart:io';
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:morvita_app/navigation_menu/map_insect/inside_map_insect/dialog_ipoint.dart';
import 'package:morvita_app/navigation_menu/map_insect/inside_map_insect/map_ipoint.dart';
import 'package:morvita_app/connect_to_http.dart';
import 'package:morvita_app/navigation_menu/feed_board/feed_create.dart';

import 'package:http/http.dart' as Http;

import 'package:flutter/foundation.dart';
import 'package:morvita_app/navigation_menu/map_insect/inside_map_insect/ipoint_model/ipoint_model.dart';
import 'package:shared_preferences/shared_preferences.dart';


class Create_ipoint extends StatefulWidget {
  const Create_ipoint({Key? key}) : super(key: key);

  @override
  State<Create_ipoint> createState() => _Create_ipointState();
}

class _Create_ipointState extends State<Create_ipoint> {

  String? _currentAddress;
  Position? _currentPosition;

  Future<bool> _handleLocationPermission() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text(
              'Location services are disabled. Please enable the services')));
      return false;
    }
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Location permissions are denied')));
        return false;
      }
    }
    if (permission == LocationPermission.deniedForever) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text(
              'Location permissions are permanently denied, we cannot request permissions.')));
      return false;
    }
    return true;
  }

  Future<void> _getCurrentPosition() async {
    final hasPermission = await _handleLocationPermission();

    if (!hasPermission) return;
    await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high)
        .then((Position position) {
      setState(() => _currentPosition = position);
      _getAddressFromLatLng(_currentPosition!);
    }).catchError((e) {
      debugPrint(e);
    });

    current_lat = '${_currentPosition?.latitude ?? ""}'.toString();
    current_long = '${_currentPosition?.longitude ?? ""}'.toString();

    ip_add.ip_latitude = current_lat;
    ip_add.ip_longitude= current_long;

    print("ip_latitude : ${ip_add.ip_latitude}");
    print("ip_longitude : ${ip_add.ip_longitude}");
  }

  Future<void> _getAddressFromLatLng(Position position) async {
    await placemarkFromCoordinates(
        _currentPosition!.latitude, _currentPosition!.longitude)
        .then((List<Placemark> placemarks) {
      Placemark place = placemarks[0];
      setState(() {
        _currentAddress =
        '${place.street}, ${place.subLocality}, ${place.subAdministrativeArea}, ${place.postalCode}';
      });
    }).catchError((e) {
      debugPrint(e);
    });
  }

  //---------------------------------------------------------------------------

  final formKey = GlobalKey<FormState>();

  List<String> typeOfInsect_Dropdown = ["ผีเสื้อ", "แมลงปอ", "แมลงปีกแข็ง"];
  String? selectedType;

  int? get_il_id = null;
  String get_il_localName = "";
  String get_il_type = "";

  Color buttonColor = Colors.white;
  Color buttonTextColor = Colors.black87;
  String buttonText = "อ้างอิงข้อมูลแมลง";

  Color mapColor = Colors.white;
  Color mapTextColor = Colors.black87;
  String mapText = "เปลี่ยนพิกัดจุดที่พบแมลง";

  double get_lat = 0.0;
  double get_long = 0.0;

  String current_lat = "";
  String current_long = "";

  bool isSwitched = false;

  Ipoint_model ip_add = Ipoint_model(
      ip_name: " ",
      ip_date: " ",
      ip_number: " ",
      ip_latitude: " ",
      ip_longitude: " ",
      ip_type: " ",
      ip_plant: " ",
      ip_detail: " ",
      ip_image: " ",
      il_id: null,
      u_id: 0,
  );

  int latest_ip_id = 0;

  final ImagePicker _picker = ImagePicker();
  List<XFile> _images = [];

  String userID = "";

  @override
  void initState(){
    super.initState();
    _getCurrentPosition();
    show_sh();
  }

  Future<void> show_sh() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      setState(() {
        userID = prefs.getString('u_id')!;
      });
    } catch (e) {
      print("ERROR_show_sh : $e");
    }
    print("user id = $userID");
  }
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        title: Text(
          'เพิ่มจุดที่พบแมลง',
          style: TextStyle(
            fontFamily: "Prompt",
            fontWeight: FontWeight.w600,
            color: Color(0xFF0A4483),
          ),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios),
          color: Colors.black54,
          onPressed: (){
            Navigator.pop(context);
          },
        ),
      ),

      body: Container(
        padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
        child: Form(
          key: formKey,
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[

                Container(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _headerText("พิกัดจุดที่พบแมลง"),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(8, 0, 8, 8),
                        child: Text(
                          "พิกัดจุดที่พบแมลงจะใช้ \"ตำแหน่งปัจจุบันของคุณ\" เป็นตำแหน่งของแมลงที่คุณค้นพบ "
                              "หากต้องการแก้ไขพิกัดจุดที่พบแมลงให้กดที่ \"แก้ไขจุดที่พบแมลง\"",
                          style: TextStyle(
                              fontFamily: 'prompt',
                              color: Colors.black54,
                              fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                Padding(
                  padding: const EdgeInsets.all(10),
                  child: Column(
                    children: [
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          primary: mapColor,
                          elevation: 8,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          padding: EdgeInsets.symmetric(horizontal: 60, vertical: 20),
                        ),
                        onPressed: (){
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => MapIpoint()),
                          ).then((value) {
                            if(value != null){
                              get_lat = value.latitude;
                              get_long = value.longitude;

                              ip_add.ip_latitude = get_lat.toString();
                              ip_add.ip_longitude = get_long.toString();

                              print(ip_add.ip_latitude);
                              print(ip_add.ip_longitude);

                              setState(() {
                                mapColor = Colors.black;
                                mapTextColor = Colors.white;
                                mapText = "กำหนดพิกัดใหม่แล้ว";
                              });
                            }
                          });
                        },
                        child: Text(
                          mapText,
                          style: TextStyle(
                            fontFamily: "Prompt",
                            fontSize: 18,
                            color: mapTextColor,
                          ),
                        ),
                      ),
                      SizedBox(height: 10,),
                      if(get_lat != 0.0 && get_long != 0.0)
                        TextButton(
                          child: Text(
                            'กลับไปใช้ตำแหน่งปัจจุบัน',
                            style: TextStyle(
                              fontFamily: "Prompt",
                              color: Colors.red,
                              fontSize: 16,
                              decoration: TextDecoration.underline,
                            ),
                          ),
                          onPressed: () {
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  title: Text(
                                    'คุณต้องการกลับไปใช้พิกัดตำแหน่งของคุณหรือไม่',
                                    style: TextStyle(
                                      fontFamily: "prompt",
                                    ),
                                  ),
                                  actions: <Widget>[
                                    TextButton(
                                      child: Text(
                                        'ยกเลิก',
                                        style: TextStyle(
                                          fontFamily: "prompt",
                                          color: Colors.grey
                                        ),
                                      ),
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                    ),
                                    TextButton(
                                      child: Text(
                                        'ยืนยัน',
                                        style: TextStyle(
                                          fontFamily: "prompt",
                                          fontWeight: FontWeight.w600,
                                          color: Colors.blue,
                                        ),
                                      ),
                                      onPressed: () {

                                        get_lat = 0.0;
                                        get_long = 0.0;

                                        ip_add.ip_latitude = current_lat;
                                        ip_add.ip_longitude = current_long;

                                        print(ip_add.ip_latitude);
                                        print(ip_add.ip_longitude);

                                        setState(() {
                                          mapColor = Colors.white;
                                          mapTextColor = Colors.black;
                                          mapText = "เปลี่ยนพิกัดจุดที่พบแมลง";
                                        });

                                        Navigator.of(context).pop();
                                      },
                                    ),
                                  ],
                                );
                              },
                            );
                          },
                        ),
                    ],
                  ),
                ),

                Container(
                  child: Row(
                    children: [
                      _headerText("อ้างอิงข้อมูลแมลง"),
                      Text("(ไม่บังคับ)", style: TextStyle(fontFamily: 'prompt', color: Colors.black54, fontWeight: FontWeight.w500),),
                    ],
                  ),
                ),
                
                Padding(
                  padding: const EdgeInsets.all(10),
                  child: Column(
                    children: [
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          primary: buttonColor,
                          elevation: 8,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          padding: EdgeInsets.symmetric(horizontal: 60, vertical: 20),
                        ),
                        onPressed: (){
                          showMenu(
                            context: context,
                            position: RelativeRect.fromLTRB(80.0, 220.0, 70.0, 0.0),
                            items: [
                              PopupMenuItem(
                                child: Text("ผีเสื้อ", style: TextStyle(fontFamily: "prompt"),),
                                value: "ผีเสื้อ",
                              ),
                              PopupMenuItem(
                                child: Text('แมลงปอ', style: TextStyle(fontFamily: "prompt"),),
                                value: "แมลงปอ",
                              ),
                              PopupMenuItem(
                                child: Text('แมลงปีกแข็ง', style: TextStyle(fontFamily: "prompt"),),
                                value: "แมลงปีกแข็ง",
                              ),
                            ],
                            elevation: 8.0,
                            semanticLabel: 'PopupMenu',
                          ).then((value) {
                            if (value != null) {
                              showDialog(
                                  context: context,
                                  builder: (BuildContext context){
                                    return DialogIpoint(titleText: value,);
                                  }
                              ).then((value) {
                                if (value != null) {
                                  // ทำสิ่งที่คุณต้องการกับค่าที่ส่งกลับมา
                                  print(value);

                                  // แยกข้อมูลและส่งไปยังค่าต่างๆ
                                  get_il_id = value["il_id"];
                                  get_il_localName = value["il_localName"];
                                  get_il_type = value["il_type"];

                                  ip_add.il_id = get_il_id;

                                  print(ip_add.il_id);
                                  print(get_il_localName);
                                  print(get_il_type);

                                  setState(() {
                                    buttonColor = Colors.black;
                                    buttonTextColor = Colors.white;
                                    buttonText = "$get_il_localName\n($get_il_type)";
                                  });
                                }
                              });
                            }
                          });
                        },
                        child: Text(
                          buttonText,
                          style: TextStyle(
                              fontFamily: "Prompt",
                              fontSize: 18,
                              color: buttonTextColor,
                          ),
                        ),
                      ),
                      SizedBox(height: 10,),
                      if(get_il_id != null)
                        TextButton(
                          child: Text(
                            'ยกเลิกการอ้างอิง',
                            style: TextStyle(
                              fontFamily: "Prompt",
                              color: Colors.red,
                              fontSize: 16,
                              decoration: TextDecoration.underline,
                            ),
                          ),
                          onPressed: () {
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  title: Text(
                                    'คุณต้องการลบการอ้างอิงข้อมูลแมลงหรือไม่',
                                    style: TextStyle(
                                      fontFamily: "prompt",
                                    ),
                                  ),
                                  actions: <Widget>[
                                    TextButton(
                                      child: Text(
                                        'ยกเลิก',
                                        style: TextStyle(
                                          fontFamily: "prompt",
                                        ),
                                      ),
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                    ),
                                    TextButton(
                                      child: Text(
                                        'ยืนยันการลบ',
                                        style: TextStyle(
                                          fontFamily: "prompt",
                                          color: Colors.red,
                                        ),
                                      ),
                                      onPressed: () {

                                        get_il_id = null;
                                        get_il_localName = "";
                                        get_il_type = "";

                                        ip_add.il_id = get_il_id;

                                        print(ip_add.il_id);
                                        print(get_il_localName);
                                        print(get_il_type);

                                        setState(() {
                                          buttonColor = Colors.white;
                                          buttonTextColor = Colors.black;
                                          buttonText = "อ้างอิงข้อมูลแมลง";
                                        });

                                        Navigator.of(context).pop();
                                      },
                                    ),
                                  ],
                                );
                              },
                            );
                          },
                        ),
                    ],
                  ),
                ),

                _headerText("ข้อมูลรูปภาพแมลง"),

                Padding(
                  padding: const EdgeInsets.all(10),
                  child: Column(
                    children: [
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          primary: _images.length == 6 ? Colors.grey : Colors.white,
                          elevation: 8,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(_images.isEmpty ? 20 : 10),
                          ),
                          padding: EdgeInsets.symmetric(horizontal: _images.isEmpty ? 60 : 20, vertical: _images.isEmpty ? 20 : 10),
                        ),
                        onPressed: _images.length == 6 ? null : _addPhotoLibrary,
                        child: Text(
                          _images.length == 6 ? "รูปภาพแมลงครบ 6 ภาพแล้ว" : 'เพิ่มรูปภาพแมลง (${6-_images.length})',
                          style: TextStyle(
                            fontFamily: "Prompt",
                            fontSize: _images.isEmpty ? 18 : null,
                            color: _images.length == 6 ? Colors.black54 : Color(0xFF0A4483)
                          ),
                        ),
                      ),
                      SizedBox(height: _images.isEmpty ? 0 : 15,),
                      Container(
                        height: _images.isEmpty ? 0 : (_images.length > 3 ? 220 : 110),
                        child: GridView.count(
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          crossAxisCount: 3,
                          crossAxisSpacing: 10,
                          mainAxisSpacing: 10,
                          children: List.generate(_images.length, (index) {
                            return Stack(
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(10.0),
                                  child: SizedBox(
                                    height: MediaQuery.of(context).size.width / 3 - 10,
                                    width: MediaQuery.of(context).size.width / 3 - 10,
                                    child: Image.file(
                                      File(_images[index].path),
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                                Positioned(
                                  top: 5,
                                  right: 5,
                                  child: GestureDetector(
                                    onTap: () {
                                      showDialog(
                                        context: context,
                                        builder: (BuildContext context) {
                                          return AlertDialog(
                                            shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.circular(20),
                                            ),
                                            title: Text(
                                              'ลบรูปภาพนี้หรือไม่',
                                              style: TextStyle(
                                                fontFamily: "Prompt"
                                              ),
                                            ),
                                            content: ClipRRect(
                                              borderRadius: BorderRadius.circular(10),
                                              child: Image.file(
                                                File(_images[index].path),
                                                fit: BoxFit.cover,
                                              ),
                                            ),
                                            actions: [
                                              TextButton(
                                                onPressed: () {
                                                  Navigator.of(context).pop();
                                                },
                                                child: Text(
                                                  'ยกเลิก',
                                                  style: TextStyle(
                                                      fontFamily: "Prompt"
                                                  ),
                                                ),
                                              ),
                                              TextButton(
                                                onPressed: () {
                                                  setState(() {
                                                    _images.removeAt(index);
                                                  });
                                                  Navigator.of(context).pop();
                                                },
                                                child: Text(
                                                  'ลบรูปภาพ',
                                                  style: TextStyle(
                                                    fontFamily: "Prompt",
                                                    color: Colors.red,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          );
                                        },
                                      );
                                    },
                                    child: Container(
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: Colors.red,
                                      ),
                                      child: Icon(
                                        Icons.close,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            );
                          }),
                        ),
                      ),
                    ],
                  ),
                ),

                Divider(
                  color: Colors.grey,  // specify the color of the line
                  thickness: 2,  // specify the thickness of the line
                  height: 40,  // specify the height of the line
                ),

                _headerText("ข้อมูลเบื้องต้น"),

                insect_field("ชื่อแมลง", 0),
                insect_field("จำนวนแมลง", 1),
                insect_field("พืชอาหาร", 2),
                dropdown_field("ชนิดของแมลง :", selectedType, typeOfInsect_Dropdown, "เลือกชนิดแมลง", 0, 0, 40),

                SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    minLines: 5,
                    maxLines: 5,
                    maxLength: 300,
                    maxLengthEnforcement: MaxLengthEnforcement.enforced,
                    keyboardType: TextInputType.multiline,
                    decoration: InputDecoration(
                      hintText: "รายละเอียดเพิ่มเติม",
                      hintStyle: TextStyle(
                        fontFamily: "Prompt",
                        color: Colors.grey,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                      ),
                    ),
                    style: TextStyle(
                      fontFamily: "Prompt",
                    ),
                    onSaved: (ip_detail){
                      ip_add.ip_detail = ip_detail!;
                    },
                  ),
                ),
                SizedBox(height: 30,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.send,
                        ),
                        SizedBox(width: 5,),
                        Text(
                          "แชร์จุดที่พบแมลงไปยังหน้าฟีด",
                          style: TextStyle(
                            fontFamily: "Prompt",
                            fontSize: 18,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(width: 20,),
                    Switch(
                      value: isSwitched,
                      onChanged: (value) {
                        setState(() {
                          isSwitched = value;
                          print(isSwitched);
                        });
                      },
                    ),
                  ],
                ),
                SizedBox(height: 30,),
                Container(
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Container(
                          width: 300,
                          height: 60,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(15)),
                            boxShadow: [
                              BoxShadow(
                                color: Color(0xFF0A4483).withOpacity(0.5),
                                spreadRadius: 4,
                                blurRadius: 10,
                              ),
                            ],
                          ),
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              fixedSize: Size(300, 60),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15),
                              ),
                              primary: Colors.transparent,
                              shadowColor: Colors.transparent,
                              backgroundColor: Color(0xFF0A4483),
                              elevation: 0,
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  'เพิ่มจุดที่ค้นพบแมลง',
                                  style: TextStyle(
                                      fontFamily: 'Prompt',
                                      fontSize: 18,
                                      fontWeight: FontWeight.w600),
                                ),
                              ],
                            ),
                            onPressed: () {
                              final DateFormat formatter = DateFormat('yyyy-M-dd');
                              final String ip_date = formatter.format(DateTime.now());
                              //ip_add.ip_date = ip_date;

                              String date = ip_date;
                              List<String> dateParts = date.split('-');

                              switch (dateParts[1]){
                                case "1": dateParts[1] = "มกราคม";break;
                                case "2": dateParts[1] = "กุมภาพันธ์";break;
                                case "3": dateParts[1] = "มีนาคม";break;
                                case "4": dateParts[1] = "เมษายน";break;
                                case "5": dateParts[1] = "พฤษภาคม";break;
                                case "6": dateParts[1] = "มิถุนายน";break;
                                case "7": dateParts[1] = "กรกฎาคม";break;
                                case "8": dateParts[1] = "สิงหาคม";break;
                                case "9": dateParts[1] = "กันยายน";break;
                                case "10": dateParts[1] = "ตุลาคม";break;
                                case "11": dateParts[1] = "พฤศจิกายน";break;
                                case "12": dateParts[1] = "ธันวาคม";break;
                              }

                              int new_year = int.parse(dateParts[0])+543;

                              String finish_date = "${dateParts[2]} ${dateParts[1]} ${new_year}";

                              ip_add.ip_date = finish_date;
                              ip_add.u_id = int.parse(userID);

                              if(_images.length >= 1){

                                if(selectedType != null){
                                  if(formKey.currentState!.validate()){
                                    formKey.currentState!.save();
                                    Add_ipoint();
                                    formKey.currentState!.reset();
                                  }
                                } else{
                                  showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return AlertDialog(
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(20),
                                        ),
                                        title: Text(
                                          'กรุณาใส่ข้อมูล \"ชนิดของแมลง\"',
                                          style: TextStyle(
                                            fontFamily: 'prompt',
                                          ),
                                        ),
                                        actions: <Widget>[
                                          TextButton(
                                            child: Text(
                                              'เข้าใจแล้ว',
                                              style: TextStyle(
                                                  fontFamily: 'prompt',
                                                  color: Colors.blue
                                              ),
                                            ),
                                            onPressed: () {
                                              Navigator.pop(context);
                                            },
                                          ),
                                        ],
                                      );
                                    },
                                  );
                                }
                              } else{
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                      title: Text(
                                        'กรุณาใส่รูปอย่างน้อย 1 รูป',
                                        style: TextStyle(
                                          fontFamily: 'prompt',
                                        ),
                                      ),
                                      actions: <Widget>[
                                        TextButton(
                                          child: Text(
                                            'เข้าใจแล้ว',
                                            style: TextStyle(
                                                fontFamily: 'prompt',
                                                color: Colors.blue
                                            ),
                                          ),
                                          onPressed: () {
                                            Navigator.pop(context);
                                          },
                                        ),
                                      ],
                                    );
                                  },
                                );
                              }
                            },
                          ),
                        ),

                        SizedBox(height: 20,),
                        TextButton(
                          child: Text(
                            'ยกเลิก',
                            style: TextStyle(
                              fontFamily: "Prompt",
                              color: Colors.red,
                              fontSize: 16,
                              decoration: TextDecoration.underline,
                            ),
                          ),
                          onPressed: () => Navigator.pop(context),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 80,)
              ],
            ),
          ),
        ),
      ),
    );
  }

  Padding _headerText(String headText) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Align(
        alignment: Alignment.centerLeft, // ใส่ค่านี้เพื่อให้ข้อความอยู่ทางซ้ายของจอ
        child: Text(
          headText,
          style: TextStyle(
            fontFamily: "Prompt",
            fontWeight: FontWeight.w600,
            fontSize: 18,
            color: Colors.blueAccent,
          ),
        ),
      ),
    );
  }

  Future<void> _addPhotoLibrary() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if(image != null) {

      //check image size before add to list
      File imageFile = File(image.path);
      int imageSize = imageFile.lengthSync();
      print('Image size: ${imageSize} bit');

      if(imageSize <= 3145728){
        setState(() {
          _images.add(image);
        });
      }else{
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              title: Text(
                'รูปภาพมีขนาดใหญ่เกินไป',
                style: TextStyle(
                  fontFamily: "prompt",
                  color: Colors.red,
                ),
              ),
              content: Text(
                'รูปภาพจะต้องมีขนาดไม่เกิน 3 MB',
                style: TextStyle(
                  fontFamily: "prompt",
                ),
              ),
              actions: <Widget>[
                TextButton(
                  child: Text(
                    'รับทราบ',
                    style: TextStyle(
                      fontFamily: "prompt",
                    ),
                  ),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            );
          },
        );
      }
    }
    //Check image in List
    var nol = _images.length;
    print("Number of image in list : $nol");
  }

  Padding insect_field(String labelName, int state_data) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextFormField(
        validator: (value) {
          if (value!.isEmpty) {
            return 'กรุณากรอกข้อมูล';
          }
          return null;
        },
        decoration: InputDecoration(
          labelText: labelName,
          labelStyle: TextStyle(
            fontFamily: "Prompt",
            color: Colors.grey,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
          ),
        ),
        style: TextStyle(
          fontFamily: "Prompt",
        ),
        keyboardType: (state_data == 1)? TextInputType.number : TextInputType.text,
        maxLength: (state_data == 1)? 4 : 50,
        onSaved: (dataSource){
          switch (state_data){
            case 0: ip_add.ip_name = dataSource!;break;
            case 1: ip_add.ip_number = dataSource!;break;
            case 2: ip_add.ip_plant = dataSource!;break;
          }
        },
      ),
    );
  }

  Padding dropdown_field(String headText, String? selected, List<String> sourceData, String labelText, int state_ui, int state_data, double size_width) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            headText,
            style: TextStyle(
              fontFamily: "Prompt",
              fontSize: 18,
            ),
          ),
          SizedBox(width: size_width,),
          Expanded(
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 10),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(20),
              ),
              child: DropdownButton<String>(
                isExpanded: true,
                value: selected,
                items: sourceData.map((item) => DropdownMenuItem(
                  value: item,
                  child: Text(item, style: TextStyle(fontFamily: "Prompt"),),
                )).toList(),
                onChanged: (item) => setState(() {
                  if(state_ui == 0){
                    selectedType = item;
                  }

                  switch (state_data){
                    case 0: ip_add.ip_type = item!;break;
                  }
                }),
                hint: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    labelText,
                    style: TextStyle(color: Colors.grey, fontFamily: "Prompt"),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future Add_ipoint() async{
    showDialog(
      context: context,
      builder: (context) {
        return Center(
          child: CircularProgressIndicator(),
        );
      },
    );
    HttpOverrides.global = MyHttpOverrides();
    Uri url = Uri.parse("https://morvita.cocopatch.com/insert_insectpoint.php");
    Map data = {
      "ip_name": ip_add.ip_name,
      "ip_date": ip_add.ip_date,
      "ip_number": ip_add.ip_number,
      "ip_latitude": ip_add.ip_latitude,
      "ip_longitude": ip_add.ip_longitude,
      "ip_type": ip_add.ip_type,
      "ip_plant": ip_add.ip_plant,
      "ip_detail": ip_add.ip_detail,
      "ip_image": ip_add.ip_image,
      "il_id": ip_add.il_id,
      "u_id": ip_add.u_id
    };
    var response = await Http.post(url, body: json.encode(data));
    print(response.body);

    // Get data from API
    Uri url_get = Uri.parse("https://morvita.cocopatch.com/get_insectpoint.php");
    var response_get = await Http.get(url_get);
    print(response_get.body);

    if(response_get.statusCode == 200){
      List jsonResponse = json.decode(response_get.body);
      if(jsonResponse.isNotEmpty){
        latest_ip_id = jsonResponse.first["ip_id"];
        print("Latest ip_id : $latest_ip_id");

        var numImg = _images.length;
        if(numImg >= 1){
          for(var i = 0; i < numImg; i++){
            uploadImage(_images[i], ip_add.u_id, "ip_id", latest_ip_id.toInt());
          }
          Navigator.pop(context);
        }else{
          print("No images");
        }

      }else{
        throw Exception("No data found");
      }
    }else{
      throw Exception("Failed to load data from API");
    }
    Navigator.pop(context);
    final text = "อัพโหลดข้อมูลจุดที่พบแมลงเสร็จสิ้น";
    final snackBar = SnackBar(content: Text(text, style: TextStyle(fontFamily: "prompt"),),backgroundColor: Colors.green,);
    ScaffoldMessenger.of(context).showSnackBar(snackBar);

    if(isSwitched == true){
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => Feed_create.setText(
            ip_add.u_id,
            latest_ip_id,
            _images,
            ip_add.ip_name,
          ),
        ),
      ).then((value) {
        setState(() {});
      });
    }
  }

  Future<void> uploadImage(XFile imageFile, int u_id, String field, int field_id) async {
    var uri = Uri.parse('https://morvita.cocopatch.com/insert_images_file.php');

    var request = Http.MultipartRequest('POST', uri)
      ..fields['u_id'] = u_id.toString()
      ..fields['field'] = field
      ..fields['field_id'] = field_id.toString()
      ..files.add(await Http.MultipartFile.fromPath('image', imageFile.path));

    var response = await request.send();

    print(response.statusCode);

    if (response.statusCode == 200 || response.statusCode == 201) {
      print("Upload successful");
    } else {
      print("Upload failed");
    }
  }
}
