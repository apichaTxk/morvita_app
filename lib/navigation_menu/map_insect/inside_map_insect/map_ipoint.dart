import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

class MapIpoint extends StatefulWidget {
  const MapIpoint({Key? key}) : super(key: key);

  @override
  State<MapIpoint> createState() => _MapIpointState();
}

class _MapIpointState extends State<MapIpoint> {
  late GoogleMapController mapController;
  late LatLng _currentPosition = LatLng(0, 0);
  final Set<Marker> _markers = {};

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
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

  void _addMarker(LatLng position) {
    setState(() {
      _markers.clear(); // This will clear all markers
      _markers.add(Marker(
        markerId: MarkerId(position.toString()),
        position: position,
        infoWindow: InfoWindow(
          title: 'Insect point location',
          snippet: 'Latitude: ${position.latitude}, Longitude: ${position.longitude}',
        ),
      ));
      _currentPosition = position;
      print('Latitude: ${position.latitude}, Longitude: ${position.longitude}');
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
          'กดเพื่อเลือกพิกัดจุดที่พบแมลง',
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
          target: LatLng(13.66045, 100.52374), // Will be updated when user location is fetched
          zoom: 5.0,
        ),
        markers: _markers,
        onTap: _addMarker,
        myLocationEnabled: true,
        myLocationButtonEnabled: true,
      ),
      floatingActionButton: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(20)),
          boxShadow: [
            BoxShadow(
              color: Color(0xFF0A4483).withOpacity(0.5),
              spreadRadius: 4,
              blurRadius: 10,
            ),
          ],
        ),
        child: FloatingActionButton.extended(
          onPressed: () {
            if(_currentPosition.latitude != 0 && _currentPosition.longitude != 0){
              Navigator.of(context).pop(_currentPosition);
            } else {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    title: Text(
                      'กรุณาระบุพิกัด',
                      style: TextStyle(
                        fontFamily: 'prompt',
                      ),
                    ),
                    content: Text(
                      'กรุณากดที่แผนที่เพื่อเลือกพิกัดที่ต้องการ',
                      style: TextStyle(
                        fontFamily: 'prompt',
                      ),
                    ),
                    actions: <Widget>[
                      TextButton(
                        child: Text(
                          'เข้าใจแล้ว',
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
            }
          },
          foregroundColor: Colors.white,
          backgroundColor: Color(0xFF0A4483),
          splashColor: Colors.white,
          elevation: 0,
          icon: Icon(
            Icons.location_on,
            size: 25,
          ),
          label: Text(
            'เลือกพิกัดแมลง',
            style: TextStyle(
                fontFamily: 'Prompt',
                fontSize: 18,
                fontWeight: FontWeight.w600),
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
