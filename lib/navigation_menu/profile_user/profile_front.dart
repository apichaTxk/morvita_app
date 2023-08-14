import 'dart:io';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:morvita_app/login_signup/login_form.dart';
import 'package:morvita_app/login_signup/signup_edit.dart';
import 'package:http/http.dart' as Http;

class Profile_front extends StatefulWidget {
  const Profile_front({Key? key}) : super(key: key);

  @override
  State<Profile_front> createState() => _Profile_frontState();
}

class _Profile_frontState extends State<Profile_front> {
  String userId = "";
  String userImage = "";
  String userEmail = "";
  String userName = "";
  String userLastName = "";
  String userPassword = "";
  String userFavorite = "";
  String userImageID = "";

  show_sh() async {
    try{
      final prefs = await SharedPreferences.getInstance();
      userId = prefs.getString('u_id')!;
      userImage = prefs.getString('u_pic')!;
      userEmail = prefs.getString('u_email')!;
      userName = prefs.getString('u_name')!;
      userLastName = prefs.getString('u_lastname')!;
      userPassword = prefs.getString('u_password')!;
      userFavorite = prefs.getString('u_favorite')!;
      userImageID = prefs.getString('id')!;
    }catch(e){
      print("ERROR_show_sh : $e");
    }
    setState(() {});
  }

  @override
  void initState() {
    show_sh();
    super.initState();
  }
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              height: 400,
              child: Stack(
                children: [
                  // Background image
                  Container(
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: NetworkImage("https://morvita.cocopatch.com/$userImage"),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  // Blur overlay
                  BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 15, sigmaY: 5), // Adjust the sigma values for the desired blur effect
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Colors.black45,
                            Colors.black45,
                          ],
                        ),
                      ),
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(height: 40,),
                      CircleAvatar(
                        radius: 60,
                        backgroundImage: userImage != null
                            ? NetworkImage("https://morvita.cocopatch.com/$userImage") as ImageProvider
                            : AssetImage("assets/profile.jpg"),
                      ),
                      SizedBox(height: 20,),
                      Center(
                        child: Text(
                          "$userName $userLastName",
                          style: TextStyle(
                              fontFamily: 'prompt',
                              fontWeight: FontWeight.w600,
                              fontSize: 20,
                              color: Colors.white
                          ),
                        ),
                      ),
                      Center(
                        child: Text(
                          userEmail,
                          style: TextStyle(
                              fontFamily: 'prompt',
                              fontSize: 16,
                              color: Colors.white70
                          ),
                        ),
                      ),
                      SizedBox(height: 30,),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          fixedSize: Size(150, 50),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(100),
                          ),
                          primary: Colors.transparent,
                          backgroundColor: Color(0xFF0A4483),
                          elevation: 5,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.person, size: 16,),
                            Text(
                              ' แก้ไขข้อมูลผู้ใช้',
                              style: TextStyle(
                                fontFamily: 'Prompt',
                              ),
                            ),
                          ],
                        ),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => SignupEdit.setText(
                                userId,
                                userEmail,
                                userPassword,
                                userName,
                                userLastName,
                                userFavorite,
                                userImage,
                                userImageID,
                              ),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        padding: EdgeInsets.all(40),
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            fixedSize: Size(300, 60),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
            primary: Colors.transparent,
            backgroundColor: Colors.red,
            elevation: 5,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.exit_to_app),
              Text(
                ' ออกจากระบบ',
                style: TextStyle(
                    fontFamily: 'Prompt',
                    fontSize: 18,
                    fontWeight: FontWeight.w600),
              ),
            ],
          ),
          onPressed: () async {
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
        ),
      ),
    );
  }
}
