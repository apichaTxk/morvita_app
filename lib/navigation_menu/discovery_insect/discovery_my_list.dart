import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:morvita_app/connect_to_http.dart';
import 'package:morvita_app/navigation_menu/activity_board/activity_map_show.dart';
import 'package:morvita_app/navigation_menu/discovery_insect/discovery_edit2.dart';
import 'package:morvita_app/navigation_menu/discovery_insect/discovery_detail.dart';
import 'package:morvita_app/navigation_menu/feed_board/feed_create.dart';
import 'package:http/http.dart' as Http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_share/flutter_share.dart';

class Discovery_my_list extends StatefulWidget {
  final String discovery_filter;
  final int statusToGo;

  Discovery_my_list({
    required this.discovery_filter,
    required this.statusToGo,
  });

  @override
  State<Discovery_my_list> createState() => _Discovery_my_listState();
}

class _Discovery_my_listState extends State<Discovery_my_list> {

  late List insectPoint = [];
  late Map<String, List<dynamic>> insectImages = {};

  late Future<void> _loadDataFuture;

  int numberOfFetch = 0;
  int numberOfCard = 0;

  String userID = "";

  @override
  void initState(){
    super.initState();
    _loadDataFuture = loadData();
  }

  Future<void> loadData() async {
    await show_sh();
    await getIpList();
    // Load images for all insects
    for (var insect in insectPoint) {
      if(insect["ip_type"].toString() == widget.discovery_filter && insect["u_id"].toString() == userID){
        await getInsectImage(insect["ip_id"].toString());
        numberOfFetch++;
      }
    }
  }

  Future<void> refreshData() async {
    _loadDataFuture = loadData();
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
              itemCount: insectPoint.length,
              itemBuilder: (BuildContext buildContext, int index){

                final ip = insectPoint[index];

                if(ip["ip_type"] == widget.discovery_filter && ip["u_id"].toString() == userID){

                  numberOfCard++;

                  print("ip_id: ${ip["ip_id"].toString()}");
                  List<dynamic> imagesForCurrentInsect = insectImages[ip["ip_id"].toString()] ?? [];
                  print(imagesForCurrentInsect.length);

                  return Column(
                    children: [
                      InkWell(
                        onTap: (){
                          print(imagesForCurrentInsect.length);
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => DiscoveryDetail(
                                insectPointData: insectPoint,
                                imageList: imagesForCurrentInsect,
                                indexOfData: index,
                              ),
                            ),
                          );
                        },
                        child: Container(
                          height: 150.0, // Adjust height value as you want
                          child: Padding(
                            padding: EdgeInsets.symmetric(vertical: 10.0), // Adjust vertical padding value as you want
                            child: Material(
                              color: Colors.white, // Add this line to change the color
                              elevation: 5.0,  // Adjust elevation as you want
                              borderRadius: BorderRadius.circular(15.0), // Adjust radius as you want
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(15.0), // Adjust radius as you want
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Stack(
                                        children: [
                                          Container(
                                            width: 120,
                                            height: 120,
                                            margin: EdgeInsets.only(right: 16),
                                            decoration: BoxDecoration(
                                              borderRadius: BorderRadius.circular(10.0),
                                              color: Colors.white,
                                            ),
                                          ),
                                          Positioned.fill(
                                            child: ClipRRect(
                                              borderRadius: BorderRadius.circular(10.0),
                                              child: Image.network(
                                                "https://morvita.cocopatch.com/${imagesForCurrentInsect[0]["path"]}",
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
                                              ),
                                            ),
                                          ),
                                        ],
                                      )

                                    ),
                                    SizedBox(width: 10,),
                                    Expanded(
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            ip['ip_name'],
                                            style: TextStyle(
                                              fontFamily: 'prompt',
                                              fontWeight: FontWeight.w600,
                                              fontSize: 18,
                                              color: Colors.black87
                                            ),
                                          ),
                                          SizedBox(height: 8,),
                                          Text(
                                            ip["ip_date"],
                                            style: TextStyle(
                                              fontFamily: 'prompt',
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.fromLTRB(0, 0, 10, 0),
                                      child: Wrap(
                                        alignment: WrapAlignment.center,
                                        children: <Widget>[
                                          widget.statusToGo == 1
                                              ? IconButton(
                                                  icon: Icon(Icons.more_vert, color: Colors.black54,),
                                                  onPressed: (){
                                                    showDialog(
                                                      context: context,
                                                      builder: (BuildContext context) {
                                                        return AlertDialog(
                                                          shape: RoundedRectangleBorder(
                                                            borderRadius: BorderRadius.circular(20),
                                                          ),
                                                          title: Text(
                                                            ip['ip_name'],
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
                                                                      print(ip["ip_latitude"].toString());
                                                                      print(ip["ip_longitude"].toString());
                                                                      Navigator.push(
                                                                        context,
                                                                        MaterialPageRoute(
                                                                          builder: (context) => ActivityMapShow(
                                                                            map_lat: ip["ip_latitude"].toString(),
                                                                            map_long: ip["ip_longitude"].toString(),
                                                                            markerInfo: ip["ip_name"],
                                                                            titieAppBar: "พิกัดจุดที่พบแมลง",
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
                                                                          'ดูพิกัด',
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
                                                                          builder: (context) => DiscoveryDetail(
                                                                            insectPointData: insectPoint,
                                                                            imageList: imagesForCurrentInsect,
                                                                            indexOfData: index,
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
                                                                          builder: (context) => DiscoveryEdit2.setText(
                                                                            ip['ip_id'],
                                                                            ip['ip_name'],
                                                                            ip['ip_date'],
                                                                            ip['ip_number'],
                                                                            ip['ip_latitude'],
                                                                            ip['ip_longitude'],
                                                                            ip['ip_type'],
                                                                            ip['ip_plant'],
                                                                            ip['ip_detail'],
                                                                            ip['il_id'],
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
                                                                    onPressed: () async {
                                                                      await FlutterShare.share(
                                                                          title: 'Share Image',
                                                                          text: 'The source of the image:',
                                                                          linkUrl: "https://morvita.cocopatch.com/${imagesForCurrentInsect[0]["path"]}",
                                                                          chooserTitle: 'Share the URL of this image'
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
                                                                        Icon(Icons.share),
                                                                        SizedBox(width: 5,),
                                                                        Text(
                                                                          'แชร์ไปยัง Facebook',
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
                                                                                  deleteIp(ip["ip_id"]);
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
                                                )
                                              : IconButton(
                                                  icon: Icon(Icons.arrow_forward_ios, color: Colors.deepOrange,),
                                                  onPressed: (){
                                                    Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                        builder: (context) => Feed_create.setText(
                                                          ip['u_id'],
                                                          ip['ip_id'],
                                                          imagesForCurrentInsect,
                                                          ip['ip_name'],
                                                        ),
                                                      ),
                                                    ).then((value) {
                                                      setState(() {});
                                                    });
                                                  },
                                                ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
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
        },
      ),
    );
  }

  Future getIpList() async{
    HttpOverrides.global = MyHttpOverrides();
    Uri url = Uri.parse("https://morvita.cocopatch.com/get_insectpoint.php");
    var response = await Http.get(url);
    print(response.body);
    insectPoint = json.decode(response.body);
    print(insectPoint);
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
  Future delete_image(int id) async{
    HttpOverrides.global = MyHttpOverrides();
    Uri url = Uri.parse("https://morvita.cocopatch.com/delete_file_images.php");
    Map data = {
      "images_id": id,
    };
    var response = await Http.post(url, body: json.encode(data));
    print(response.body);
  }

  Future deleteIp(int ip_id) async{
    HttpOverrides.global = MyHttpOverrides();
    Uri url = Uri.parse("https://morvita.cocopatch.com/delete_insectpoint.php",);
    Map data = {
      "ip_id": ip_id,
    };
    var response = await Http.post(url, body: json.encode(data));
    print(response.body);
    Navigator.pop(context);
    Navigator.pop(context);
    refreshData();
  }
}