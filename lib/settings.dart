// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:our_foodie/main.dart';
import 'package:our_foodie/saveData.dart';
import 'package:our_foodie/shops/our_shops.dart';
import 'package:our_foodie/shops/shop_details.dart';
import 'package:our_foodie/test.dart';
import 'package:our_foodie/uploader.dart';
import 'package:url_launcher/url_launcher.dart';

import 'createFoodShopsAndPlaces.dart';

String version = "2024.5.7";

Future<void> ExternalLaunchUrl(String url) async {
  final Uri urlIn = Uri.parse(url);
  if (!await launchUrl(urlIn, mode: LaunchMode.externalApplication)) {
    showToastText('Could not launch $urlIn');
    throw 'Could not launch $urlIn';
  }
}

bool isAnonymousUser() => FirebaseAuth.instance.currentUser!.isAnonymous;
final random = Random();
final FirebaseFirestore firestore = FirebaseFirestore.instance;
FirebaseAuth auth = FirebaseAuth.instance;

String getID() => DateFormat('d.M.y-kk:mm:ss').format(DateTime.now());

String userId() => FirebaseAuth.instance.currentUser!.email.toString();

fullUserId() {
  if (FirebaseAuth.instance.currentUser!.isAnonymous) {
    return "Anonymous";
  }
  var user = FirebaseAuth.instance.currentUser!.email!;
  return user;
}

isOwner() =>
    !isAnonymousUser() &&
    ((FirebaseAuth.instance.currentUser!.email! ==
            "sujithnimmala03@gmail.com") ||
        (FirebaseAuth.instance.currentUser!.email! ==
            "sujithnaidu03@gmail.com"));

class settings extends StatefulWidget {
  const settings({super.key});

  @override
  State<settings> createState() => _settingsState();
}

class _settingsState extends State<settings> {
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            H2Heading("Account Details"),
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                color: Colors.blueGrey.shade900,
              ),
              padding: EdgeInsets.all(8),
              margin: EdgeInsets.all(10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    height: 70,
                    width: 70,
                    margin: EdgeInsets.symmetric(horizontal: 10),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(40),
                        color: Colors.white54,
                        image: DecorationImage(
                            image: NetworkImage(
                                auth.currentUser!.photoURL.toString()))),
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "${auth.currentUser!.displayName != null ? auth.currentUser!.displayName!.split(";").first : fullUserId().toString().split("@").first}",
                        style: TextStyle(
                          fontSize: 20.0,
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        fullUserId(),
                        style: TextStyle(
                          color: Colors.white70,
                          fontWeight: FontWeight.w600,
                          fontSize: 18,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  )
                ],
              ),
            ),
            H2Heading("Settings"),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 15.0, vertical: 10),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  InkWell(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => SubjectCreater()));
                    },
                    child: Container(
                      padding: EdgeInsets.only(left: 10),
                      decoration: BoxDecoration(
                          color: Colors.white10,
                          borderRadius: BorderRadius.circular(12)),
                      child: Row(
                        children: [
                          Icon(
                            Icons.add,
                            color: Colors.white70,
                            size: 25,
                          ),
                          H2Heading("Submit Shop Details"),
                          Spacer(),
                          Container(
                            margin: EdgeInsets.symmetric(
                                horizontal: 5, vertical: 5),
                            padding: EdgeInsets.symmetric(
                                horizontal: 15, vertical: 5),
                            decoration: BoxDecoration(
                                color: Colors.white12,
                                borderRadius: BorderRadius.circular(8)),
                            child: Text(
                              "Upload",
                              style:
                                  TextStyle(color: Colors.white, fontSize: 15),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                  if (!isAnonymousUser())
                    InkWell(
                      child: Container(
                        padding:
                            EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                        margin: EdgeInsets.symmetric(vertical: 2),
                        decoration: BoxDecoration(
                            color: Colors.white12,
                            borderRadius: BorderRadius.circular(10)),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Icon(
                                  Icons.password,
                                  color: Colors.white70,
                                  size: 25,
                                ),
                                Text(
                                  " Update Password",
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 25),
                                ),
                              ],
                            ),
                            Icon(
                              Icons.chevron_right,
                              size: 25,
                              color: Colors.white38,
                            )
                          ],
                        ),
                      ),
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    const UpdatePasswordPage()));
                      },
                    ),
                  InkWell(
                      child: Container(
                        padding:
                            EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                        margin: EdgeInsets.symmetric(vertical: 2),
                        decoration: BoxDecoration(
                            color: Colors.white12,
                            borderRadius: BorderRadius.circular(10)),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Icon(
                                  Icons.password,
                                  color: Colors.white70,
                                  size: 25,
                                ),
                                Text(
                                  " Update Place",
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 25),
                                ),
                              ],
                            ),
                            Icon(
                              Icons.chevron_right,
                              size: 25,
                              color: Colors.white38,
                            )
                          ],
                        ),
                      ),
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    const StateAndCitySelection()));
                      },
                    ),
                  InkWell(
                    child: Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                      margin: EdgeInsets.symmetric(vertical: 2),
                      decoration: BoxDecoration(
                          color: Colors.white10,
                          borderRadius: BorderRadius.circular(10)),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Icon(
                                Icons.account_circle_outlined,
                                color: Colors.white70,
                                size: 25,
                              ),
                              Text(
                                " Delete My Account",
                                style: TextStyle(
                                    color: Colors.orange, fontSize: 25),
                              ),
                            ],
                          ),
                          Icon(
                            Icons.chevron_right,
                            size: 25,
                            color: Colors.white38,
                          )
                        ],
                      ),
                    ),
                    onTap: () async {
                      try {
                        final FirebaseAuth _auth = FirebaseAuth.instance;
                        User? user = _auth.currentUser;

                        // Show confirmation dialog
                        bool confirm = await showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: Text('Confirm Delete Your Account'),
                              content: Text(
                                  'Are you sure you want to delete your account?'),
                              actions: <Widget>[
                                TextButton(
                                  onPressed: () =>
                                      Navigator.of(context).pop(false),
                                  // Cancel
                                  child: Text('Cancel'),
                                ),
                                TextButton(
                                  onPressed: () =>
                                      Navigator.of(context).pop(true),
                                  // Confirm
                                  child: Text('Delete'),
                                ),
                              ],
                            );
                          },
                        );
                        if (confirm == true) {
                          await user!.delete();
                          await FirebaseAuth.instance.signOut();
                          showToastText('Account deleted successfully');
                          // Navigator.pushReplacement(
                          //     context,
                          //     MaterialPageRoute(
                          //         builder: (context) =>
                          //             Scaffold(body: LoginPage())));
                        } else {
                          showToastText('Account deletion cancelled');
                        }
                      } catch (e) {
                        print('Failed to delete account: $e');
                        showToastText("Error : $e");
                      }
                    },
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10.0, vertical: 5),
                    child: Divider(
                      color: Colors.white30,
                    ),
                  ),
                  InkWell(
                    child: Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                      margin: EdgeInsets.only(bottom: 2),
                      decoration: BoxDecoration(
                          color: Colors.white10,
                          borderRadius: BorderRadius.circular(10)),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Icon(
                                Icons.report_problem_outlined,
                                color: Colors.white70,
                                size: 25,
                              ),
                              Text(
                                " Report",
                                style: TextStyle(
                                    color: Colors.white, fontSize: 25),
                              ),
                            ],
                          ),
                          Icon(
                            Icons.chevron_right,
                            size: 25,
                            color: Colors.white38,
                          )
                        ],
                      ),
                    ),
                    onTap: () {
                      sendingMails("sujithnimmala03@gmail.com");
                    },
                  ),
                  InkWell(
                    child: Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                      margin: EdgeInsets.symmetric(vertical: 2),
                      decoration: BoxDecoration(
                          color: Colors.white10,
                          borderRadius: BorderRadius.circular(10)),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Icon(
                                Icons.privacy_tip_outlined,
                                color: Colors.white70,
                                size: 25,
                              ),
                              Text(
                                " Privacy Policy",
                                style: TextStyle(
                                    color: Colors.white, fontSize: 25),
                              ),
                            ],
                          ),
                          Icon(
                            Icons.chevron_right,
                            size: 25,
                            color: Colors.white38,
                          )
                        ],
                      ),
                    ),
                    onTap: () {
                      ExternalLaunchUrl(
                          "https://github.com/NSCreator/PRIVACY_POLACY/blob/main/Privacy-policy");
                    },
                  ),
                  InkWell(
                    child: Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                      margin: EdgeInsets.symmetric(vertical: 2),
                      decoration: BoxDecoration(
                          color: Colors.white10,
                          borderRadius: BorderRadius.circular(10)),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Icon(
                                Icons.read_more,
                                color: Colors.white70,
                                size: 25,
                              ),
                              Text(
                                " About",
                                style: TextStyle(
                                    color: Colors.white, fontSize: 25),
                              ),
                            ],
                          ),
                          Icon(
                            Icons.chevron_right,
                            size: 25,
                            color: Colors.white38,
                          )
                        ],
                      ),
                    ),
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => Scaffold(
                                    body: SafeArea(
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          backButton(),
                                          H1Heading("About"),
                                          Center(
                                            child: H2Heading("We are Testing the App"),
                                          )
                                        ],
                                      ),
                                    ),
                                  )));
                    },
                  ),
                ],
              ),
            ),
            if (isOwner())
              Padding(
                padding: EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    Row(
                      children: [
                        H2Heading("Update App"),
                        ElevatedButton(
                            onPressed: () async {
                              await FirebaseDatabase.instance
                                  .ref("Updated")
                                  .set(version + "," + getID().toString());
                              showToastText("Data Updated");
                            },
                            child: Text("Update"))
                      ],
                    ),
                  ],
                ),
              ),
            SizedBox(
              height: 30,
            ),
            Container(
              width: double.infinity,
              margin: EdgeInsets.all(10),
              padding: EdgeInsets.symmetric(vertical: 10),
              decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(15)),
              child: SafeArea(
                child: Column(
                  children: [
                    Padding(
                      padding:
                          EdgeInsets.only(bottom: 10.0, left: 30, right: 30),
                      child: InkWell(
                        child: Container(
                          width: double.infinity,
                          padding: EdgeInsets.symmetric(vertical: 5),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(color: Colors.white54)),
                          child: Center(
                            child: Text(
                              "Logout",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 25,
                                  fontWeight: FontWeight.w500),
                            ),
                          ),
                        ),
                        onTap: () {
                          showDialog(
                            context: context,
                            builder: (context) {
                              return Dialog(
                                backgroundColor: Colors.white,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10)),
                                elevation: 16,
                                child: Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: ListView(
                                    shrinkWrap: true,
                                    children: <Widget>[
                                      SizedBox(height: 15),
                                      Padding(
                                        padding: EdgeInsets.only(left: 15),
                                        child: Text(
                                          "Do you want Log Out",
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontWeight: FontWeight.w600,
                                              fontSize: 18),
                                        ),
                                      ),
                                      SizedBox(
                                        height: 5,
                                      ),
                                      Center(
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            Spacer(),
                                            InkWell(
                                              child: Container(
                                                decoration: BoxDecoration(
                                                  color: Colors.black26,
                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                ),
                                                child: Padding(
                                                  padding: EdgeInsets.symmetric(
                                                      horizontal: 15,
                                                      vertical: 5),
                                                  child: Text(
                                                    "Back",
                                                    style: TextStyle(
                                                        color: Colors.black,
                                                        fontSize: 14),
                                                  ),
                                                ),
                                              ),
                                              onTap: () {
                                                Navigator.pop(context);
                                              },
                                            ),
                                            SizedBox(
                                              width: 10,
                                            ),
                                            InkWell(
                                              child: Container(
                                                decoration: BoxDecoration(
                                                  color: Colors.red,
                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                ),
                                                child: Padding(
                                                  padding: EdgeInsets.symmetric(
                                                      horizontal: 15,
                                                      vertical: 5),
                                                  child: Text(
                                                    "Log Out",
                                                    style: TextStyle(
                                                        color: Colors.black,
                                                        fontSize: 14),
                                                  ),
                                                ),
                                              ),
                                              onTap: () async {
                                                if (isAnonymousUser()) {
                                                  final FirebaseAuth _auth =
                                                      FirebaseAuth.instance;
                                                  User? user =
                                                      _auth.currentUser;
                                                  await user!.delete();
                                                  await FirebaseAuth.instance
                                                      .signOut();
                                                  showToastText(
                                                      'Account deleted successfully');
                                                  Navigator.pop(context);
                                                  // Navigator.pushReplacement(
                                                  //     context,
                                                  //     MaterialPageRoute(
                                                  //         builder: (context) =>
                                                  //             Scaffold(
                                                  //                 body:
                                                  //                 MyApp())));
                                                } else {
                                                  FirebaseAuth.instance
                                                      .signOut();
                                                  Navigator.pop(context);
                                                  Navigator.pop(context);
                                                }
                                              },
                                            ),
                                            SizedBox(
                                              width: 20,
                                            ),
                                          ],
                                        ),
                                      ),
                                      SizedBox(
                                        height: 10,
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          );
                        },
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Text(
                          "our Foodie",
                          style: TextStyle(color: Colors.white38, fontSize: 14),
                        ),
                        Text(
                          "v$version",
                          style: TextStyle(
                            fontSize: 14.0,
                            color: Colors.white38,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          "from NS",
                          style: TextStyle(color: Colors.white38, fontSize: 14),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class EditProfilePage extends StatefulWidget {
  Function(bool) onChange;

  EditProfilePage({required this.onChange});

  @override
  _EditProfilePageState createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  TextEditingController _nameController = TextEditingController();
  FirebaseAuth _auth = FirebaseAuth.instance;
  User? _user;

  @override
  void initState() {
    super.initState();
    _getUserData();
  }

  Future<void> _getUserData() async {
    _user = _auth.currentUser;
    if (_user != null) {
      setState(() {
        _nameController.text = _user!.displayName!.split(";").first ?? '';
      });
    }
  }

  Future<void> _updateProfile() async {
    if (!mounted) return; // Check if widget is still mounted

    // Show loading indicator
    showDialog(
      context: context,
      barrierDismissible: false, // Prevent users from dismissing the dialog
      builder: (BuildContext context) {
        return Center(
          child: CircularProgressIndicator(), // Circular loading indicator
        );
      },
    );

    try {
      await _user!.updateDisplayName(_nameController.text);

      if (!mounted)
        return; // Check again in case the widget got unmounted during async operation
      Navigator.of(context).pop(); // Dismiss the loading indicator

      widget.onChange(true);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Profile updated successfully')),
      );
    } catch (e) {
      print('Error updating profile: $e');
      if (!mounted) return; // Check if mounted before showing SnackBar
      Navigator.of(context).pop(); // Dismiss the loading indicator

      // Show error message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to update profile')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            backButton(),
            H2Heading("Edit Profile"),
            TextFieldContainer(
              controller: _nameController,
              hintText: 'Name',
              heading: "Profile Name",
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  ElevatedButton(
                    onPressed: () async {
                      await _updateProfile();
                      Navigator.pop(context);
                    },
                    child: Text('Save'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class UpdatePasswordPage extends StatefulWidget {
  const UpdatePasswordPage({Key? key}) : super(key: key);

  @override
  _UpdatePasswordPageState createState() => _UpdatePasswordPageState();
}

class _UpdatePasswordPageState extends State<UpdatePasswordPage> {
  final _formKey = GlobalKey<FormState>();
  final _currentUser = FirebaseAuth.instance.currentUser;
  final _newPasswordController = TextEditingController();

  @override
  void dispose() {
    _newPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  backButton(),
                  H2Heading(
                    "Update Password Page",
                  )
                ],
              ),
              const SizedBox(height: 16.0),
              TextFieldContainer(
                controller: _newPasswordController,
                hintText: 'New Password',
              ),
              const SizedBox(height: 16.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  ElevatedButton(
                    onPressed: () async {
                      // _currentUser!.updateDisplayName("displayName");

                      if (_formKey.currentState!.validate()) {
                        try {
                          await _currentUser!
                              .updatePassword(_newPasswordController.text);
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Password updated successfully.'),
                            ),
                          );
                          Navigator.pop(context);
                        } on FirebaseAuthException catch (e) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content:
                                  Text('Error updating password: ${e.message}'),
                            ),
                          );
                        }
                      }
                    },
                    child: const Text('Update Password'),
                  ),
                  SizedBox(width: 16.0),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

Future<void> sendingMails(String urlIn) async {
  var url = Uri.parse("mailto:$urlIn");
  if (!await launchUrl(url)) throw 'Could not launch $url';
}
