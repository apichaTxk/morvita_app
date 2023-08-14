import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class Map_show extends StatefulWidget {
  const Map_show({Key? key}) : super(key: key);

  @override
  State<Map_show> createState() => _Map_showState();
}

class _Map_showState extends State<Map_show> {
  
  late GoogleMapController mapController;
  
  final LatLng _center = const LatLng(16.250642, 103.259681);

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Google Maps"),
      ),
      body: GoogleMap(
        onMapCreated: _onMapCreated,
        initialCameraPosition: CameraPosition(
          target: _center,
          zoom: 11.0,
        ),
      ),
    );
  }
}
