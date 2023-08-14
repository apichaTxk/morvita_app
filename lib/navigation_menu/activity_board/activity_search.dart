import 'dart:io';
import 'dart:convert';
import 'dart:ui';
import 'package:http/http.dart' as Http;

import 'package:flutter/material.dart';
import 'package:morvita_app/connect_to_http.dart';
import 'package:morvita_app/navigation_menu/activity_board/activity_create.dart';
import 'package:morvita_app/navigation_menu/activity_board/activity_edit.dart';
import 'package:morvita_app/navigation_menu/activity_board/activity_search.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class ActivitySearch extends StatefulWidget {
  const ActivitySearch({Key? key}) : super(key: key);

  @override
  State<ActivitySearch> createState() => _ActivitySearchState();
}

class _ActivitySearchState extends State<ActivitySearch> {

  late List activityData = [];
  List<dynamic> filterList = [];

  late Map<String, List<dynamic>> insectImages = {};
  late Future<void> _loadDataFuture;

  final TextEditingController searchController = TextEditingController();

  List<PageController> _controllers = [];

  bool status_map = false;

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
    await getAbList();
    // Load images for all insects
    for (var insect in activityData) {
      await getInsectImage(insect["ab_id"].toString());
    }
  }

  void searchList(String query){
    final List<dynamic> matches = [];

    if(query.isNotEmpty){
      for(final data in activityData){
        if(data['ab_name'].toString().toLowerCase().contains(query.toLowerCase())
            || data['ab_date'].toString().toLowerCase().contains(query.toLowerCase())
            || data['ab_startDate'].toString().toLowerCase().contains(query.toLowerCase())
        ){
          matches.add(data);
        }
      }

      setState(() {
        filterList = matches;
      });
    } else {
      setState(() {
        filterList = List.from(activityData);
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
          'บอร์ดกิจกรรม',
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
                labelText: "ค้นหากิจกรรม",
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
                  return Center(child: CircularProgressIndicator(),);
                } else if(snapshot.hasError){
                  return Text('Error: ${snapshot.error}');
                } else {
                  return ListView.builder(
                    itemCount: filterList.length,
                    itemBuilder: (BuildContext buildContext, int index){
                      final ab = filterList[index];

                      if (_controllers.length < filterList.length) {
                        _controllers.add(PageController());
                      }

                      print("ab_id: ${ab["ab_id"].toString()}");
                      List<dynamic> imagesForCurrentInsect = insectImages[ab["ab_id"].toString()] ?? [];

                      if(ab["ab_latitude"] != " " && ab["ab_longitude"] != " "){
                        status_map = true;
                      }else{
                        status_map = false;
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
                                        // ตัวอย่างการกำหนดฟังก์ชันเมื่อปุ่มถูกกด
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
    setState(() {
      activityData = json.decode(response.body);
      filterList = List.from(activityData);
    });
    print(activityData);
  }

  Future<void> getInsectImage(String ab_id) async {
    try {
      HttpOverrides.global = MyHttpOverrides();
      Uri url = Uri.parse("https://morvita.cocopatch.com/get_images.php");
      var response = await Http.get(
        url.replace(queryParameters: {
          'field': "ab_id",
          'field_id': ab_id,
        }),
      );
      print(response.body);
      // Update the assignment to handle the response appropriately
      var responseBody = json.decode(response.body);
      if (responseBody is List<dynamic>) {
        insectImages[ab_id] = responseBody; // Update here
      } else {
        print("Invalid response format: $responseBody");
      }
    } catch (e) {
      print("Error while getting insect images: $e");
    }
  }
}
