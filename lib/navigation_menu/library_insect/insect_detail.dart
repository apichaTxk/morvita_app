import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:morvita_app/connect_to_http.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as Http;

class Insect_detail extends StatefulWidget {
  final List insectData;
  final List imageList;
  final int indexOfData;
  final bool band_status;
  final bool band_show;

  Insect_detail({
    required this.insectData,
    required this.imageList,
    required this.indexOfData,
    required this.band_status,
    required this.band_show,
  });

  @override
  State<Insect_detail> createState() => _Insect_detailState();
}

class _Insect_detailState extends State<Insect_detail> {

  int _currentSlide = 0;

  String userID = "";

  //icon and color for band icon
  Color nonbandColor = Colors.red;
  Color bandColor = Colors.black54;
  IconData nonbandIcon = Icons.report_outlined;
  IconData bandIcon = Icons.report_off_outlined;

  // band icon set state
  Color? setBandColor;
  IconData? setBandIcon;

  @override
  void initState(){
    super.initState();
    show_sh();
    set_band_icon();
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

  set_band_icon(){
    if(widget.band_status == true){
      setBandColor = bandColor;
      setBandIcon = bandIcon;
    } else{
      setBandColor = nonbandColor;
      setBandIcon = nonbandIcon;
    }
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        title: Text(
          widget.insectData[widget.indexOfData]['il_localName'],
          style: TextStyle(
              fontFamily: 'prompt',
              fontWeight: FontWeight.w600,
              color: Colors.black87
          ),
        ),

        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios),
          color: Colors.black54,
          onPressed: (){
            Navigator.pop(context);
          },
        ),
        actions: [
          if(widget.band_show == true)
            IconButton(
                onPressed: (){
                  if(widget.band_status == false){
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          title: Text(
                            'คุณต้องการแบนข้อมูลแมลงนี้ใช่หรือไม่',
                            style: TextStyle(
                              fontFamily: 'prompt',
                            ),
                          ),
                          content: Text(
                            'ก่อนจะเริ่มทำการแบนข้อมูลแมลงนี้ กรุณาตรวจสอบให้แน่ใจว่าข้อมูลแมลงนี้มีข้อผิดพลาดหรือข้อมูลอันไม่พึงประสงค์จริง',
                            style: TextStyle(
                              fontFamily: 'prompt',
                            ),
                          ),
                          actions: <Widget>[
                            TextButton(
                              child: Text(
                                'ยกเลิก',
                                style: TextStyle(
                                    fontFamily: 'prompt',
                                    color: Colors.blue
                                ),
                              ),
                              onPressed: () {
                                Navigator.pop(context);
                              },
                            ),
                            TextButton(
                              child: Text(
                                'แบนข้อมูลแมลงนี้',
                                style: TextStyle(
                                    fontFamily: 'prompt',
                                    color: Colors.red
                                ),
                              ),
                              onPressed: () {
                                band_lib(widget.insectData[widget.indexOfData]['il_id'].toString());
                                setState(() {
                                  widget.band_status == true;
                                  setBandIcon = bandIcon;
                                  setBandColor = bandColor;
                                });
                                Navigator.pop(context);
                                Navigator.of(context).pop(true);
                              },
                            ),
                          ],
                        );
                      },
                    );
                  } else {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          title: Text(
                            'คุณต้องการยกเลิกแบนข้อมูลแมลงนี้ใช่หรือไม่',
                            style: TextStyle(
                              fontFamily: 'prompt',
                            ),
                          ),
                          actions: <Widget>[
                            TextButton(
                              child: Text(
                                'แบนต่อไป',
                                style: TextStyle(
                                    fontFamily: 'prompt',
                                    color: Colors.blue
                                ),
                              ),
                              onPressed: () {
                                Navigator.pop(context);
                              },
                            ),
                            TextButton(
                              child: Text(
                                'ใช่ ฉันต้องการยกเลิก',
                                style: TextStyle(
                                    fontFamily: 'prompt',
                                    color: Colors.blue
                                ),
                              ),
                              onPressed: () {
                                band_lib(widget.insectData[widget.indexOfData]['il_id'].toString());
                                setState(() {
                                  widget.band_status == false;
                                  set_band_icon();
                                  setBandIcon = nonbandIcon;
                                  setBandColor = nonbandColor;
                                });
                                Navigator.pop(context);
                                Navigator.of(context).pop(true);
                              },
                            ),
                          ],
                        );
                      },
                    );
                  }
                },
                icon: Icon(
                  setBandIcon,
                  color: setBandColor,
                  size: 30,
                ),
            ),
        ],
      ),

      body: Container(
        padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                alignment: Alignment.center,
                child: Column(
                  children: [
                    CarouselSlider.builder(
                      itemCount: widget.imageList.length,
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
                                "https://morvita.cocopatch.com/${widget.imageList[i]["path"]}",
                                width: 300,
                                fit: BoxFit.cover,
                                loadingBuilder: (BuildContext context, Widget child, ImageChunkEvent? loadingProgress) {
                                  if (loadingProgress == null) {
                                    return child;
                                  }
                                  return Center(
                                    child: CircularProgressIndicator(
                                      value: loadingProgress.expectedTotalBytes != null
                                          ? loadingProgress.cumulativeBytesLoaded / loadingProgress.expectedTotalBytes!
                                          : null,
                                    ),
                                  );
                                },
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
                      "${_currentSlide + 1} จาก ${widget.imageList.length}",
                      style: TextStyle(
                        fontFamily: 'prompt',
                      ),
                    ), // This will display the current slide number
                  ],
                ),
              ),
              SizedBox(height: 30,),
              headerText('ข้อมูลพื้นฐาน'),
              showText('ชื่อสามัญ : ', widget.insectData[widget.indexOfData]["il_localName"]),
              showText('ชื่อท้องถิ่น : ', widget.insectData[widget.indexOfData]["il_thainame"]),
              showText('ชนิดแมลง : ', widget.insectData[widget.indexOfData]["il_type"]),
              showText('ฤดูกาลที่ค้นพบ : ', widget.insectData[widget.indexOfData]["il_season"]),
              SizedBox(height: 20,),
              headerText('ข้อมูลทางอนุกรมวิธาน'),
              showText('Order : ', widget.insectData[widget.indexOfData]["il_order"]),
              showText('Family : ', widget.insectData[widget.indexOfData]["il_family"]),
              showText('Genus : ', widget.insectData[widget.indexOfData]["il_genus"]),
              showText('Species : ', widget.insectData[widget.indexOfData]["il_species"]),
              SizedBox(height: 80,),
            ],
          ),
        ),
      ),
    );
  }

  Padding headerText(String headerText) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Text(
        headerText,
        style: TextStyle(
          fontFamily: 'prompt',
          fontWeight: FontWeight.bold,
          color: Colors.blueAccent,
          fontSize: 18,
        ),
      ),
    );
  }

  Padding showText(String frontText, String infoText) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Row(
        children: [
          Text(
            frontText,
            style: TextStyle(
              fontFamily: 'prompt',
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),
          Text(
            infoText,
            style: TextStyle(
              fontFamily: 'prompt',
              fontSize: 18,
              color: Colors.black54,
            ),
          ),
        ],
      ),
    );
  }

  Future band_lib(String il_id) async{
    HttpOverrides.global = MyHttpOverrides();
    Uri url = Uri.parse("https://morvita.cocopatch.com/insert_band.php");
    Map data = {
      "u_id": int.parse(userID),
      "il_id": il_id,
    };
    var response = await Http.post(url, body: json.encode(data));
    print(response.body);
  }
}
