import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:morvita_app/connect_to_http.dart';
import 'package:http/http.dart' as Http;
import 'package:flutter/foundation.dart';
import 'package:image_picker/image_picker.dart';
import 'package:morvita_app/navigation_menu/library_insect/insect_model/insect_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class InsectEdit2 extends StatefulWidget {
  int il_id = 0;
  var il_thainame = " ";
  var il_localName = " ";
  var il_season = " ";
  var il_type = " ";
  var il_order = " ";
  var il_family = " ";
  var il_genus = " ";
  var il_species = " ";
  var il_image = " ";
  List imageList = [];

  InsectEdit2.setText(
      int il_id,
      String il_thainame,
      String il_localName,
      String il_season,
      String il_type,
      String il_order,
      String il_family,
      String il_genus,
      String il_species,
      String il_image,
      List imageList,)
  {
    this.il_id = il_id;
    this.il_thainame = il_thainame;
    this.il_localName = il_localName;
    this.il_season = il_season;
    this.il_type = il_type;
    this.il_order = il_order;
    this.il_family = il_family;
    this.il_genus = il_genus;
    this.il_species = il_species;
    this.il_image = il_image;
    this.imageList = imageList;
  }

  @override
  State<InsectEdit2> createState() => _InsectEdit2State(il_id, il_thainame, il_localName, il_season, il_type, il_order, il_family, il_genus, il_species, il_image, imageList);
}

class _InsectEdit2State extends State<InsectEdit2> {

  int il_id = 0;
  var il_thainame = TextEditingController();
  var il_localName = TextEditingController();
  var il_season = " ";
  var il_type = " ";
  var il_order = TextEditingController();
  var il_family = TextEditingController();
  var il_genus = TextEditingController();
  var il_species = TextEditingController();
  var il_image = " ";
  List imageList = [];

  _InsectEdit2State(
      int il_id,
      String il_thainame,
      String il_localName,
      String il_season,
      String il_type,
      String il_order,
      String il_family,
      String il_genus,
      String il_species,
      String il_image,
      List imageList,)
  {
    this.il_id = il_id;
    this.il_thainame.text = il_thainame;
    this.il_localName.text = il_localName;
    this.il_season = il_season;
    this.il_type = il_type;
    this.il_order.text = il_order;
    this.il_family.text = il_family;
    this.il_genus.text = il_genus;
    this.il_species.text = il_species;
    this.il_image = il_image;
    this.imageList = imageList;
  }

  //================================================================

  List<String> typeOfInsect_Dropdown = ["ผีเสื้อ", "แมลงปอ", "แมลงปีกแข็ง"];
  String? selectedType;

  List<String> seasonFound_Dropdown = ["ฤดูร้อน", "ฤดูฝน", "ฤดูหนาว"];
  String? selectedSeason;

  int latest_il_id = 0;

  final ImagePicker _picker = ImagePicker();
  List<XFile> _images = [];

  String userID = "";

  @override
  void initState(){
    super.initState();
    show_sh();
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        title: Text(
          'แก้ไขข้อมูลแมลง',
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
            children: <Widget>[

              _headerText("ข้อมูลรูปภาพแมลง"),

              Padding(
                padding: const EdgeInsets.all(10),
                child: Column(
                  children: [
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        primary: _images.length == 6 ? Colors.grey : Colors.white,
                        elevation: 8,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(_images.isEmpty ? 20 : 10),
                        ),
                        padding: EdgeInsets.symmetric(horizontal: _images.isEmpty ? 60 : 20, vertical: _images.isEmpty ? 20 : 10),
                      ),
                      onPressed: _images.length == 6 ? null : _addPhotoLibrary,
                      child: Text(
                        _images.length == 6 ? "รูปภาพแมลงครบ 6 ภาพแล้ว" : 'เพิ่มรูปภาพแมลง (${6-_images.length})',
                        style: TextStyle(
                          fontFamily: "Prompt",
                          fontSize: _images.isEmpty ? 18 : null,
                          color: _images.length == 6 ? Colors.black54 : Color(0xFF0A4483),
                        ),
                      ),
                    ),
                    SizedBox(height: _images.isEmpty ? 0 : 15,),
                    Container(
                      height: _images.isEmpty ? 0 : (_images.length > 3 ? 220 : 110),
                      child: GridView.count(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        crossAxisCount: 3,
                        crossAxisSpacing: 10,
                        mainAxisSpacing: 10,
                        children: List.generate(_images.length, (index) {
                          return Stack(
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(10.0),
                                child: SizedBox(
                                  height: MediaQuery.of(context).size.width / 3 - 10,
                                  width: MediaQuery.of(context).size.width / 3 - 10,
                                  child: Image.file(
                                    File(_images[index].path),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                              Positioned(
                                top: 5,
                                right: 5,
                                child: GestureDetector(
                                  onTap: () {
                                    showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return AlertDialog(
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(20),
                                          ),
                                          title: Text(
                                            'ลบรูปภาพนี้หรือไม่',
                                            style: TextStyle(
                                                fontFamily: "Prompt"
                                            ),
                                          ),
                                          content: ClipRRect(
                                            borderRadius: BorderRadius.circular(10),
                                            child: Image.file(
                                              File(_images[index].path),
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                          actions: [
                                            TextButton(
                                              onPressed: () {
                                                Navigator.of(context).pop();
                                              },
                                              child: Text(
                                                'ยกเลิก',
                                                style: TextStyle(
                                                    fontFamily: "Prompt"
                                                ),
                                              ),
                                            ),
                                            TextButton(
                                              onPressed: () {
                                                setState(() {
                                                  _images.removeAt(index);
                                                });
                                                Navigator.of(context).pop();
                                              },
                                              child: Text(
                                                'ลบรูปภาพ',
                                                style: TextStyle(
                                                  fontFamily: "Prompt",
                                                  color: Colors.red,
                                                ),
                                              ),
                                            ),
                                          ],
                                        );
                                      },
                                    );
                                  },
                                  child: Container(
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: Colors.red,
                                    ),
                                    child: Icon(
                                      Icons.close,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          );
                        }),
                      ),
                    ),
                  ],
                ),
              ),

              Divider(
                color: Colors.grey,  // specify the color of the line
                thickness: 2,  // specify the thickness of the line
                height: 40,  // specify the height of the line
              ),

              _headerText("ข้อมูลพื้นฐาน"),

              insect_field("ชื่อสามัญ", 0, il_localName),
              insect_field("ชื่อท้องถิ่น", 1, il_thainame),

              dropdown_field("ชนิดของแมลง :", il_type, typeOfInsect_Dropdown, "เลือกชนิดแมลง", 0, 0, 40),
              dropdown_field("ฤดูกาลที่ค้นพบ :", il_season, seasonFound_Dropdown, "เลือกฤดูกาล", 1, 1, 37),

              _headerText("ข้อมูลทางอนุกรมวิธาน"),

              insect_field("Order", 2, il_order),
              insect_field("Family", 3, il_family),
              insect_field("Genus", 4, il_genus),
              insect_field("Species", 5, il_species),

              SizedBox(height: 30,),

              Container(
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Container(
                        width: 300,
                        height: 60,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.bottomLeft,
                            end: Alignment.topRight,
                            colors: [Color(0xFF0A4483), Color(0xFF0A8367)],
                          ),
                          borderRadius: BorderRadius.all(Radius.circular(15)),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.blue.withOpacity(0.5),
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
                            elevation: 0,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'แก้ไขข้อมูลแมลง',
                                style: TextStyle(
                                    fontFamily: 'Prompt',
                                    fontSize: 18,
                                    fontWeight: FontWeight.w600),
                              ),
                            ],
                          ),
                          onPressed: () {
                            if(_images.length > 0){
                              for(int i=0; i<imageList.length; i++){
                                delete_image(int.parse(imageList[i]["id"]));
                              }
                              for(int j=0; j<_images.length; j++){
                                uploadImage(_images[j], userID, "il_id", il_id);
                              }
                            }
                            Update_Insect();
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
              SizedBox(height: 80,),
            ],
          ),
        ),
      ),
    );
  }
  Padding dropdown_field(String headText, String? selected, List<String> sourceData, String labelText, int state_ui, int state_data, double size_width) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            headText,
            style: TextStyle(
              fontFamily: "Prompt",
              fontSize: 18,
            ),
          ),
          SizedBox(width: size_width,),
          Expanded(
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 10),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(20),
              ),
              child: DropdownButton<String>(
                isExpanded: true,
                value: selected,
                items: sourceData.map((item) => DropdownMenuItem(
                  value: item,
                  child: Text(item, style: TextStyle(fontFamily: "Prompt"),),
                )).toList(),
                onChanged: (item) => setState(() {
                  if(state_ui == 0){
                    selectedType = item;
                  }else{
                    selectedSeason = item;
                  }

                  switch (state_data){
                    case 0: il_type = item!;break;
                    case 1: il_season = item!;break;
                  }
                }),
                hint: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    labelText,
                    style: TextStyle(color: Colors.grey, fontFamily: "Prompt"),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Padding insect_field(String labelName, int state_data, TextEditingController textx) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextFormField(
        controller: textx,
        decoration: InputDecoration(
          labelText: labelName,
          labelStyle: TextStyle(
            fontFamily: "Prompt",
            color: Colors.grey,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
          ),
        ),
        style: TextStyle(
          fontFamily: "Prompt",
        ),
        keyboardType: TextInputType.text,
        maxLength: 50,
        onSaved: (dataSource){
          switch (state_data){
            case 0: il_localName.text = dataSource!;break;
            case 1: il_thainame.text = dataSource!;break;
            case 2: il_order.text = dataSource!;break;
            case 3: il_family.text = dataSource!;break;
            case 4: il_genus.text = dataSource!;break;
            case 5: il_species.text = dataSource!;break;
          }
        },
      ),
    );
  }

  Future<void> _addPhotoLibrary() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if(image != null) {

      //check image size before add to list
      File imageFile = File(image.path);
      int imageSize = imageFile.lengthSync();
      print('Image size: ${imageSize} bit');

      if(imageSize <= 3145728){
        setState(() {
          _images.add(image);
        });
      }else{
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              title: Text(
                'รูปภาพมีขนาดใหญ่เกินไป',
                style: TextStyle(
                  fontFamily: "prompt",
                  color: Colors.red,
                ),
              ),
              content: Text(
                'รูปภาพจะต้องมีขนาดไม่เกิน 3 MB',
                style: TextStyle(
                  fontFamily: "prompt",
                ),
              ),
              actions: <Widget>[
                TextButton(
                  child: Text(
                    'รับทราบ',
                    style: TextStyle(
                      fontFamily: "prompt",
                    ),
                  ),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            );
          },
        );
      }
    }
    //Check image in List
    var nol = _images.length;
    print("Number of image in list : $nol");
  }

  Padding _headerText(String headText) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Align(
        alignment: Alignment.centerLeft, // ใส่ค่านี้เพื่อให้ข้อความอยู่ทางซ้ายของจอ
        child: Text(
          headText,
          style: TextStyle(
            fontFamily: "Prompt",
            fontWeight: FontWeight.w600,
            fontSize: 18,
            color: Colors.blueAccent,
          ),
        ),
      ),
    );
  }

  Future Update_Insect() async{
    HttpOverrides.global = MyHttpOverrides();
    Uri url = Uri.parse("https://morvita.cocopatch.com/updateinsect_lb.php");
    Map data = {
      "il_id": il_id,
      "il_thainame": il_thainame.text,
      "il_localName": il_localName.text,
      "il_season": il_season,
      "il_type": il_type,
      "il_order": il_order.text,
      "il_family": il_family.text,
      "il_genus": il_genus.text,
      "il_species": il_species.text,
      "il_image": il_image,
    };
    var response = await Http.post(url, body: json.encode(data));
    print(response.body);
    Navigator.of(context).pop(true);
  }

  Future<void> uploadImage(XFile imageFile, String u_id, String field, int field_id) async {
    var uri = Uri.parse('https://morvita.cocopatch.com/insert_images_file.php');

    var request = Http.MultipartRequest('POST', uri)
      ..fields['u_id'] = u_id
      ..fields['field'] = field
      ..fields['field_id'] = field_id.toString()
      ..files.add(await Http.MultipartFile.fromPath('image', imageFile.path));

    var response = await request.send();

    print(response.statusCode);

    if (response.statusCode == 200 || response.statusCode == 201) {
      print("Upload successful");
    } else {
      print("Upload failed");
    }
  }

  Future delete_image(int id) async{
    HttpOverrides.global = MyHttpOverrides();
    Uri url = Uri.parse("https://morvita.cocopatch.com/delete_file_images.php");
    Map data = {
      "images_id": id,
    };
    var response = await Http.post(url, body: json.encode(data));
    print(response.body);
  }
}
