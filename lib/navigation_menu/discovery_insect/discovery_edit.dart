import 'dart:convert';
import 'dart:io';
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

import 'package:morvita_app/connect_to_http.dart';
import 'package:http/http.dart' as Http;
import 'package:flutter/foundation.dart';

class Discovery_edit extends StatefulWidget {

  int ip_id = 0;
  var ip_name = " ";
  var ip_date = " ";
  var ip_number = " ";
  var ip_latitude = " ";
  var ip_longitude = " ";
  var ip_type = " ";
  var ip_plant = " ";
  var ip_detail = " ";
  var ip_image = " ";

  Discovery_edit.setText(
      int ip_id,
      String ip_name,
      String ip_date,
      String ip_number,
      String ip_latitude,
      String ip_longitude,
      String ip_type,
      String ip_plant,
      String ip_detail,
      String ip_image,)
  {
    this.ip_id = ip_id;
    this.ip_name = ip_name;
    this.ip_date = ip_date;
    this.ip_number = ip_number;
    this.ip_latitude = ip_latitude;
    this.ip_longitude = ip_longitude;
    this.ip_type = ip_type;
    this.ip_plant = ip_plant;
    this.ip_detail = ip_detail;
    this.ip_image = ip_image;
  }

  @override
  State<Discovery_edit> createState() => _Discovery_editState(ip_id, ip_name, ip_date, ip_number, ip_latitude, ip_longitude, ip_type, ip_plant, ip_detail, ip_image);
}

class _Discovery_editState extends State<Discovery_edit> {

  int ip_id = 0;
  var ip_name = TextEditingController();
  var ip_date = " ";
  var ip_number = TextEditingController();
  var ip_latitude = " ";
  var ip_longitude = " ";
  var ip_type = " ";
  var ip_plant = TextEditingController();
  var ip_detail = TextEditingController();
  var ip_image = " ";

  _Discovery_editState(
      int ip_idx,
      String ip_namex,
      String ip_datex,
      String ip_numberx,
      String ip_latitudex,
      String ip_longitudex,
      String ip_typex,
      String ip_plantx,
      String ip_detailx,
      String ip_imagex,)
  {
    ip_id = ip_idx;
    ip_name.text = ip_namex;
    ip_date = ip_datex;
    ip_number.text = ip_numberx;
    ip_latitude = ip_latitudex;
    ip_longitude = ip_longitudex;
    ip_type = ip_typex;
    ip_plant.text = ip_plantx;
    ip_detail.text = ip_detailx;
    ip_image = ip_imagex;
  }

  List<String> typeOfInsect_Dropdown = ["Butterfly", "Dragonfly", "Beatle"];
  String? selectedType;

  final ButtonStyle style = ElevatedButton.styleFrom(
      textStyle: const TextStyle(fontSize: 20));

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Discovery Edit'),
      ),

      body: Container(
        padding: EdgeInsets.symmetric(vertical: 40, horizontal: 20),
        child: Form(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                SizedBox(height: 20,),
                TextFormField(
                  controller: ip_name,
                  maxLength: 50,
                  maxLengthEnforcement: MaxLengthEnforcement.enforced,
                  decoration: InputDecoration(
                    labelText: "Insect name",
                  ),
                  keyboardType: TextInputType.text,
                  onSaved: (ip_namei){
                    ip_name.text = ip_namei!;
                  },
                ),
                SizedBox(height: 20,),
                DropdownButton<String>(
                  value: selectedType = ip_type,
                  items: typeOfInsect_Dropdown.map((item) => DropdownMenuItem(
                    value: item,
                    child: Text(item, style: TextStyle(fontSize: 18),),
                  )).toList(),
                  onChanged: (item) => setState(() {
                    selectedType = item;
                    ip_type = item!;
                  }),
                  hint: Align(
                    alignment: Alignment.centerRight,
                    child: Text(
                      "Type of Insect",
                      style: TextStyle(color: Colors.grey),
                    ),
                  ),
                ),
                SizedBox(height: 20,),
                TextFormField(
                  controller: ip_number,
                  maxLength: 50,
                  maxLengthEnforcement: MaxLengthEnforcement.enforced,
                  decoration: InputDecoration(
                    labelText: "Number of insect",
                  ),
                  keyboardType: TextInputType.number,
                  onSaved: (ip_numberi){
                    ip_number.text = ip_numberi.toString();
                  },
                ),
                TextFormField(
                  controller: ip_plant,
                  maxLength: 50,
                  maxLengthEnforcement: MaxLengthEnforcement.enforced,
                  decoration: InputDecoration(
                    labelText: "Insect's plant",
                  ),
                  keyboardType: TextInputType.text,
                  onSaved: (ip_planti){
                    ip_plant.text = ip_planti!;
                  },
                ),
                SizedBox(height: 30,),
                Column(
                  children: <Widget>[
                    ElevatedButton(
                      style: style,
                      onPressed: () => pickImage(ImageSource.gallery),
                      child: const Text('Choose Gallery'),
                    ),
                  ],
                ),
                TextFormField(
                  controller: ip_detail,
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
                  onSaved: (ip_detaili){
                    ip_detail.text = ip_detaili!;
                  },
                ),
                Container(
                  child: Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        ElevatedButton(
                          child: Text('Edit'),
                          onPressed: () {
                            print(ip_id);
                            print(ip_name.text);
                            print(ip_date);
                            print(ip_number.text);
                            print(ip_latitude);
                            print(ip_longitude);
                            print(ip_type);
                            print(ip_plant.text);
                            print(ip_detail.text);
                            print(ip_image);
                            // Update_discovery();
                            // Navigator.pop(context);
                          },
                        ),
                        SizedBox(width: 10,),
                        ElevatedButton(
                          child: Text('Close'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red,
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

  Future pickImage(ImageSource source) async{
    try{
      print("In picker1");
      final XFile? image = await ImagePicker().pickImage(source: source);
      print("In Picture2");
      if(image == null) return;

      //Base64 Encode
      final bytex = await File(image.path).readAsBytes();
      String img_en = base64Encode(bytex);
      print(img_en.length);

    } on PlatformException catch (e){
      print("Failed to pick image: $e");
    }
    print("End picker");
  }

  Future Update_discovery() async{
    HttpOverrides.global = MyHttpOverrides();
    Uri url = Uri.parse("https://morvita.cocopatch.com/update_insectpoint.php");
    Map data = {
      "ip_id": ip_id,
      "ip_name": ip_name.text,
      "ip_date": ip_date,
      "ip_number": ip_number.text,
      "ip_latitude": ip_latitude,
      "ip_longitude": ip_longitude,
      "ip_type": ip_type,
      "ip_plant": ip_plant.text,
      "ip_detail": ip_detail.text,
      "ip_image": ip_image,
    };
    var response = await Http.post(url, body: json.encode(data));
    print(response.body);
  }
}
