import 'dart:convert';

import 'package:our_foodie/test.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SubjectPreferences {
  static const String key = "savedFoodies";

  static Future<void> save(List<ShopDetailsConvertor> subjects) async {
    final prefs = await SharedPreferences.getInstance();
    final subjectsJson = subjects.map((subject) => subject.toJson()).toList();
    final subjectsString = jsonEncode(subjectsJson);
    await prefs.setString(key, subjectsString);
  }

  static Future<List<ShopDetailsConvertor>> get() async {
    final prefs = await SharedPreferences.getInstance();
    final subjectsString = prefs.getString(key);
    if (subjectsString != null) {
      final subjectsJson = jsonDecode(subjectsString) as List;
      return subjectsJson
          .map((json) => ShopDetailsConvertor.fromJson(json))
          .toList();
    } else {
      return [];
    }
  }

  static Future<void> add(ShopDetailsConvertor newSubject) async {
    final List<ShopDetailsConvertor> subjects = await get();
    subjects.add(newSubject);
    await save(subjects);
  }

  static Future<void> delete(String subjectId) async {
    List<ShopDetailsConvertor> subjects = await get();
    subjects.removeWhere((subject) => subject.id == subjectId);
    await save(subjects);
  }

  // Check if a subject with given id is present
  static Future<bool> isPresent(String subjectId) async {
    List<ShopDetailsConvertor> subjects = await get();
    return subjects.any((subject) => subject.id == subjectId);
  }
}
