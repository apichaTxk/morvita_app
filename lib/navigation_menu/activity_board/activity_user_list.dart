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
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class ActivityUserList extends StatefulWidget {
  const ActivityUserList({Key? key}) : super(key: key);

  @override
  State<ActivityUserList> createState() => _ActivityUserListState();
}

class _ActivityUserListState extends State<ActivityUserList> {

  late List activityData = [];
  late Map<String, List<dynamic>> insectImages = {};
  late List userData = [];
  late Map<String, List<dynamic>> userImages = {};

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
    // Load images for all insects
    for (var insect in activityData) {
      if(insect["u_id"].toString() == userID){
        await getInsectImage("ab_id", insect["ab_id"].toString());
      }
    }
    await getUserData();
    for (var userx in userData) {
      if(userx["u_id"].toString() == userID){
        await getInsectImage("u_img", userx["u_id"].toString());
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

  Future<void> refreshData() async {
    _loadDataFuture = loadData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        title: Text(
          'กิจกรรมของคุณ',
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

                if(ab["u_id"].toString() == userID){

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
                                trailing: GestureDetector(
                                  onTap: () {
                                    showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return AlertDialog(
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(20),
                                          ),
                                          title: Text(
                                            "จัดการกิจกรรมของคุณ",
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
                                                      Navigator.push(
                                                        context,
                                                        MaterialPageRoute(
                                                          builder: (context) => ActivityEdit2.setText(
                                                            ab["ab_name"],
                                                            ab["ab_date"],
                                                            ab["ab_startDate"],
                                                            ab["ab_endDate"],
                                                            ab["ab_text"],
                                                            ab["ab_latitude"],
                                                            ab["ab_longitude"],
                                                            ab["ab_image_video"],
                                                            ab["ab_id"],
                                                            imagesForCurrentInsect,
                                                          ),
                                                        ),
                                                      ).then((value) {
                                                        if(value == true){
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
                                                Padding(
                                                  padding: const EdgeInsets.all(8.0),
                                                  child: ElevatedButton(
                                                    onPressed: () {
                                                      showDialog(
                                                        context: context,
                                                        builder: (BuildContext context) {
                                                          return AlertDialog(
                                                            shape: RoundedRectangleBorder(
                                                              borderRadius: BorderRadius.circular(20),
                                                            ),
                                                            title: Text(
                                                              'ต้องการลบกิจกรรมนี้ของคุณหรือไม่',
                                                              style: TextStyle(
                                                                fontFamily: 'prompt',
                                                              ),
                                                            ),
                                                            actions: <Widget>[
                                                              TextButton(
                                                                child: Text(
                                                                  'ยกเลิก',
                                                                  style: TextStyle(
                                                                      fontFamily: 'prompt',
                                                                      color: Colors.blue
                                                                  ),
                                                                ),
                                                                onPressed: () {
                                                                  Navigator.pop(context);
                                                                },
                                                              ),
                                                              TextButton(
                                                                child: Text(
                                                                  'ลบกิจกรรม',
                                                                  style: TextStyle(
                                                                      fontFamily: 'prompt',
                                                                      color: Colors.red
                                                                  ),
                                                                ),
                                                                onPressed: () {
                                                                  for(int i=0;i<imagesForCurrentInsect.length;i++){
                                                                    delete_image(int.parse(imagesForCurrentInsect[i]['id']));
                                                                  }
                                                                  deleteAb(ab['ab_id']);
                                                                },
                                                              ),
                                                            ],
                                                          );
                                                        },
                                                      );
                                                    },
                                                    style: ElevatedButton.styleFrom(
                                                      shape: RoundedRectangleBorder(
                                                        borderRadius: BorderRadius.circular(10.0), // กำหนดขอบที่โค้งมน
                                                      ),
                                                      fixedSize: Size(200, 50), // กำหนดขนาดของปุ่ม
                                                      backgroundColor: Colors.red, // กำหนดสีส้ม
                                                    ),
                                                    child: Row(
                                                      mainAxisAlignment: MainAxisAlignment.center,
                                                      children: [
                                                        Icon(Icons.delete),
                                                        SizedBox(width: 5,),
                                                        Text(
                                                          'ลบข้อมูล',
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
                                  child: Icon(Icons.more_vert),
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
                }
                return Container();
              },
            );
          }
        },
      ),
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

  Future delete_image(int id) async{
    HttpOverrides.global = MyHttpOverrides();
    Uri url = Uri.parse("https://morvita.cocopatch.com/delete_file_images.php");
    Map data = {
      "images_id": id,
    };
    var response = await Http.post(url, body: json.encode(data));
    print(response.body);
  }

  Future deleteAb(int ab_id) async{
    HttpOverrides.global = MyHttpOverrides();
    Uri url = Uri.parse("https://morvita.cocopatch.com/delete_activity.php",);
    Map data = {
      "ab_id": ab_id,
    };
    var response = await Http.post(url, body: json.encode(data));
    print(response.body);
    Navigator.pop(context);
    Navigator.pop(context);
    refreshData();
  }
}
