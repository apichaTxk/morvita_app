import 'dart:async';
import 'dart:io';
import 'dart:convert';
import 'package:http/http.dart' as Http;

import 'package:flutter/material.dart';
import 'package:morvita_app/connect_to_http.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Map_list_api extends StatefulWidget {
  const Map_list_api({Key? key}) : super(key: key);

  @override
  State<Map_list_api> createState() => _Map_list_apiState();
}

class _Map_list_apiState extends State<Map_list_api> {

  Completer<GoogleMapController> _controller = Completer();

  List insectPoint = [];
  List<Marker> _marker = [];
  String userID = "";

  Future getInsectPointList() async{
    HttpOverrides.global = MyHttpOverrides();
    Uri url = Uri.parse("https://morvita.cocopatch.com/get_insectpoint.php");
    var response = await Http.get(url);
    //print(response.body);
    insectPoint = json.decode(response.body);
    print(insectPoint);
    setState(() {});

    updateMarkers();
  }

  void updateMarkers() {
    print('Welcome to setState');
    print('insectPoint length = ${insectPoint.length}');
    for (int i = 0; i < insectPoint.length; i++) {
      print('Map created loop');

      final iPoint = insectPoint[i];
      var iLat = double.parse(iPoint['ip_latitude']);
      var iLng = double.parse(iPoint['ip_longitude']);

      if(iPoint['u_id'].toString() == userID ){
        _marker.add(
          Marker(
            markerId: MarkerId(iPoint['ip_id'].toString()),
            position: LatLng(iLat, iLng),
            infoWindow: InfoWindow(title: iPoint['ip_name'].toString(),),
          ),
        );
      }
    }
  }


  @override
  void initState(){
    getInsectPointList();
    show_sh();
    super.initState();
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
    return GoogleMap(
      onMapCreated: (GoogleMapController controller) {
        _controller.complete(controller);
      },
      initialCameraPosition: CameraPosition(
        target: LatLng(13.66045, 100.52374),
        zoom: 5,
      ),
      markers: Set<Marker>.of(_marker),
      myLocationEnabled: true,
      myLocationButtonEnabled: true,
    );
  }
}
