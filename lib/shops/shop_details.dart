// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'dart:collection';
import 'dart:io';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_stars/flutter_rating_stars.dart';
import 'package:our_foodie/shops/map%20view.dart';
import 'package:our_foodie/test.dart';
import 'package:our_foodie/uploader.dart';
import 'package:path_provider/path_provider.dart';
import 'package:http/http.dart'as http;
class ShopDetails extends StatefulWidget {
  ShopDetailsConvertor data;

   ShopDetails({required this.data});

  @override
  State<ShopDetails> createState() => _ShopDetailsState();
}

class _ShopDetailsState extends State<ShopDetails> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        top: false,
        child: Column(
          children: [
            Expanded(
              child: ClipRRect(
                borderRadius: BorderRadius.only(
                    bottomRight: Radius.circular(30),
                    bottomLeft: Radius.circular(30)),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.05),
                    border: Border.all(color: Colors.white.withOpacity(0.05)),
                    borderRadius: BorderRadius.only(
                        bottomRight: Radius.circular(30),
                        bottomLeft: Radius.circular(30)),
                  ),
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        backButton(),
                        Padding(
                          padding: const EdgeInsets.only(
                              left: 10.0, top: 10, bottom: 5),
                          child: Text(
                            widget.data.headings.commonName,
                            style: TextStyle(
                                fontSize: 20,
                                color: Colors.white,
                                fontWeight: FontWeight.w500),
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.all(5),
                          padding: EdgeInsets.all(8),
                          width: double.infinity,
                          decoration: BoxDecoration(
                              color: Color.fromARGB(255, 27, 32, 35),
                              borderRadius: BorderRadius.circular(25)),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(20),
                                child:ImageShowAndDownload(image: widget.data.thumbnail.fileUrl,isZoom: true,)
                              ),
                              Padding(
                                padding: const EdgeInsets.all(5.0),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Icon(
                                          Icons.brightness_7_rounded,
                                          color: Colors.greenAccent,
                                        ),
                                        Container(
                                          margin: EdgeInsets.all(10),
                                          padding: EdgeInsets.all(2),
                                          decoration: BoxDecoration(
                                              color: Colors.amber,
                                              borderRadius:
                                                  BorderRadius.circular(5)),
                                          child: Text(
                                            "Famous",
                                            style: TextStyle(
                                                fontSize: 15,
                                                color: Colors.black),
                                          ),
                                        )
                                      ],
                                    ),
                                    Text(
                                      widget.data.headings.shopName,
                                      style: TextStyle(
                                          fontSize: 20,
                                          color: Colors.white,
                                          fontWeight: FontWeight.w500),
                                    ),
                                    RatingStars(
                                      value: 3.5,
                                    )
                                  ],
                                ),
                              )
                            ],
                          ),
                        ),

                        Padding(
                            padding:  EdgeInsets.all(10.0),
                            child: scrollingImages(
                                images: widget.data.images
                                    .map((HomePageImage) => HomePageImage.fileUrl)
                                    .toList(),

                                isZoom: true,
                                ar: AspectRatio(
                                  aspectRatio: 16 / 6,
                                )),
                          ),
                        Container(
                          margin: EdgeInsets.all(5),
                          padding: EdgeInsets.symmetric(vertical: 10,horizontal: 15),
                          width: double.infinity,
                          decoration: BoxDecoration(
                              color: Color.fromARGB(255, 27, 32, 35),
                              borderRadius: BorderRadius.circular(25)),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("Tags", style: TextStyle(
                                  color: Colors.white, fontSize: 18,fontWeight: FontWeight.w500),),
                              Wrap(

                                direction: Axis.horizontal,
                                children: widget.data.tags
                                    .map(
                                      (text) => Container(
                                        decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            border: Border.all(
                                                color: Colors.white30)),
                                        padding: EdgeInsets.symmetric(
                                            vertical: 3, horizontal: 8),
                                        margin:
                                        EdgeInsets.only(left: 8, bottom: 5,top: 8),
                                        child: Text(
                                          text,
                                          style: TextStyle(
                                              color: Colors.white, fontSize: 13),
                                        ),
                                      ),
                                    )
                                    .toList(),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.all(5),
                          padding: EdgeInsets.symmetric(vertical: 10,horizontal: 15),
                          width: double.infinity,
                          decoration: BoxDecoration(
                              color: Color.fromARGB(255, 27, 32, 35),
                              borderRadius: BorderRadius.circular(25)),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("Address", style: TextStyle(
                                  color: Colors.white, fontSize: 20,fontWeight: FontWeight.w500),),
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 8.0,vertical: 3),
                                child: Column(
                                  children: [
                                    Text(widget.data.address, style: TextStyle(
                                        color: Colors.white70, fontSize: 16,fontWeight: FontWeight.w500),),
                                  ],
                                ),
                              ),

                            ],
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.all(5),
                          padding: EdgeInsets.symmetric(vertical: 10,horizontal: 15),
                          width: double.infinity,
                          decoration: BoxDecoration(
                              color: Color.fromARGB(255, 27, 32, 35),
                              borderRadius: BorderRadius.circular(25)),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("About", style: TextStyle(
                                  color: Colors.white, fontSize: 18,fontWeight: FontWeight.w500),),
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 8.0,vertical: 3),
                                child: Column(
                                  children: [
                                    Text(widget.data.about, style: TextStyle(
                                        color: Colors.white70, fontSize: 15,fontWeight: FontWeight.w500),),
                                  ],
                                ),
                              ),

                            ],
                          ),
                        ),
                        Center(child: Padding(
                          padding: const EdgeInsets.only(bottom: 10.0,left: 10,right: 10),
                          child: Text("Uploaded by ${widget.data.createdBy.name}",style: TextStyle(color: Colors.white60,fontSize: 12),),
                        )),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Container(
                  padding: EdgeInsets.symmetric(vertical: 2, horizontal: 10),
                  margin: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                  decoration: BoxDecoration(
                      color: Colors.orangeAccent,
                      borderRadius: BorderRadius.circular(20)),
                  child: Row(
                    children: [
                      Icon(Icons.directions),
                      Text(
                        "Direction",
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.w500),
                      ),
                    ],
                  ),
                ),
                InkWell(
                  onTap: (){
                    Navigator.push(context, MaterialPageRoute(builder: (context)=>ShopMapView(data:widget.data)));

                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: 2, horizontal: 10),
                    margin: EdgeInsets.only(bottom: 5, top: 5, right: 20),
                    decoration: BoxDecoration(
                        color: Colors.orangeAccent,
                        borderRadius: BorderRadius.circular(20)),
                    child: Row(
                      children: [
                        Icon(Icons.location_on),
                        Text(
                          "Map",
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.w500),
                        ),
                      ],
                    ),
                  ),
                ),

              ],
            ),

          ],
        ),
      ),
    );
  }
}

class backButton extends StatelessWidget {
  String text;
  bool isColorBlack;

  backButton({super.key, this.text = "", this.isColorBlack=false});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      bottom: false,
      child: Row(
        children: [
          InkWell(
            onTap: () {
              Navigator.pop(context);
            },
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 8),
              margin: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
              decoration: BoxDecoration(
                  color:isColorBlack? Colors.black:Colors.white, borderRadius: BorderRadius.circular(20)),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Icon(
                    Icons.arrow_back,
                    size: 20,
                    color:isColorBlack? Colors.white:Colors.black87,
                  ),
                  Text(
                    "back ",
                    style: TextStyle(fontSize: 16, color:isColorBlack? Colors.white:Colors.black87,),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class scrollingImages extends StatefulWidget {
  AspectRatio ar;
  final List images;

  bool isZoom;

  scrollingImages({
    Key? key,
    required this.images,

    this.isZoom = false,
    this.ar = const AspectRatio(aspectRatio: 16 / 9),
  }) : super(key: key);

  @override
  State<scrollingImages> createState() => _scrollingImagesState();
}

class _scrollingImagesState extends State<scrollingImages> {
  String imagesDirPath = '';
  int currentPos = 0;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        CarouselSlider.builder(
            itemCount: widget.images.length,
            options: CarouselOptions(
                aspectRatio: widget.ar.aspectRatio,
                viewportFraction: 1,
                enableInfiniteScroll: true,
                autoPlay: widget.images.length > 1 ? true : false,
                autoPlayInterval: const Duration(seconds: 3),
                autoPlayAnimationDuration: const Duration(milliseconds: 800),
                autoPlayCurve: Curves.fastOutSlowIn,
                onPageChanged: (index, reason) {
                  setState(() {
                    currentPos = index;
                  });
                }),
            itemBuilder:
                (BuildContext context, int itemIndex, int pageViewIndex) {
              return ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: AspectRatio(
                  aspectRatio: widget.ar.aspectRatio,
                  child: ImageShowAndDownload(
                    image: widget.images[itemIndex],

                    isZoom: widget.isZoom,
                  ),
                ),
              );
            }),
        Positioned(
          bottom: 5,
          right: 20,
          child: Container(
            decoration: BoxDecoration(
                color: Colors.black, borderRadius: BorderRadius.circular(5)),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: widget.images.map((url) {
                int index = widget.images.indexOf(url);
                return Container(
                  width: 5.0,
                  height: 5.0,
                  margin: const EdgeInsets.symmetric(
                      vertical: 2.0, horizontal: 2.0),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: currentPos == index ? Colors.white : Colors.white24,
                  ),
                );
              }).toList(),
            ),
          ),
        ),
      ],
    );
  }
}
class ImageShowAndDownload extends StatefulWidget {
  String image;
  bool isZoom;

  ImageShowAndDownload(
      {super.key, required this.image,  this.isZoom = false});

  @override
  State<ImageShowAndDownload> createState() => _ImageShowAndDownloadState();
}

class _ImageShowAndDownloadState extends State<ImageShowAndDownload> {
  String filePath = "";
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadImage();
  }

  void _loadImage() async {
    final Directory appDir = await getApplicationDocumentsDirectory();

    final fileName = widget.image.split("/").last;

    filePath = '${appDir.path}/$fileName';

    if (await File(filePath).exists()) {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    } else {
      await _download(widget.image);
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _download(String fileUrl) async {
    try {
      var response;
      if (fileUrl.startsWith('https://drive.google.com')) {
        String name = fileUrl.split('/d/')[1].split('/')[0];
        fileUrl = "https://drive.google.com/uc?export=download&id=$name";
        response = await http.get(Uri.parse(fileUrl));
      } else {
        try {
          response = await http.get(Uri.parse(fileUrl));
        } catch (e) {
          fileUrl = await getFileUrl(fileUrl);
          response = await http.get(Uri.parse(fileUrl));
        }
      }
      if (response.statusCode == 200) {
        final documentDirectory = await getApplicationDocumentsDirectory();
        final newDirectory =
        Directory('${documentDirectory.path}/images');
        if (!await newDirectory.exists()) {
          await newDirectory.create(recursive: true);
        }
        final file = File(filePath);
        await file.writeAsBytes(response.bodyBytes);
      } else {
        print('Failed to download file. HTTP Status: ${response.statusCode}');
      }
    } catch (e) {
      print('Error downloading file: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Center(
          child: CircularProgressIndicator(
            color: Colors.greenAccent,
          ));
    } else {
      if (widget.isZoom) {
        return InkWell(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => Scaffold(
                  body: SafeArea(
                    child: Column(
                      children: [
                        backButton(),
                        Expanded(
                          child: InteractiveViewer(
                            child: Center(
                              child: Image.file(
                                File(filePath),
                                fit: BoxFit.contain,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
          child: Image.file(
            File(filePath),
            fit: BoxFit.fill,
          ),
        );
      } else {
        return Image.file(
          File(filePath),
          fit: BoxFit.fill,
        );
      }
    }
  }
}
