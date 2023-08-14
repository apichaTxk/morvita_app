import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:morvita_app/connect_to_http.dart';

import 'package:http/http.dart' as Http;

class Insect_edit extends StatefulWidget {
  int id = 0;
  var thainame = " ";
  var localname = " ";
  var season = " ";
  var type = " ";
  var order = " ";
  var family = " ";
  var genus = " ";
  var species = " ";
  var image = " ";

  Insect_edit.setText(
      int id,
      String thainame,
      String localname,
      String season,
      String type,
      String order,
      String family,
      String genus,
      String species,
      String image,)
  {
    this.id = id;
    this.thainame = thainame;
    this.localname = localname;
    this.season = season;
    this.type = type;
    this.order = order;
    this.family = family;
    this.genus = genus;
    this.species = species;
    this.image = image;
  }

  @override
  State<Insect_edit> createState() => _Insect_editState(id, thainame, localname, season, type, order, family, genus, species, image);
}

class _Insect_editState extends State<Insect_edit> {

  int id = 0;
  var thainame = TextEditingController();
  var localname = TextEditingController();
  var season = " ";
  var type = " ";
  var order = TextEditingController();
  var family = TextEditingController();
  var genus = TextEditingController();
  var species = TextEditingController();
  var image = " ";

  _Insect_editState(
      int idx,
      String thainamex,
      String localnamex,
      String seasonx,
      String typex,
      String orderx,
      String familyx,
      String genusx,
      String speciesx,
      String imagex,)
  {
    id = idx;
    thainame.text = thainamex;
    localname.text = localnamex;
    season = seasonx;
    type = typex;
    order.text = orderx;
    family.text = familyx;
    genus.text = genusx;
    species.text = speciesx;
    image = imagex;
  }

  List<String> typeOfInsect_Dropdown = ["Butterfly", "Dragonfly", "Beatle"];
  String? selectedType;

  List<String> seasonFound_Dropdown = ["Summer", "Rainy", "Winter"];
  String? selectedSeason;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Insect Data"),
      ),
      body: Container(
        padding: EdgeInsets.symmetric(vertical: 50, horizontal: 20),
        child: Form(
          // key: formKey,
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[

                _headerText("General data"),

                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    controller: localname,
                    decoration: InputDecoration(
                      labelText: "Global name",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                    keyboardType: TextInputType.text,
                    onSaved: (localnames){
                      localname.text = localnames!;
                    },
                  ),
                ),

                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    controller: thainame,
                    decoration: InputDecoration(
                      labelText: "Thai name",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                    keyboardType: TextInputType.text,
                    onSaved: (thainames){
                      thainame.text = thainames!;
                    },
                  ),
                ),

                DropdownButton<String>(
                  value: selectedType = type,
                  items: typeOfInsect_Dropdown.map((item) => DropdownMenuItem(
                    value: item,
                    child: Text(item, style: TextStyle(fontSize: 18),),
                  )).toList(),
                  onChanged: (item) => setState(() {
                    selectedType = item;
                    type = item!;
                  }),
                  hint: Align(
                    alignment: Alignment.centerRight,
                    child: Text(
                      "Type of Insect",
                      style: TextStyle(color: Colors.grey),
                    ),
                  ),
                ),

                DropdownButton<String>(
                  value: selectedSeason = season,
                  items: seasonFound_Dropdown.map((item) => DropdownMenuItem(
                    value: item,
                    child: Text(item, style: TextStyle(fontSize: 18),),
                  )).toList(),
                  onChanged: (item) => setState(() {
                    selectedSeason = item;
                    season = item!;
                  }),
                  hint: Align(
                    alignment: Alignment.centerRight,
                    child: Text(
                      "Season found",
                      style: TextStyle(color: Colors.grey),
                    ),
                  ),
                ),

                _headerText("Science data"),

                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    controller: order,
                    decoration: InputDecoration(
                      labelText: "Order",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                    keyboardType: TextInputType.text,
                    onSaved: (orders){
                      order.text = orders!;
                    },
                  ),
                ),

                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    controller: family,
                    decoration: InputDecoration(
                      labelText: "Family",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                    keyboardType: TextInputType.text,
                    onSaved: (familys){
                      family.text = familys!;
                    },
                  ),
                ),

                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    controller: genus,
                    decoration: InputDecoration(
                      labelText: "Genus",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                    keyboardType: TextInputType.text,
                    onSaved: (genuss){
                      genus.text = genuss!;
                    },
                  ),
                ),

                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    controller: species,
                    decoration: InputDecoration(
                      labelText: "Species",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                    keyboardType: TextInputType.text,
                    onSaved: (speciess){
                      species.text = speciess!;
                    },
                  ),
                ),

                // ----------- ตัวอย่างการเขียนโค้ดแบบ func ---------------------
                //_insectLibraryField("lText", "hText", insect_l.season),

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[

                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: SizedBox(
                        width: 150,
                        height: 50,
                        child: ElevatedButton(
                          // color: Colors.blue,
                          // shape: RoundedRectangleBorder(
                          //   borderRadius: BorderRadius.all(Radius.circular(30)),
                          // ),
                          child: Text(
                            "Add Data",
                            style: TextStyle(color: Colors.white, fontSize: 20),
                          ),
                          onPressed: (){
                            Update_Insect();
                            Navigator.pop(context);
                          },
                        ),
                      ),
                    ),

                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: SizedBox(
                        width: 150,
                        height: 50,
                        child: ElevatedButton(
                          // color: Colors.red,
                          // shape: RoundedRectangleBorder(
                          //   borderRadius: BorderRadius.all(Radius.circular(30)),
                          // ),
                          child: Text(
                            "Cancle",
                            style: TextStyle(color: Colors.white, fontSize: 20),
                          ),
                          onPressed: (){},
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Padding _headerText(String headText) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Text(
        headText,
        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 20,
          color: Colors.orange,
        ),
      ),
    );
  }

  Future Update_Insect() async{
    HttpOverrides.global = MyHttpOverrides();
    Uri url = Uri.parse("https://morvita.cocopatch.com/updateinsect_lb.php");
    Map data = {
      "il_id": id,
      "il_thainame": thainame.text,
      "il_localName": localname.text,
      "il_season": season,
      "il_type": type,
      "il_order": order.text,
      "il_family": family.text,
      "il_genus": genus.text,
      "il_species": species.text,
      "il_image": image,
    };
    var response = await Http.post(url, body: json.encode(data));
    print(response.body);
  }
}
