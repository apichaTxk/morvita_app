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

class DiscoveryEdit2 extends StatefulWidget {
  int ip_id = 0;
  var ip_name = "";
  var ip_date = "";
  var ip_number = "";
  var ip_latitude = "";
  var ip_longitude = "";
  var ip_type = "";
  var ip_plant = "";
  var ip_detail = "";
  int? il_id = null;
  List imageList = [];

  DiscoveryEdit2.setText(
      int ip_id,
      String ip_name,
      String ip_date,
      String ip_number,
      String ip_latitude,
      String ip_longitude,
      String ip_type,
      String ip_plant,
      String ip_detail,
      int? il_id,
      List imageList,
      ){
    this.ip_id = ip_id;
    this.ip_name = ip_name;
    this.ip_date = ip_date;
    this.ip_number = ip_number;
    this.ip_latitude = ip_latitude;
    this.ip_longitude = ip_longitude;
    this.ip_type = ip_type;
    this.ip_plant = ip_plant;
    this.ip_detail = ip_detail;
    this.il_id = il_id;
    this.imageList = imageList;
  }

  @override
  State<DiscoveryEdit2> createState() => _DiscoveryEdit2State(ip_id,ip_name,ip_date,ip_number,ip_latitude,ip_longitude,ip_type,ip_plant,ip_detail,il_id,imageList);
}

class _DiscoveryEdit2State extends State<DiscoveryEdit2> {

  int ip_id = 0;
  var ip_name = TextEditingController();
  var ip_date = "";
  var ip_number = TextEditingController();
  var ip_latitude = "";
  var ip_longitude = "";
  var ip_type = "";
  var ip_plant = TextEditingController();
  var ip_detail = TextEditingController();
  int? il_id = null;
  List imageList = [];

  _DiscoveryEdit2State(
      int ip_id,
      String ip_name,
      String ip_date,
      String ip_number,
      String ip_latitude,
      String ip_longitude,
      String ip_type,
      String ip_plant,
      String ip_detail,
      int? il_id,
      List imageList,
      ){
    this.ip_id = ip_id;
    this.ip_name.text = ip_name;
    this.ip_date = ip_date;
    this.ip_number.text = ip_number;
    this.ip_latitude = ip_latitude;
    this.ip_longitude = ip_longitude;
    this.ip_type = ip_type;
    this.ip_plant.text = ip_plant;
    this.ip_detail.text = ip_detail;
    this.il_id = il_id;
    this.imageList = imageList;
  }

  //================================================================

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

  String get_lat = "";
  String get_long = "";

  final ImagePicker _picker = ImagePicker();
  List<XFile> _images = [];

  String userID = "";

  @override
  void initState(){
    super.initState();
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        title: Text(
          'แก้ไขจุดที่พบแมลง',
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
                        "โปรดจำไว้ว่าหากไม่มีการเปลี่ยนแปลงใดๆของข้อมูล ระบบจะไม่มีการบันทึกใดๆทั้งสิ้น หากผู้ใช้ต้องการเปลี่ยนแปลงข้อมูลกรุณาให้ข้อมูลใหม่กับเรา",
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
                            get_lat = value.latitude.toString();
                            get_long = value.longitude.toString();

                            print(get_lat);
                            print(get_long);

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
                    if(get_lat != "" && get_long != "")
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

                                      get_lat = "";
                                      get_long = "";

                                      print(ip_latitude);
                                      print(ip_longitude);

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

                                print(get_il_id);
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

                                      print(il_id);

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
                                                print(_images.length);
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

              insect_field("ชื่อแมลง", 0, ip_name),
              insect_field("จำนวนแมลง", 1, ip_number),
              insect_field("พืชอาหาร", 2, ip_plant),
              dropdown_field("ชนิดของแมลง :", ip_type, typeOfInsect_Dropdown, "เลือกชนิดแมลง", 0, 0, 40),

              SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  controller: ip_detail,
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
                  onSaved: (ip_detaili){
                    ip_detail.text = ip_detaili!;
                  },
                ),
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
                                'แก้ไขจุดที่ค้นพบแมลง',
                                style: TextStyle(
                                    fontFamily: 'Prompt',
                                    fontSize: 18,
                                    fontWeight: FontWeight.w600),
                              ),
                            ],
                          ),
                          onPressed: () {
                            if(get_lat != "" && get_long != ""){
                              ip_latitude = get_lat;
                              ip_longitude = get_long;
                            }
                            if(get_il_id != null){
                              il_id = get_il_id!;
                            }
                            if(_images.length > 0){
                              for(int i=0; i<imageList.length; i++){
                                delete_image(int.parse(imageList[i]["id"]));
                              }
                              for(int j=0; j<_images.length; j++){
                                uploadImage(_images[j], userID, "ip_id", ip_id);
                              }
                            }
                            Update_discovery();
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

  Padding insect_field(String labelName, int state_data, TextEditingController textx) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextFormField(
        controller: textx,
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
            case 0: ip_name.text = dataSource!;break;
            case 1: ip_number.text = dataSource!;break;
            case 2: ip_plant.text = dataSource!;break;
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
                value: selectedType = selected,
                items: sourceData.map((item) => DropdownMenuItem(
                  value: item,
                  child: Text(item, style: TextStyle(fontFamily: "Prompt"),),
                )).toList(),
                onChanged: (item) => setState(() {
                  if(state_ui == 0){
                    selectedType = item;
                  }

                  switch (state_data){
                    case 0: ip_type = item!;break;
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

  Future Update_discovery() async{
    HttpOverrides.global = MyHttpOverrides();
    Uri url = Uri.parse("https://morvita.cocopatch.com/update_insectpoint.php");
    Map data = {
      "ip_id": ip_id,
      "ip_name": ip_name.text,
      "ip_date": ip_date,
      "ip_number": ip_number.text,
      "ip_latitude": ip_latitude,
      "ip_longitude": ip_longitude,
      "ip_type": ip_type,
      "ip_plant": ip_plant.text,
      "ip_detail": ip_detail.text,
      "ip_image": "",
      "il_id": il_id,
    };
    var response = await Http.post(url, body: json.encode(data));
    print(response.body);
    Navigator.of(context).pop(true);
  }

  Future<void> uploadImage(XFile imageFile, String u_id, String field, int field_id) async {
    var uri = Uri.parse('https://morvita.cocopatch.com/insert_images_file.php');

    var request = Http.MultipartRequest('POST', uri)
      ..fields['u_id'] = u_id
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

  Future delete_image(int id) async{
    HttpOverrides.global = MyHttpOverrides();
    Uri url = Uri.parse("https://morvita.cocopatch.com/delete_file_images.php");
    Map data = {
      "images_id": id,
    };
    var response = await Http.post(url, body: json.encode(data));
    print(response.body);
  }
}
