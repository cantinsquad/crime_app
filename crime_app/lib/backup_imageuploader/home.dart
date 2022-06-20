// import 'package:crime_app/authentication.dart';
// import 'package:crime_app/login.dart';
// import 'package:crime_app/imagepicker.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:firebase_core/firebase_core.dart';
// import 'package:flutter/material.dart';
// import 'dart:io';

// import 'package:flutter/material.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:location/location.dart';

// import 'imagefromgallery.dart';

// enum ImageSourceType { gallery, camera }

// class Home extends StatefulWidget {
//   const Home({super.key});

//   @override
//   State<Home> createState() => _HomeState();
// }

// class _HomeState extends State<Home> {
//   var _image;

//   var imagePicker;

//   var type;

//   void _handleURLButtonPress(BuildContext context, var type) {
//     Navigator.push(
//         context, MaterialPageRoute(builder: (context) => const CameraWidget()));
//   }

//   @override
//   void initState() {
//     super.initState();
//     imagePicker = ImagePicker();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//         floatingActionButton: FloatingActionButton(
//           onPressed: () {
//             AuthenticationHelper()
//                 .signOut()
//                 .then((_) => Navigator.pushReplacement(
//                       context,
//                       MaterialPageRoute(builder: (contex) => const Login()),
//                     ));
//           },
//           tooltip: 'Logout',
//           child: const Icon(Icons.logout),
//         ),
//         appBar: AppBar(
//           title: const Text("Image Picker Example"),
//         ),
//         body: Center(
//           child: Column(
//             children: [
//               MaterialButton(
//                 color: Colors.blue,
//                 child: const Text(
//                   "Pick Image from Gallery",
//                   style: TextStyle(
//                       color: Colors.white70, fontWeight: FontWeight.bold),
//                 ),
//                 onPressed: () {
//                   _handleURLButtonPress(context, ImageSourceType.gallery);
//                 },
//               ),
//               MaterialButton(
//                 color: Colors.blue,
//                 child: const Text(
//                   "Pick Image from Camera",
//                   style: TextStyle(
//                       color: Colors.white70, fontWeight: FontWeight.bold),
//                 ),
//                 onPressed: () {
//                   _handleURLButtonPress(context, ImageSourceType.camera);
//                 },
//               ),
//             ],
//           ),
//         ));
//   }
// }
