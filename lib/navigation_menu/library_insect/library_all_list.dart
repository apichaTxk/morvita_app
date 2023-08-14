import 'dart:convert';
import 'dart:io';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:morvita_app/connect_to_http.dart';
import 'package:http/http.dart' as Http;

import 'package:morvita_app/navigation_menu/library_insect/insect_detail.dart';
import 'package:morvita_app/navigation_menu/library_insect/insect_edit2.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class Library_all_list extends StatefulWidget {
  final String library_name;
  final bool band_show;

  Library_all_list({
    required this.library_name,
    required this.band_show,
  });

  @override
  State<Library_all_list> createState() => _Library_all_listState();
}

class _Library_all_listState extends State<Library_all_list> {

  late List insectData = [];
  late Map<String, List<dynamic>> insectImages = {};
  late List bandData = [];
  late List<bool> bandStatus = [];

  late Future<void> _loadDataFuture;

  List<PageController> _controllers = [];

  int numberOfFetch = 0;
  int numberOfCard = 0;

  String userID = "";

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

  Future<void> loadData() async {
    if(widget.band_show == true){
      await show_sh();
    }
    await getBandData(userID);
    await getinsectlist();
    // Load images for all insects
    for (var insect in insectData) {
      if(insect["il_type"].toString() == widget.library_name){
        await getInsectImage(insect["il_id"].toString());
        numberOfFetch++;
      }
    }
    set_band_status();
  }

  void set_band_status() {
    bool band_status = false;

    for (int i=0; i<insectData.length; i++){
      band_status = false;

      var ida = insectData[i];

      for(int j=0; j<bandData.length; j++){
        var band = bandData[j];
        if(ida["il_id"] == band["il_id"]){
          band_status = true;
          bandStatus.add(true);
        }
      }

      if(band_status == false){
        bandStatus.add(false);
      }
    }
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

                  if(ida["il_type"] == widget.library_name){

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
                                  band_status: bandStatus[index],
                                  band_show: widget.band_show,
                                ),
                              ),
                            ).then((value) {
                              if(value == true){
                                setState(() {
                                  _loadDataFuture = loadData();
                                });
                              }
                            });
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
                                    child: Column(
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

  Future deleteInsect(int id) async{
    HttpOverrides.global = MyHttpOverrides();
    Uri url = Uri.parse("https://morvita.cocopatch.com/deleteinsect_lb.php",);
    Map data = {
      "il_id": id,
    };
    var response = await Http.post(url, body: json.encode(data));
    print(response.body);
  }

  Future getBandData(String u_id) async{
    HttpOverrides.global = MyHttpOverrides();
    Uri url = Uri.parse("https://morvita.cocopatch.com/get_band.php");
    var response = await Http.get(
      url.replace(queryParameters: {
        'u_id': u_id,
      }),
    );
    print(response.body);
    bandData = json.decode(response.body);
    print(bandData);
    setState(() {});
  }
}