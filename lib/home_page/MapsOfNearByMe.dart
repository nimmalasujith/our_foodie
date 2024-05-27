// ignore_for_file: unnecessary_import, prefer_const_constructors


import 'dart:math';

import 'package:carousel_slider/carousel_options.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_stars/flutter_rating_stars.dart';
import 'package:geolocator/geolocator.dart';

// import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'package:our_foodie/saveData.dart';
import 'package:our_foodie/shops/shop_details.dart';
import 'package:our_foodie/test.dart';

class MapOfNearByMe extends StatefulWidget {
  List<ShopDetailsConvertor> data;

  MapOfNearByMe({required this.data});

  @override
  _MapOfNearByMeState createState() => _MapOfNearByMeState();
}

class _MapOfNearByMeState extends State<MapOfNearByMe> {
  double _currentSliderValue = 0;
  bool isRadarOn = false;
  TextEditingController _textEditingController = TextEditingController();

  GoogleMapController? _mapController;

  void changeTab(LatLng coordinates) {
    _mapController?.animateCamera(
      CameraUpdate.newLatLngZoom(
          LatLng(coordinates.latitude, coordinates.longitude), 16),
    );
  }

  Set<Marker> _markers = Set<Marker>();

  int markerIdCounter = 1;
  CameraPosition kGooglePlex = CameraPosition(
    target: LatLng(16.544922, 81.521229),
    zoom: 14.4746,
  );

  TextEditingController searchController = TextEditingController();

  void callbackFunction(int index, CarouselPageChangedReason reason) {
    LatLng position = LatLng(widget.data[index].coordinates.latitude,
        widget.data[index].coordinates.longitude);
    _markers.clear();
    setState(() {
      _markers.add(
        Marker(
          markerId: MarkerId(_markers.length.toString()),
          position: position,
          infoWindow: InfoWindow(title: ""),
        ),
      );
    });
  }

  bool isTapped = false;

  ShowAllLocations(List<ShopDetailsConvertor> data) {
    for (ShopDetailsConvertor x in data) {
      addMarker(LatLng(x.coordinates.latitude, x.coordinates.longitude),
          x.headings.shopName, x.id);
    }
  }

  BitmapDescriptor markerIcon = BitmapDescriptor.defaultMarker;

  @override
  void initState() {
    addCustomIcon();
    super.initState();
    ShowAllLocations(widget.data);
    _searchResult.addAll(widget.data);
    _getCurrentLocation();
    WidgetsBinding.instance.addPostFrameCallback((_) {});
  }

  LatLng _currentLatLng = LatLng(0, 0);

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
      // _currentLatLng = LatLng(16.557331633656013, 81.52295988053085);
      _currentLatLng = LatLng(position.latitude, position.longitude);
    });
  }

  void addCustomIcon() {
    BitmapDescriptor.fromAssetImage(
            ImageConfiguration.empty, "assets/mapicons/restaurants.png")
        .then(
      (icon) {
        markerIcon = icon;
      },
    );
  }

  late GoogleMapController mapController;
  bool _isBottomSheetVisible = false;

  void _showInitialBottomSheet(ShopDetailsConvertor data) {
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
                            data.headings.commonName,
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
                                image: data.thumbnail.fileUrl,
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
                                    data.headings.shopName,
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
                                    children: data.tags
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
                                    data.address,
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

  bool isCarouselSliderClosed = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Stack(
            children: [
              SizedBox(
                height: double.infinity,
                width: double.infinity,
                child: GoogleMap(
                  myLocationButtonEnabled: false,
                  compassEnabled: false,
                  onMapCreated: (controller) {
                    _mapController = controller;
                  },
                  circles: _createCircle(),
                  initialCameraPosition: kGooglePlex,
                  markers: _markers,
                ),
              ),
            ],
          ),
          Positioned(
              bottom: 40,
              left: 0,
              right: 0,
              child: AnimatedOpacity(
                opacity: isCarouselSliderClosed && _searchResult.isNotEmpty
                    ? 1.0
                    : 0.0,
                duration: Duration(milliseconds: 300),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    InkWell(
                      onTap: () {
                        setState(() {
                          isCarouselSliderClosed = false;
                          ShowAllLocations(widget.data);
                        });
                      },
                      child: Container(
                        margin:
                            EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                        padding:
                            EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                        decoration: BoxDecoration(
                            color: Color.fromARGB(255, 27, 32, 35),
                            borderRadius: BorderRadius.circular(20)),
                        child: Icon(
                          Icons.close,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    if(_searchResult.isNotEmpty)CarouselSlider.builder(
                        itemCount: _searchResult.length,
                        itemBuilder: (BuildContext context, int itemIndex,
                            int pageViewIndex) {
                          final data = _searchResult[itemIndex];
                          return InkWell(
                            onTap: () {
                              setState(() {
                                isTapped = !isTapped;
                                _showInitialBottomSheet(data);
                              });
                            },
                            child: Container(
                              width: double.infinity,
                              padding: EdgeInsets.all(3),
                              decoration: BoxDecoration(
                                  color: Color.fromARGB(255, 27, 32, 35),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.grey.withOpacity(0.5),
                                      spreadRadius: 2,
                                      blurRadius: 5,
                                      offset: Offset(0, 2),
                                    ),
                                  ],
                                  borderRadius: BorderRadius.circular(24)),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(20),
                                    child: AspectRatio(
                                      aspectRatio: 1,
                                      child: ImageShowAndDownload(
                                        image: data.thumbnail.fileUrl,
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    child: Column(
                                      children: [
                                        Text(
                                          data.headings.commonName,
                                          style: TextStyle(
                                              fontSize: 18,
                                              color: Colors.black),
                                        ),
                                        Text(
                                          data.headings.shopName,
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontWeight: FontWeight.w500,
                                              fontSize: 22),
                                          maxLines: 2,
                                        ),
                                        RatingStars(
                                          value: 2.8,
                                          starColor: Colors.orangeAccent,
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.all(3.0),
                                          child: Text(
                                            "${data.address}",
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
                            ),
                          );
                        },
                        options: CarouselOptions(
                          enableInfiniteScroll:false,
                          height: 130,
                          viewportFraction: 0.9,
                          initialPage: 0,
                          autoPlayInterval: Duration(seconds: 3),
                          autoPlayAnimationDuration:
                              Duration(milliseconds: 800),
                          autoPlayCurve: Curves.fastOutSlowIn,
                          enlargeCenterPage: true,
                          enlargeFactor: 0.18,
                          onPageChanged: callbackFunction,
                          scrollDirection: Axis.horizontal,
                        )),
                  ],
                ),
              )),
          Positioned(
              bottom: 20,
              right: 0,
              child: !isCarouselSliderClosed? SafeArea(
                child: InkWell(
                  onTap: () {
                    if(!isRadarOn){
                      _searchResult.clear();
                      _searchResult.addAll(widget.data);
                    }
                    setState(() {
                      if (_searchResult.isEmpty) {
                        showToastText("No Shops");
                      } else {
                        isCarouselSliderClosed = true;
                      }
                    });
                  },
                  child: Container(
                    margin: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                    padding:
                        EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                    decoration: BoxDecoration(
                        color: Color.fromARGB(255, 27, 32, 35),
                        borderRadius: BorderRadius.circular(20)),
                    child: Text(
                      "Show Shops",
                      style: TextStyle(color: Colors.white, fontSize: 20),
                    ),
                  ),
                ),
              ):Container()),
          Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: SafeArea(
                child: Column(
                  children: [
                    backButton(
                      isColorBlack: true,
                    ),
                    AnimatedOpacity(
                      opacity: !_isBottomSheetVisible ? 1.0 : 0.0,
                      duration: Duration(milliseconds: 300),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: Container(
                                  margin: EdgeInsets.only(
                                      left: 15, top: 5, right: 5),
                                  decoration: BoxDecoration(
                                      color: Color.fromARGB(255, 27, 32, 35),
                                      borderRadius: BorderRadius.circular(25),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.grey.withOpacity(0.2),
                                          // Shadow color
                                          spreadRadius: 2,
                                          // How far the shadow should spread
                                          blurRadius: 1,
                                          // How soft the shadow should be
                                          offset: Offset(
                                              0, 2), // Offset of the shadow
                                        ),
                                      ],
                                      border: Border.all(
                                          color:
                                              Colors.black.withOpacity(0.1))),
                                  child: Row(
                                    children: [
                                      if (!isRadarOn)
                                        Padding(
                                          padding: const EdgeInsets.only(
                                              left: 15, right: 10),
                                          child: Icon(
                                            Icons.search,
                                            color: Colors.white70,
                                          ),
                                        ),
                                      isRadarOn
                                          ? Expanded(
                                              child: Slider(
                                                activeColor: Colors.greenAccent,
                                                thumbColor: Colors.white,
                                                value: _currentSliderValue,
                                                min: 0,
                                                max: 5000,
                                                divisions: 59,
                                                // For steps of 1 km
                                                label:
                                                    "${NumberFormat("0.0").format((_currentSliderValue / 1000)).toString()} Kms",
                                                onChanged: (double value) {

                                                  setState(() {

                                                    _searchResult = filterShopsByDistance(widget.data, _currentLatLng.latitude, _currentLatLng.longitude,_currentSliderValue/1000 );
                                                    showToastText("Available Shops ${_searchResult.length}");
                                                    kGooglePlex =
                                                        CameraPosition(
                                                      target: _currentLatLng,
                                                      zoom: 17 -
                                                          _currentSliderValue /
                                                              1200,
                                                    );
                                                    _mapController?.animateCamera(
                                                        CameraUpdate
                                                            .newCameraPosition(
                                                                kGooglePlex));
                                                    _currentSliderValue = value;
                                                  });
                                                },
                                              ),
                                            )
                                          : Expanded(
                                              child: Padding(
                                                padding: const EdgeInsets.only(
                                                    right: 10),
                                                child: TextFormField(
                                                  controller:
                                                      _textEditingController,
                                                  textInputAction:
                                                      TextInputAction.next,
                                                  style: TextStyle(
                                                    color: Colors.white,
                                                    fontWeight: FontWeight.w500,
                                                    fontSize: 20,
                                                  ),
                                                  onChanged: (value) {
                                                    setState(() {
                                                      _filterSearchResults(
                                                          _textEditingController
                                                              .text);
                                                      if (_textEditingController
                                                          .text.isNotEmpty) {
                                                        isCarouselSliderClosed =
                                                            false;
                                                      }
                                                    });
                                                  },
                                                  decoration: InputDecoration(
                                                      border: InputBorder.none,
                                                      hintText: 'Search shop',
                                                      hintStyle: TextStyle(
                                                        color: Colors.white70,
                                                        fontWeight:
                                                            FontWeight.w300,
                                                        fontSize: 20,
                                                      )),
                                                ),
                                              ),
                                            ),
                                      if (_textEditingController
                                          .text.isNotEmpty)
                                        InkWell(
                                          onTap: () {
                                            setState(() {
                                              _textEditingController.clear();
                                            });
                                          },
                                          child: Padding(
                                            padding: EdgeInsets.only(
                                                left: 5, right: 15),
                                            child: Icon(Icons.close),
                                          ),
                                        ),
                                    ],
                                  ),
                                ),
                              ),
                              InkWell(
                                onTap: () async {
                                  setState(() {

                                    isRadarOn = !isRadarOn;

                                    if (isRadarOn) {
                                      kGooglePlex = CameraPosition(
                                        target: _currentLatLng,
                                        zoom: 17 - _currentSliderValue / 1200,
                                      );
                                      _mapController?.animateCamera(
                                          CameraUpdate.newCameraPosition(
                                              kGooglePlex));
                                      _markers.add(
                                        Marker(
                                            markerId: MarkerId(
                                                _markers.length.toString()),
                                            position: _currentLatLng,
                                            infoWindow:
                                                InfoWindow(title: "You"),
                                            onTap: () {}),
                                      );
                                    } else {

                                      _currentSliderValue=0;
                                      _markers.clear();
                                      ShowAllLocations(widget.data);

                                    }
                                  });
                                },
                                child: Container(
                                  margin: EdgeInsets.only(
                                      left: 5, top: 5, right: 10),
                                  decoration: BoxDecoration(
                                      color: isRadarOn
                                          ? Colors.greenAccent
                                          : Colors.white,
                                      borderRadius: BorderRadius.circular(25),
                                      border: Border.all(
                                          color:
                                              Colors.black.withOpacity(0.1))),
                                  child: Padding(
                                    padding: const EdgeInsets.all(5.0),
                                    child: Icon(
                                      Icons.radar,
                                      size: 35,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          if (_textEditingController.text.isNotEmpty ||
                              _isBottomSheetVisible)
                            Container(
                              constraints: BoxConstraints(maxHeight: 600),
                              margin:
                                  EdgeInsets.only(left: 10, right: 65, top: 5),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  InkWell(
                                    onTap: () {
                                      setState(() {
                                        if (_searchResult.isEmpty) {
                                          showToastText("No Shops");
                                        } else {
                                          isCarouselSliderClosed = true;
                                        }
                                      });
                                    },
                                    child: Container(
                                      padding: EdgeInsets.symmetric(
                                          vertical: 5, horizontal: 10),
                                      margin: EdgeInsets.symmetric(
                                          vertical: 0, horizontal: 5),
                                      decoration: BoxDecoration(
                                          color: Colors.black87,
                                          borderRadius:
                                              BorderRadius.circular(15)),
                                      child: Text(
                                        "View All",
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.w500),
                                      ),
                                    ),
                                  ),
                                  ListView.builder(
                                      shrinkWrap: true,
                                      itemCount: _searchResult.length,
                                      itemBuilder: (context, int index) {
                                        final data = _searchResult[index];
                                        return InkWell(
                                          child: Container(
                                            margin: EdgeInsets.all(2),
                                            padding: EdgeInsets.symmetric(
                                                vertical: 5, horizontal: 10),
                                            decoration: BoxDecoration(
                                                color: Colors.black
                                                    .withOpacity(0.8),
                                                borderRadius:
                                                    BorderRadius.circular(15)),
                                            child: Column(
                                              children: [
                                                Row(
                                                  children: [
                                                    Expanded(
                                                      child: Column(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .start,
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          Text(
                                                            data.headings
                                                                .shopName,
                                                            style: TextStyle(
                                                                fontSize: 18,
                                                                color: Colors
                                                                    .white),
                                                          ),
                                                          Text(
                                                            "Rating",
                                                            style: TextStyle(
                                                                fontSize: 14,
                                                                color: Colors
                                                                    .white),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                Padding(
                                                  padding: const EdgeInsets
                                                      .symmetric(
                                                      vertical: 2.0,
                                                      horizontal: 5),
                                                  child: Text(
                                                    data.address,
                                                    style: TextStyle(
                                                        fontSize: 14,
                                                        color: Colors.white),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          onTap: () {
                                            changeTab(LatLng(
                                                data.coordinates.latitude,
                                                data.coordinates.longitude));
                                            _showInitialBottomSheet(data);

                                            _textEditingController.clear();
                                          },
                                        );
                                      }),
                                ],
                              ),
                            ),
                        ],
                      ),
                    ),
                  ],
                ),
              )),
        ],
      ),
    );
  }

  List<ShopDetailsConvertor> _searchResult = [];

  void _filterSearchResults(String query) {
    List<ShopDetailsConvertor> dummySearchList =
        List<ShopDetailsConvertor>.from(widget.data);
    if (query.isNotEmpty) {
      List<ShopDetailsConvertor> dummyListData = [];
      dummySearchList.forEach((item) {
        if (item.headings.shopName
            .toLowerCase()
            .contains(query.toLowerCase())) {
          dummyListData.add(item);
        }
      });
      setState(() {
        _searchResult.clear();
        _searchResult.addAll(dummyListData);
        ShowAllLocations(dummyListData);
      });
    } else {
      setState(() {
        _searchResult.clear();
        _searchResult.addAll(widget.data);
        ShowAllLocations(widget.data);

      });
    }
  }

  Set<Circle> _createCircle() {
    return {
      Circle(
        circleId: CircleId('1kmRadius'),
        center: _currentLatLng,
        radius: _currentSliderValue,
        fillColor: Colors.blue.withOpacity(0.5),
        strokeColor: Colors.blue,
        strokeWidth: 1,
      ),
    };
  }

  void addMarker(LatLng position, String title, String id) {
    setState(() {
      _markers.add(
        Marker(
            markerId: MarkerId(_markers.length.toString()),
            position: position,
            infoWindow: InfoWindow(title: title),
            onTap: () {}),
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
List<ShopDetailsConvertor> filterShopsByDistance(
    List<ShopDetailsConvertor> shops,
    double currentLat,
    double currentLng,
    double radiusInKm,
    ) {
  return shops.where((shop) {
    final distance = calculateDistance(
      currentLat,
      currentLng,
      shop.coordinates.latitude,
      shop.coordinates.longitude,
    );
    return distance <= radiusInKm;
  }).toList();
}
double calculateDistance(double lat1, double lon1, double lat2, double lon2) {
  const p = 0.017453292519943295; // PI / 180
  const c = cos;
  final a = 0.5 - c((lat2 - lat1) * p)/2 +
      c(lat1 * p) * c(lat2 * p) *
          (1 - c((lon2 - lon1) * p))/2;
  return 12742 * asin(sqrt(a)); // 2 * R; R = 6371 km
}