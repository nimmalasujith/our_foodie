// ignore_for_file: prefer_const_constructors

import 'dart:async';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:our_foodie/our_places.dart';
import 'package:our_foodie/settings.dart';
import 'firebase_options.dart';
import 'homePage.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp( MyApp());
}

class MyApp extends StatelessWidget {
   MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      home: SplashScreen(),
    );
  }
}

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 1)).then((value) => Navigator.of(context)
        .pushReplacement(
            MaterialPageRoute(builder: (context) => const BottomNavigation())));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
            height: 200.0,
            width: 200.0,
            child: LottieBuilder.asset('assets/animassets/mapanimation.json')),
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          PageView(
            controller: _pageController,
            onPageChanged: (index) {
              setState(() {
                _selectedIndex = index;
              });
            },
            children: [
              HomePage(),
              OursPlace(),
              Container(color: Colors.green),
              Container(color: Colors.yellow),
              Settings()
            ],
          ),
          Positioned(
              bottom: 0,
              left: 20,
              right: 20,
              child: SafeArea(
                child: Container(
                  padding: EdgeInsets.symmetric(vertical: 5,horizontal: 25),
                  margin: EdgeInsets.symmetric(vertical: 5),
                  decoration: BoxDecoration(color: Colors.blueGrey.shade900,borderRadius: BorderRadius.circular(15)),
                  child:  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      BottomIcon(Icons.home,"Home",0),
                      BottomIcon(Icons.place,"Ours",1),
                      BottomIcon(Icons.bookmark,"Save",2),
                      BottomIcon(Icons.search,"Search",3),
                      BottomIcon(Icons.settings,"Setting",4),
                    ],
                  ),
                ),
              ))
        ],
      ),
    );
  }
  Widget BottomIcon(IconData icon,String heading,int index){
    return GestureDetector(
      onTap: (){
        _onItemTapped(index);
      },
      child: Column(
        children: [
          Icon(icon,size:index==_selectedIndex? 25:20,color: index==_selectedIndex?Colors.white:Colors.white38,),
          Text(heading,style: TextStyle(color: index==_selectedIndex?Colors.white70:Colors.white38,fontSize: index==_selectedIndex?12:10),)
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
