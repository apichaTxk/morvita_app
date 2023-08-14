import 'dart:convert';
import 'dart:io';
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:morvita_app/navigation_menu/activity_board/activity_model/activity_model.dart';
import 'package:morvita_app/navigation_menu/activity_board/activity_map.dart';
import 'package:morvita_app/connect_to_http.dart';
import 'package:image_picker/image_picker.dart';

import 'package:http/http.dart' as Http;
import 'package:shared_preferences/shared_preferences.dart';

class Activity_create extends StatefulWidget {
  const Activity_create({Key? key}) : super(key: key);

  @override
  State<Activity_create> createState() => _Activity_createState();
}

class _Activity_createState extends State<Activity_create> {

  TextEditingController start_Activity_Date = TextEditingController();
  TextEditingController end_Activity_Date = TextEditingController();

  final formKey = GlobalKey<FormState>();

  double get_lat = 0.0;
  double get_long = 0.0;

  Color buttonColor = Colors.white;
  Color buttonTextColor = Colors.black87;
  String buttonText = "เพิ่มพิกัดกิจกรรม";

  Ab_model_add ab_add = Ab_model_add(
      ab_name: " ",
      ab_date: " ",
      ab_startDate: " ",
      ab_endDate: " ",
      ab_text: " ",
      ab_latitude: " ",
      ab_longitude: " ",
      ab_image_video: " ",
      u_id: 0
  );

  int latest_ab_id = 0;

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
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        title: Text(
          'สร้างกิจกรรม',
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
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
        child: Form(
          key: formKey,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[

                Container(
                  child: Row(
                    children: [
                      _headerText("พิกัดกิจกรรม"),
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
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => ActivityMap()),
                          ).then((value) {
                            if(value != null){
                              get_lat = value.latitude;
                              get_long = value.longitude;

                              ab_add.ab_latitude = get_lat.toString();
                              ab_add.ab_longitude = get_long.toString();

                              print(ab_add.ab_latitude);
                              print(ab_add.ab_longitude);

                              setState(() {
                                buttonColor = Colors.black;
                                buttonTextColor = Colors.white;
                                buttonText = "กำหนดพิกัดกิจกรรมแล้ว";
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
                      if(get_lat != 0.0 && get_long != 0.0)
                        TextButton(
                          child: Text(
                            'ถอนพิกัดกิจกรรม',
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

                                        get_lat = 0.0;
                                        get_long = 0.0;

                                        ab_add.ab_latitude = " ";
                                        ab_add.ab_longitude = " ";

                                        print(ab_add.ab_latitude);
                                        print(ab_add.ab_longitude);

                                        setState(() {
                                          buttonColor = Colors.white;
                                          buttonTextColor = Colors.black;
                                          buttonText = "เพิ่มพิกัดกิจกรรม";
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

                _headerText("รูปภาพกิจกรรม"),

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
                          _images.length == 6 ? "รูปภาพกิจกรรมครบ 6 ภาพแล้ว" : 'เพิ่มรูปภาพกิจกรรม (${6-_images.length})',
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

                _headerText("ข้อมูลกิจกรรม"),

                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'กรุณากรอกข้อมูล';
                      }
                      return null;
                    },
                    decoration: InputDecoration(
                      labelText: 'ชื่อกิจกรรม',
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
                    maxLength: 50,
                    maxLengthEnforcement: MaxLengthEnforcement.enforced,
                    keyboardType: TextInputType.text,
                    onSaved: (ab_name){
                      ab_add.ab_name = ab_name!;
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    minLines: 5,
                    maxLines: 5,
                    maxLength: 300,
                    maxLengthEnforcement: MaxLengthEnforcement.enforced,
                    keyboardType: TextInputType.multiline,
                    decoration: InputDecoration(
                      hintText: "ข้อความของคุณ",
                      hintStyle: TextStyle(
                        color: Colors.grey,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                      ),
                    ),
                    style: TextStyle(
                      fontFamily: "Prompt",
                    ),
                    onSaved: (ab_text){
                      ab_add.ab_text = ab_text!;
                    },
                  ),
                ),

                SizedBox(height: 20,),
                dateActivity_SE(context, "วันที่เริ่มกิจกรรม", start_Activity_Date, "Enter correct start date",),
                dateActivity_SE(context, "วันที่สิ้นสุดกิจกรรม", end_Activity_Date, "Enter correct end date",),

                SizedBox(height: 50,),
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
                                  ' สร้างกิจกรรม',
                                  style: TextStyle(
                                      fontFamily: 'Prompt',
                                      fontSize: 18,
                                      fontWeight: FontWeight.w600),
                                ),
                              ],
                            ),
                            onPressed: (){
                              final DateFormat formatter = DateFormat('yyyy-M-dd');
                              final String ab_date = formatter.format(DateTime.now());
                              ab_add.ab_date = set_new_date(ab_date);

                              final DateFormat dateFormat = DateFormat('yyyy-M-d');
                              DateTime startDate = dateFormat.parse(start_Activity_Date.text);
                              DateTime endDate = dateFormat.parse(end_Activity_Date.text);

                              ab_add.u_id = int.parse(userID);

                              if(_images.length >= 1){

                                if(endDate.isBefore(startDate)) {
                                  showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return AlertDialog(
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(20),
                                        ),
                                        title: Text(
                                          'วันที่สิ้นสุดกิจกรรมต้องเป็นวันเดียวกันหรือมากกว่าวันที่เริ่มกิจกรรม',
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
                                } else {
                                  ab_add.ab_startDate = set_new_date(start_Activity_Date.text);
                                  ab_add.ab_endDate = set_new_date(end_Activity_Date.text);

                                  if(formKey.currentState!.validate()){
                                    formKey.currentState!.save();
                                    Add_activity();
                                    formKey.currentState!.reset();
                                  }
                                }
                              }else{
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
                SizedBox(height: 80,),
              ],
            ),
          ),
        ),
      ),
    );
  }

  String set_new_date(String oldDate){
    String date = oldDate;
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

    return finish_date;
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

  Padding dateActivity_SE(BuildContext context, String lText, TextEditingController date_se, String emptyText) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextFormField(
        validator: (value) {
          if (value!.isEmpty) {
            return 'กรุณากรอกข้อมูล';
          }
          return null;
        },
        controller: date_se,
        onTap: () async{
          DateTime? pickeddate = await showDatePicker(
            context: context,
            initialDate: DateTime.now(),
            firstDate: DateTime(2000),
            lastDate: DateTime(2101),
          );

          if(pickeddate != null){
            setState(() {
              date_se.text = DateFormat('yyyy-M-dd').format(pickeddate);
            });
          }
        },

        decoration: InputDecoration(
          labelText: lText,
          labelStyle: TextStyle(
            fontFamily: "Prompt",
            color: Colors.grey,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          suffixIcon: Icon(Icons.calendar_today, color: Colors.black54,),
        ),
        style: TextStyle(
          fontFamily: "Prompt",
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

  Future Add_activity() async{
    showDialog(
      context: context,
      builder: (context) {
        return Center(
          child: CircularProgressIndicator(),
        );
      },
    );
    HttpOverrides.global = MyHttpOverrides();
    Uri url = Uri.parse("https://morvita.cocopatch.com/insert_activity.php");
    Map data = {
      "ab_name": ab_add.ab_name,
      "ab_date": ab_add.ab_date,
      "ab_startDate": ab_add.ab_startDate,
      "ab_endDate": ab_add.ab_endDate,
      "ab_text": ab_add.ab_text,
      "ab_latitude": ab_add.ab_latitude,
      "ab_longitude": ab_add.ab_longitude,
      "ab_image_video": ab_add.ab_image_video,
      "u_id": ab_add.u_id,
    };
    var response = await Http.post(url, body: json.encode(data));
    print(response.body);

    // Get data from API
    Uri url_get = Uri.parse("https://morvita.cocopatch.com/get_activity.php");
    var response_get = await Http.get(url_get);
    print(response_get.body);

    if(response_get.statusCode == 200){
      List jsonResponse = json.decode(response_get.body);
      if(jsonResponse.isNotEmpty){
        latest_ab_id = jsonResponse.first["ab_id"];
        print("Latest ab_id : $latest_ab_id");

        var numImg = _images.length;
        if(numImg >= 1){
          for(var i = 0; i < numImg; i++){
            uploadImage(_images[i], ab_add.u_id, "ab_id", latest_ab_id.toInt());
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
    final text = "อัพโหลดกิจกรรมเสร็จสิ้น";
    final snackBar = SnackBar(content: Text(text, style: TextStyle(fontFamily: "prompt"),),backgroundColor: Colors.green,);
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
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
