// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:our_foodie/save/sharedPref_save_data.dart';
import 'package:our_foodie/shops/shop_details.dart';
import 'package:our_foodie/test%20page%20too.dart';
import 'package:our_foodie/test.dart';
Widget H1Heading(String heading){
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 10.0),
    child: Text(
      heading,
      style: TextStyle(fontSize: 25, color: Colors.white),
    ),
  );
}
Widget H2Heading(String heading){
  return Padding(
    padding: const EdgeInsets.only(left: 10.0,top: 10,bottom: 2),
    child: Text(
      heading,
      style: TextStyle(fontSize: 20, color: Colors.white,fontWeight: FontWeight.w500),
    ),
  );
}
Widget H3Heading(String heading){
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 10.0),
    child: Text(
      heading,
      style: TextStyle(fontSize: 16, color: Colors.white,fontWeight: FontWeight.w500),
    ),
  );
}
class OursPlace extends StatefulWidget {
  List<ShopDetailsConvertor> data;
   OursPlace({required this.data});

  @override
  State<OursPlace> createState() => _OursPlaceState();
}

class _OursPlaceState extends State<OursPlace> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    "In ",
                    style: TextStyle(fontSize: 25, color: Colors.white),
                  ),
                  Icon(
                    Icons.location_on_outlined,
                    color: Colors.orangeAccent,
                  ),
                  Text(
                    "Bhimavaram",
                    style: TextStyle(fontSize: 20, color: Colors.white),
                  ),
                ],
              ),
            ),
            H1Heading("Food Places"),
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
                padding: EdgeInsets.symmetric(horizontal: 10),
                shrinkWrap: true,
                itemCount: widget.data.length,
                physics: NeverScrollableScrollPhysics(),
                itemBuilder: (BuildContext context, int index) {
                  return ShopContainer(data: widget.data[index],);
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

class ShopContainer extends StatefulWidget {
  ShopDetailsConvertor data;
  ShopContainer({required this.data});

  @override
  State<ShopContainer> createState() => _ShopContainerState();
}

class _ShopContainerState extends State<ShopContainer> {

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => ShopDetails(data: widget.data,)));
      },
      child: Container(
        height: 120,
        margin: EdgeInsets.symmetric(vertical: 5),
        padding: EdgeInsets.all(3),
        decoration: BoxDecoration(
            color: Colors.blue.withOpacity(0.05),
            borderRadius: BorderRadius.circular(26),
            border: Border.all(color: Colors.white.withOpacity(0.03))),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: AspectRatio(
                      aspectRatio: 1,
                      child: Container(
                        color: Colors.white12,
                        child: ImageShowAndDownload(image: widget.data.thumbnail.fileUrl)
                      ),
                    )),
                Positioned(
                    top: 10,
                    right: 10,
                    child:BookMarkButton(data: widget.data,) )
              ],
            ),
            Expanded(
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10.0, vertical: 5),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.data.headings.shopName,
                      style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w500,
                          color: Colors.white),
                    ),
                    Row(
                      children: [
                        Text(
                          "Family",
                          style: TextStyle(color: Colors.white),
                        ),
                        Text(
                          "Point",
                          style: TextStyle(color: Colors.white),
                        ),
                        Text(
                          "Chandrika Biryani",
                          style: TextStyle(color: Colors.white),
                        ),
                      ],
                    ),
                    Text(
                      widget.data.address,
                      style: TextStyle(color: Colors.white60),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
class BookMarkButton extends StatefulWidget {
  ShopDetailsConvertor data;
   BookMarkButton({required this.data});

  @override
  State<BookMarkButton> createState() => _BookMarkButtonState();
}

class _BookMarkButtonState extends State<BookMarkButton> {

  bool isPresent =false;

  getData() async {
    isPresent = await SubjectPreferences.isPresent(widget.data.id);
    setState(() {
      isPresent;
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
    return InkWell(
      child: isPresent
          ? Icon(Icons.favorite,color: Colors.white,)
          : Icon(Icons.favorite_border,color: Colors.white,),
      onTap: () async {
          if (isPresent) {
            await SubjectPreferences.delete(widget.data.id);
          } else {
            await SubjectPreferences.add(widget.data);
          }
          getData();

      },
    );
  }
}

