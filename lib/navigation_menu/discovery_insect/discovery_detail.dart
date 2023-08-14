import 'package:flutter/material.dart';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:morvita_app/navigation_menu/activity_board/activity_map_show.dart';

class DiscoveryDetail extends StatefulWidget {
  final List insectPointData;
  final List imageList;
  final int indexOfData;

  DiscoveryDetail({
    required this.insectPointData,
    required this.imageList,
    required this.indexOfData,
  });

  @override
  State<DiscoveryDetail> createState() => _DiscoveryDetailState();
}

class _DiscoveryDetailState extends State<DiscoveryDetail> {

  int _currentSlide = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        title: Text(
          widget.insectPointData[widget.indexOfData]['ip_name'],
          style: TextStyle(
              fontFamily: 'prompt',
              fontWeight: FontWeight.w600,
              color: Colors.black87
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

      body: Container(
        padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                alignment: Alignment.center,
                child: Column(
                  children: [
                    CarouselSlider.builder(
                      itemCount: widget.imageList.length,
                      options: CarouselOptions(
                        enlargeCenterPage: true,
                        height: 200,
                        autoPlay: false, // เลื่อนรูปภาพอัตโนมัติ
                        autoPlayInterval: Duration(seconds: 3),
                        reverse: false,
                        aspectRatio: 5.0,
                        onPageChanged: (index, reason) {
                          setState(() {
                            _currentSlide = index;
                          });
                        },
                      ),
                      itemBuilder: (context, i, id) {
                        //for onTap to redirect to another screen
                        return GestureDetector(
                          child: Container(
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(15),
                                border: Border.all(color: Colors.white,)
                            ),
                            //ClipRRect for image border radius
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(15),
                              child: Image.network(
                                "https://morvita.cocopatch.com/${widget.imageList[i]["path"]}",
                                width: 300,
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
                          // onTap: (){
                          //   var url = imageList[i];
                          //   print(url.toString());
                          // },
                        );
                      },
                    ),
                    SizedBox(height: 20), // Add a space between the slider and text
                    Text(
                      "${_currentSlide + 1} จาก ${widget.imageList.length}",
                      style: TextStyle(
                        fontFamily: 'prompt',
                      ),
                    ), // This will display the current slide number
                  ],
                ),
              ),
              // Text(widget.insectPointData[widget.indexOfData]["ip_name"]),
              // Text(widget.insectPointData[widget.indexOfData]["ip_date"]),
              // Text(widget.insectPointData[widget.indexOfData]["ip_number"]),
              // Text(widget.insectPointData[widget.indexOfData]["ip_latitude"].toString()),
              // Text(widget.insectPointData[widget.indexOfData]["ip_longitude"].toString()),
              // Text(widget.insectPointData[widget.indexOfData]["ip_type"]),
              // Text(widget.insectPointData[widget.indexOfData]["ip_plant"]),
              // Text(widget.insectPointData[widget.indexOfData]["ip_detail"]),
              SizedBox(height: 30,),
              headerText('ข้อมูลเบื้องต้น'),
              showText('ชื่อแมลง : ', widget.insectPointData[widget.indexOfData]["ip_name"]),
              showText('วันที่ค้นพบ : ', widget.insectPointData[widget.indexOfData]["ip_date"]),
              showText('จำนวนแมลงที่ค้นพบ : ', widget.insectPointData[widget.indexOfData]["ip_number"]),
              showText('ชนิดของแมลง : ', widget.insectPointData[widget.indexOfData]["ip_type"]),
              showText('พืชอาหาร : ', widget.insectPointData[widget.indexOfData]["ip_plant"]),
              showText('รายละเอียดเพิ่มเติม : ', widget.insectPointData[widget.indexOfData]["ip_detail"]),
              SizedBox(height: 20,),
              headerText('พิกัดจุดที่พบแมลง'),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(10),
                    child: ElevatedButton(
                      onPressed: () {
                        print(widget.insectPointData[widget.indexOfData]["ip_latitude"].toString());
                        print(widget.insectPointData[widget.indexOfData]["ip_longitude"].toString());
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ActivityMapShow(
                              map_lat: widget.insectPointData[widget.indexOfData]["ip_latitude"].toString(),
                              map_long: widget.insectPointData[widget.indexOfData]["ip_longitude"].toString(),
                              markerInfo: widget.insectPointData[widget.indexOfData]["ip_name"],
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
                            'ดูพิกัดกิจกรรม',
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
              SizedBox(height: 80,),
            ],
          ),
        ),
      ),
    );
  }
  Padding headerText(String headerText) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Text(
        headerText,
        style: TextStyle(
          fontFamily: 'prompt',
          fontWeight: FontWeight.bold,
          color: Colors.blueAccent,
          fontSize: 18,
        ),
      ),
    );
  }

  Padding showText(String frontText, String infoText) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Row(
        children: [
          Text(
            frontText,
            style: TextStyle(
              fontFamily: 'prompt',
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),
          Text(
            infoText,
            style: TextStyle(
              fontFamily: 'prompt',
              fontSize: 18,
              color: Colors.black54,
            ),
          ),
        ],
      ),
    );
  }
}
