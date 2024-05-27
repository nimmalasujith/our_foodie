// ignore_for_file: prefer_const_constructors

import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:our_foodie/settings.dart';
import 'package:our_foodie/shops/our_shops.dart';
import 'package:our_foodie/shops/shop_details.dart';
import 'package:our_foodie/uploader.dart';

import 'test page too.dart';
import 'test.dart';

class SubjectCreator extends StatefulWidget {
  ShopDetailsConvertor? data;

  SubjectCreator({
    this.data,
  });

  @override
  State<SubjectCreator> createState() => _SubjectCreatorState();
}

class _SubjectCreatorState extends State<SubjectCreator> {
  final CommonNameController = TextEditingController();
  final FullHeadingController = TextEditingController();
  final DescriptionController = TextEditingController();
  final AddressController = TextEditingController();
  final LatCoOrdinatesController = TextEditingController();
  final LngCoOrdinatesController = TextEditingController();
  FileUploader thumbnail =
  FileUploader(fileUrl: "", fileMessageId: 0, type: "image");
  List<FileUploader> images = [];

  List<String> PhoneNosList = [];
  final TextEditingController PhoneNosController = TextEditingController();
  int selectedPhoneNosIndex = -1;
  List<String> ShopEmailsList = [];
  final TextEditingController ShopEmailsController = TextEditingController();
  int selectedShopEmailsIndex = -1;
  List<String> tagsList = [];
  final TextEditingController tagsController = TextEditingController();
  int selectedTagsIndex = -1;

  List<Rating> rating = [];

  void AutoFill() async {
    setState(() {});
  }

  List<DescriptionConvertor> descriptionList = [];
  Map<String, List<String>> stateCityMap = {};
  CoordinatesConvertor coordinates = CoordinatesConvertor(
    latitude: 0,
    longitude: 0,
  );
  String? selectedState;
  String? selectedCity;

  Future<void> loadJsonData() async {
    String data =
    await rootBundle.loadString('assets/states/states_and_cities.json');
    final jsonResult = json.decode(data) as Map<String, dynamic>;
    setState(() {
      stateCityMap = jsonResult
          .map((key, value) => MapEntry(key, List<String>.from(value)));
    });
  }

  @override
  void initState() {
    if (widget.data != null) {
      AutoFill();
    }
    loadJsonData();
    super.initState();
  }

  @override
  void dispose() {
    CommonNameController.dispose();
    DescriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              backButton(),
              H2Heading("Select State and City"),
              Container(
                margin: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.05),
                    borderRadius: BorderRadius.circular(15)),
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Text(
                          "State :   ",
                          style: TextStyle(
                              color: Colors.orangeAccent,
                              fontSize: 20,
                              fontWeight: FontWeight.w500),
                        ),
                        Expanded(
                          child: DropdownButton<String>(
                            hint: Text('Select State'),
                            value: selectedState,
                            dropdownColor: Colors.black87,
                            borderRadius: BorderRadius.circular(20),
                            isExpanded: true,
                            onChanged: (String? newValue) {
                              setState(() {
                                selectedState = newValue;
                                selectedCity =
                                null; // Reset city when state changes
                              });
                            },
                            items: stateCityMap.keys
                                .map<DropdownMenuItem<String>>((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(
                                  value,
                                  style: TextStyle(color: Colors.white),
                                ),
                              );
                            }).toList(),
                          ),
                        ),
                      ],
                    ),
                    if (selectedState != null) ...[
                      Row(
                        children: [
                          Text(
                            "City :     ",
                            style: TextStyle(
                                color: Colors.orangeAccent,
                                fontSize: 20,
                                fontWeight: FontWeight.w500),
                          ),
                          Expanded(
                            child: DropdownButton<String>(
                              hint: Text('Select City'),
                              value: selectedCity,
                              dropdownColor: Colors.black87,
                              borderRadius: BorderRadius.circular(20),
                              isExpanded: true,
                              onChanged: (String? newValue) {
                                setState(() {
                                  selectedCity = newValue;
                                });
                              },
                              items: stateCityMap[selectedState!]!
                                  .map<DropdownMenuItem<String>>(
                                      (String value) {
                                    return DropdownMenuItem<String>(
                                      value: value,
                                      child: Text(
                                        value,
                                        style: TextStyle(color: Colors.white),
                                      ),
                                    );
                                  }).toList(),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ],
                ),
              ),
              if (selectedState != null && selectedCity != null) ...[
                TextFieldContainer(
                  heading: "Common Name",
                  controller: CommonNameController,
                  hintText: 'common name',
                ),
                TextFieldContainer(
                  heading: "Shop Name",
                  controller: FullHeadingController,
                  hintText: 'shop name',
                ),
                Container(
                  margin: EdgeInsets.symmetric(vertical: 5, horizontal: 5),
                  padding: EdgeInsets.symmetric(vertical: 5, horizontal: 5),
                  decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.05),
                      borderRadius: BorderRadius.circular(10)),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      H2Heading("Tags"),
                      ReorderableListView(
                        physics: NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        padding: EdgeInsets.only(
                            left: 10, right: 10, bottom: 1),
                        children: List.generate(
                          tagsList.length,
                              (index) =>
                              Container(
                                key: ValueKey(index),
                                // Assign a unique key to each item
                                padding:
                                EdgeInsets.symmetric(
                                    vertical: 5, horizontal: 10),
                                margin: EdgeInsets.symmetric(vertical: 2),
                                decoration: BoxDecoration(
                                  color: Colors.white10,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Row(
                                  children: [
                                    Expanded(child: Text(tagsList[index],
                                      style: TextStyle(color: Colors.white),)),
                                    InkWell(
                                        onTap: () {
                                          setState(() {
                                            selectedTagsIndex = index;
                                            tagsController.text =
                                            tagsList[index];
                                          });
                                        },
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 10.0),
                                          child: Icon(Icons.edit),
                                        )),
                                    InkWell(
                                        onTap: () {
                                          setState(() {
                                            tagsList.removeAt(index);
                                          });
                                        },
                                        child: Icon(Icons.delete)),
                                  ],
                                ),
                              ),
                        ),
                        onReorder: (int oldIndex, int newIndex) {
                          setState(() {
                            if (oldIndex < newIndex) {
                              newIndex -= 1;
                            }

                            tagsList.insert(
                                newIndex, tagsList.removeAt(oldIndex));
                          });
                        },
                      ),
                      Row(
                        children: [
                          Flexible(
                            child: TextFieldContainer(
                              controller: tagsController,
                              hintText: 'enter tag here',
                              obscureText: false,

                            ),
                          ),
                          InkWell(
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                  vertical: 5, horizontal: 10),
                              decoration: BoxDecoration(
                                color: Colors.white12,
                                border: Border.all(color: Colors.white),
                                borderRadius: BorderRadius.circular(14),
                              ),
                              child: Text(
                                selectedTagsIndex >= 0 ? "Save" : "Add",
                                style: TextStyle(
                                    fontSize: 20, color: Colors.white),
                              ),
                            ),
                            onTap: () {
                              setState(() {
                                if (selectedTagsIndex >= 0) {
                                  tagsList[selectedTagsIndex] =
                                      tagsController.text;
                                } else {
                                  tagsList.add(tagsController.text);
                                }
                              });
                              selectedTagsIndex = -1;
                              tagsController.clear();
                            },
                          )
                        ],
                      ),
                    ],
                  ),
                ),
                TextFieldContainer(
                  heading: "About Shop",
                  controller: DescriptionController,
                  hintText: 'about',
                ),

                Uploader(
                  type: FileType.image,
                  getIVF: (d) {
                    setState(() {
                      thumbnail = d.first;
                    });
                  },
                ),
                Uploader(
                  type: FileType.image,
                  allowMultiple: true,
                  getIVF: (d) {
                    setState(() {
                      images = d;
                    });
                  },
                ),
                Container(
                  margin: EdgeInsets.symmetric(vertical: 5, horizontal: 5),
                  color: Colors.white10,
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 15, top: 8),
                        child: Text(
                          "Description List",
                          style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.w500,
                              color: Colors.white
                          ),
                        ),
                      ),
                      ReorderableListView(
                        physics: NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        padding: EdgeInsets.only(
                            left: 10, right: 10, bottom: 1),
                        children: List.generate(
                          descriptionList.length,
                              (index) =>
                              Container(
                                key: ValueKey(index),
                                padding:
                                EdgeInsets.symmetric(
                                    vertical: 5, horizontal: 10),
                                margin: EdgeInsets.symmetric(vertical: 2),
                                decoration: BoxDecoration(
                                  color: Colors.white10,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Row(
                                  children: [
                                    Expanded(
                                        child: Text(
                                          descriptionList[index].heading,
                                          style: TextStyle(
                                              color: Colors.white),)),
                                    InkWell(
                                        onTap: () {
                                          setState(() {
                                            descriptionList.removeAt(index);
                                          });
                                        },
                                        child: Icon(Icons.delete))
                                  ],
                                ),
                              ),
                        ),
                        onReorder: (int oldIndex, int newIndex) {
                          setState(() {
                            if (oldIndex < newIndex) {
                              newIndex -= 1;
                            }
                            final DescriptionConvertor item =
                            descriptionList.removeAt(oldIndex);
                            descriptionList.insert(newIndex, item);
                          });
                        },
                      ),
                    ],
                  ),
                ),
                TextFieldContainer(
                  heading: "Shop Address",
                  controller: AddressController,
                  hintText: 'address',
                ),
                Container(
                  margin: EdgeInsets.symmetric(vertical: 5, horizontal: 8),
                  padding: EdgeInsets.symmetric(vertical: 5),
                  decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.05),
                      borderRadius: BorderRadius.circular(20)),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      H2Heading("Shop Co-Ordinates"),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Expanded(
                            child: TextFieldContainer(
                              heading: "Latitude",
                              controller: LatCoOrdinatesController,
                              hintText: 'Latitude',
                            ),
                          ),
                          Expanded(
                            child: TextFieldContainer(
                              heading: "Longitude",
                              controller: LngCoOrdinatesController,
                              hintText: 'Longitude',
                            ),
                          ),
                          InkWell(
                              onTap: () async {
                                coordinates =
                                await Navigator.push(
                                context,
                                MaterialPageRoute(
                                builder: (context) => MapScreen()));
                                setState(() {
                                  LatCoOrdinatesController.text = coordinates.latitude.toString();
                                  LngCoOrdinatesController.text = coordinates.longitude.toString();
                                });
                              },
                              child: Container(
                                  margin: EdgeInsets.only(right: 10, bottom: 7),
                                  padding: EdgeInsets.symmetric(
                                      vertical: 2, horizontal: 20),
                                  decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(10)),
                                  child: Text(
                                    " Pick\nPlace",
                                    style: TextStyle(
                                        color: Colors.blueGrey,
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold),
                                  )))
                        ],
                      ),
                    ],
                  ),
                ),
                Container(
                  margin: EdgeInsets.symmetric(vertical: 5, horizontal: 5),
                  padding: EdgeInsets.symmetric(vertical: 5, horizontal: 5),
                  decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.05),
                      borderRadius: BorderRadius.circular(20)),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      H2Heading("Shop Phone Numbers"),
                      ReorderableListView(
                        physics: NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        padding: EdgeInsets.only(
                            left: 10, right: 10, bottom: 1),
                        children: List.generate(
                          PhoneNosList.length,
                              (index) =>
                              Container(
                                key: ValueKey(index),
                                // Assign a unique key to each item
                                padding:
                                EdgeInsets.symmetric(
                                    vertical: 5, horizontal: 10),
                                margin: EdgeInsets.symmetric(vertical: 2),
                                decoration: BoxDecoration(
                                  color: Colors.white10,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Row(
                                  children: [
                                    Expanded(child: Text(PhoneNosList[index],
                                      style: TextStyle(color: Colors.white),)),
                                    InkWell(
                                        onTap: () {
                                          setState(() {
                                            selectedPhoneNosIndex = index;
                                            PhoneNosController.text =
                                            PhoneNosList[index];
                                          });
                                        },
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 10.0),
                                          child: Icon(Icons.edit),
                                        )),
                                    InkWell(
                                        onTap: () {
                                          setState(() {
                                            PhoneNosList.removeAt(index);
                                          });
                                        },
                                        child: Icon(Icons.delete)),
                                  ],
                                ),
                              ),
                        ),
                        onReorder: (int oldIndex, int newIndex) {
                          setState(() {
                            if (oldIndex < newIndex) {
                              newIndex -= 1;
                            }

                            PhoneNosList.insert(
                                newIndex, PhoneNosList.removeAt(oldIndex));
                          });
                        },
                      ),
                      Row(
                        children: [
                          Flexible(
                            child: TextFieldContainer(
                              controller: PhoneNosController,
                              hintText: 'Enter Phone No Here',
                              obscureText: false,

                            ),
                          ),
                          InkWell(
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                  vertical: 5, horizontal: 10),
                              decoration: BoxDecoration(
                                color: Colors.white12,
                                border: Border.all(color: Colors.white),
                                borderRadius: BorderRadius.circular(14),
                              ),
                              child: Text(
                                selectedPhoneNosIndex >= 0 ? "Save" : "Add",
                                style: TextStyle(
                                    fontSize: 20, color: Colors.white),
                              ),
                            ),
                            onTap: () {
                              setState(() {
                                if (selectedPhoneNosIndex >= 0) {
                                  PhoneNosList[selectedPhoneNosIndex] =
                                      PhoneNosController.text;
                                } else {
                                  PhoneNosList.add(PhoneNosController.text);
                                }
                              });
                              selectedPhoneNosIndex = -1;
                              PhoneNosController.clear();
                            },
                          )
                        ],
                      ),
                    ],
                  ),
                ),
                Container(
                  margin: EdgeInsets.symmetric(vertical: 5, horizontal: 5),
                  padding: EdgeInsets.symmetric(vertical: 5, horizontal: 5),
                  decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.05),
                      borderRadius: BorderRadius.circular(10)),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      H2Heading("Shop Emails"),
                      ReorderableListView(
                        physics: NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        padding: EdgeInsets.only(
                            left: 10, right: 10, bottom: 1),
                        children: List.generate(
                          ShopEmailsList.length,
                              (index) =>
                              Container(
                                key: ValueKey(index),
                                // Assign a unique key to each item
                                padding:
                                EdgeInsets.symmetric(
                                    vertical: 5, horizontal: 10),
                                margin: EdgeInsets.symmetric(vertical: 2),
                                decoration: BoxDecoration(
                                  color: Colors.white10,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Row(
                                  children: [
                                    Expanded(child: Text(ShopEmailsList[index],
                                      style: TextStyle(color: Colors.white),)),
                                    InkWell(
                                        onTap: () {
                                          setState(() {
                                            selectedShopEmailsIndex = index;
                                            ShopEmailsController.text =
                                            ShopEmailsList[index];
                                          });
                                        },
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 10.0),
                                          child: Icon(Icons.edit),
                                        )),
                                    InkWell(
                                        onTap: () {
                                          setState(() {
                                            ShopEmailsList.removeAt(index);
                                          });
                                        },
                                        child: Icon(Icons.delete)),
                                  ],
                                ),
                              ),
                        ),
                        onReorder: (int oldIndex, int newIndex) {
                          setState(() {
                            if (oldIndex < newIndex) {
                              newIndex -= 1;
                            }

                            ShopEmailsList.insert(
                                newIndex, ShopEmailsList.removeAt(oldIndex));
                          });
                        },
                      ),
                      Row(
                        children: [
                          Flexible(
                            child: TextFieldContainer(
                              controller: ShopEmailsController,
                              hintText: 'enter email here',
                              obscureText: false,

                            ),
                          ),
                          InkWell(
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                  vertical: 5, horizontal: 10),
                              decoration: BoxDecoration(
                                color: Colors.white12,
                                border: Border.all(color: Colors.white),
                                borderRadius: BorderRadius.circular(14),
                              ),
                              child: Text(
                                selectedShopEmailsIndex >= 0 ? "Save" : "Add",
                                style: TextStyle(
                                    fontSize: 20, color: Colors.white),
                              ),
                            ),
                            onTap: () {
                              setState(() {
                                if (selectedShopEmailsIndex >= 0) {
                                  ShopEmailsList[selectedShopEmailsIndex] =
                                      ShopEmailsController.text;
                                } else {
                                  ShopEmailsList.add(ShopEmailsController.text);
                                }
                              });
                              selectedShopEmailsIndex = -1;
                              ShopEmailsController.clear();
                            },
                          )
                        ],
                      ),
                    ],
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.black87,
                      ),
                      child: Text("Back"),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    ElevatedButton(
                        onPressed: () {
                          String id = getID();
                  if(coordinates.longitude==0&&coordinates.latitude==0){
                    setState(() {
                      coordinates.latitude = double.parse( LatCoOrdinatesController.text);
                      coordinates.longitude = double.parse(LngCoOrdinatesController.text);
                    });
                  }
                          rating.add(Rating(RatingNo: 4, UserId: "sujith"));
                          FirebaseFirestore.instance
                              .collection("submittedShopDetails")
                              .doc(selectedState)
                              .collection(selectedCity.toString())
                              .doc(id)
                              .set(ShopDetailsConvertor(
                              id: id,
                              coordinates: coordinates,
                              contacts: ContactsConvertor(
                                  numbers: PhoneNosList,
                                  emails: ShopEmailsList),
                              address: AddressController.text,
                              thumbnail: thumbnail,
                              tags: tagsList,
                              headings: Name(
                                  shopName: FullHeadingController.text,
                                  commonName:
                                  CommonNameController.text),
                              rating: rating,
                              about: DescriptionController.text,
                              reviews: [],
                              images: images,
                              createdBy: CreatedByConvertor(
                                  name: "Nimmala", email: "sujithnimmala03@gmail.com"))
                              .toJson());

                          Navigator.pop(context);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.greenAccent,
                        ),
                        child: widget.data == null
                            ? Text("Create")
                            : Text("Update")),
                    SizedBox(
                      width: 20,
                    )
                  ],
                ),
              ] else
                ...[
                  if (selectedState == null && selectedCity == null)
                    Center(
                        child: Text(
                          "Please Select State and City/Town",
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w500,
                              fontSize: 20),
                        ))
                  // else if(selectedState==null)Center(child: Text("Please Select State",style: TextStyle(color: Colors.white,fontWeight: FontWeight.w500,fontSize: 20),))
                  else
                    if (selectedCity == null)
                      Center(
                          child: Text(
                            "Please Select City or Town",
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w500,
                                fontSize: 20),
                          ))
                ],
              SizedBox(
                height: 20,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class TextFieldContainer extends StatelessWidget {
  String heading;
  final controller;
  final String hintText;
  final bool obscureText;

  TextFieldContainer({super.key,
    required this.controller,
    required this.hintText,
    this.obscureText = false,
    this.heading = ""});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (heading.isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(left: 15, top: 8),
            child: Text(
              heading,
              style: TextStyle(fontSize: 15, color: Colors.white),
            ),
          ),
        Padding(
          padding:
          const EdgeInsets.only(left: 10, right: 10, top: 5, bottom: 5),
          child: Container(
            decoration: BoxDecoration(
                color: Colors.white12,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: Colors.white.withOpacity(0.15))),
            child: Padding(
              padding: EdgeInsets.only(left: 10),
              child: TextFormField(
                controller: controller,
                obscureText: obscureText,
                textInputAction: TextInputAction.next,
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w500,
                  fontSize: 20,
                ),
                maxLines: null,
                decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: hintText,
                  hintStyle: TextStyle(
                    color: Colors.white54,
                    fontWeight: FontWeight.w300,
                    fontSize: 18,
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class DescriptionConvertor {

  final String heading;

  final List<String> points;


  DescriptionConvertor({
    required this.heading,
    required this.points,

  });

  Map<String, dynamic> toJson() =>
      {
        "heading": heading,
        "points": points.toList(),

      };

  static DescriptionConvertor fromJson(Map<String, dynamic> json) =>
      DescriptionConvertor(
        heading: json["heading"],
        points: List<String>.from(json["points"]),
      );

  static List<DescriptionConvertor> fromMapList(List<dynamic> list) {
    return list.map((item) => fromJson(item)).toList();
  }
}
