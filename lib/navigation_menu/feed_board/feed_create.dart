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

class Feed_create extends StatefulWidget {

  int u_id = 0;
  int ip_id = 0;
  List imageList = [];
  String titleName = "";

  Feed_create.setText(
      int u_id,
      int ip_id,
      List imageList,
      String titleName,)
  {
    this.u_id = u_id;
    this.ip_id = ip_id;
    this.imageList = imageList;
    this.titleName = titleName;
  }

  @override
  State<Feed_create> createState() => _Feed_createState(u_id, ip_id, imageList, titleName);
}

class _Feed_createState extends State<Feed_create> {

  int u_idi = 0;
  int ip_idi = 0;
  List imageListi = [];
  String titleNamei = "";

  _Feed_createState(
      int u_id,
      int ip_id,
      List imageList,
      String titleName,)
  {
    u_idi = u_id;
    ip_idi = ip_id;
    imageListi = imageList;
    titleNamei = titleName;
  }

  // =========================================================================

  Feed_model fb_add = Feed_model(
      fb_date: " ",
      fb_text: " ",
      u_id: 0,
      ip_id: 0
  );

  final formKey = GlobalKey<FormState>();

  int _currentSlide = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        title: Text(
          'แชร์ \"${titleNamei}\"',
          style: TextStyle(
            fontFamily: 'prompt',
            fontWeight: FontWeight.w600,
            color: Colors.blueAccent
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
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Container(
                  margin: EdgeInsets.all(15),
                  child: Column(
                    children: [
                      CarouselSlider.builder(
                        itemCount: imageListi.length,
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
                                child: Image.file(
                                  File(imageListi[i].path),
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
                        "${_currentSlide + 1} จาก ${imageListi.length}",
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
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'กรุณากรอกข้อมูล';
                      }
                      return null;
                    },
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
                    onSaved: (fb_text){
                      fb_add.fb_text = fb_text!;
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
                                Icon(
                                  Icons.arrow_upward,
                                  size: 25,
                                ),
                                Text(
                                  ' แชร์ไปยังหน้าฟีด',
                                  style: TextStyle(
                                      fontFamily: 'Prompt',
                                      fontSize: 18,
                                      fontWeight: FontWeight.w600),
                                ),
                              ],
                            ),
                            onPressed: () {
                              fb_add.u_id = u_idi;
                              fb_add.ip_id = ip_idi;

                              final DateFormat formatter = DateFormat('yyyy-M-dd');
                              final String fb_date = formatter.format(DateTime.now());

                              String date = fb_date;
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

                              fb_add.fb_date = finish_date;

                              if(formKey.currentState!.validate()){
                                formKey.currentState!.save();
                                Add_feed();
                                formKey.currentState!.reset();
                                Navigator.of(context).popUntil((route) => route.isFirst);
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
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future Add_feed() async{
    HttpOverrides.global = MyHttpOverrides();
    Uri url = Uri.parse("https://morvita.cocopatch.com/insert_feed_broad.php");
    Map data = {
      "fb_date": fb_add.fb_date,
      "fb_text": fb_add.fb_text,
      "u_id": fb_add.u_id,
      "ip_id": fb_add.ip_id,
    };
    var response = await Http.post(url, body: json.encode(data));
    print(response.body);
  }
}
