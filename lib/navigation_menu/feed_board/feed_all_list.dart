import 'dart:convert';
import 'dart:io';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:morvita_app/connect_to_http.dart';

import 'package:morvita_app/navigation_menu/feed_board/feed_create.dart';
import 'package:morvita_app/navigation_menu/feed_board/feed_user_list.dart';
import 'package:morvita_app/navigation_menu/feed_board/pre_feed_create.dart';
import 'package:morvita_app/navigation_menu/feed_board/feed_edit2.dart';
import 'package:morvita_app/navigation_menu/feed_board/feed_search.dart';

import 'package:morvita_app/navigation_menu/discovery_insect/discovery_tabbar.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import 'package:http/http.dart' as Http;

class Feed_all_list extends StatefulWidget {
  const Feed_all_list({Key? key}) : super(key: key);

  @override
  State<Feed_all_list> createState() => _Feed_all_listState();
}

class _Feed_all_listState extends State<Feed_all_list> {

  late List fbData = [];
  late Map<String, List<dynamic>> insectImages = {};
  late List userData = [];
  late Map<String, List<dynamic>> userImages = {};
  late List favData = [];
  late List<Color> favColor = [];
  late List<bool> favStatus = [];

  late Future<void> _loadDataFuture;

  List<PageController> _controllers = [];

  late List insectData = [];
  late List insectPoint = [];

  bool status_refer = false;

  String thaiName = "";
  String localName = "";

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
    await show_sh();
    await getFbList();
    await getinsectlist();
    await getIpList();
    await getFavData(userID);
    // Load images for all insects
    for (var insect in fbData) {
      await getInsectImage("ip_id", insect["ip_id"].toString());
    }
    await getUserData();
    for (var userx in userData) {
      await getInsectImage("u_img", userx["u_id"].toString());
    }
    set_fav_color();
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

  void set_fav_color() {
    bool fav_status = false;

    for (int i=0; i<fbData.length; i++){
      fav_status = false;

      var fb = fbData[i];

      for(int j=0; j<favData.length; j++){
        var fav = favData[j];
        if(fb["fb_id"] == fav["fb_id"]){
          fav_status = true;
          favColor.add(Colors.pink);
          favStatus.add(true);
        }
      }

      if(fav_status == false){
        favColor.add(Colors.black54);
        favStatus.add(false);
      }
    }
  }
  
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(65),
        child: AppBar(
          backgroundColor: Colors.white.withAlpha(200),
          elevation: 5,
          centerTitle: false,
          // flexibleSpace: ClipRect(
          //   child: BackdropFilter(
          //     filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          //     child: Container(color: Colors.transparent,),
          //   ),
          // ),
          flexibleSpace: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                  colors: [Color(0xFF0A4483), Color(0xFF0A8367)],
                  begin: Alignment.bottomLeft,
                  end: Alignment.topRight
              ),
            ),
          ),
          title: Text(
            "หน้าฟีด",
            style: TextStyle(
              fontFamily: "Prompt",
              fontSize: 30,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
          actions: [
            IconButton(
              icon: Icon(Icons.search),
              color: Colors.white,
              onPressed: (){
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => FeedSearch(),
                  ),
                );
              },
            ),
            IconButton(
              onPressed: (){
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => FeedUserList(),
                  ),
                );
              },
              icon: Icon(Icons.account_circle, color: Colors.white,),
            ),
          ],
        ),
      ),

      body: FutureBuilder(
        future: _loadDataFuture,
        builder: (BuildContext context, AsyncSnapshot snapshot){
          if(snapshot.connectionState == ConnectionState.waiting){
            return Center(child: CircularProgressIndicator());
          } else if(snapshot.hasError){
            return Text('Error: ${snapshot.error}');
          } else {
            return ListView.builder(
              itemCount: fbData.length,
              itemBuilder: (BuildContext buildContext, int index){
                final fb = fbData[index];

                if (_controllers.length < fbData.length) {
                  _controllers.add(PageController());
                }

                print("ip_id: ${fb["ip_id"].toString()}");
                List<dynamic> imagesForCurrentInsect = insectImages[fb["ip_id"].toString()] ?? [];
                List<dynamic> imagesForCurrentUser = [];

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

                // ค้นหาและแสดงข้อมูลผู้ใช้
                var userName = "";
                var userLastName = "";

                for(int x=0;x<userData.length;x++){
                  if(fb["u_id"].toString() == userData[x]["u_id"].toString()){
                    print("come here");
                    userName = userData[x]["u_name"].toString();
                    userLastName = userData[x]["u_lastname"].toString();
                    imagesForCurrentUser = userImages[userData[x]["u_id"].toString()] ?? [];
                    break;
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
                              leading: CircleAvatar(
                                backgroundImage: NetworkImage("https://morvita.cocopatch.com/${imagesForCurrentUser[0]["path"]}"),
                              ),
                              title: Text(
                                "${userName} ${userLastName}",
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
                                      onPressed: (){
                                        fav_feed(fb['fb_id'].toString());
                                        if(favStatus[index] == false){
                                          setState(() {
                                            favColor[index] = Colors.pink;
                                            favStatus[index] = true;
                                          });
                                        }else{
                                          setState(() {
                                            favColor[index] = Colors.black54;
                                            favStatus[index] = false;
                                          });
                                        }
                                      },
                                      icon: Icon(
                                        Icons.favorite,
                                        color: favColor[index],
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
                    if(index == fbData.length-1)
                      SizedBox(height: 70,),
                  ],
                );
              },
            );
          }
        },
      ),
    );
  }
  Future getFbList() async{
    HttpOverrides.global = MyHttpOverrides();
    Uri url = Uri.parse("https://morvita.cocopatch.com/get_feed_broad.php");
    var response = await Http.get(url);
    print(response.body);
    fbData = json.decode(response.body);
    print(fbData);
    setState(() {});
  }

  Future<void> getInsectImage(String field, String field_id) async {
    try {
      HttpOverrides.global = MyHttpOverrides();
      Uri url = Uri.parse("https://morvita.cocopatch.com/get_images.php");
      var response = await Http.get(
        url.replace(queryParameters: {
          'field': field,
          'field_id': field_id,
        }),
      );
      print(response.body);
      // Update the assignment to handle the response appropriately
      var responseBody = json.decode(response.body);
      if (responseBody is List<dynamic>) {
        if(field == "ip_id"){
          insectImages[field_id] = responseBody; // Update here
        } else {
          userImages[field_id] = responseBody; // Update here
        }
      } else {
        print("Invalid response format: $responseBody");
      }
    } catch (e) {
      print("Error while getting insect images: $e");
    }
  }

  Future deleteFb(int fb_id) async{
    HttpOverrides.global = MyHttpOverrides();
    Uri url = Uri.parse("https://morvita.cocopatch.com/delete_feed_broad.php",);
    Map data = {
      "fb_id": fb_id,
    };
    var response = await Http.post(url, body: json.encode(data));
    print(response.body);
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

  Future getUserData() async{
    HttpOverrides.global = MyHttpOverrides();
    Uri url = Uri.parse("https://morvita.cocopatch.com/selectuser.php");
    var response = await Http.get(url);
    print(response.body);
    userData = json.decode(response.body);
    print(userData);
    setState(() {});
  }

  Future fav_feed(String fb_id) async{
    HttpOverrides.global = MyHttpOverrides();
    Uri url = Uri.parse("https://morvita.cocopatch.com/insert_fav_feed.php");
    Map data = {
      "u_id": int.parse(userID),
      "fb_id": fb_id,
    };
    var response = await Http.post(url, body: json.encode(data));
    print(response.body);
  }

  Future getFavData(String u_id) async{
    HttpOverrides.global = MyHttpOverrides();
    Uri url = Uri.parse("https://morvita.cocopatch.com/get_fav_feed.php");
    var response = await Http.get(
      url.replace(queryParameters: {
        'u_id': u_id,
      }),
    );
    print(response.body);
    favData = json.decode(response.body);
    print(userData);
    setState(() {});
  }
}
