import 'dart:convert';
import 'dart:io';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:morvita_app/login_signup/login_form.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../connect_to_http.dart';

import 'package:http/http.dart' as Http;

import 'package:morvita_app/login_signup/signup_model/signup_model.dart';

class SignupEdit extends StatefulWidget {
  var u_id = "";
  var u_email = "";
  var u_password = "";
  var u_name = "";
  var u_lastname = "";
  var u_favorite = "";
  var u_img = "";
  var id = "";

  SignupEdit.setText(
      String u_id,
      String u_email,
      String u_password,
      String u_name,
      String u_lastname,
      String u_favorite,
      String u_img,
      String id,
      ){
    this.u_id = u_id;
    this.u_email = u_email;
    this.u_password = u_password;
    this.u_name = u_name;
    this.u_lastname = u_lastname;
    this.u_favorite = u_favorite;
    this.u_img = u_img;
    this.id = id;
  }

  @override
  State<SignupEdit> createState() => _SignupEditState(u_id, u_email, u_password, u_name, u_lastname, u_favorite, u_img, id);
}

class _SignupEditState extends State<SignupEdit> {

  var u_id = "";
  var u_email = TextEditingController();
  var u_password = TextEditingController();
  var u_name = TextEditingController();
  var u_lastname = TextEditingController();
  var u_favorite = "";
  var u_img = "";
  var id = "";

  _SignupEditState(
      String u_id,
      String u_email,
      String u_password,
      String u_name,
      String u_lastname,
      String u_favorite,
      String u_img,
      String id,
      ){
    this.u_id = u_id;
    this.u_email.text = u_email;
    this.u_password.text = u_password;
    this.u_name.text = u_name;
    this.u_lastname.text = u_lastname;
    this.u_favorite = u_favorite;
    this.u_img = u_img;
    this.id = id;
  }

  //================================================================

  var insectFilter = [];
  var insectFilter_Str = "";

  XFile? _images = null;
  final ImagePicker _picker = ImagePicker();

  var showPwd = true;

  String latest_u_id = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.close_rounded, size: 30,),
          onPressed: (){
            Navigator.pop(context);
          },
        ),
      ),
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/signup_wall.jpg'),
            fit: BoxFit.cover,
          ),
        ),
        child: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.black45,
                  Colors.black45,
                ]
            ),
          ),
          alignment: Alignment.topCenter,
          padding: const EdgeInsets.all(18),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                SizedBox(height: 32,),
                Text(
                  "แก้ข้อมูลส่วนตัว",
                  style: TextStyle(fontSize: 20, fontFamily: 'Prompt', color: Colors.white),
                ),
                SizedBox(height: 30,),
                Stack(
                  children: <Widget>[
                    CircleAvatar(
                      radius: 60,
                      backgroundImage: _images == null
                          ? NetworkImage("https://morvita.cocopatch.com/$u_img") as ImageProvider
                          : MemoryImage(File(_images!.path).readAsBytesSync()),
                    ),
                    Positioned(
                      left: 45,
                      right: 45,
                      bottom: 0,
                      child: InkWell(
                        onTap: _addPhotoLibrary,
                        child: Icon(
                          Icons.camera_alt,
                          color: Colors.blueGrey,
                          size: 30,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 30,),
                TextFormField(
                  controller: u_name,
                  style: TextStyle(fontSize: 20, color: Colors.white, fontFamily: 'Prompt'),
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: "ชื่อ",
                    hintStyle: TextStyle(fontFamily: 'Prompt', color: Colors.white70, fontSize: 20),
                    prefixIcon: Icon(Icons.person, color: Colors.white70),

                    fillColor: Colors.blueGrey.withOpacity(0.7),
                    filled: true,

                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.white, width: 2.5),
                      borderRadius: BorderRadius.circular(30),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.white38, width: 2),
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  obscureText: false,
                  onSaved: (data) async {
                    u_name.text = data!;
                  },
                ),
                SizedBox(height: 10,),
                TextFormField(
                  controller: u_lastname,
                  style: TextStyle(fontSize: 20, color: Colors.white, fontFamily: 'Prompt'),
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: "นามสกุล",
                    hintStyle: TextStyle(fontFamily: 'Prompt', color: Colors.white70, fontSize: 20),
                    prefixIcon: Icon(Icons.person, color: Colors.white70),

                    fillColor: Colors.blueGrey.withOpacity(0.7),
                    filled: true,

                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.white, width: 2.5),
                      borderRadius: BorderRadius.circular(30),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.white38, width: 2),
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  obscureText: false,
                  onSaved: (data) async {
                    u_lastname.text = data!;
                  },
                ),
                SizedBox(height: 10,),
                TextFormField(
                  controller: u_email,
                  style: TextStyle(fontSize: 20, color: Colors.white, fontFamily: 'Prompt'),
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: "อีเมล",
                    hintStyle: TextStyle(fontFamily: 'Prompt', color: Colors.white70, fontSize: 20),
                    prefixIcon: Icon(Icons.mail, color: Colors.white70),

                    fillColor: Colors.blueGrey.withOpacity(0.7),
                    filled: true,

                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.white, width: 2.5),
                      borderRadius: BorderRadius.circular(30),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.white38, width: 2),
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  obscureText: false,
                  keyboardType: TextInputType.emailAddress,
                  onSaved: (data) async {
                    u_email.text = data!;
                  },
                ),
                SizedBox(height: 10,),
                TextFormField(
                  controller: u_password,
                  style: TextStyle(fontSize: 20, color: Colors.white, fontFamily: 'Prompt'),
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: "รหัสผ่าน",
                    hintStyle: TextStyle(fontFamily: 'Prompt', color: Colors.white70, fontSize: 20),
                    prefixIcon: Icon(Icons.lock, color: Colors.white70),
                    suffixIcon: IconButton(
                      icon: Icon((showPwd == true) ? Icons.remove_red_eye_outlined : Icons.remove_red_eye, color: Colors.white,),
                      onPressed: () => setState(() {
                        showPwd = !showPwd;
                      }),
                    ),

                    fillColor: Colors.blueGrey.withOpacity(0.7),
                    filled: true,

                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.white, width: 2.5),
                      borderRadius: BorderRadius.circular(30),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.white38, width: 2),
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  obscureText: showPwd,
                  onSaved: (data) async {
                    u_password.text = data!;
                  },
                ),
                SizedBox(height: 15,),
                Column(
                  children: <Widget>[
                    Text(
                      'เลือกแมลงชนิดโปรดของคุณ',
                      style: TextStyle(fontFamily: 'Prompt',fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
                    ),
                  ],
                ),
                SizedBox(height: 10,),
                Wrap(
                  alignment: WrapAlignment.center,
                  children: ["ผีเสื้อ", "แมลงปอ", "แมลงปีกแข็ง"].map((filterType){
                    return Padding(
                      padding: const EdgeInsets.fromLTRB(0, 0, 10, 0),
                      child: FilterChip(
                        label: Text(filterType),
                        labelStyle: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontFamily: 'prompt',
                        ),
                        backgroundColor: Colors.black54,
                        selectedColor: Colors.blueAccent,
                        checkmarkColor: Colors.white,
                        selected: insectFilter.contains(filterType),
                        onSelected: (val){
                          setState(() {
                            insectFilter_Str = "";
                            if(val){
                              insectFilter.add(filterType);
                            }else{
                              insectFilter.removeWhere((name) {
                                return name == filterType;
                              });
                            }
                            for(int i=0;i<insectFilter.length;i++){
                              insectFilter_Str = insectFilter_Str + insectFilter[i] + ",";
                            }
                            if(insectFilter_Str != ""){
                              insectFilter_Str = insectFilter_Str.substring(0, insectFilter_Str.length-1);
                            }
                            u_favorite = insectFilter_Str;
                            print(u_favorite);
                          });
                        },
                      ),
                    );
                  }).toList(),
                ),

                SizedBox(height: 30,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    ElevatedButton(
                      onPressed: (){
                        Navigator.pop(context);
                      },
                      child: Text(
                        'ยกเลิก',
                        style: TextStyle(fontFamily: 'Prompt', fontSize: 20),
                      ),
                      style: ElevatedButton.styleFrom(
                        shape: StadiumBorder(),
                        padding: EdgeInsets.symmetric(vertical: 16),
                        minimumSize: Size(140, 60),
                        backgroundColor: Colors.red,
                      ),
                    ),
                    SizedBox(width: 30,),
                    ElevatedButton(
                      onPressed: () async {
                        if(_images != null){
                          delete_image(int.parse(id));
                          uploadImage(_images!, u_id, "u_img", int.parse(u_id));
                        }
                        Update_User();

                        try{
                          SharedPreferences prefs = await SharedPreferences.getInstance();
                          await prefs.setString('status_login', "");
                          await prefs.setString('u_pic', "");
                        }catch(e){
                          print("ERROR Report : $e");
                        }

                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (context) => Login_form()),
                        );
                      },
                      child: Text(
                        'แก้ไขข้อมูล',
                        style: TextStyle(fontFamily: 'Prompt', fontSize: 20),
                      ),
                      style: ElevatedButton.styleFrom(
                        shape: StadiumBorder(),
                        padding: EdgeInsets.symmetric(vertical: 16),
                        minimumSize: Size(140, 60),
                        backgroundColor: Colors.green,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 80,)
              ],
            ),
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
          _images = image;
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
  }

  Future Update_User() async{
    HttpOverrides.global = MyHttpOverrides();
    Uri url = Uri.parse("https://morvita.cocopatch.com/update_user.php");
    Map data = {
      "u_id": u_id,
      "u_email": u_email.text,
      "u_password": u_password.text,
      "u_name": u_name.text,
      "u_lastname": u_lastname.text,
      "u_pic": "",
      "u_favorite": u_favorite,
    };
    var response = await Http.post(url, body: json.encode(data));
    print(response.body);
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
