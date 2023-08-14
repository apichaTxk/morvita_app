import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';

import 'package:morvita_app/connect_to_http.dart';
import 'package:http/http.dart' as Http;

class DialogIpoint extends StatefulWidget {
  final String titleText;

  DialogIpoint({
    required this.titleText
  });

  @override
  State<DialogIpoint> createState() => _DialogIpointState();
}

class _DialogIpointState extends State<DialogIpoint> {

  late List insectData = [];

  final List<Color> titlesColor = [
    Color(0xFF0A4483),
    Color(0xFF0A4483),
    Color(0xFF0A4483),
  ];

  final List<Color> dataColor = [
    Colors.blueAccent,
    Colors.blueAccent,
    Colors.blueAccent,
  ];

  @override
  void initState(){
    super.initState();
    getinsectlist();
  }

  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      title: Text(
        widget.titleText,
        style: TextStyle(
          fontFamily: "prompt",
          color: widget.titleText == "ผีเสื้อ" ? titlesColor[0]
              : widget.titleText == "แมลงปอ" ? titlesColor[1]
              : widget.titleText == "แมลงปีกแข็ง" ? titlesColor[2]
              : Colors.black,
        ),
      ),
      content: Container(
        width: double.maxFinite,
        child: insectData.isEmpty
            ? Center(child: CircularProgressIndicator())
            : ListView.builder(
          shrinkWrap: true,
          itemCount: insectData.length,
          itemBuilder: (BuildContext context, int index) {
            final ida = insectData[index];
            Color colorText = Colors.black;

            switch (ida['il_type']){
              case "ผีเสื้อ": colorText = dataColor[0];break;
              case "แมลงปอ": colorText = dataColor[1];break;
              case "แมลงปีกแข็ง": colorText = dataColor[2];break;
            }
            if(widget.titleText == ida['il_type']){
              return Padding(
                padding: EdgeInsets.symmetric(vertical: 8.0),
                child: Material(
                  elevation: 5.0, // this gives the shadow
                  borderRadius: BorderRadius.circular(10.0),
                  child: InkWell( // makes ListTile clickable
                    onTap: () {
                      Navigator.of(context).pop(ida);
                    },
                    child: ListTile(
                      title: Center(
                        child: Text(
                          ida['il_thainame'],
                          style: TextStyle(
                            fontFamily: "prompt",
                            fontWeight: FontWeight.w600,
                            color: colorText,
                          ),
                        ),
                      ),
                      subtitle: Center(
                        child: Text(
                          '${ida['il_localName']}',
                          style: TextStyle(
                            fontFamily: "prompt",
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              );
            }
            return Container();
          },
        ),
      ),
      actions: <Widget>[
        TextButton(
          child: Text(
            'ยกเลิก',
            style: TextStyle(
              fontFamily: "prompt",
              color: Colors.red,
            ),
          ),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ],
    );
  }

  Future<void> getinsectlist() async{
    HttpOverrides.global = MyHttpOverrides();
    Uri url = Uri.parse("https://morvita.cocopatch.com/getInsectlist_lb.php");
    var response = await Http.get(url);
    print(response.body);
    setState(() {
      insectData = json.decode(response.body);
    });
    print(insectData);
  }
}
