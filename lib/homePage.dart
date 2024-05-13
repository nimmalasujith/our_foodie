// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'dart:async';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_rating_stars/flutter_rating_stars.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:our_foodie/saveData.dart';
import 'package:our_foodie/test%20page%20too.dart';
import 'package:our_foodie/test.dart';

import 'SearchBar.dart';

final GlobalKey<_MapPageState> HomePageKey = GlobalKey<_MapPageState>();

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.all(10.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Our Foodie",
                        style:
                            TextStyle(fontSize: 25, fontWeight: FontWeight.w500),
                      ),
                      Row(
                        children: [
                          Icon(
                            Icons.location_on_outlined,
                            size: 15,
                          ),
                          Text(
                            "Bhimavaram",
                            style: TextStyle(
                                fontWeight: FontWeight.w500, fontSize: 15),
                          ),
                        ],
                      ),
                    ],
                  ),
                  Container(
                    padding: EdgeInsets.all(5),
                    margin: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.blueGrey.shade900,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Icon(
                      Icons.search,
                      color: Colors.white,
                    ),
                  )
                ],
              ),
            ),
            Container(
              margin: EdgeInsets.symmetric(vertical: 5,horizontal: 10),
              height: 130,
              width: double.infinity,
              decoration: BoxDecoration(color: Colors.black12,borderRadius: BorderRadius.circular(10)),
              child: ClipRRect(borderRadius: BorderRadius.circular(10),child: Stack(
                children: [
                  MapScreen(),
                  Positioned(
                      top: 0,
                      bottom: 0,
                      right: 0,
                      left: 0,
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(11),
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Colors.transparent,
                              Colors.transparent,
                              Colors.transparent,     Colors.transparent,


                              Colors.black26,
                              Colors.black38,
                              Colors.black54,
                              Colors.black87,
                              Colors.black
                            ],
                          ),
                        ),
                        child: Align(
                          alignment: Alignment.bottomLeft,
                          child: Text(
                            " Get Foodie... Near By You",
                            style: TextStyle(color: Colors.white,fontSize: 20),
                          ),
                        ),
                      ))
                ],
              )),
            ),
            // Center(child: Text("Be a member and earn money from this app")),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10.0),
              child: SizedBox(
                height: 30,
                child: Row(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.03),
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: Colors.black12)),
                      margin: EdgeInsets.only(left: 10),
                      padding: EdgeInsets.all(5),
                      alignment: Alignment.center,
                      child: Row(
                        children: [
                          Icon(Icons.sort),
                          Text("sort"),
                          Icon(Icons.arrow_drop_down),
                        ],
                      ),
                    ),
                    ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: 3,
                        physics: NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemBuilder: (BuildContext context, int index) {
                          return Container(
                            decoration: BoxDecoration(
                                color: Colors.black.withOpacity(0.03),
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(color: Colors.black12)),
                            margin: EdgeInsets.only(left: 10),
                            padding: EdgeInsets.all(5),
                            child: Text("$index foodie"),
                          );
                        }),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Text(
                "Today Try This",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
              ),
            ),
            ListView.builder(
                itemCount: 3,
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),

                itemBuilder: (BuildContext context, int index) {
                  return Container(
                    decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.02),
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: Colors.black12)),
                    margin: EdgeInsets.symmetric(vertical: 2, horizontal: 10),
                    padding: EdgeInsets.all(10),
                    child: Text("$index foodie"),
                  );
                }),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Text(
                "Famous Foodies",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
              ),
            ),
            ListView.builder(
                itemCount: 5,
                physics: NeverScrollableScrollPhysics(),

                shrinkWrap: true,
                itemBuilder: (BuildContext context, int index) {
                  return Container(
                    decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.02),
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: Colors.black12)),
                    margin: EdgeInsets.symmetric(vertical: 2, horizontal: 10),
                    padding: EdgeInsets.all(10),
                    child: Text("$index foodie"),
                  );
                }),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Text(
                "Categorise",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
              ),
            ),
            GridView.builder(
              physics: NeverScrollableScrollPhysics(),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3, // Number of columns
                crossAxisSpacing: 10, // Spacing between columns
                mainAxisSpacing: 10, // Spacing between rows
                childAspectRatio: 1, // Aspect ratio of each grid item
              ),
              itemCount: 5,
              shrinkWrap: true,
              itemBuilder: (BuildContext context, int index) {
                return Column(
                  children: [
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.02),
                          borderRadius: BorderRadius.circular(70),
                          border: Border.all(color: Colors.black12),
                        ),
                        margin: EdgeInsets.symmetric(vertical: 2, horizontal: 10),
                        padding: EdgeInsets.all(10),

                      ),
                    ),
                    Text("$index foodie")
                  ],
                );
              },
            ),
            SizedBox(height: 100,)
          ],
        ),
      ),
    );
  }
}

class MapPage extends StatefulWidget {
  MapPage({Key? key}) : super(key: HomePageKey);

  @override
  _MapPageState createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
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
                                  onValueChanged: (v) {},
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
                                  animationDuration:
                                      Duration(milliseconds: 1000),
                                  valueLabelPadding: const EdgeInsets.symmetric(
                                      vertical: 2, horizontal: 10),
                                  valueLabelMargin:
                                      const EdgeInsets.only(right: 10),
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
