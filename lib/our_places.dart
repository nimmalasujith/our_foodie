// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:our_foodie/test%20page%20too.dart';

class OursPlace extends StatefulWidget {
  const OursPlace({super.key});

  @override
  State<OursPlace> createState() => _OursPlaceState();
}

class _OursPlaceState extends State<OursPlace> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Row(
              children: [
                Text(
                  "In ",
                  style: TextStyle(fontSize: 25),
                ),
                Icon(Icons.location_on_outlined),
                Text(
                  "Bhimavaram",
                  style: TextStyle(fontSize: 20),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0),
            child: Text(
              "Food Places",
              style: TextStyle(fontSize: 25),
            ),
          ),
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
          ListView.builder(
            padding: EdgeInsets.symmetric(horizontal: 10),
              shrinkWrap: true,
              itemCount: 5,
              itemBuilder: (BuildContext context, int index) {
                return Container(
                  margin: EdgeInsets.symmetric(vertical: 2),
                  height: 20,
                  width: double.infinity,
                  color: Colors.black12,
                );
              })
        ],
      ),
    );
  }
}
