// ignore_for_file: prefer_const_constructors

import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:our_foodie/homePage.dart';
import 'package:our_foodie/saveData.dart';
import 'package:our_foodie/settings.dart';
import 'package:our_foodie/test.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SearchBarContainer extends StatefulWidget {
  List<shopDetailsConvertor> data;

  SearchBarContainer({required this.data});

  @override
  State<SearchBarContainer> createState() => _SearchBarContainerState();
}

class _SearchBarContainerState extends State<SearchBarContainer> {
  TextEditingController _textEditingController = TextEditingController();
  List<dynamic> tags = [];

  getData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final shopDetailsJson = prefs.getString("tags");
    List<dynamic> shopDetailsList = jsonDecode(shopDetailsJson!);
    setState(() {
      tags = shopDetailsList;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getData();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Container(
                margin: EdgeInsets.only(left: 15, top: 5, right: 5),
                decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.9),
                    borderRadius: BorderRadius.circular(25),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.2), // Shadow color
                        spreadRadius: 2, // How far the shadow should spread
                        blurRadius: 1, // How soft the shadow should be
                        offset: Offset(0, 2), // Offset of the shadow
                      ),
                    ],
                    border: Border.all(color: Colors.black.withOpacity(0.1))),
                child: Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 15, right: 10),
                      child: Icon(Icons.search),
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(right: 10),
                        child: TextFormField(
                          controller: _textEditingController,
                          textInputAction: TextInputAction.next,
                          style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.w500,
                            fontSize: 20,
                          ),
                          onChanged: (value) {
                            setState(() {});
                          },
                          decoration: InputDecoration(
                              border: InputBorder.none,
                              hintText: 'Search shop',
                              hintStyle: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.w300,
                                fontSize: 20,
                              )),
                        ),
                      ),
                    ),
                    if (_textEditingController.text.isNotEmpty)
                      InkWell(
                        onTap: () {
                          setState(() {
                            _textEditingController.clear();
                          });
                        },
                        child: Padding(
                          padding: const EdgeInsets.only(left: 10, right: 15),
                          child: Icon(Icons.close),
                        ),
                      ),
                  ],
                ),
              ),
            ),
            InkWell(
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => Settings()));
              },
              child: Container(
                margin: EdgeInsets.only(left: 5, top: 5, right: 10),
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(25),
                    border: Border.all(color: Colors.black.withOpacity(0.1))),
                child: Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: Icon(
                    Icons.settings,
                    size: 35,
                  ),
                ),
              ),
            ),
          ],
        ),
        if (_textEditingController.text.isNotEmpty)
          Container(
            constraints: BoxConstraints(maxHeight: 600),
            margin: EdgeInsets.only(left: 10, right: 10, top: 5),
            decoration: BoxDecoration(
                color: Colors.white38, borderRadius: BorderRadius.circular(16)),
            child: ListView.builder(
                shrinkWrap: true,
                itemCount: widget.data.length,
                itemBuilder: (context, int index) {
                  final data = widget.data[index];
                  return InkWell(
                    child: Container(
                      margin: EdgeInsets.all(2),
                      decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.9),
                          borderRadius: BorderRadius.circular(15)),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Container(
                                height: 50,
                                width: 80,
                                margin: EdgeInsets.symmetric(
                                    vertical: 3, horizontal: 3),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(8),
                                    image: DecorationImage(
                                        image:
                                            NetworkImage(data.images.mainImage),
                                        fit: BoxFit.cover)),
                              ),
                              Expanded(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      data.headings.fullHeading,
                                      style: TextStyle(fontSize: 18),
                                    ),
                                    Text(
                                      "Rating",
                                      style: TextStyle(fontSize: 14),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 2.0, horizontal: 5),
                            child: Text(
                              data.address,
                              style: TextStyle(fontSize: 14),
                            ),
                          ),
                        ],
                      ),
                    ),
                    onTap: () {
                      HomePageKey.currentState!.changeTab(LatLng(
                          double.parse(data.coordinates.split(",")[0]),
                          double.parse(data.coordinates.split(",")[1])));
                      _textEditingController.clear();
                      setState(() {});
                    },
                  );
                }),
          ),
        Padding(
          padding: const EdgeInsets.only(top: 8.0),
          child: Row(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: SizedBox(
                    height: 35,
                    child: ListView.builder(
                        shrinkWrap: true,
                        scrollDirection: Axis.horizontal,
                        itemCount: tags.length,
                        itemBuilder: (context, int index) {
                          final data = tags[index];
                          return data
                                  .toString()
                                  .startsWith(_textEditingController.text)
                              ? InkWell(
                                  child: Container(
                                    margin: EdgeInsets.only(
                                        left: index == 0 ? 15 : 5),
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 10),
                                    decoration: BoxDecoration(
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.grey.withOpacity(0.1), // Shadow color
                                            spreadRadius: 1, // How far the shadow should spread
                                            blurRadius: 1, // How soft the shadow should be
                                            offset: Offset(0, 2), // Offset of the shadow
                                          ),
                                        ],
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(20),

                                        border: Border.all(
                                            color:
                                                Colors.black.withOpacity(0.1))),
                                    child: Center(
                                        child: Text(
                                      data,
                                      style: TextStyle(
                                          fontWeight: FontWeight.w500,
                                          fontSize: 18),
                                    )),
                                  ),
                                  onTap: () {
                                    List<shopDetailsConvertor> d = widget.data
                                        .where((a) =>
                                            a.tags.contains(data.toString()))
                                        .toList();
                                    HomePageKey.currentState!.setData(d);
                                  },
                                )
                              : Container();
                        }),
                  ),
                ),
              ),
              InkWell(
                onTap: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => SeeAll()));
                },
                child: Container(
                  height: 34,
                  margin: EdgeInsets.only(right: 8),
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  decoration: BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.3), // Shadow color
                          spreadRadius: 2, // How far the shadow should spread
                          blurRadius: 5, // How soft the shadow should be
                          offset: Offset(0, 2), // Offset of the shadow
                        ),
                      ],
                      color: Colors.black,
                      borderRadius: BorderRadius.circular(15),
                      border: Border.all(color: Colors.black.withOpacity(0.1))),
                  child: Center(
                      child: Text(
                    "See All",
                    style: TextStyle(
                        fontWeight: FontWeight.w500,
                        color: Colors.white,
                        fontSize: 18),
                  )),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class SeeAll extends StatefulWidget {
  const SeeAll({super.key});

  @override
  State<SeeAll> createState() => _SeeAllState();
}

class _SeeAllState extends State<SeeAll> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            InkWell(
              onTap: (){
                Navigator.pop(context);
              },
              child: Wrap(
                crossAxisAlignment: WrapCrossAlignment.center,
                children: [
                  Icon(Icons.arrow_back,size: 20,),
                  Text(
                    "back",
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 18),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Total Shops",
                    style: TextStyle(
                        fontWeight: FontWeight.w500,
                        color: Colors.black,
                        fontSize: 25),
                  ),
                  Text(
                    "23",
                    style: TextStyle(
                        fontWeight: FontWeight.w500,
                        color: Colors.black,
                        fontSize: 25),
                  ),

                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
