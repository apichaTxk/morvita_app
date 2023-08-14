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

class ActivityEdit2 extends StatefulWidget {
  var ab_name = " ";
  var ab_date = " ";
  var ab_startDate = " ";
  var ab_endDate = " ";
  var ab_text = " ";
  var ab_latitude = " ";
  var ab_longitude = " ";
  var ab_image_video = " ";
  int ab_id = 0;
  List imageList = [];

  ActivityEdit2.setText(
      String ab_name,
      String ab_date,
      String ab_startDate,
      String ab_endDate,
      String ab_text,
      String ab_latitude,
      String ab_longitude,
      String ab_image_video,
      int ab_id,
      List imageList)
  {
    this.ab_name = ab_name;
    this.ab_date = ab_date;
    this.ab_startDate = ab_startDate;
    this.ab_endDate = ab_endDate;
    this.ab_text = ab_text;
    this.ab_latitude = ab_latitude;
    this.ab_longitude = ab_longitude;
    this.ab_image_video = ab_image_video;
    this.ab_id = ab_id;
    this.imageList = imageList;
  }

  @override
  State<ActivityEdit2> createState() => _ActivityEdit2State(ab_name, ab_date, ab_startDate, ab_endDate, ab_text, ab_latitude, ab_longitude, ab_image_video, ab_id, imageList);
}

class _ActivityEdit2State extends State<ActivityEdit2> {

  var ab_name = TextEditingController();
  var ab_date = " ";
  var ab_startDate = TextEditingController();
  var ab_endDate = TextEditingController();
  var ab_text = TextEditingController();
  var ab_latitude = " ";
  var ab_longitude = " ";
  var ab_image_video = " ";
  int ab_id = 0;
  List imageList = [];

  _ActivityEdit2State(
      String ab_name,
      String ab_date,
      String ab_startDate,
      String ab_endDate,
      String ab_text,
      String ab_latitude,
      String ab_longitude,
      String ab_image_video,
      int ab_id,
      List imageList,)
  {
    this.ab_name.text = ab_name;
    this.ab_date = ab_date;
    this.ab_startDate.text = ab_startDate;
    this.ab_endDate.text = ab_endDate;
    this.ab_text.text = ab_text;
    this.ab_latitude = ab_latitude;
    this.ab_longitude = ab_longitude;
    this.ab_image_video = ab_image_video;
    this.ab_id = ab_id;
    this.imageList = imageList;
  }

  //============================================================================

  String get_lat = "";
  String get_long = "";

  Color buttonColor = Colors.white;
  Color buttonTextColor = Colors.black87;
  String buttonText = "เพิ่มพิกัดกิจกรรม";

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        title: Text(
          'แก้ไขกิจกรรม',
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
                            get_lat = value.latitude.toString();
                            get_long = value.longitude.toString();

                            print(get_lat);
                            print(get_long);

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
                    if(get_lat != "" && get_long != "")
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

                                      get_lat = "";
                                      get_long = "";

                                      print(ab_latitude);
                                      print(ab_longitude);

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
                  controller: ab_name,
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
                  onSaved: (ab_namex){
                    ab_name.text = ab_namex!;
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  controller: ab_text,
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
                  onSaved: (ab_textx){
                    ab_text.text = ab_textx!;
                  },
                ),
              ),

              SizedBox(height: 20,),
              dateActivity_SE(context, "วันที่เริ่มกิจกรรม", ab_startDate, "Enter correct start date",),
              dateActivity_SE(context, "วันที่สิ้นสุดกิจกรรม", ab_endDate, "Enter correct end date",),

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
                            if(get_lat != "" && get_long != ""){
                              ab_latitude = get_lat;
                              ab_longitude = get_long;
                            }
                            if(_images.length > 0){
                              for(int i=0; i<imageList.length; i++){
                                delete_image(int.parse(imageList[i]["id"]));
                              }
                              for(int j=0; j<_images.length; j++){
                                uploadImage(_images[j], userID, "ab_id", ab_id);
                              }
                            }
                            Update_Activity();
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

  Padding dateActivity_SE(BuildContext context, String lText, TextEditingController date_se, String emptyText) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextFormField(
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

  Future Update_Activity() async{
    HttpOverrides.global = MyHttpOverrides();
    Uri url = Uri.parse("https://morvita.cocopatch.com/update_activity.php");
    Map data = {
      "ab_name": ab_name.text,
      "ab_date": ab_date,
      "ab_startDate": ab_startDate.text,
      "ab_endDate": ab_endDate.text,
      "ab_text": ab_text.text,
      "ab_latitude": ab_latitude,
      "ab_longitude": ab_longitude,
      "ab_image_video": ab_image_video,
      "ab_id": ab_id,
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
