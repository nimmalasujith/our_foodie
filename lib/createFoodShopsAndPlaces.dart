// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import 'test page too.dart';
import 'test.dart';

class SubjectCreator extends StatefulWidget {
  shopDetailsConvertor? data;

  SubjectCreator({
    this.data,
  });

  @override
  State<SubjectCreator> createState() => _SubjectCreatorState();
}

class _SubjectCreatorState extends State<SubjectCreator> {
  final ShortHeadingController = TextEditingController();
  final FullHeadingController = TextEditingController();
  final DescriptionController = TextEditingController();
  final AddressController = TextEditingController();
  final CoOrdinatesController = TextEditingController();

  void AutoFill() async {
    setState(() {});
  }

  @override
  void initState() {
    if (widget.data != null) {
      AutoFill();
    }
    super.initState();
  }

  @override
  void dispose() {
    ShortHeadingController.dispose();
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
              TextFieldContainer(
                heading: "Short Name",
                child: TextFormField(
                  controller: ShortHeadingController,
                  textInputAction: TextInputAction.next,
                  style: TextStyle(color: Colors.black, fontSize: 20),
                  decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: 'Name',
                      hintStyle: TextStyle(color: Colors.black54)),
                ),
              ),
              TextFieldContainer(
                heading: "Full Name",
                child: TextFormField(
                  controller: FullHeadingController,
                  textInputAction: TextInputAction.next,
                  style: TextStyle(color: Colors.black, fontSize: 20),
                  decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: 'Full Name',
                      hintStyle: TextStyle(color: Colors.black54)),
                ),
              ),
              TextFieldContainer(
                heading: "Description",
                child: TextFormField(
                  //obscureText: true,
                  controller: DescriptionController,
                  textInputAction: TextInputAction.next,
                  maxLines: null,
                  style: TextStyle(color: Colors.black, fontSize: 20),

                  decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: 'Description',
                      hintStyle: TextStyle(color: Colors.black54)),
                ),
              ),
              TextFieldContainer(
                heading: "Address",
                child: TextFormField(
                  //obscureText: true,
                  controller: AddressController,
                  textInputAction: TextInputAction.next,
                  maxLines: null,
                  style: TextStyle(color: Colors.black, fontSize: 20),

                  decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: 'Address',
                      hintStyle: TextStyle(color: Colors.black54)),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Expanded(
                    child: TextFieldContainer(
                      heading: "Co Ordinates",
                      child: TextFormField(
                        //obscureText: true,
                        controller: CoOrdinatesController,
                        textInputAction: TextInputAction.next,
                        maxLines: null,
                        style: TextStyle(color: Colors.black, fontSize: 20),

                        decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: 'Co Ordinates',
                            hintStyle: TextStyle(color: Colors.black54)),
                      ),
                    ),
                  ),
                  ElevatedButton(
                      onPressed: () async {
                        CoOrdinatesController.text = await Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => MapScreen()));
                      },
                      child: Text("Pick Place"))
                ],
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

class TextFieldContainer extends StatefulWidget {
  Widget child;
  String heading;

  TextFieldContainer({required this.child, this.heading = ""});

  @override
  State<TextFieldContainer> createState() => _TextFieldContainerState();
}

class _TextFieldContainerState extends State<TextFieldContainer> {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.heading.isNotEmpty)
          Padding(
            padding: EdgeInsets.only(left: 15, top: 8),
            child: Text(
              widget.heading,
              style: creatorHeadingTextStyle,
            ),
          ),
        Padding(
          padding: EdgeInsets.only(left: 10, right: 10, top: 5, bottom: 5),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.15),
              border: Border.all(color: Colors.black12),
              borderRadius: BorderRadius.circular(15),
            ),
            child: Padding(
              padding: EdgeInsets.only(left: 10),
              child: widget.child,
            ),
          ),
        ),
      ],
    );
  }
}

const TextStyle creatorHeadingTextStyle =
    TextStyle(fontSize: 20, fontWeight: FontWeight.w500, color: Colors.black);
