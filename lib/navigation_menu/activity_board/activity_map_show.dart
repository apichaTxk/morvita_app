import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

class ActivityMapShow extends StatefulWidget {
  final String map_lat;
  final String map_long;
  final String markerInfo;
  final String titieAppBar;

  ActivityMapShow({
    required this.map_lat,
    required this.map_long,
    required this.markerInfo,
    required this.titieAppBar,
  });

  @override
  State<ActivityMapShow> createState() => _ActivityMapShowState();
}

class _ActivityMapShowState extends State<ActivityMapShow> {

  late GoogleMapController mapController;
  final Set<Marker> _markers = {};

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;

    setState(() {
      // สร้าง Marker จาก activity_lat และ activity_long และเพิ่มเข้าไปใน _markers set
      _markers.add(
          Marker(
            markerId: MarkerId('activity_marker'), // ใส่ ID ให้กับ Marker
            position: LatLng(
                double.parse(widget.map_lat),
                double.parse(widget.map_long)
            ),
            infoWindow: InfoWindow(
              title: widget.markerInfo, // ใส่ข้อความที่ต้องการแสดงเมื่อคลิกที่ Marker
            ),
          )
      );
    });

    _locateUser();
  }


  void _locateUser() async {
    var location = new Location();
    location.onLocationChanged.listen((l) {
      mapController.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(target: LatLng(l.latitude!, l.longitude!), zoom: 15),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        title: Text(
          widget.titieAppBar,
          style: TextStyle(
            fontFamily: "Prompt",
            fontWeight: FontWeight.w600,
            color: Colors.black87,
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
      body: GoogleMap(
        onMapCreated: _onMapCreated,
        initialCameraPosition: CameraPosition(
          target: LatLng(double.parse(widget.map_lat), double.parse(widget.map_long)), // Will be updated when user location is fetched
          zoom: 15.0,
        ),
        markers: _markers,
        myLocationEnabled: true,
        myLocationButtonEnabled: true,
      ),
    );
  }
}
