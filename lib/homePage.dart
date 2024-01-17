// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'dart:async';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_rating_stars/flutter_rating_stars.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:our_foodie/saveData.dart';
import 'package:our_foodie/test.dart';

import 'SearchBar.dart';

final GlobalKey<_HomePageState> HomePageKey = GlobalKey<_HomePageState>();

class HomePage extends StatefulWidget {
  HomePage({Key? key}) : super(key: HomePageKey);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  GoogleMapController? _mapController;

  void changeTab(LatLng coordinates) {
    _mapController?.animateCamera(
      CameraUpdate.newLatLngZoom(
          LatLng(coordinates.latitude, coordinates.longitude), 16),
    );
  }

  Set<Marker> _markers = Set<Marker>();

  int markerIdCounter = 1;
  static const CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(16.544922, 81.521229),
    zoom: 14.4746,
  );

  TextEditingController searchController = TextEditingController();
  List<shopDetailsConvertor> shopDetails = [];
  List<shopDetailsConvertor> data = [];
  shopDetailsConvertor showBottomData = shopDetailsConvertor(
      id: "",
      coordinates: "",
      contacts: ContactsConvertor(numbers: [], emails: []),
      address: "",
      images: Images(otherImages: [], mainImage: ""),
      tags: [],
      headings: Headings(fullHeading: "", shortHeading: ""),
      rating: [],
      description: "",
      reviews: []);

  setData(List<shopDetailsConvertor> filteredData) {
    setState(() {
      data = filteredData;
    });
  }

  void callbackFunction(int index, CarouselPageChangedReason reason) {
    LatLng position = LatLng(
      double.parse(data[index].coordinates.split(",")[0]),
      double.parse(data[index].coordinates.split(",")[1]),
    );
    _markers.clear();
    setState(() {
      _markers.add(
        Marker(
          markerId: MarkerId(_markers.length.toString()),
          position: position,
          infoWindow: InfoWindow(title: ""),
        ),
      );
      showBottomData = data[index];
    });

    HomePageKey.currentState!.changeTab(position);
  }

  @override
  void initState() {
    getData();

    super.initState();
  }

  Future<dynamic> getData() async {
    shopDetails = await getShopDetails(true);

    setState(() {
      shopDetails;
    });
  }

  bool isTapped = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: RefreshIndicator(
        onRefresh: getData,
        child: Stack(
          children: [
            Stack(
              children: [
                SizedBox(
                  height: double.infinity,
                  width: double.infinity,
                  child: GoogleMap(
                    compassEnabled: true,
                    onMapCreated: (controller) {
                      _mapController = controller;
                    },
                    initialCameraPosition: _kGooglePlex,
                    markers: _markers,
                  ),
                ),
                if (isTapped)
                  Positioned(
                      child: Container(
                    color: Colors.black54,
                  ))
              ],
            ),
            if (data.isNotEmpty)
              Positioned(
                  bottom: 40,
                  left: 0,
                  right: 0,
                  child: CarouselSlider.builder(
                      itemCount: data.length,
                      itemBuilder: (BuildContext context, int itemIndex,
                              int pageViewIndex) =>
                          InkWell(
                            onTap: () {
                              setState(() {
                                isTapped = true;
                                showBottomData = data[itemIndex];
                              });
                            },
                            child: Container(
                              width: double.infinity,
                              decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.9),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.grey.withOpacity(0.5),
                                      spreadRadius: 2,
                                      blurRadius: 5,
                                      offset: Offset(0, 2),
                                    ),
                                  ],
                                  borderRadius: BorderRadius.circular(18)),
                              child: Column(
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Container(
                                        height: 90,
                                        width: 180,
                                        margin: EdgeInsets.all(3),
                                        decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(15),
                                            image: DecorationImage(
                                                image: NetworkImage(
                                                    data[itemIndex]
                                                        .images
                                                        .mainImage),
                                                fit: BoxFit.cover)),
                                      ),
                                      Expanded(
                                        child: Column(
                                          children: [
                                            Padding(
                                              padding:
                                                  const EdgeInsets.all(3.0),
                                              child: Text(
                                                data[itemIndex]
                                                    .headings
                                                    .fullHeading,
                                                style: TextStyle(
                                                    color: Colors.black,
                                                    fontSize: 20),
                                                maxLines: 2,
                                              ),
                                            ),
                                            Padding(
                                              padding:
                                                  const EdgeInsets.all(3.0),
                                              child: Text(
                                                "${data[itemIndex].id}",
                                                style: TextStyle(
                                                    color: Colors.black,
                                                    fontSize: 16),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(left: 5.0),
                                    child: Text(
                                      data[itemIndex].address,
                                      style: TextStyle(
                                          color: Colors.black, fontSize: 16),
                                      maxLines: 2,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                      options: CarouselOptions(
                        height: 150,
                        viewportFraction: 0.9,
                        initialPage: 0,
                        autoPlayInterval: Duration(seconds: 3),
                        autoPlayAnimationDuration: Duration(milliseconds: 800),
                        autoPlayCurve: Curves.fastOutSlowIn,
                        enlargeCenterPage: true,
                        enlargeFactor: 0.18,
                        onPageChanged: callbackFunction,
                        scrollDirection: Axis.horizontal,
                      ))),
            if (showBottomData.id.isNotEmpty && isTapped)
              Positioned(
                top: 0,
                left: 0,
                right: 0,
                child: SafeArea(
                  child: Container(
                      margin: EdgeInsets.only(top: 10, left: 10, right: 10),
                      decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.9),
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(20),
                            topRight: Radius.circular(20),
                            bottomRight: Radius.circular(20),
                            bottomLeft: Radius.circular(20),
                          )),
                      height: 500,
                      width: double.infinity,
                      child: Column(
                        children: [
                          Expanded(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                InkWell(
                                  onTap: () {
                                    setState(() {
                                      showBottomData = shopDetailsConvertor(
                                          id: "",
                                          coordinates: "",
                                          contacts: ContactsConvertor(
                                              numbers: [], emails: []),
                                          address: "",
                                          images: Images(
                                              otherImages: [], mainImage: ""),
                                          tags: [],
                                          headings: Headings(
                                              fullHeading: "",
                                              shortHeading: ""),
                                          rating: [],
                                          description: "",
                                          reviews: []);
                                      isTapped = false;
                                    });
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.all(10.0),
                                    child: Wrap(
                                      children: [
                                        Icon(Icons.arrow_back),
                                        Text('back')
                                      ],
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(5.0),
                                  child: Row(
                                    children: [
                                      Expanded(
                                          flex: 3,
                                          child: AspectRatio(
                                            aspectRatio: 16 / 9,
                                            child: ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(20),
                                              child: Image.network(
                                                showBottomData.images.mainImage,
                                                fit: BoxFit.cover,
                                              ),
                                            ),
                                          )),
                                      if (showBottomData
                                          .images.otherImages.isNotEmpty)
                                        SizedBox(
                                          width: 3,
                                        ),
                                      if (showBottomData
                                          .images.otherImages.isNotEmpty)
                                        Expanded(
                                          child: ListView.builder(
                                              shrinkWrap: true,
                                              itemCount: 3,
                                              itemBuilder: (context,
                                                      int index) =>
                                                  AspectRatio(
                                                    aspectRatio: 16 / 9,
                                                    child: Container(
                                                      margin:
                                                          EdgeInsets.symmetric(
                                                              vertical: 1),
                                                      width: double.infinity,
                                                      decoration: BoxDecoration(
                                                          image: DecorationImage(
                                                              image: NetworkImage(
                                                                  "showBottomData.images.otherImages[index]")),
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(10),
                                                          color:
                                                              Colors.black12),
                                                    ),
                                                  )),
                                        )
                                    ],
                                  ),
                                ),
                                Text(
                                  showBottomData.headings.shortHeading,
                                  style: TextStyle(fontSize: 20),
                                ),
                                Text(
                                  showBottomData.headings.fullHeading,
                                  style: TextStyle(fontSize: 20),
                                ),
                                Text(
                                  showBottomData.address,
                                  style: TextStyle(fontSize: 20),
                                ),
                                RatingStars(
                                  value: 2.5,
                                  onValueChanged: (v) {

                                  },
                                  starBuilder: (index, color) => Icon(
                                    Icons.ac_unit_outlined,
                                    color: color,
                                  ),
                                  starCount: 5,
                                  starSize: 30,
                                  valueLabelColor: const Color(0xff9b9b9b),
                                  valueLabelTextStyle: const TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w400,
                                      fontStyle: FontStyle.normal,
                                      fontSize: 12.0),
                                  valueLabelRadius: 10,
                                  maxValue: 5,
                                  starSpacing: 2,
                                  maxValueVisibility: true,
                                  valueLabelVisibility: true,
                                  animationDuration: Duration(milliseconds: 1000),
                                  valueLabelPadding:
                                  const EdgeInsets.symmetric(vertical: 2, horizontal: 10),
                                  valueLabelMargin: const EdgeInsets.only(right: 10),
                                  starOffColor: const Color(0xffe7e8ea),
                                  starColor: Colors.orange,
                                )
                              ],
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Container(
                                margin: EdgeInsets.symmetric(
                                    horizontal: 5, vertical: 5),
                                padding: EdgeInsets.symmetric(horizontal: 10),
                                decoration: BoxDecoration(
                                    color: Colors.greenAccent,
                                    borderRadius: BorderRadius.circular(20)),
                                child: Row(
                                  children: [
                                    Text(
                                      "Show Directions",
                                      style: TextStyle(fontSize: 20),
                                    ),
                                    Icon(Icons.directions)
                                  ],
                                ),
                              ),
                              Container(
                                margin: EdgeInsets.symmetric(
                                    horizontal: 5, vertical: 5),
                                padding: EdgeInsets.symmetric(horizontal: 10),
                                decoration: BoxDecoration(
                                    color: Colors.greenAccent,
                                    borderRadius: BorderRadius.circular(20)),
                                child: Row(
                                  children: [
                                    Text(
                                      "Start",
                                      style: TextStyle(fontSize: 20),
                                    ),
                                    Icon(Icons.directions)
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ],
                      )),
                ),
              ),
            if (!isTapped)
              Positioned(
                  top: 0,
                  left: 0,
                  right: 0,
                  child:
                      SafeArea(child: SearchBarContainer(data: shopDetails))),
          ],
        ),
      ),
      // floatingActionButton: IconButton(
      //   icon: Icon(Icons.add),
      //   onPressed: () {

      //   },
      // ),
      // floatingActionButton: Row(
      //   children: [

      //     IconButton(
      //         onPressed: () {
      //           setState(() {
      //             searchToggle = true;
      //             radiusSlider = false;
      //             pressedNear = false;
      //             cardTapped = false;
      //             getDirections = false;
      //           });
      //         },
      //         icon: Icon(Icons.search)),
      //     IconButton(
      //         onPressed: () {
      //           setState(() {
      //             searchToggle = false;
      //             radiusSlider = false;
      //             pressedNear = false;
      //             cardTapped = false;
      //             getDirections = true;
      //           });
      //         },
      //         icon: Icon(Icons.navigation))
      //   ],
      // ),
    );
  }

  void addMarker(LatLng position, String title) {
    setState(() {
      _markers.add(
        Marker(
          markerId: MarkerId(_markers.length.toString()),
          position: position,
          infoWindow: InfoWindow(title: title),
        ),
      );
    });
  }

  void editMarker(String markerId, LatLng newPosition, String newTitle) {
    setState(() {
      _markers.removeWhere((marker) => marker.markerId.value == markerId);
      _markers.add(
        Marker(
          markerId: MarkerId(markerId),
          position: newPosition,
          infoWindow: InfoWindow(title: newTitle),
        ),
      );
    });
  }

  void deleteMarker(String markerId) {
    setState(() {
      _markers.removeWhere((marker) => marker.markerId.value == markerId);
    });
  }
}
