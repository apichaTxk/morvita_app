import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:morvita_app/connect_to_http.dart';

import 'package:http/http.dart' as Http;

class Activity_edit extends StatefulWidget {

  var ab_name = " ";
  var ab_date = " ";
  var ab_startDate = " ";
  var ab_endDate = " ";
  var ab_text = " ";
  var ab_latitude = " ";
  var ab_longitude = " ";
  var ab_image_video = " ";
  int ab_id = 0;

  Activity_edit.setText(
      String ab_name,
      String ab_date,
      String ab_startDate,
      String ab_endDate,
      String ab_text,
      String ab_latitude,
      String ab_longitude,
      String ab_image_video,
      int ab_id,)
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
  }

  @override
  State<Activity_edit> createState() => _Activity_editState(ab_name, ab_date, ab_startDate, ab_endDate, ab_text, ab_latitude, ab_longitude, ab_image_video, ab_id);
}

class _Activity_editState extends State<Activity_edit> {

  var ab_name = TextEditingController();
  var ab_date = " ";
  var ab_startDate = TextEditingController();
  var ab_endDate = TextEditingController();
  var ab_text = TextEditingController();
  var ab_latitude = " ";
  var ab_longitude = " ";
  var ab_image_video = " ";
  int ab_id = 0;

  _Activity_editState(
      String ab_namex,
      String ab_datex,
      String ab_startDatex,
      String ab_endDatex,
      String ab_textx,
      String ab_latitudex,
      String ab_longitudex,
      String ab_image_videox,
      int ab_idx,)
  {
    ab_name.text = ab_namex;
    ab_date = ab_datex;
    ab_startDate.text = ab_startDatex;
    ab_endDate.text = ab_endDatex;
    ab_text.text = ab_textx;
    ab_latitude = ab_latitudex;
    ab_longitude = ab_longitudex;
    ab_image_video = ab_image_videox;
    ab_id = ab_idx;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Activity Edit'),
      ),
      body: Container(
        padding: const EdgeInsets.only(left: 40, right: 40),
        child: Form(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[

              SizedBox(height: 20,),
              TextFormField(
                controller: ab_name,
                maxLength: 50,
                maxLengthEnforcement: MaxLengthEnforcement.enforced,
                decoration: InputDecoration(
                  labelText: "Activity name",
                ),

                keyboardType: TextInputType.text,
                onSaved: (ab_namex){
                  ab_name.text = ab_namex!;
                },
              ),

              SizedBox(height: 20,),
              dateActivity_SE(context, "Date of start", ab_startDate, "Enter correct start date"),
              SizedBox(height: 20,),
              dateActivity_SE(context, "Date of end", ab_endDate, "Enter correct end date"),

              SizedBox(height: 70,),
              Text("Message here!"),
              SizedBox(height: 10,),
              TextFormField(
                controller: ab_text,
                minLines: 5,
                maxLines: 5,
                maxLength: 300,
                maxLengthEnforcement: MaxLengthEnforcement.enforced,
                keyboardType: TextInputType.multiline,
                decoration: InputDecoration(
                  hintText: "Enter a message here",
                  hintStyle: TextStyle(
                    color: Colors.grey,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                  ),
                ),
                onSaved: (ab_textx){
                  ab_text.text = ab_textx!;
                },
              ),

              SizedBox(height: 50,),
              Container(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    ElevatedButton(
                      child: Text("Edit"),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        fixedSize: const Size(100, 100),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(50)
                        ),
                      ),
                      onPressed: (){
                        Update_Activity();
                        Navigator.pop(context);
                      },
                    ),

                    SizedBox(width: 50,),

                    ElevatedButton(
                      child: Text("Cancle"),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        fixedSize: const Size(100, 100),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(50)
                        ),
                      ),
                      onPressed: (){
                        Navigator.pop(context);
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  TextFormField dateActivity_SE(BuildContext context, String lText, TextEditingController date_se, String emptyText) {
    return TextFormField(
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
        suffixIcon: Icon(Icons.calendar_today),
      ),
    );
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
  }
}
