// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter_rating_stars/flutter_rating_stars.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:our_foodie/home_page/MapsOfNearByMe.dart';
import 'package:our_foodie/saveData.dart';
import 'package:our_foodie/shops/shop_details.dart';
import 'package:our_foodie/test.dart';

class ShopMapView extends StatefulWidget {
  ShopDetailsConvertor data;

  ShopMapView({required this.data});

  @override
  State<ShopMapView> createState() => _ShopMapViewState();
}

class _ShopMapViewState extends State<ShopMapView> {
  bool _isBottomSheetVisible = false;
  BitmapDescriptor markerIcon = BitmapDescriptor.defaultMarker;
  LatLng? _currentLatLng;

  Future<void> _getCurrentLocation() async {

    bool serviceEnabled;
    LocationPermission permission;
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return;
    }
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return;
    }

    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);

    setState(() {
      _currentLatLng = LatLng(position.latitude, position.longitude);
    });
  }

  @override
  void initState() {
    addCustomIcon();
    super.initState();
    _getCurrentLocation();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _showInitialBottomSheet();
    });
  }

  void addCustomIcon() {
    BitmapDescriptor.fromAssetImage(
        ImageConfiguration.empty,"assets/mapicons/restaurants.png")
        .then(
          (icon) {
            markerIcon = icon;
      },
    );

  }

  late GoogleMapController mapController;

  void _showInitialBottomSheet() {
    setState(() {
      _isBottomSheetVisible = true;
    });

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) {
        return SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Center(
                child: InkWell(
                  onTap: () {
                    Navigator.pop(context);
                    setState(() {
                      _isBottomSheetVisible = false;
                    });
                  },
                  child: Container(
                    padding: EdgeInsets.all(5),
                    margin: EdgeInsets.symmetric(vertical: 8),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: Colors.white),
                    child: Icon(
                      Icons.close,
                      size: 30,
                      color: Colors.red,
                    ),
                  ),
                ),
              ),
              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.blueGrey.shade900,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30),
                  ),
                ),
                child: SafeArea(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(
                          left: 15.0,
                          top: 10,
                        ),
                        child: Center(
                          child: Text(
                            widget.data.headings.commonName,
                            style: TextStyle(
                              fontSize: 20,
                              color: Colors.white,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.all(5),
                        padding: EdgeInsets.all(8),
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: Color.fromARGB(255, 27, 32, 35),
                          borderRadius: BorderRadius.circular(25),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(20),
                              child: ImageShowAndDownload(
                                image: widget.data.thumbnail.fileUrl,
                                isZoom: true,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(5.0),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    widget.data.headings.shopName,
                                    style: TextStyle(
                                      fontSize: 20,
                                      color: Colors.white,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  RatingStars(
                                    value: 3.5,
                                  ),
                                  Wrap(
                                    direction: Axis.horizontal,
                                    children: widget.data.tags
                                        .map(
                                          (text) => Container(
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                              border: Border.all(
                                                  color: Colors.white30),
                                            ),
                                            padding: EdgeInsets.symmetric(
                                                vertical: 3, horizontal: 8),
                                            margin: EdgeInsets.only(
                                                right: 8, top: 8),
                                            child: Text(
                                              text,
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 13,
                                              ),
                                            ),
                                          ),
                                        )
                                        .toList(),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.all(5),
                        padding:
                            EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: Color.fromARGB(255, 27, 32, 35),
                          borderRadius: BorderRadius.circular(25),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Address",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 8.0, vertical: 3),
                              child: Column(
                                children: [
                                  Text(
                                    widget.data.address,
                                    style: TextStyle(
                                      color: Colors.white70,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    ).whenComplete(() {
      setState(() {
        _isBottomSheetVisible = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          GoogleMap(
            myLocationButtonEnabled: false,
            myLocationEnabled: true,
            initialCameraPosition: CameraPosition(
              target: LatLng(widget.data.coordinates.latitude,
                  widget.data.coordinates.longitude), // Initial camera position
              zoom: 12,
            ),
            onMapCreated: (GoogleMapController controller) {
              mapController = controller;
            },
            markers: {
              Marker(
                markerId: MarkerId(widget.data.headings.shopName),
                position: LatLng(widget.data.coordinates.latitude,
                    widget.data.coordinates.longitude),
                icon: markerIcon,
              ),
              if(_currentLatLng!=null)Marker(
                markerId: MarkerId("You"),
                position: LatLng(_currentLatLng!.latitude,
                    _currentLatLng!.longitude),
                // icon: markerIcon,
              ),
            },
            polylines: {
              Polyline(
                polylineId: PolylineId('line'),
                points: [_currentLatLng!,  LatLng(widget.data.coordinates.latitude,
                    widget.data.coordinates.longitude)],
                color: Colors.deepOrange,
                width: 3,
              ),
            },
          ),
          Positioned(
              child: backButton(
            isColorBlack: true,
          )),
          Positioned(
            top: 5,
            right: 10,
            child: AnimatedOpacity(
              opacity: !_isBottomSheetVisible ? 1.0 : 0.0,
              duration: Duration(milliseconds: 300),
              child: SafeArea(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Container(
                      padding: EdgeInsets.symmetric(vertical: 5, horizontal: 5),
                      decoration: BoxDecoration(
                        color: Color.fromARGB(255, 27, 32, 35),
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(15),
                          topRight: Radius.circular(15),
                        ),
                      ),
                      child: Container(
                        padding:
                            EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                        decoration: BoxDecoration(
                          color: Colors.orange.withOpacity(0.7),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          children: [
                            Icon(Icons.directions, color: Colors.white),
                            Text(
                              " Direction ",
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        _showInitialBottomSheet();
                      },
                      child: Container(
                        padding: EdgeInsets.only(
                            bottom: 8, left: 12, right: 12, top: 5),
                        decoration: BoxDecoration(
                          color: Color.fromARGB(255, 27, 32, 35),
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(15),
                            bottomLeft: Radius.circular(15),
                            bottomRight: Radius.circular(15),
                          ),
                        ),
                        child: Column(
                          children: [
                            Row(
                              children: [
                                Text(
                                  "${widget.data.headings.shopName} ",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18,
                                  ),
                                ),

                                Icon(Icons.expand_circle_down,
                                    color: Colors.white),
                              ],
                            ),
                            Row(
                              children: [
                                Text(
                                  "~ ${double.parse(calculateDistance(_currentLatLng!.latitude, _currentLatLng!.longitude, widget.data.coordinates.latitude, widget.data.coordinates.longitude).toStringAsFixed(1))}Km from You (Straight Line)",
                                  style: TextStyle(
                                    color: Colors.white70,
                                    fontWeight: FontWeight.w500,
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
