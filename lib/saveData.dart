import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:our_foodie/test.dart';
import 'package:shared_preferences/shared_preferences.dart';
Future<void> showToastText(String message) async {
  await Fluttertoast.cancel();
  Fluttertoast.showToast(
      msg: message,
      fontSize: 18,
      timeInSecForIosWeb: 3
  );
}
Future<List<shopDetailsConvertor>> getShopDetails(bool isLoading) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();

  final shopDetailsJson = prefs.getString("shops");
  if (shopDetailsJson == null || shopDetailsJson.isEmpty || isLoading) {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('foodPlaces')
        .doc("bhimavaram")
        .collection("foodShops")
        .get();
    try {
      var documentSnapshot = await FirebaseFirestore.instance
          .collection("foodPlaces")
          .doc("bhimavaram")
          .get();
      if (documentSnapshot.exists) {

        var documentData = documentSnapshot.data();
        try {
          final regSylMp =  (documentData!["tags"] as List<dynamic>?) ?? [];
          String projectsJson = jsonEncode(regSylMp);
          await prefs.setString("tags", projectsJson);
        } catch (e) {
          print("Error processing data: $e");
        }
      } else {

      }
    } catch (e) {
      print("Error getting study materials: $e");

    }

    List<Map<String, dynamic>> projectsData = querySnapshot.docs
        .map((doc) => doc.data() as Map<String, dynamic>)
        .toList();

    String projectsJson = jsonEncode(projectsData);
    await prefs.setString("shops", projectsJson);

    List<shopDetailsConvertor> projects = projectsData
        .map((json) => shopDetailsConvertor.fromJson(json))
        .toList();

    return projects;
  } else {
    List<dynamic> projectsJsonList = json.decode(shopDetailsJson);
    List<shopDetailsConvertor> projects = projectsJsonList
        .map((json) => shopDetailsConvertor.fromJson(json))
        .toList();

    return projects;
  }
}