// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'dart:async';
import 'dart:ui';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_rating_stars/flutter_rating_stars.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'package:our_foodie/home_page/MapsOfNearByMe.dart';
import 'package:our_foodie/home_page/categorise_filter_foodies.dart';
import 'package:our_foodie/saveData.dart';
import 'package:our_foodie/settings.dart';
import 'package:our_foodie/shops/shop_details.dart';
import 'package:our_foodie/test%20page%20too.dart';
import 'package:our_foodie/test.dart';
import 'package:our_foodie/uploader.dart';

import 'SearchBar.dart';
import 'shops/our_shops.dart';

class HomePage extends StatefulWidget {
  List<ShopDetailsConvertor> data;

  HomePage({required this.data});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<CategoriesConvertor> Categories = [
    CategoriesConvertor(
        name: "Biryani",
        path: "assets/HomePage Food Type Images/biryani.png",
        padding: EdgeInsets.symmetric(vertical: 10)),
    CategoriesConvertor(
        name: "Cakes", path: "assets/HomePage Food Type Images/cake.png"),
    CategoriesConvertor(
        name: "Noodle",
        path: "assets/HomePage Food Type Images/noodle.png",
        padding: EdgeInsets.symmetric(vertical: 8)),
    CategoriesConvertor(
        name: "Milk Shake",
        path: "assets/HomePage Food Type Images/milkShake.png"),
    CategoriesConvertor(
        name: "Meals",
        path: "assets/HomePage Food Type Images/meals.png",
        padding: EdgeInsets.symmetric(vertical: 5)),
    CategoriesConvertor(
        name: "Samosa", path: "assets/HomePage Food Type Images/samosa.png"),
    CategoriesConvertor(
        name: "Tea",
        path: "assets/HomePage Food Type Images/tea.png",
        padding: EdgeInsets.symmetric(vertical: 8)),
  ];

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
                        style: TextStyle(
                            fontSize: 25,
                            fontWeight: FontWeight.w600,
                            color: Colors.greenAccent),
                      ),
                      Row(
                        children: [
                          Icon(
                            Icons.location_on_outlined,
                            size: 16,
                            color: Colors.orangeAccent,
                          ),
                          Text(
                            "Bhimavaram",
                            style: TextStyle(
                                fontWeight: FontWeight.w500,
                                fontSize: 16,
                                color: Colors.white70),
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
                      size: 30,
                    ),
                  )
                ],
              ),
            ),
            H2Heading("Get Foodie... Nearby You"),

            InkWell(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => MapOfNearByMe(
                              data: widget.data,
                            )));
              },
              child: Container(
                margin: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                height: 100,
                width: double.infinity,
                decoration: BoxDecoration(
                    color: Colors.black12,
                    borderRadius: BorderRadius.circular(10)),
                child: ClipRRect(
                    borderRadius: BorderRadius.circular(15),
                    child: Stack(
                      children: [
                        MapScreen(),
                        Positioned(
                            top: 0,
                            bottom: 0,
                            right: 0,
                            left: 0,
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(15),
                                border: Border.all(color: Colors.white12),
                                gradient: LinearGradient(
                                  begin: Alignment.topCenter,
                                  end: Alignment.bottomCenter,
                                  colors: [
                                    Colors.transparent,
                                    Colors.transparent,
                                    Colors.transparent,
                                    Colors.transparent,
                                    Colors.black26,
                                    Colors.black38,
                                    Colors.black54,
                                  ],
                                ),
                              ),
                            ))
                      ],
                    )),
              ),
            ),
            // Center(child: Text("Be a member and earn money from this app")),
            // Padding(
            //   padding: const EdgeInsets.symmetric(vertical: 10.0),
            //   child: SizedBox(
            //     height: 30,
            //     child: Row(
            //       children: [
            //         Container(
            //           decoration: BoxDecoration(
            //               color: Colors.white.withOpacity(0.03),
            //               borderRadius: BorderRadius.circular(10),
            //               border: Border.all(color: Colors.white12)),
            //           margin: EdgeInsets.only(left: 10),
            //           padding: EdgeInsets.all(5),
            //           child: Row(
            //             children: [
            //               Icon(Icons.sort,color: Colors.white,),
            //               Text("sort",style: TextStyle(color: Colors.white),),
            //               Icon(Icons.arrow_drop_down,color: Colors.white,),
            //             ],
            //           ),
            //         ),
            //         ListView.builder(
            //             scrollDirection: Axis.horizontal,
            //             itemCount: 3,
            //             physics: NeverScrollableScrollPhysics(),
            //             shrinkWrap: true,
            //             itemBuilder: (BuildContext context, int index) {
            //               return Container(
            //                 decoration: BoxDecoration(
            //                     color: Colors.white.withOpacity(0.03),
            //                     borderRadius: BorderRadius.circular(10),
            //                     border: Border.all(color: Colors.white12)),
            //                 margin: EdgeInsets.only(left: 10),
            //                 padding: EdgeInsets.all(5),
            //                 child: Text("$index foodie",style: TextStyle(color: Colors.white),),
            //               );
            //             }),
            //       ],
            //     ),
            //   ),
            // ),
            SizedBox(
              height: 20,
            ),
            H3Heading("${auth.currentUser!.displayName}, What's On Your Mind?"),
            SizedBox(
              height: 100,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: EdgeInsets.symmetric(horizontal: 15),
                physics: BouncingScrollPhysics(),
                itemCount: Categories.length,
                shrinkWrap: true,
                itemBuilder: (BuildContext context, int index) {
                  return InkWell(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => CategoriseFilterFoodies(
                                    data: widget.data,
                                    FilteredItem: Categories[index].name,
                                  )));
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 2),
                      child: Column(
                        children: [
                          DropShadow(
                            blurRadius: 5,
                            child: Padding(
                              padding: Categories[index].padding,
                              child: Image.asset(
                                Categories[index].path,
                              ),
                            ),
                          ),
                          Text(
                            Categories[index].name,
                            style: TextStyle(color: Colors.white, fontSize: 13),
                          )
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),

            H2Heading("Famous Foodies"),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 5.0),
              child: SizedBox(
                height: 30,
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.03),
                            borderRadius: BorderRadius.circular(15),
                            border: Border.all(color: Colors.white12)),
                        margin: EdgeInsets.only(left: 10),
                        padding: EdgeInsets.symmetric(horizontal: 10),
                        alignment: Alignment.center,
                        child: Row(
                          children: [
                            Icon(
                              Icons.sort,
                              color: Colors.white,
                              size: 18,
                            ),
                            Text(
                              " sort ",
                              style: TextStyle(
                                  color: Colors.white70, fontSize: 18),
                            ),
                            Icon(
                              Icons.arrow_drop_down,
                              color: Colors.white,
                              applyTextScaling: false,
                              size: 20,
                            ),
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
                                  color: Colors.white.withOpacity(0.03),
                                  borderRadius: BorderRadius.circular(15),
                                  border: Border.all(color: Colors.white12)),
                              margin: EdgeInsets.only(left: 10),
                              padding: EdgeInsets.symmetric(horizontal: 10),
                              alignment: Alignment.center,
                              child: Text(
                                " sort ",
                                style: TextStyle(
                                    color: Colors.white70, fontSize: 18),
                              ),
                            );
                          }),
                      SizedBox(
                        width: 20,
                      ),
                    ],
                  ),
                ),
              ),
            ),
            ListView.builder(
                itemCount: widget.data.length,
                physics: NeverScrollableScrollPhysics(),
                padding: EdgeInsets.symmetric(horizontal: 10),
                shrinkWrap: true,
                itemBuilder: (BuildContext context, int index) {
                  return ShopContainer(data: widget.data[index]);
                }),

            SizedBox(
              height: 100,
            )
          ],
        ),
      ),
    );
  }
}

class CategoriesConvertor {
  final String name;
  final String path;
  final EdgeInsets padding;

  CategoriesConvertor(
      {required this.name, required this.path, this.padding = EdgeInsets.zero});
}

class DropShadow extends StatelessWidget {
  const DropShadow({
    required this.child,
    this.blurRadius = 3.0,
    this.borderRadius = 0.0,
    this.offset = const Offset(0, 5),
    this.opacity = 1.0,
    this.spread = 3.0,
    this.color,
    super.key,
  });

  final Widget child;
  final double blurRadius;
  final double borderRadius;
  final Offset offset;
  final double opacity;
  final double spread;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ClipRRect(
        child: Stack(
          children: [
            Transform.translate(
              offset: offset,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(borderRadius),
                child: Opacity(
                  opacity: opacity,
                  child: color == null
                      ? child
                      : ColorFiltered(
                          colorFilter: ColorFilter.mode(
                            color!,
                            BlendMode.srcIn,
                          ),
                          child: child,
                        ),
                ),
              ),
            ),
            Positioned.fill(
              child: BackdropFilter(
                filter: ImageFilter.blur(
                  sigmaX: blurRadius,
                  sigmaY: blurRadius,
                ),
                child: const ColoredBox(color: Colors.transparent),
              ),
            ),
            ClipRRect(
              borderRadius: BorderRadius.circular(borderRadius),
              child: child,
            ),
          ],
        ),
      ),
    );
  }
}
