// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:our_foodie/test.dart';

class MapScreen extends StatefulWidget {
  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  late GoogleMapController mapController;
   LatLng _pickedLocation=LatLng(0, 0); // Default location
  Set<Marker> _markers = Set();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GoogleMap(
          myLocationButtonEnabled:false,
        initialCameraPosition: CameraPosition(
          target: LatLng(16.544922, 81.521229), // Initial camera position
          zoom: 15,
        ),
        onMapCreated: (GoogleMapController controller) {
          mapController = controller;
        },
        onTap: (LatLng location) {
          setState(() {
            _pickedLocation = location;
            _markers.clear();
            _markers.add(
              Marker(
                markerId: MarkerId('picked-location'),
                position: _pickedLocation,
                infoWindow: InfoWindow(title: 'Picked Location'),
              ),
            );
          });
        },
        markers: _markers,
      ),
      floatingActionButton:(_pickedLocation.longitude!=0)&&(_pickedLocation.latitude!=0)? FloatingActionButton(
        onPressed: () {
          Navigator.pop(context, CoordinatesConvertor(
            latitude:_pickedLocation.latitude,
            longitude:_pickedLocation.longitude,
          ));
        },
        child: Icon(Icons.check),
      ):Container(),
    );
  }
}
