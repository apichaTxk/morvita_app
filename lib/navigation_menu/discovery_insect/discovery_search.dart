import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:morvita_app/connect_to_http.dart';
import 'package:morvita_app/navigation_menu/discovery_insect/discovery_detail.dart';
import 'package:morvita_app/navigation_menu/feed_board/feed_create.dart';
import 'package:http/http.dart' as Http;

class DiscoverySearch extends StatefulWidget {
  const DiscoverySearch({Key? key}) : super(key: key);

  @override
  State<DiscoverySearch> createState() => _DiscoverySearchState();
}

class _DiscoverySearchState extends State<DiscoverySearch> {

  late List insectPoint = [];
  List<dynamic> filterList = [];

  late Map<String, List<dynamic>> insectImages = {};
  late Future<void> _loadDataFuture;

  final TextEditingController searchController = TextEditingController();

  @override
  void initState(){
    super.initState();
    _loadDataFuture = loadData();
  }

  Future<void> loadData() async {
    await getIpList();
    // Load images for all insects
    for (var insect in insectPoint) {
      await getInsectImage(insect["ip_id"].toString());
    }
  }

  void searchList(String query){
    final List<dynamic> matches = [];

    if(query.isNotEmpty){
      for(final data in insectPoint){
        if(data['ip_name'].toString().toLowerCase().contains(query.toLowerCase())
            || data['ip_date'].toString().toLowerCase().contains(query.toLowerCase())
            || data['ip_plant'].toString().toLowerCase().contains(query.toLowerCase())
        ){
          matches.add(data);
        }
      }

      setState(() {
        filterList = matches;
      });
    } else {
      setState(() {
        filterList = List.from(insectPoint);
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
          'แมลงที่ค้นพบ',
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
                labelText: "ค้นหาแมลงที่ค้นพบ",
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
                }else{
                  return ListView.builder(
                    itemCount: filterList.length,
                    itemBuilder: (BuildContext buildContext, int index){

                      final ip = filterList[index];

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
                                    insectPointData: filterList,
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
                                  color: Color(0xFFF9F3EE), // Add this line to change the color
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
                                                ip['ip_date'],
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
                                              IconButton(
                                                icon: Icon(Icons.more_vert, color: Colors.deepOrange,),
                                                onPressed: (){},),
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

  Future getIpList() async{
    HttpOverrides.global = MyHttpOverrides();
    Uri url = Uri.parse("https://morvita.cocopatch.com/get_insectpoint.php");
    var response = await Http.get(url);
    print(response.body);
    setState(() {
      insectPoint = json.decode(response.body);
      filterList = List.from(insectPoint);
    });
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
}
