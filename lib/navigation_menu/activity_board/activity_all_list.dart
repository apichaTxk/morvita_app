import 'dart:io';
import 'dart:convert';
import 'dart:ui';
import 'package:http/http.dart' as Http;

import 'package:flutter/material.dart';
import 'package:morvita_app/connect_to_http.dart';
import 'package:morvita_app/navigation_menu/activity_board/activity_create.dart';
import 'package:morvita_app/navigation_menu/activity_board/activity_edit2.dart';
import 'package:morvita_app/navigation_menu/activity_board/activity_search.dart';
import 'package:morvita_app/navigation_menu/activity_board/activity_map_show.dart';
import 'package:morvita_app/navigation_menu/activity_board/activity_user_list.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';


class Activity_all_list extends StatefulWidget {
  const Activity_all_list({Key? key}) : super(key: key);

  @override
  State<Activity_all_list> createState() => _Activity_all_listState();
}

class _Activity_all_listState extends State<Activity_all_list> {

  late List activityData = [];
  late Map<String, List<dynamic>> insectImages = {};
  late List userData = [];
  late Map<String, List<dynamic>> userImages = {};
  late List favData = [];
  late List<Color> favColor = [];
  late List<bool> favStatus = [];

  late Future<void> _loadDataFuture;

  List<PageController> _controllers = [];

  bool status_map = false;

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
    await getAbList();
    await getFavData(userID);
    // Load images for all insects
    for (var insect in activityData) {
      await getInsectImage("ab_id", insect["ab_id"].toString());
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

    for (int i=0; i<activityData.length; i++){
      fav_status = false;

      var ab = activityData[i];

      for(int j=0; j<favData.length; j++){
        var fav = favData[j];
        if(ab["ab_id"] == fav["ab_id"]){
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
            "บอร์ดกิจกรรม",
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
                    builder: (context) => ActivitySearch(),
                  ),
                );
              },
            ),
            IconButton(
              onPressed: (){
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ActivityUserList(),
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
            return Center(child: CircularProgressIndicator(),);
          } else if(snapshot.hasError){
            return Text('Error: ${snapshot.error}');
          } else {
            return ListView.builder(
              itemCount: activityData.length,
              itemBuilder: (BuildContext buildContext, int index){
                final ab = activityData[index];

                if (_controllers.length < activityData.length) {
                  _controllers.add(PageController());
                }

                print("ab_id: ${ab["ab_id"].toString()}");
                List<dynamic> imagesForCurrentInsect = insectImages[ab["ab_id"].toString()] ?? [];
                List<dynamic> imagesForCurrentUser = [];

                if(ab["ab_latitude"] != " " && ab["ab_longitude"] != " "){
                  status_map = true;
                }else{
                  status_map = false;
                }

                // ค้นหาและแสดงข้อมูลผู้ใช้
                var userName = "";
                var userLastName = "";

                for(int x=0;x<userData.length;x++){
                  if(ab["u_id"].toString() == userData[x]["u_id"].toString()){
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
                                ab["ab_date"],
                                style: TextStyle(
                                  fontFamily: 'prompt',
                                ),
                              ),
                            ),

                            messageHeader(ab['ab_name']),
                            SizedBox(height: 8),
                            messagePost(ab['ab_text']),
                            SizedBox(height: 8),
                            messageDate("เริ่ม", ab['ab_startDate']),
                            SizedBox(height: 8),
                            messageDate("สิ้นสุด", ab['ab_endDate']),

                            if(status_map == true)
                              SizedBox(height: 15),
                            if(status_map == true)
                              ElevatedButton(
                                onPressed: () {
                                  print(ab["ab_latitude"]);
                                  print(ab["ab_longitude"]);
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => ActivityMapShow(
                                        map_lat: ab["ab_latitude"],
                                        map_long: ab["ab_longitude"],
                                        markerInfo: ab["ab_name"],
                                        titieAppBar: "พิกัดกิจกรรม",
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
                                    Icon(Icons.location_pin),
                                    SizedBox(width: 5,),
                                    Text(
                                      'ดูพิกัดกิจกรรม',
                                      style: TextStyle(
                                        fontFamily: 'prompt',
                                        fontWeight: FontWeight.w600,
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
                                        fav_activity(ab['ab_id'].toString());
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
                    if(index == activityData.length-1)
                      SizedBox(height: 70,),
                  ],
                );
              },
            );
          }
        },
      ),

      floatingActionButton: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(20)),
          boxShadow: [
            BoxShadow(
              color: Color(0xFF0A4483).withOpacity(0.5),
              spreadRadius: 4,
              blurRadius: 10,
            ),
          ],
        ),
        child: FloatingActionButton.extended(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => Activity_create(),
              ),
            ).then((value) {
              setState(() {});
            });
          },
          foregroundColor: Colors.white,
          backgroundColor: Color(0xFF0A4483),
          splashColor: Colors.white,
          elevation: 0,
          icon: Icon(
            Icons.add,
            size: 25,
          ),
          label: Text(
            'สร้างกิจกรรม',
            style: TextStyle(
                fontFamily: 'Prompt',
                fontSize: 18,
                fontWeight: FontWeight.w600),
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  Padding messageHeader(String message) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 0, 12, 0),
      child: Row(
        children: <Widget>[
          Flexible(
            child: Text(
              message,
              style: TextStyle(
                fontFamily: 'prompt',
                fontWeight: FontWeight.bold,
              ),
            ),
          )
        ],
      ),
    );
  }

  Padding messagePost(String message) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 0, 12, 0),
      child: Row(
        children: <Widget>[
          Flexible(
            child: Text(
              message,
              style: TextStyle(
                fontFamily: 'prompt',
              ),
            ),
          )
        ],
      ),
    );
  }

  Padding messageDate(String front, String message) {

    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 0, 12, 0),
      child: Row(
        children: <Widget>[
          Text(
            front+" ",
            style: TextStyle(
              fontFamily: 'prompt',
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            message,
            style: TextStyle(
              fontFamily: 'prompt',
            ),
          ),
        ],
      ),
    );
  }

  Future getAbList() async{
    HttpOverrides.global = MyHttpOverrides();
    Uri url = Uri.parse("https://morvita.cocopatch.com/get_activity.php");
    var response = await Http.get(url);
    print(response.body);
    activityData = json.decode(response.body);
    print(activityData);
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
        if(field == "ab_id"){
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

  Future getUserData() async{
    HttpOverrides.global = MyHttpOverrides();
    Uri url = Uri.parse("https://morvita.cocopatch.com/selectuser.php");
    var response = await Http.get(url);
    print(response.body);
    userData = json.decode(response.body);
    print(userData);
    setState(() {});
  }

  Future deleteAb(int ab_id) async{
    HttpOverrides.global = MyHttpOverrides();
    Uri url = Uri.parse("https://morvita.cocopatch.com/delete_activity.php",);
    Map data = {
      "ab_id": ab_id,
    };
    var response = await Http.post(url, body: json.encode(data));
    print(response.body);
  }

  Future fav_activity(String ab_id) async{
    HttpOverrides.global = MyHttpOverrides();
    Uri url = Uri.parse("https://morvita.cocopatch.com/insert_fav_activity.php");
    Map data = {
      "u_id": int.parse(userID),
      "ab_id": ab_id,
    };
    var response = await Http.post(url, body: json.encode(data));
    print(response.body);
  }

  Future getFavData(String u_id) async{
    HttpOverrides.global = MyHttpOverrides();
    Uri url = Uri.parse("https://morvita.cocopatch.com/get_fav_activity.php");
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
