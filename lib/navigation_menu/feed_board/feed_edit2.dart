import 'dart:io';
import 'dart:convert';
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:morvita_app/navigation_menu/feed_board/feed_model/feed_model.dart';
import 'package:morvita_app/connect_to_http.dart';
import 'package:intl/intl.dart';

import 'package:carousel_slider/carousel_slider.dart';

import 'package:http/http.dart' as Http;

class FeedEdit2 extends StatefulWidget {
  List imageList = [];
  var fb_text = "";
  var fb_date = "";
  int fb_id = 0;

  FeedEdit2.setText(
      List imageList,
      String fb_text,
      String fb_date,
      int fb_id,)
  {
    this.imageList = imageList;
    this.fb_text = fb_text;
    this.fb_date = fb_date;
    this.fb_id = fb_id;
  }

  @override
  State<FeedEdit2> createState() => _FeedEdit2State(imageList, fb_text, fb_date, fb_id);
}

class _FeedEdit2State extends State<FeedEdit2> {

  List imageList = [];
  var fb_text = TextEditingController();
  var fb_date = "";
  int fb_id = 0;

  _FeedEdit2State(
      List imageList,
      String fb_text,
      String fb_date,
      int fb_id,)
  {
    this.imageList = imageList;
    this.fb_text.text = fb_text;
    this.fb_date = fb_date;
    this.fb_id = fb_id;
  }

  //================================================================

  int _currentSlide = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        title: Text(
          'แก้ไขหน้าฟีด',
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
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Container(
                margin: EdgeInsets.all(15),
                child: Column(
                  children: [
                    CarouselSlider.builder(
                      itemCount: imageList.length,
                      options: CarouselOptions(
                        enlargeCenterPage: true,
                        height: 200,
                        autoPlay: false, // เลื่อนรูปภาพอัตโนมัติ
                        autoPlayInterval: Duration(seconds: 3),
                        reverse: false,
                        aspectRatio: 5.0,
                        onPageChanged: (index, reason) {
                          setState(() {
                            _currentSlide = index;
                          });
                        },
                      ),
                      itemBuilder: (context, i, id) {
                        //for onTap to redirect to another screen
                        return GestureDetector(
                          child: Container(
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(15),
                                border: Border.all(color: Colors.white,)
                            ),
                            //ClipRRect for image border radius
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(15),
                              child: Image.network(
                                  "https://morvita.cocopatch.com/${imageList[i]["path"]}", // Replace with your actual image URL
                                width: 300,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          // onTap: (){
                          //   var url = imageList[i];
                          //   print(url.toString());
                          // },
                        );
                      },
                    ),
                    SizedBox(height: 20), // Add a space between the slider and text
                    Text(
                      "${_currentSlide + 1} จาก ${imageList.length}",
                      style: TextStyle(
                        fontFamily: 'prompt',
                      ),
                    ), // This will display the current slide number
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  controller: fb_text,
                  minLines: 5,
                  maxLines: 5,
                  maxLength: 300,
                  maxLengthEnforcement: MaxLengthEnforcement.enforced,
                  keyboardType: TextInputType.multiline,
                  decoration: InputDecoration(
                    hintText: "ข้อความของคุณ",
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
                  onSaved: (fb_texti){
                    fb_text.text = fb_texti!;
                  },
                ),
              ),
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
                              color: Colors.blueAccent.withOpacity(0.5),
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
                            backgroundColor: Colors.blueAccent,
                            elevation: 0,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'แก้ไขหน้าฟีด',
                                style: TextStyle(
                                    fontFamily: 'Prompt',
                                    fontSize: 18,
                                    fontWeight: FontWeight.w600),
                              ),
                            ],
                          ),
                          onPressed: () {
                            Update_Fb();
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
            ],
          ),
        ),
      ),
    );
  }

  Future Update_Fb() async{
    HttpOverrides.global = MyHttpOverrides();
    Uri url = Uri.parse("https://morvita.cocopatch.com/update_feed_broad.php");
    Map data = {
      "fb_date": fb_date,
      "fb_text": fb_text.text,
      "fb_id": fb_id
    };
    var response = await Http.post(url, body: json.encode(data));
    print(response.body);
    Navigator.of(context).pop(true);
  }
}
