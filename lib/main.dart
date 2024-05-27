// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'dart:async';
import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:lottie/lottie.dart';
import 'package:our_foodie/SearchBar.dart';
import 'package:our_foodie/auth/auth.dart';
import 'package:our_foodie/save/save_page.dart';
import 'package:our_foodie/saveData.dart';
import 'package:our_foodie/search_bar/search_bar.dart';
import 'package:our_foodie/shops/our_shops.dart';
import 'package:our_foodie/settings.dart';
import 'package:our_foodie/test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import 'firebase_options.dart';
import 'get_all_data.dart';
import 'homePage.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme:
          ThemeData(scaffoldBackgroundColor: Color.fromARGB(255, 27, 32, 35)),
      debugShowCheckedModeBanner: false,
      home: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return BottomNavigation();
          } else {
            return LoginPage();
          }
        },
      ),
    );
  }
}

class BottomNavigation extends StatefulWidget {
  const BottomNavigation({Key? key}) : super(key: key);

  @override
  State<BottomNavigation> createState() => _BottomNavigationState();
}

class _BottomNavigationState extends State<BottomNavigation> {
  final PageController _pageController = PageController(initialPage: 0);
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      _pageController.animateToPage(
        index,
        duration: const Duration(milliseconds: 300),
        curve: Curves.ease,
      );
    });
  }

  List<ShopDetailsConvertor>? data;


  bool hasIntoPage = false;

  _checkIntroductionSeen() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool hasSeenIntroduction = await prefs.getBool('hasIntoPage') ?? true;
    if (hasSeenIntroduction) {
      setState(() {
        hasIntoPage = hasSeenIntroduction;
      });
    }else{
      isUpdated();
    }


  }
  void showUpdateDialog(BuildContext context) {
    showDialog(

      context: context,
      builder: (BuildContext context) {
        // return dialog
        return AlertDialog(
          backgroundColor: Colors.blueGrey.shade900,
          title: Text('Update Available',style: TextStyle(color: Colors.white,)),
          content: Text(
              'A new update for this app is available on the Play Store. Please update to enjoy the latest features and improvements.',
              style: TextStyle(color: Colors.white70,)),
          actions: [
            TextButton(
              onPressed: () {
                launch('https://play.google.com/store/apps/details?id=com.nimmalasujith.our');
              },
              child: Text('Open Play Store',style: TextStyle(color: Colors.greenAccent,fontSize: 20)),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Cancel',style: TextStyle(color: Colors.white70,fontSize: 15)),
            ),
          ],
        );
      },
    );
  }
   isUpdated() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final localUpdatedAt = prefs.getString('Updated');
      Future<DataSnapshot> fetchData() async {
        final databaseReference = await FirebaseDatabase.instance.ref("Updated").once();
        return databaseReference.snapshot;
      }
      final data1 = await fetchData();

      List<String> value = data1.value.toString().split(",");

      if(value.first!=version){
        showUpdateDialog(context);
      }
      if (localUpdatedAt != value.last) {
        showToastText("Data Updating");
        data = await getShops(true);
        await prefs.setString('Updated', value.last);

      } else {
        data = await getShops(false);

      }
    } on PlatformException catch (error) {
      print('PlatformException: $error');
      showToastText('Error checking for updates: $error');
      return false; // Indicate error
    } catch (error) {
      data = await getShops(true);
      print('Error: $error');
      showToastText('An error occurred: $error');

    }
    setState(() {
      data;
    });
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _checkIntroductionSeen();


  }

  @override
  Widget build(BuildContext context) {
    if (hasIntoPage) {
      return StateAndCitySelection();
    } else {

      return Scaffold(
        body: data != null
            ? Stack(
                children: [
                  PageView(
                    controller: _pageController,
                    onPageChanged: (index) {
                      setState(() {
                        _selectedIndex = index;
                      });
                    },
                    children: [
                      HomePage(
                        data: data!,
                      ),
                      OursPlace(
                        data: data!,
                      ),
                      SavePage(),
                      SearchBarPage(
                        data: data!,
                      ),
                      settings()
                    ],
                  ),
                  Positioned(
                      bottom: 0,
                      left: 0,
                      right: 0,
                      child: SafeArea(
                        child: Container(
                          padding:
                              EdgeInsets.symmetric(vertical: 5, horizontal: 25),
                          decoration:
                              BoxDecoration(color: Colors.blueGrey.shade900),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              BottomIcon(Icons.home, "Home", 0),
                              BottomIcon(Icons.place, "Ours", 1),
                              BottomIcon(Icons.bookmark, "Save", 2),
                              BottomIcon(Icons.search, "Search", 3),
                              BottomIcon(Icons.settings, "Setting", 4),
                            ],
                          ),
                        ),
                      ))
                ],
              )
            : Center(
                child: Container(
                  height: 200.0,
                  width: 200.0,
                  color: Colors.white10,
                  child: LottieBuilder.asset(
                      'assets/animassets/mapanimation.json'),
                ),
              ),
      );
    }
  }

  Widget BottomIcon(IconData icon, String heading, int index) {
    return GestureDetector(
      onTap: () {
        _onItemTapped(index);
      },
      child: Column(
        children: [
          Icon(
            icon,
            size: index == _selectedIndex ? 25 : 22,
            color: index == _selectedIndex ? Colors.white : Colors.white38,
          ),
          Text(
            heading,
            style: TextStyle(
                color:
                    index == _selectedIndex ? Colors.white70 : Colors.white38,
                fontSize: index == _selectedIndex ? 12 : 10),
          )
        ],
      ),
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }
}

class StateAndCitySelection extends StatefulWidget {
  const StateAndCitySelection({super.key});

  @override
  State<StateAndCitySelection> createState() => _StateAndCitySelectionState();
}

class _StateAndCitySelectionState extends State<StateAndCitySelection> {
  String? selectedState;
  String? selectedCity;
  List<Map<String, dynamic>> projectsData=[];
  List<String> states = [];
  List<String> cities = [];

  Future<void> loadStates() async {
    QuerySnapshot querySnapshot =
        await FirebaseFirestore.instance.collection('Bharat').get();
    projectsData = querySnapshot.docs
        .map((doc) => doc.data() as Map<String, dynamic>)
        .toList();
    states = projectsData.map((e) => e["id"].toString()).toList();

    setState(() {
      states;
      projectsData;
    });
  }

  Future<void> loadCities(String selectedState) async {
    for (Map<String, dynamic> x in projectsData){

      if(x["id"] == selectedState){
        cities.addAll(List<String>.from(x["cities"]));
      }
    }
    setState(() {
      cities;
    });
  }

  @override
  void initState() {
    loadStates();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 20),
            ListView.builder(
                shrinkWrap: true,
                itemCount: states.length,
                itemBuilder: (BuildContext context, int index) {
                  return H1Heading(states[index]);
                }),
            Center(
              child: Container(
                height: 150.0,
                width: 150.0,
                child: LottieBuilder.asset(
                    'assets/animassets/mapanimation.json',
                    reverse: true),
              ),
            ),
            Center(child: H1Heading('Welcome to Foodie!')),
            Center(
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 20.0, horizontal: 10),
                child: H3Heading(
                    "Select the place to find all restaurants and shops nearby you."),
              ),
            ),
            H2Heading("Select State and City"),
            Container(
              margin: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
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
                          hint: Text(
                            'Select State',
                            style: TextStyle(color: Colors.white70),
                          ),
                          value: selectedState,
                          dropdownColor: Colors.black87,
                          borderRadius: BorderRadius.circular(20),
                          isExpanded: true,
                          onChanged: (String? newValue) {
                            setState(() {
                              selectedState = newValue;
                              selectedCity = null;
                              loadCities(selectedState!);
                            });
                          },
                          items: states!
                              .map<DropdownMenuItem<String>>((String value) {
                            return DropdownMenuItem(
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
                            hint: Text(
                              'Select City',
                              style: TextStyle(color: Colors.white70),
                            ),
                            value: selectedCity,
                            dropdownColor: Colors.black87,
                            borderRadius: BorderRadius.circular(20),
                            isExpanded: true,
                            onChanged: (String? newValue) {
                              setState(() {
                                selectedCity = newValue;
                              });
                            },
                            items: cities!
                                .map<DropdownMenuItem<String>>((String value) {
                              return DropdownMenuItem(
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
            if(selectedState!=null&&selectedCity!=null)Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                InkWell(
                  onTap: () async {
                    SharedPreferences prefs = await SharedPreferences.getInstance();
                    await prefs.setBool('hasIntoPage', false);
                    await prefs.setString('state', selectedState!);
                    await prefs.setString('city', selectedCity!);
                    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>BottomNavigation()));
                  },
                  child: Container(
                    margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: Colors.white10,
                        border: Border.all(color: Colors.white54)),
                    child: Text(
                      "Set Selected Place",
                      style: TextStyle(
                          fontSize: 20,
                          color: Colors.white,
                          fontWeight: FontWeight.w500),
                    ),
                  ),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
