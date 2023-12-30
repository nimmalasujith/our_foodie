import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:our_foodie/test.dart';

import 'createFoodShopsAndPlaces.dart';

class Settings extends StatefulWidget {
  const Settings({super.key});

  @override
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
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
                    "Setting",
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 18),
                  ),
                ],
              ),
            ),
           ElevatedButton(onPressed: (){
             Navigator.push(context, MaterialPageRoute(builder: (context)=>SubjectCreator()));
           }, child: Text("ADD")),
           if(false) ElevatedButton(onPressed: (){
                  CreateSubject(
                      id: getID(),
                      tags: [],
                      places: 'bhimavaram',
                      images: Images(otherImages: [], mainImage: ""),
                      headings: Headings(fullHeading: "", shortHeading: ""),
                      contacts: ContactsConvertor(numbers: [], emails: []),
                      reviews: [ReviewsConvertor(id: "", data: "")],
                      Description: '',
                      ratings: [Rating(UserId: "", RatingNo: 1)],
                      address: '',
                      coordinates: '');
            }, child: Text("Create"))
          ],
        ),
      ),
    );
  }
}
String getID() {

  var now = new DateTime.now();
  return DateFormat('d.M.y-kk:mm:ss').format(now);
}