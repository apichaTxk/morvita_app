import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:morvita_app/connect_to_http.dart';

import 'package:http/http.dart' as Http;

class Feed_edit extends StatefulWidget {

  var fb_date = " ";
  var fb_text = " ";
  int fb_id = 0;

  Feed_edit.setText(
      String fb_date,
      String fb_text,
      int fb_id,)
  {
    this.fb_date = fb_date;
    this.fb_text = fb_text;
    this.fb_id = fb_id;
  }

  @override
  State<Feed_edit> createState() => _Feed_editState(fb_date, fb_text, fb_id);
}

class _Feed_editState extends State<Feed_edit> {

  var fb_date = " ";
  var fb_text = TextEditingController();
  int fb_id = 0;

  _Feed_editState(
      String fb_datex,
      String fb_textx,
      int fb_idx)
  {
    fb_date = fb_datex;
    fb_text.text = fb_textx;
    fb_id = fb_idx;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Feed Edit'),
      ),

      body: Container(
        padding: const EdgeInsets.only(left: 40, right: 40),
        child: Form(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              SizedBox(height: 50,),
              Container(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text('fb_id = ${fb_id}, fb_date = ${fb_date}', style: TextStyle(fontSize: 20),),
                  ],
                ),
              ),
              SizedBox(height: 20,),
              TextFormField(
                controller: fb_text,
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
                onSaved: (fb_texts){
                  fb_text.text = fb_texts!;
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
                        Update_Fb();
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
  }
}
