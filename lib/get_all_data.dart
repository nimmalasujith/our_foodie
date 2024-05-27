import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:our_foodie/test.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<List<ShopDetailsConvertor>> getShops(bool isLoading) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();

  try {
    final studyMaterialsJson = prefs.getString("shops") ?? "";
    final String state = prefs.getString("state") ?? "";
    final String city = prefs.getString("city") ?? "";

    if (studyMaterialsJson.isEmpty || isLoading) {
      QuerySnapshot querySnapshot =
      await FirebaseFirestore.instance.collection('Bharat').doc(state).collection(city).get();
      List<Map<String, dynamic>> projectsData = querySnapshot.docs
          .map((doc) => doc.data() as Map<String, dynamic>)
          .toList();
      String projectsJson = jsonEncode(projectsData);
      await prefs.setString("shops", projectsJson);
      List<ShopDetailsConvertor> projects =
      projectsData.map((json) => ShopDetailsConvertor.fromJson(json)).toList();
      return projects;
    } else {
      List<Map<String, dynamic>> projectsJsonList =
      List<Map<String, dynamic>>.from(json.decode(studyMaterialsJson));
      List<ShopDetailsConvertor> projects = projectsJsonList
          .map((json) => ShopDetailsConvertor.fromJson(json))
          .toList();

      return projects;
    }
  } catch (e) {
    // Handle exceptions
    print("Error in getProjects: $e");
    return []; // Return empty list or handle error accordingly
  }
}