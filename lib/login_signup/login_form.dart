import 'package:flutter/material.dart';

import 'signup_form.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:http/http.dart' as Http;
import 'package:morvita_app/connect_to_http.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:morvita_app/show_nav_bar.dart';
import 'package:morvita_app/navigation_menu/library_insect/library_select.dart';

import 'dart:convert';
import 'dart:io';

class Login_form extends StatefulWidget {
  const Login_form({Key? key}) : super(key: key);

  @override
  State<Login_form> createState() => _Login_formState();
}

class _Login_formState extends State<Login_form> {

  late List userInfo = [];
  late List userImg = [];

  late String email = " ";
  late String password = " ";

  final formKey = GlobalKey<FormState>();

  var showPwd = true;

  final Shader linearGradient = LinearGradient(
    colors: <Color>[Colors.greenAccent, Colors.lightBlue],
  ).createShader(Rect.fromLTWH(0.0, 0.0, 200.0, 70.0));

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/login_wall2.jpg'),
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
          alignment: Alignment.center,
          padding: const EdgeInsets.all(18),
          child: Form(
            key: formKey,
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(
                    "MorVita",
                    style: TextStyle(fontSize: 60, fontFamily: 'Prompt',
                      foreground: Paint()..shader = linearGradient,
                    ),
                  ),
                  SizedBox(height: 30,),
                  Text(
                    "เข้าสู่ระบบ",
                    style: TextStyle(fontSize: 30, fontFamily: 'Prompt', color: Colors.white),
                  ),
                  SizedBox(height: 30,),

                  TextFormField(
                    style: TextStyle(fontSize: 20, color: Colors.white, fontFamily: 'Prompt'),
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: "อีเมล",
                      hintStyle: TextStyle(fontFamily: 'Prompt', color: Colors.white70, fontSize: 20),
                      prefixIcon: Icon(Icons.mail, color: Colors.white70),

                      fillColor: Colors.black.withOpacity(0.7),
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
                    onSaved: (emails){
                      email = emails!;
                    },
                  ),
                  SizedBox(height: 10,),

                  TextFormField(
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

                      fillColor: Colors.black.withOpacity(0.7),
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
                    onSaved: (passwords) async {
                      password = passwords!;
                    },
                  ),
                  SizedBox(height: 40,),

                  ElevatedButton(
                    onPressed: (){
                      if(formKey.currentState!.validate()){
                        formKey.currentState!.save();
                        login();
                        formKey.currentState!.reset();
                      }
                    },
                    child: Text(
                      "เข้าสู่ระบบ",
                      style: TextStyle(fontSize: 22, fontFamily: 'Prompt', fontWeight: FontWeight.bold, color: Colors.white),
                    ),
                    style: ElevatedButton.styleFrom(
                      shape: StadiumBorder(),
                      padding: EdgeInsets.symmetric(vertical: 16),
                      minimumSize: Size(210, 65),
                    ),
                  ),
                  SizedBox(height: 20,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text("คุณยังไม่เป็นสมัครใช่ไหม?",
                        style: TextStyle(
                          fontFamily: 'prompt',
                          color: Colors.white,
                          fontSize: 15,
                        ),
                      ),
                      TextButton(
                        onPressed: (){
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => Signup_form()
                            ),
                          ).then((value) {
                            setState(() {});
                          });
                        },
                        child: Text(
                          "สมัครเลย",
                          style: TextStyle(fontFamily: 'Prompt',fontWeight: FontWeight.bold, color: Colors.white, fontSize: 15,),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      TextButton(
                        onPressed: (){
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => Library_select(status_lib: 0, band_show: false,),
                            ),
                          );
                        },
                        child: Text(
                          "เข้าใช้งานแบบไม่เป็นสมาชิก >>",
                          style: TextStyle(fontFamily: 'Prompt',fontWeight: FontWeight.bold, color: Colors.white, fontSize: 15,),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future login() async{
    showDialog(
      context: context,
      builder: (context) {
        return Center(
          child: CircularProgressIndicator(),
        );
      },
    );
    HttpOverrides.global = MyHttpOverrides();
    Uri url = Uri.parse("https://morvita.cocopatch.com/login.php");
    Map data = {
      "u_email": email,
      "u_password": password,
    };

    var response = await Http.post(url, body: json.encode(data));
    print(response.body);
    try{
      if(json.decode(response.body) == "password true"){
        print("complete");

        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString('status_login', '1');

        print(email);
        getUserInfo(email);

        Future.delayed(Duration(seconds: 4)).then((_) {
          Navigator.pop(context);

          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => Show_nav_bar()),
          );
        });

      }else{
        print("Invalid email or Password");
        Navigator.pop(context);
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return alertDialog(context, 'อีเมล หรือ รหัสผ่าน ไม่ถูกต้อง!', 'เพื่อที่การเข้าสู่ระบบกรุณาระบุ \"อีเมล\" และ \"รหัสผ่าน\" ให้ถูกต้อง');
          },
        );
      }
    }catch(IOException){
      Navigator.pop(context);
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return alertDialog(context, 'อีเมล หรือ รหัสผ่าน ไม่ถูกต้อง!', 'เพื่อที่การเข้าสู่ระบบกรุณาระบุ \"อีเมล\" และ \"รหัสผ่าน\" ให้ถูกต้อง');
        },
      );
    }
  }

  AlertDialog alertDialog(BuildContext context, String headerText, String contentText) {
    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      title: Text(
        headerText,
        style: TextStyle(
          fontFamily: 'prompt',
          color: Colors.red,
        ),
      ),
      content: Text(
        contentText,
        style: TextStyle(
          fontFamily: 'prompt',
        ),
      ),
      actions: <Widget>[
        TextButton(
          child: Text(
            'รับทราบ',
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
  }

  Future getUserInfo(String email) async{
    HttpOverrides.global = MyHttpOverrides();
    Uri url = Uri.parse("https://morvita.cocopatch.com/selectuser.php?u_email=$email");
    var response = await Http.get(url);
    print(response.body);
    userInfo = json.decode(response.body);
    print(userInfo);

    getInsectImage(userInfo[0]['u_id']);

    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('u_id', userInfo[0]['u_id']);
    await prefs.setString('u_email', userInfo[0]['u_email']);
    await prefs.setString('u_password', userInfo[0]['u_password']);
    await prefs.setString('u_name', userInfo[0]['u_name']);
    await prefs.setString('u_lastname', userInfo[0]['u_lastname']);
    await prefs.setString('u_favorite', userInfo[0]['u_favorite']);
  }

  Future<void> getInsectImage(String u_img) async {
    try {
      HttpOverrides.global = MyHttpOverrides();
      Uri url = Uri.parse("https://morvita.cocopatch.com/get_images.php");
      var response = await Http.get(
        url.replace(queryParameters: {
          'field': "u_img",
          'field_id': u_img,
        }),
      );
      print(response.body);
      // Update the assignment to handle the response appropriately
      userImg = json.decode(response.body);
      print(userImg);

      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('u_pic', userImg[0]['path']);
      await prefs.setString('id', userImg[0]['id']);
    } catch (e) {
      print("Error while getting insect images: $e");
    }
  }
}
