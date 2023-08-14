import 'dart:convert';
import 'dart:io';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:morvita_app/connect_to_http.dart';
import 'package:http/http.dart' as Http;

import 'package:morvita_app/navigation_menu/library_insect/insect_detail.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class InsectSearch extends StatefulWidget {
  const InsectSearch({Key? key}) : super(key: key);

  @override
  State<InsectSearch> createState() => _InsectSearchState();
}

class _InsectSearchState extends State<InsectSearch> {

  late List insectData = [];
  List<dynamic> filterList = [];

  late Map<String, List<dynamic>> insectImages = {};
  late Future<void> _loadDataFuture;

  final TextEditingController searchController = TextEditingController();

  List<PageController> _controllers = [];

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
    await getinsectlist();
    // Load images for all insects
    for (var insect in insectData) {
      await getInsectImage(insect["il_id"].toString());
    }
  }

  void searchList(String query){
    final List<dynamic> matches = [];

    if(query.isNotEmpty){
      for(final data in insectData){
        if(data['il_thainame'].toString().toLowerCase().contains(query.toLowerCase())
            || data['il_localName'].toString().toLowerCase().contains(query.toLowerCase())
            || data['il_type'].toString().toLowerCase().contains(query.toLowerCase())
            || data['il_order'].toString().toLowerCase().contains(query.toLowerCase())
            || data['il_family'].toString().toLowerCase().contains(query.toLowerCase())
            || data['il_genus'].toString().toLowerCase().contains(query.toLowerCase())
            || data['il_species'].toString().toLowerCase().contains(query.toLowerCase())
        ){
          matches.add(data);
        }
      }

      setState(() {
        filterList = matches;
      });
    } else {
      setState(() {
        filterList = List.from(insectData);
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
          'ห้องสมุดแมลง',
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
                labelText: "ค้นหาแมลงจากห้องสมุดแมลง",
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

                        final ida = filterList[index];

                        if (_controllers.length < filterList.length) {
                          _controllers.add(PageController());
                        }

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
                                      insectData: filterList,
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
                          ],
                        );
                      },
                    );
                  }
                }
            )
                : Center(child: Text('ไม่มีข้อมูล', style: TextStyle(fontFamily: 'prompt'),),)
          ),
        ],
      ),
    );
  }

  Future<void> getinsectlist() async{
    HttpOverrides.global = MyHttpOverrides();
    Uri url = Uri.parse("https://morvita.cocopatch.com/getInsectlist_lb.php");
    var response = await Http.get(url);
    print(response.body);
    setState(() {
      insectData = json.decode(response.body);
      filterList = List.from(insectData);
    });
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
