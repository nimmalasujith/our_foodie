// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'dart:math';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:intl/intl.dart';
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server.dart';
import 'package:our_foodie/homePage.dart';
import 'package:our_foodie/main.dart';
import 'package:our_foodie/saveData.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../settings.dart';
import '../shops/shop_details.dart';

class LoginPage extends StatelessWidget {
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> _signInWithGoogle(BuildContext context) async {
    try {
      final GoogleSignInAccount? googleSignInAccount =
          await GoogleSignIn().signIn();
      if (googleSignInAccount == null) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Google sign-in was canceled.'),
        ));
        return;
      }
      final GoogleSignInAuthentication googleAuth =
          await googleSignInAccount.authentication;
      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );
      await FirebaseAuth.instance.signInWithCredential(credential);
    } catch (error) {
      print(error);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Failed to sign in with Google: $error'),
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Text(
              "Our Foodie",
              style: TextStyle(
                  fontSize: 35,
                  fontWeight: FontWeight.w500,
                  color: Colors.orangeAccent),
            ),
            Column(
              children: [
                Text(
                  'Welcome back you\'ve been missed!',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                  ),
                ),

                const SizedBox(height: 25),

                MyTextField(
                  controller: usernameController,
                  hintText: 'Username',
                  obscureText: false,
                ),

                const SizedBox(height: 10),

                MyTextField(
                  controller: passwordController,
                  hintText: 'Password',
                  obscureText: true,
                ),

                const SizedBox(height: 10),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      InkWell(
                        onTap: () async {
                          final String email = usernameController.text.trim();
                          if (email.length > 10) {
                            try {
                              await _auth.sendPasswordResetEmail(email: email);
                              showDialog(
                                context: context,
                                builder: (context) => AlertDialog(
                                  title: Text('Password Reset Email Sent'),
                                  content: Text(
                                      'An email with instructions to reset your password has been sent to $email.'),
                                  actions: <Widget>[
                                    TextButton(
                                      onPressed: () => Navigator.pop(context),
                                      child: Text('OK'),
                                    ),
                                  ],
                                ),
                              );
                            } catch (error) {
                              showDialog(
                                context: context,
                                builder: (context) => AlertDialog(
                                  title: Text('Error'),
                                  content: Text(error.toString()),
                                  actions: <Widget>[
                                    TextButton(
                                      onPressed: () => Navigator.pop(context),
                                      child: Text('OK'),
                                    ),
                                  ],
                                ),
                              );
                            }
                          } else {
                            showToastText("Enter Gmail");
                          }
                        },
                        child: Text(
                          'Forgot Password?',
                          style: TextStyle(color: Colors.grey[500]),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 25),

                // sign in button
                InkWell(
                  onTap: () => signIn(context, usernameController.text,
                      passwordController.text),
                  child: Container(
                    padding: const EdgeInsets.all(25),
                    margin: const EdgeInsets.symmetric(horizontal: 25),
                    decoration: BoxDecoration(
                      color: Colors.black,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Center(
                      child: Text(
                        "Sign In",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
                )
              ],
            ),
            Text(
              "or",
              style: TextStyle(fontSize: 15, color: Colors.white54),
            ),
            Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton(
                      onPressed: () async {
                        showDialog(
                            context: context,
                            barrierDismissible: false,
                            builder: (context) => Center(
                                  child: CircularProgressIndicator(
                                    color: Colors.white54,
                                  ),
                                ));
                        try {
                          await FirebaseAuth.instance.signInAnonymously();

                          Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => BottomNavigation()));
                        } catch (e) {
                          Navigator.pop(context);
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            content: Text(
                                'An error occurred. Please try again later.'),
                          ));
                        } finally {}
                      },

                      child: Text('Guest Role'),
                    ),
                    ElevatedButton(
                      onPressed: () => _signInWithGoogle(context),
                      child: Text('Sign in with Google'),
                    ),
                  ],
                ),
                SizedBox(
                  height: 20,
                ),
                InkWell(
                  onTap: () {
                    // Navigator.push(context,
                    //     MaterialPageRoute(builder: (context) => createNewUser()));
                  },
                  child: Row(
                    // alignment: WrapAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Not a member? ',
                        style: TextStyle(color: Colors.white, fontSize: 18),
                      ),
                      Text(
                        'Register Now',
                        style: TextStyle(
                            color: Colors.orangeAccent,
                            fontWeight: FontWeight.w500,
                            fontSize: 20),
                      ),
                    ],
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}

Future signIn(BuildContext context, String user, String password) async {
  showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => Center(
            child: CircularProgressIndicator(),
          ));
  try {
    await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: user.trim().toLowerCase(), password: password.trim());
    Navigator.of(context).pop();
    updateToken(getBranch(user.trim()));
  } on FirebaseException catch (e) {
    showToastText(e.message as String);
    Navigator.of(context).pop();
  }
}

class MyTextField extends StatelessWidget {
  final controller;
  final String hintText;
  final bool obscureText;

  const MyTextField({
    required this.controller,
    required this.hintText,
    required this.obscureText,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: TextField(
        style: TextStyle(color: Colors.white, fontSize: 15),
        controller: controller,
        obscureText: obscureText,
        decoration: InputDecoration(
            enabledBorder: const OutlineInputBorder(
              borderSide: BorderSide(color: Colors.white12),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.grey.shade400),
            ),
            fillColor: Colors.white10,
            filled: true,
            hintText: hintText,
            hintStyle: TextStyle(color: Colors.grey[500])),
      ),
    );
  }
}

// class createNewUser extends StatefulWidget {
//
//
//   createNewUser();
//
//   @override
//   State<createNewUser> createState() => _createNewUserState();
// }
//
// class _createNewUserState extends State<createNewUser> {
//   bool isTrue = false;
//   bool isSend = false;
//   String otp = "";
//   List branches = [
//     "ECE",
//     "CIVIL",
//     "CSE",
//     "EEE",
//     "IT",
//     "MECH",
//     "AIDS",
//     "CSBS",
//     "AIML",
//     "CSD",
//     "CSIT"
//   ];
//   String branch = "None";
//   final emailController = TextEditingController();
//   final usernameController = TextEditingController();
//   final otpController = TextEditingController();
//   final passwordController = TextEditingController();
//   final passwordController_X = TextEditingController();
//
//   String generateCode() {
//     final Random random = Random();
//     const characters = '123456789abcdefghijklmnpqrstuvwxyz';
//     String code = '';
//     for (int i = 0; i < 6; i++) {
//       code += characters[random.nextInt(characters.length)];
//     }
//     return code;
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: SafeArea(
//         child: SingleChildScrollView(
//           child: Column(
//             children: [
//               backButton(),
//               SizedBox(
//                 height: 15,
//               ),
//               TextFieldContainer(
//
//                   heading: "Format : 2_b91a____@srkrec.ac.in (STD)",
//                   child: TextFormField(
//                     enabled: (!isTrue) && (!isSend),
//                     controller: emailController,
//                     textInputAction: TextInputAction.next,
//                     style: textFieldStyle(),
//                     decoration: InputDecoration(
//                         border: InputBorder.none,
//                         hintText: 'Enter College Mail ID',
//                         hintStyle: textFieldHintStyle()),
//                     validator: (email) =>
//                     email != null && !EmailValidator.validate(email)
//                         ? "Enter a valid Email"
//                         : null,
//                   )),
//               if (!isTrue)Padding(
//                 padding: EdgeInsets.only(left: 10, top: 10, bottom: 5,right: 10),
//                 child: Text(
//                   'Note : "OTP will only be sent for the domain srkrec.ac.in"',
//                   style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500,color: Colors.white),
//                 ),
//               ),
//               if (!isTrue)Padding(
//                 padding: EdgeInsets.only(left: 10, top: 10, bottom: 5,right: 10),
//                 child: Text(
//                   'Note : "Use Outlook for OTP. If the OTP does not arrive, then check in spam messages. If you still aren'
//                       't receiving it, there may'
//                       'be a problem with our regulated Gmail. Please check it."',
//                   style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500,color: Colors.white70),
//                 ),
//               ),
//               Padding(
//                 padding: const EdgeInsets.all(8.0),
//                 child: Row(
//                   mainAxisAlignment: MainAxisAlignment.end,
//                   children: [
//                     if (isSend)
//                       Flexible(
//                         child: TextFieldContainer(
//                             child: TextFormField(
//                               controller: otpController,
//                               textInputAction: TextInputAction.next,
//                               style: textFieldStyle(),
//                               decoration: InputDecoration(
//                                   border: InputBorder.none,
//                                   hintText: 'Enter OTP',
//                                   hintStyle: textFieldHintStyle()),
//                             )),
//                       ),
//                     Padding(
//                       padding: EdgeInsets.symmetric(horizontal: 10),
//                       child: InkWell(
//                         child: Container(
//                           decoration: BoxDecoration(
//                               color: Colors.blueGrey,
//                               borderRadius: BorderRadius.circular(20)),
//                           child: Padding(
//                             padding: EdgeInsets.symmetric(
//                                 vertical: 5, horizontal: 10),
//                             child: Text(
//                               isSend ? "Verify" : "Send OTP",
//                               style: TextStyle(
//                                   color: Colors.black,
//                                   fontSize: 25,
//                                   fontWeight: FontWeight.w600),
//                             ),
//                           ),
//                         ),
//                         onTap: () async {
//                           if (isSend) {
//                             if (otp == otpController.text.trim()) {
//                               isTrue = true;
//                               await FirebaseFirestore.instance
//                                   .collection("tempRegisters")
//                                   .doc(emailController.text.toLowerCase())
//                                   .delete();
//                             } else {
//                               showToastText("Please Enter Correct OTP");
//                             }
//                           }
//                           else {
//                             await FirebaseFirestore.instance
//                                 .collection("tempRegisters")
//                                 .doc(emailController.text.toLowerCase())
//                                 .get()
//                                 .then((DocumentSnapshot snapshot) async {
//                               if (snapshot.exists) {
//                                 var data = snapshot.data();
//                                 if (data != null && data is Map<String, dynamic>) {
//                                   String value = data['code'];
//                                   otp = value;
//                                   await FirebaseFirestore.instance
//                                       .collection("tempRegisters")
//                                       .doc(emailController.text.toLowerCase())
//                                       .set({
//                                     "email": emailController.text.toLowerCase(),
//                                     "code": otp,
//                                     "data": getID()
//                                   });
//                                 }
//                               }
//                               else {
//                                 otp = await generateCode();
//                                 await FirebaseFirestore.instance
//                                     .collection("tempRegisters")
//                                     .doc(emailController.text.toLowerCase())
//                                     .set({
//                                   "email": emailController.text.toLowerCase(),
//                                   "code": otp
//                                 });
//                               }
//                               setState(() {
//                                 otp;
//                               });
//                             }).catchError((error) {
//                               print(
//                                   "An error occurred while retrieving data: $error");
//                             });
//                             var email = emailController.text.toLowerCase()
//                                 .trim()
//                                 .split('@');
//                             if (email[1] == 'srkrec.ac.in') {
//                               sendEmail(emailController.text.toLowerCase().trim(),
//                                   otp);
//                               branch = await getBranch(emailController.text
//                                   .toLowerCase());
//                             }
//                             else {
//                               if (emailController.text
//                                   .split('@')
//                                   .last
//                                   .toLowerCase() == 'gmail.com') {
//                                 showToastText("OTP is Not Sent to Email");
//                               }
//                               else
//                                 showToastText("Please Enter Correct Email ID");
//                             }
//                             messageToOwner(
//                               emailController.text.toLowerCase() + "'s code : $otp",
//                             );
//                             isSend = true;
//                           }
//
//                           setState(() {
//                             branch;
//                             isSend;
//                             otp;
//                             isTrue;
//                           });
//                         },
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//               Text(
//                 "Your Branch : $branch",
//                 style: TextStyle(color: Colors.white, fontSize: 20),
//               ),
//               if (isTrue)
//                 Column(
//                   mainAxisAlignment: MainAxisAlignment.start,
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Padding(
//                       padding:
//                       EdgeInsets.symmetric(vertical: 15, horizontal: 15),
//                       child: Text(
//                         "Fill the Details",
//                         style: creatorHeadingTextStyle,
//                       ),
//                     ),
//
//                     TextFieldContainer(
//                       child: TextFormField(
//
//                         controller: usernameController,
//                         textInputAction: TextInputAction.next,
//                         style: textFieldStyle(),
//                         decoration: InputDecoration(
//                             border: InputBorder.none,
//                             hintText: 'Name',
//                             hintStyle: textFieldHintStyle()),
//
//                       ), heading: "User Name",),
//                     TextFieldContainer(
//                       child: TextFormField(
//                         obscureText: true,
//                         controller: passwordController,
//                         textInputAction: TextInputAction.next,
//                         style: textFieldStyle(),
//                         decoration: InputDecoration(
//                             border: InputBorder.none,
//                             hintText: 'Password',
//                             hintStyle: textFieldHintStyle()),
//                         autovalidateMode: AutovalidateMode.onUserInteraction,
//                         validator: (value) =>
//                         value != null && value.length < 6
//                             ? "Enter min. 6 characters"
//                             : null,
//                       ), heading: "Password",),
//                     TextFieldContainer(
//                         child: TextFormField(
//                           obscureText: true,
//                           controller: passwordController_X,
//                           textInputAction: TextInputAction.next,
//                           style: textFieldStyle(),
//                           decoration: InputDecoration(
//                             border: InputBorder.none,
//                             hintText: 'Conform Password',
//                             hintStyle: textFieldHintStyle(),
//                           ),
//                           autovalidateMode: AutovalidateMode.onUserInteraction,
//                           validator: (value) =>
//                           value != null && value.length < 6
//                               ? "Enter min. 6 characters"
//                               : null,
//                         )),
//                     if (branch == "None")Padding(
//                       padding:
//                       EdgeInsets.symmetric(vertical: 10, horizontal: 10),
//                       child: Row(
//                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                         children: [
//                           Text(
//                             "Selected Branch : $branch",
//                             style: creatorHeadingTextStyle,
//                           ),
//                           if((int.tryParse(emailController.text.substring(0, 2)) == null &&
//                               emailController.text
//                                   .split("@")
//                                   .last == "srkrec.ac.in") || emailController.text
//                               .split("@")
//                               .last == "gmail.com")ElevatedButton(onPressed: () {
//                             setState(() {
//                               branch = "None";
//                             });
//                           }, child: Text("Edit"))
//                         ],
//                       ),
//                     ),
//                     if (branch == "None")
//                       Padding(
//                         padding: EdgeInsets.all(8.0),
//                         child: Container(
//                           constraints: BoxConstraints(maxHeight: 50),
//
//                           child: ListView.separated(
//                             physics: const BouncingScrollPhysics(),
//                             scrollDirection: Axis.horizontal,
//                             itemCount: branches.length,
//                             // Display only top 5 items
//                             itemBuilder: (context, int index) {
//                               return InkWell(
//                                 child: Column(
//                                   children: [
//                                     Container(
//                                         padding: EdgeInsets.symmetric(
//                                             vertical: 2, horizontal: 20),
//                                         margin: EdgeInsets.only(left: index == 0 ? 10 : 3),
//
//                                         decoration: BoxDecoration(
//                                             color: branch == branches[index]
//                                                 ? Colors.black.withOpacity(0.6)
//                                                 : Colors.black.withOpacity(0.1),
//                                             borderRadius: BorderRadius.circular(15)),
//                                         child: Text(
//                                           "${branches[index]}",
//                                           style: TextStyle(
//                                               color: Colors.black,
//                                               fontSize: 25,
//                                               fontWeight: FontWeight.w500),
//                                         )),
//                                   ],
//                                 ),
//                                 onTap: () {
//                                   setState(() {
//                                     branch = branches[index];
//                                   });
//                                 },
//                               );
//                             },
//                             separatorBuilder: (context, index) =>
//                                 SizedBox(
//                                   width: 3,
//                                 ),
//                           ),
//                         ),
//                       ),
//                     SizedBox(height: 10,),
//                     Row(
//                       mainAxisAlignment: MainAxisAlignment.end,
//                       crossAxisAlignment: CrossAxisAlignment.center,
//                       children: [
//                         TextButton(
//                           onPressed: () {
//                             Navigator.pop(context);
//                           },
//                           child: Text('cancel ', style: TextStyle(fontSize: 25,color: Colors.white70)),
//                         ),
//                         TextButton(
//                           onPressed: () async {
//                             if (branch == "None") {
//                               showToastText("Select Branch");
//                               return;
//                             }
//                             if (passwordController.text.trim() ==
//                                 passwordController_X.text.trim()) {
//                               showDialog(
//                                   context: context,
//                                   barrierDismissible: false,
//                                   builder: (context) =>
//                                       Center(
//                                         child: CircularProgressIndicator(),
//                                       ));
//                               try {
//                                 await FirebaseAuth.instance
//                                     .createUserWithEmailAndPassword(
//                                     email:
//                                     emailController.text.trim().toLowerCase(),
//                                     password: passwordController.text.trim());
//                                 await Future.delayed(Duration(seconds: 1));
//                                 FirebaseAuth _auth = FirebaseAuth.instance;
//                                 await _auth.currentUser!.updateDisplayName(
//                                     usernameController.text + ";" + branch);
//                                 SharedPreferences prefs = await SharedPreferences.getInstance();
//                                 prefs.setInt('lastOpenAdTime', DateTime
//                                     .now()
//                                     .millisecondsSinceEpoch);
//                                 NotificationService().showNotification(
//                                     title: "Welcome to eSRKR app!",
//                                     body: "Your Successfully Registered!");
//                                 updateToken(branch);
//                                 newUser(emailController.text.trim().toLowerCase());
//                               } on FirebaseException catch (e) {
//                                 print(e);
//                                 Utils.showSnackBar(e.message);
//                               }
//                               Navigator.pop(context);
//                               Navigator.pop(context);
//                             } else {
//                               showToastText("Enter Same Password");
//                             }
//                           },
//                           child: Padding(
//                             padding: EdgeInsets.only(right: 15),
//                             child: Text(
//                               'Sign up ',
//                               style: TextStyle(fontSize: 30,color: Colors.orangeAccent),
//                             ),
//                           ),
//                         ),
//                       ],
//                     ),
//                     SizedBox(height: 100,)
//
//                   ],
//                 ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
//
//   Future<void> sendEmail(String mail, String otp) async {
//     final smtpServer = gmail(
//         'esrkr.study.app@gmail.com', 'tvkd ujkb ybdt leay');
//     DateTime currentDate = DateTime.now();
//     String formattedDate = DateFormat('d MMM, y').format(currentDate);
//     String htmlContent = """
//     <!DOCTYPE html>
// <html lang="en">
//   <head>
//     <meta charset="UTF-8" />
//     <meta name="viewport" content="width=device-width, initial-scale=1.0" />
//     <meta http-equiv="X-UA-Compatible" content="ie=edge" />
//     <title>Static Template</title>
//
//     <link
//       href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600&display=swap"
//       rel="stylesheet"
//     />
//   </head>
//   <body
//     style="
//       margin: 0;
//       font-family: 'Poppins', sans-serif;
//       background: #ffffff;
//       font-size: 14px;
//     "
//   >
//     <div
//       style="
//         max-width: 680px;
//         margin: 0 auto;
//         padding: 45px 20px 60px;
//         background: #f4f7ff;
//          background-repeat: no-repeat;
//         background-size: 800px 452px;
//         background-position: top center;
//         font-size: 14px;
//         color: #434343;
//       "
//     >
//       <header>
//         <table style="width: 100%;">
//           <tbody>
//             <tr style="height: 0;">
//
//               <td>
//
//                 <h2 style="text-align: left;">eSRKR App</h2>
//               </td>
//
//               <td style="text-align: right;">
//                 <span
//                   style="font-size: 16px; line-height: 30px;"
//                   >$formattedDate</span
//                 >
//               </td>
//             </tr>
//           </tbody>
//         </table>
//       </header>
//
//       <main>
//         <div
//           style="
//             margin: 0;
//             margin-top: 50px;
//             padding: 92px 20px 115px;
//             background: #ffffff;
//             border-radius: 30px;
//             text-align: center;
//           "
//         >
//           <div style="width: 100%; max-width: 489px; margin: 0 auto;">
//             <h1
//               style="
//                 margin: 0;
//                 font-size: 24px;
//                 font-weight: 500;
//                 color: #1f1f1f;
//               "
//             >
//             App Login OTP
//             </h1>
//             <p
//               style="
//                 margin: 0;
//                 margin-top: 17px;
//                 font-size: 16px;
//                 font-weight: 500;
//               "
//             >
//               Hey ${emailController.text
//         .split("@")
//         .first
//         .toUpperCase()},
//             </p>
//             <p
//               style="
//                 margin: 0;
//                 margin-top: 17px;
//                 font-weight: 500;
//                 letter-spacing: 0.56px;
//               "
//             >
//             Your code is:
//             </p>
//             <p
//               style="
//                 margin: 0;
//                 margin-top: 60px;
//                 font-size: 30px;
//                 font-weight: 600;
//                 letter-spacing: 15px;
//                 color: #ba3d4f;
//               "
//             >
//               $otp
//             </p>
//             <p
//             style="
//               margin: 0;
//               margin-top: 17px;
//               font-weight: 500;
//               letter-spacing: 0.56px;
//             "
//           >
//           OTP is valid until
//             <span style="font-weight: 800; color: #1f1f1f;">App is Closed</span>..
//           </p>
//             <p
//               style="
//                 margin: 0;
//                 margin-top: 17px;
//                 font-size: 18px;
//                 font-weight: 500;
//                 letter-spacing: 0.56px;
//               "
//             >
//             Thank you for being a member of the eSRKR App.
//             </p>
//           </div>
//         </div>
//
//         <p
//           style="
//             max-width: 600px;
//             margin: 0 auto;
//             margin-top: 90px;
//             text-align: center;
//             font-weight: 500;
//             color: #8c8c8c;
//           "
//         >
//         Need help? You can reach us at <span  style="color: #499fb6; text-decoration: none;">esrkr.study.app@gmail.com</span>
//
//           or
//           <span  style="color: #499fb6; text-decoration: none;">sujithnimmala03@gmail.com</span>
//         </p>
//       </main>
//
//       <footer
//         style="
//           width: 100%;
//           margin: 20px auto 0;
//           text-align: center;
//           border-top: 1px solid #e6ebf1;
//         ">
//         <p
//           style="
//             margin: 0;
//             text-align: center;
//             margin-top: 40px;
//             font-size: 16px;
//             font-weight: 600;
//             color: #434343;
//           "
//         >
//         eSRKR App Team
//         </p>
//         <p style="margin: 0; margin-top: 8px; color: #434343;text-align: center;">
//         - ECE Department -
//         </p>
//
//       </footer>
//     </div>
//   </body>
// </html>
// """;
//
//     // Create the message
//     final message = Message()
//       ..from = Address('esrkr.study.app@gmail.com')
//       ..recipients.add(mail)
//       ..subject = 'eSRKR App'
//       ..html = htmlContent; // Set the HTML content
//
//     try {
//       await send(message, smtpServer);
//       showToastText("OTP Sent");
//     } catch (e) {
//       print('Error sending email: $e');
//       showToastText('Error sending email: $e');
//     }
//   }
// }
//

getBranch(String email) {
  String str = email.substring(6, 8);
  if (str == '04') {
    return 'ECE';
  } else if (str == '01') {
    return 'CIVIL';
  } else if (str == '05') {
    return 'CSE';
  } else if (str == '02') {
    return 'EEE';
  } else if (str == '12') {
    return 'IT';
  } else if (str == '03') {
    return 'MECH';
  } else if (str == '57') {
    return 'CSBS';
  } else if (str == '54') {
    return 'AIDS';
  } else {
    FirebaseAuth _auth = FirebaseAuth.instance;
    if (_auth.currentUser!.email != null) {
      return _auth.currentUser!.displayName!.split(";").last;
    }
    return "ECE";
  }
}

bool isAnonymousUser() => FirebaseAuth.instance.currentUser!.isAnonymous;

Future<void> updateToken(String branch) async {
  final token = await FirebaseMessaging.instance.getToken() ?? "";
  await FirebaseFirestore.instance.collection("tokens").doc(fullUserId()).set(
      {"id": fullUserId(), "time": getID(), "token": token, "branch": branch});
}
