import 'dart:convert';
import 'dart:io';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../connect_to_http.dart';

import 'package:http/http.dart' as Http;

import 'package:morvita_app/login_signup/signup_model/signup_model.dart';
import 'package:morvita_app/validator_field.dart';

class Signup_form extends StatefulWidget {
  const Signup_form({Key? key}) : super(key: key);

  @override
  State<Signup_form> createState() => _Signup_formState();
}

class _Signup_formState extends State<Signup_form> {

  var insectFilter = [];
  var insectFilter_Str = "";

  XFile? _images = null;
  final ImagePicker _picker = ImagePicker();

  final formKey = GlobalKey<FormState>();
  Signup_Model profile = Signup_Model(
    u_id: 0,
    email: '',
    password: '',
    name: '',
    lastname: '',
    favorite: '',
    image: '',
  );

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
          child: Form(
            key: formKey,
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  SizedBox(height: 32,),
                  Text(
                    "สมัครสมาชิก",
                    style: TextStyle(fontSize: 30, fontFamily: 'Prompt', color: Colors.white),
                  ),
                  SizedBox(height: 30,),
                  Stack(
                    children: <Widget>[
                      CircleAvatar(
                        radius: 60,
                        backgroundImage: _images != null
                            ? FileImage(File(_images!.path))
                            : AssetImage("assets/profile.jpg") as ImageProvider<Object>?,
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
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'กรุณากรอกข้อมูล';
                      }
                      return null;
                    },
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
                      profile.name = data!;
                    },
                  ),
                  SizedBox(height: 10,),
                  TextFormField(
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'กรุณากรอกข้อมูล';
                      }
                      return null;
                    },
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
                      profile.lastname = data!;
                    },
                  ),
                  SizedBox(height: 10,),
                  TextFormField(
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'กรุณากรอกข้อมูล';
                      }
                      return null;
                    },
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
                      profile.email = data!;
                    },
                  ),
                  SizedBox(height: 10,),
                  TextFormField(
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'กรุณากรอกข้อมูล';
                      }
                      return null;
                    },
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
                      profile.password = data!;
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
                              profile.favorite = insectFilter_Str;
                              print(profile.favorite);
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
                        onPressed: (){},
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
                        onPressed: (){
                          if(_images != null){
                            if(formKey.currentState!.validate()){
                              formKey.currentState!.save();
                              register();
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
                                    'กรุณาใส่รูปโปรไฟล์ของคุณ',
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
                        child: Text(
                          'สมัครเลย',
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

  Future register() async {
    showDialog(
      context: context,
      builder: (context) {
        return Center(
          child: CircularProgressIndicator(),
        );
      },
    );
    HttpOverrides.global = MyHttpOverrides();
    Uri url = Uri.parse("https://morvita.cocopatch.com/signup.php");
    Map data = {
      "u_email": profile.email,
      "u_password": profile.password,
      "u_name": profile.name,
      "u_lastname": profile.lastname,
      "u_pic": "",
      "u_favorite": profile.favorite
    };
    var response = await Http.post(url, body: json.encode(data));
    print(response.body);

    // Get data from API
    Uri url_get = Uri.parse("https://morvita.cocopatch.com/selectuser.php?u_email=${profile.email}");
    var response_get = await Http.get(url_get);
    print(response_get.body);

    if(response_get.statusCode == 200){
      List jsonResponse = json.decode(response_get.body);
      if(jsonResponse.isNotEmpty){
        latest_u_id = jsonResponse[0]["u_id"];
        print("Latest u_id : $latest_u_id");

        if(_images != null){
          uploadImage(_images!, latest_u_id, "u_img", latest_u_id);
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
    final text = "ลงทะเบียนเสร็จสิ้น";
    final snackBar = SnackBar(content: Text(text, style: TextStyle(fontFamily: "prompt"),),backgroundColor: Colors.green,);
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  Future<void> uploadImage(XFile imageFile, String u_id, String field, String field_id) async {
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
}