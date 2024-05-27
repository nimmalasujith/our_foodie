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
