import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class Mapmap extends StatefulWidget {
  const Mapmap({Key? key}) : super(key: key);

  @override
  State<Mapmap> createState() => _MapmapState();
}

class _MapmapState extends State<Mapmap> {
  Completer<GoogleMapController> _controller = Completer();
  static final CameraPosition _kGooglePlex = const CameraPosition(
      target: LatLng(16.2384341, 103.2536846), zoom: 14.4746);
  List<Marker> _marker = [];
  List<Marker> _list = const [
    Marker(
        markerId: MarkerId('1'),
        position: LatLng(16.2384341, 103.2536846),
        infoWindow: InfoWindow(title: 'แมลงสาบ')),
    Marker(
        markerId: MarkerId('2'),
        position: LatLng(16.2502918, 103.2655813),
        infoWindow: InfoWindow(title: 'บักเมฆ')),
    Marker(
        markerId: MarkerId('3'),
        position: LatLng(16.2472842, 103.2601311),
        infoWindow: InfoWindow(title: 'หอพักสตรีเดอะณิช')),
    Marker(
        markerId: MarkerId('4'),
        position: LatLng(16.2446678, 103.2565798),
        infoWindow: InfoWindow(title: 'โรงงานผลิตน้ำดื่ม มมส')),
    Marker(
        markerId: MarkerId('5'),
        position: LatLng(16.2387553, 103.257245),
        infoWindow: InfoWindow(title: 'หอ เฟรชชี่'))
  ];
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _marker.addAll(_list);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: GoogleMap(
          initialCameraPosition: _kGooglePlex,
          mapType: MapType.normal,
          myLocationEnabled: true,
          compassEnabled: true,
          markers: Set<Marker>.of(_marker),
          onMapCreated: (GoogleMapController controller) {
            _controller.complete(controller);
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.location_disabled_outlined),
        onPressed: ()async{
          GoogleMapController controller = await _controller.future ;
          controller.animateCamera(CameraUpdate.newCameraPosition(
              CameraPosition(
                  target: LatLng(16.2384341, 103.2536846),
                  zoom: 14
              )
          ));
        },
      ),
    );
  }
}
