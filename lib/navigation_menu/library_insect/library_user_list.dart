import 'dart:convert';
import 'dart:io';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:morvita_app/connect_to_http.dart';
import 'package:http/http.dart' as Http;

import 'package:morvita_app/navigation_menu/library_insect/insect_detail.dart';
import 'package:morvita_app/navigation_menu/library_insect/insect_edit2.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class LibraryUserList extends StatefulWidget {
  final String library_name;
  final String userID;

  LibraryUserList({
    required this.library_name,
    required this.userID,
  });

  @override
  State<LibraryUserList> createState() => _LibraryUserListState();
}

class _LibraryUserListState extends State<LibraryUserList> {

  late List insectData = [];
  late Map<String, List<dynamic>> insectImages = {};

  late Future<void> _loadDataFuture;

  List<PageController> _controllers = [];

  int numberOfFetch = 0;
  int numberOfCard = 0;

  @override
  void initState(){
    super.initState();
    _loadDataFuture = loadData();
  }
  @override
  void dispose() {
    // Dispose all PageControllers in the list
    for (var controller in _controllers) {
      controller.dispose();
    }
    super.dispose();
  }

  Future<void> refreshData() async {
    _loadDataFuture = loadData();
  }

  Future<void> loadData() async {
    await getinsectlist();
    // Load images for all insects
    for (var insect in insectData) {
      if(insect["il_type"].toString() == widget.library_name && insect["u_id"].toString() == widget.userID){
        await getInsectImage(insect["il_id"].toString());
        numberOfFetch++;
      }
    }
  }

  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
      child: FutureBuilder(
          future: _loadDataFuture,
          builder: (BuildContext context, AsyncSnapshot snapshot){
            if(snapshot.connectionState == ConnectionState.waiting){
              return Center(child: CircularProgressIndicator());
            } else if(snapshot.hasError){
              return Text('Error: ${snapshot.error}');
            }else{
              return ListView.builder(
                itemCount: insectData.length,
                itemBuilder: (BuildContext buildContext, int index){

                  final ida = insectData[index];

                  if (_controllers.length < insectData.length) {
                    _controllers.add(PageController());
                  }

                  if(ida["il_type"] == widget.library_name && ida["u_id"].toString() == widget.userID){

                    numberOfCard++;

                    print("il_id: ${ida["il_id"].toString()}");
                    List<dynamic> imagesForCurrentInsect = insectImages[ida["il_id"].toString()] ?? [];

                    return Column(
                      children: [
                        InkWell(
                          onTap: (){
                            print(imagesForCurrentInsect.length);
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => Insect_detail(
                                  insectData: insectData,
                                  imageList: imagesForCurrentInsect,
                                  indexOfData: index,
                                  band_status: false,
                                  band_show: false,
                                ),
                              ),
                            );
                          },
                          child: Card(
                            clipBehavior: Clip.antiAlias,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(24),
                            ),
                            child: Column(
                              children: [
                                Container(
                                  height: 200,
                                  child: Stack(
                                    children: [
                                      PageView.builder(
                                        controller: _controllers[index],
                                        itemCount: imagesForCurrentInsect.length,
                                        itemBuilder: (BuildContext context, int imageIndex) {
                                          final iim = imagesForCurrentInsect[imageIndex];
                                          print(iim["path"],);
                                          return Image.network(
                                            "https://morvita.cocopatch.com/${iim["path"]}",
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
                                          );
                                        },
                                      ),
                                      Positioned(
                                        bottom: 8,
                                        left: 0,
                                        right: 0,
                                        child: Center(
                                          child: SmoothPageIndicator(
                                            controller: _controllers[index],
                                            count: imagesForCurrentInsect.length,
                                            effect: WormEffect(
                                              dotColor: Colors.grey,
                                              activeDotColor: Colors.blue,
                                              dotWidth: 8,
                                              dotHeight: 8,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.all(16).copyWith(bottom: 16),
                                  child: Align(
                                    alignment: Alignment.centerLeft,
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Align(
                                              alignment: Alignment.centerLeft,
                                              child: Text(
                                                ida["il_localName"].toString(),
                                                style: TextStyle(fontSize: 20, color: Color(0xFF0A4483), fontWeight: FontWeight.w600),
                                              ),
                                            ),
                                            Align(
                                              alignment: Alignment.centerLeft,
                                              child: Text(
                                                ida["il_genus"].toString() + " " + ida["il_species"].toString(),
                                                style: TextStyle(fontSize: 16),
                                              ),
                                            ),
                                          ],
                                        ),
                                        IconButton(
                                          onPressed: (){
                                            showDialog(
                                              context: context,
                                              builder: (BuildContext context) {
                                                return AlertDialog(
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius: BorderRadius.circular(20),
                                                  ),
                                                  title: Text(
                                                    ida["il_localName"],
                                                    style: TextStyle(
                                                      fontFamily: 'prompt',
                                                    ),
                                                  ),
                                                  content: SingleChildScrollView(
                                                    child: Column(
                                                      children: [
                                                        Padding(
                                                          padding: const EdgeInsets.all(8.0),
                                                          child: ElevatedButton(
                                                            onPressed: () {
                                                              print(imagesForCurrentInsect.length);
                                                              Navigator.push(
                                                                context,
                                                                MaterialPageRoute(
                                                                  builder: (context) => Insect_detail(
                                                                    insectData: insectData,
                                                                    imageList: imagesForCurrentInsect,
                                                                    indexOfData: index,
                                                                    band_status: false,
                                                                    band_show: false,
                                                                  ),
                                                                ),
                                                              );
                                                            },
                                                            style: ElevatedButton.styleFrom(
                                                              shape: RoundedRectangleBorder(
                                                                borderRadius: BorderRadius.circular(10.0), // กำหนดขอบที่โค้งมน
                                                              ),
                                                              fixedSize: Size(200, 50), // กำหนดขนาดของปุ่ม
                                                              backgroundColor: Colors.blueAccent, // กำหนดสีส้ม
                                                            ),
                                                            child: Row(
                                                              mainAxisAlignment: MainAxisAlignment.center,
                                                              children: [
                                                                Icon(Icons.info),
                                                                SizedBox(width: 5,),
                                                                Text(
                                                                  'ดูข้อมูล',
                                                                  style: TextStyle(
                                                                    fontFamily: 'prompt',
                                                                    fontWeight: FontWeight.w600,
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                        ),
                                                        Padding(
                                                          padding: const EdgeInsets.all(8.0),
                                                          child: ElevatedButton(
                                                            onPressed: () {
                                                              Navigator.push(
                                                                context,
                                                                MaterialPageRoute(
                                                                  builder: (context) => InsectEdit2.setText(
                                                                    ida['il_id'],
                                                                    ida['il_thainame'],
                                                                    ida['il_localName'],
                                                                    ida['il_season'],
                                                                    ida['il_type'],
                                                                    ida['il_order'],
                                                                    ida['il_family'],
                                                                    ida['il_genus'],
                                                                    ida['il_species'],
                                                                    ida['il_image'],
                                                                    imagesForCurrentInsect,
                                                                  ),
                                                                ),
                                                              ).then((value) {
                                                                if(value == true){
                                                                  print("เข้าแล้วจ้าาาาา");
                                                                  Navigator.pop(context);
                                                                  refreshData();
                                                                }
                                                              });
                                                            },
                                                            style: ElevatedButton.styleFrom(
                                                              shape: RoundedRectangleBorder(
                                                                borderRadius: BorderRadius.circular(10.0), // กำหนดขอบที่โค้งมน
                                                              ),
                                                              fixedSize: Size(200, 50), // กำหนดขนาดของปุ่ม
                                                              backgroundColor: Colors.blueAccent, // กำหนดสีส้ม
                                                            ),
                                                            child: Row(
                                                              mainAxisAlignment: MainAxisAlignment.center,
                                                              children: [
                                                                Icon(Icons.edit),
                                                                SizedBox(width: 5,),
                                                                Text(
                                                                  'แก้ไขข้อมูล',
                                                                  style: TextStyle(
                                                                    fontFamily: 'prompt',
                                                                    fontWeight: FontWeight.w600,
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  actions: <Widget>[
                                                    TextButton(
                                                      child: Text(
                                                        'เสร็จสิ้น',
                                                        style: TextStyle(
                                                            fontFamily: 'prompt',
                                                            color: Colors.blue
                                                        ),
                                                      ),
                                                      onPressed: () {
                                                        Navigator.pop(context);
                                                      },
                                                    ),
                                                  ],
                                                );
                                              },
                                            );
                                          },
                                          icon: Icon(Icons.more_vert),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        if(numberOfFetch == numberOfCard)
                          SizedBox(height: 70,),
                      ],
                    );
                  }
                  return Container();
                },
              );
            }
          }
      ),
    );
  }

  Future<void> getinsectlist() async{
    HttpOverrides.global = MyHttpOverrides();
    Uri url = Uri.parse("https://morvita.cocopatch.com/getInsectlist_lb.php");
    var response = await Http.get(url);
    print(response.body);
    insectData = json.decode(response.body);
    print(insectData);
  }

  Future<void> getInsectImage(String il_id) async {
    try {
      HttpOverrides.global = MyHttpOverrides();
      Uri url = Uri.parse("https://morvita.cocopatch.com/get_images.php");
      var response = await Http.get(
        url.replace(queryParameters: {
          'field': "il_id",
          'field_id': il_id,
        }),
      );
      print(response.body+"XXXXX");
      // Update the assignment to handle the response appropriately
      var responseBody = json.decode(response.body);
      if (responseBody is List<dynamic>) {
        insectImages[il_id] = responseBody; // Update here
      } else {
        print("Invalid response format: $responseBody");
      }
    } catch (e) {
      print("Error while getting insect images: $e");
    }
  }
}
