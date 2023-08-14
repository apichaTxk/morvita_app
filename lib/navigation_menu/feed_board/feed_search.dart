import 'dart:convert';
import 'dart:io';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:morvita_app/connect_to_http.dart';

import 'package:morvita_app/navigation_menu/feed_board/feed_create.dart';
import 'package:morvita_app/navigation_menu/feed_board/pre_feed_create.dart';
import 'package:morvita_app/navigation_menu/feed_board/feed_edit.dart';
import 'package:morvita_app/navigation_menu/feed_board/feed_search.dart';

import 'package:morvita_app/navigation_menu/discovery_insect/discovery_tabbar.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import 'package:http/http.dart' as Http;

class FeedSearch extends StatefulWidget {
  const FeedSearch({Key? key}) : super(key: key);

  @override
  State<FeedSearch> createState() => _FeedSearchState();
}

class _FeedSearchState extends State<FeedSearch> {

  late List fbData = [];
  List<dynamic> filterList = [];

  late Map<String, List<dynamic>> insectImages = {};
  late Future<void> _loadDataFuture;

  final TextEditingController searchController = TextEditingController();

  List<PageController> _controllers = [];

  late List insectData = [];
  late List insectPoint = [];

  bool status_refer = false;

  String thaiName = "";
  String localName = "";

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
    await getFbList();
    await getinsectlist();
    await getIpList();
    // Load images for all insects
    for (var insect in fbData) {
      await getInsectImage(insect["ip_id"].toString());
    }
  }

  void searchList(String query){
    final List<dynamic> matches = [];

    if(query.isNotEmpty){
      for(final data in fbData){
        if(data['fb_date'].toString().toLowerCase().contains(query.toLowerCase())
            || data['fb_text'].toString().toLowerCase().contains(query.toLowerCase())
        ){
          matches.add(data);
        }
      }

      setState(() {
        filterList = matches;
      });
    } else {
      setState(() {
        filterList = List.from(fbData);
      });
    }
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        title: Text(
          'หน้าฟีด',
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
        actions: [
          IconButton(
            onPressed: (){},
            icon: Icon(Icons.info_outline, color: Color(0xFF0A4483),),
          ),
        ],
      ),

      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(10),
            child:  TextFormField(
              enabled: true,
              scrollPadding: EdgeInsets.all(10),
              controller: searchController,
              onChanged: searchList,
              decoration: InputDecoration(
                labelText: "ค้นหาฟีด",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
                prefixIcon: Icon(Icons.search, color: Colors.black54,),
              ),
              style: TextStyle(
                fontFamily: 'prompt',
              ),
            ),
          ),

          Expanded(
            child: filterList.isNotEmpty
                ? FutureBuilder(
              future: _loadDataFuture,
              builder: (BuildContext context, AsyncSnapshot snapshot){
                if(snapshot.connectionState == ConnectionState.waiting){
                  return Center(child: CircularProgressIndicator());
                } else if(snapshot.hasError){
                  return Text('Error: ${snapshot.error}');
                } else {
                  return ListView.builder(
                    itemCount: filterList.length,
                    itemBuilder: (BuildContext buildContext, int index){
                      final fb = filterList[index];

                      if (_controllers.length < filterList.length) {
                        _controllers.add(PageController());
                      }

                      print("ip_id: ${fb["ip_id"].toString()}");
                      List<dynamic> imagesForCurrentInsect = insectImages[fb["ip_id"].toString()] ?? [];

                      for(int i=0;i<insectPoint.length;i++){
                        if(fb["ip_id"] == insectPoint[i]["ip_id"]){
                          if(insectPoint[i]["il_id"] != null){
                            status_refer = true;
                            for(int j=0;j<insectData.length;j++){
                              if(insectPoint[i]["il_id"] == insectData[j]["il_id"]){
                                thaiName = insectData[j]["il_thainame"];
                                localName = insectData[j]["il_localName"];
                              }
                            }
                            break;
                          }else{
                            status_refer = false;
                            break;
                          }
                        }
                      }

                      return Column(
                        children: [
                          Card(
                            child: Container(
                              height: 450,
                              child: Column(
                                children: <Widget>[
                                  ListTile(
                                    leading: CircleAvatar(),
                                    title: Text(
                                      "Username",
                                      style: TextStyle(
                                        fontFamily: 'prompt',
                                      ),
                                    ),
                                    subtitle: Text(
                                      fb["fb_date"],
                                      style: TextStyle(
                                        fontFamily: 'prompt',
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.fromLTRB(12, 0, 12, 0),
                                    child: Row(
                                      children: <Widget>[
                                        Flexible(
                                          child: Text(
                                            fb['fb_text'],
                                            style: TextStyle(
                                              fontFamily: 'prompt',
                                            ),
                                          ),
                                        )
                                      ],
                                    ),
                                  ),

                                  if(status_refer == true)
                                    SizedBox(height: 15),
                                  if(status_refer == true)
                                    Container(
                                      decoration: BoxDecoration(
                                        color: Colors.grey.shade300,
                                        borderRadius: BorderRadius.circular(10), // กำหนดค่าขอบโค้งให้มน
                                      ),
                                      width: MediaQuery.of(context).size.width - 32,
                                      height: 60,
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            thaiName,
                                            style: TextStyle(
                                                fontFamily: 'prompt',
                                                fontSize: 18,
                                                fontWeight: FontWeight.w600
                                            ),
                                          ),
                                          Text(
                                            localName,
                                            style: TextStyle(
                                              fontFamily: 'prompt',
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),

                                  SizedBox(height: 15),
                                  Expanded(
                                    child: Container(
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
                                                  activeDotColor: Colors.blueAccent,
                                                  dotWidth: 8,
                                                  dotHeight: 8,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      Row(
                                        children: <Widget>[
                                          IconButton(
                                            onPressed: (){},
                                            icon: Icon(
                                              Icons.favorite_border,
                                              color: Colors.black54,
                                              size: 30,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      );
                    },
                  );
                }
              },
            )
                : Center(child: Text('ไม่มีข้อมูล', style: TextStyle(fontFamily: 'prompt'),),),),
        ],
      ),
    );
  }

  Future getFbList() async{
    HttpOverrides.global = MyHttpOverrides();
    Uri url = Uri.parse("https://morvita.cocopatch.com/get_feed_broad.php");
    var response = await Http.get(url);
    print(response.body);
    setState(() {
      fbData = json.decode(response.body);
      filterList = List.from(fbData);
    });
    print(fbData);
  }

  Future<void> getInsectImage(String ip_id) async {
    try {
      HttpOverrides.global = MyHttpOverrides();
      Uri url = Uri.parse("https://morvita.cocopatch.com/get_images.php");
      var response = await Http.get(
        url.replace(queryParameters: {
          'field': "ip_id",
          'field_id': ip_id,
        }),
      );
      print(response.body);
      // Update the assignment to handle the response appropriately
      var responseBody = json.decode(response.body);
      if (responseBody is List<dynamic>) {
        insectImages[ip_id] = responseBody; // Update here
      } else {
        print("Invalid response format: $responseBody");
      }
    } catch (e) {
      print("Error while getting insect images: $e");
    }
  }

  Future<void> getinsectlist() async{
    HttpOverrides.global = MyHttpOverrides();
    Uri url = Uri.parse("https://morvita.cocopatch.com/getInsectlist_lb.php");
    var response = await Http.get(url);
    print(response.body);
    insectData = json.decode(response.body);
    print(insectData);
  }

  Future getIpList() async{
    HttpOverrides.global = MyHttpOverrides();
    Uri url = Uri.parse("https://morvita.cocopatch.com/get_insectpoint.php");
    var response = await Http.get(url);
    print(response.body);
    insectPoint = json.decode(response.body);
    print(insectPoint);
  }
}
