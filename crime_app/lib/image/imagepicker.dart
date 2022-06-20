import 'dart:convert';
import 'dart:ffi';
import 'dart:io';
import 'dart:ui';
import 'package:crime_app/fir_output/output.dart';
import 'package:location/location.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:crime_app/auth/authentication.dart';
import 'package:crime_app/auth/login.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';

class CameraWidget extends StatefulWidget {
  const CameraWidget({super.key});

  @override
  State createState() {
    return CameraWidgetState();
  }
}

class CameraWidgetState extends State {
  List<XFile> imageFiles = [];
  var uid = "";

  Future<LocationData> getloc() async {
    Location location = Location();

    bool serviceEnabled;
    PermissionStatus permissionGranted;
    LocationData locationData;

    serviceEnabled = await location.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await location.requestService();
      if (!serviceEnabled) {
        return Future.error('Location services are disabled.');
      }
    }

    permissionGranted = await location.hasPermission();
    if (permissionGranted == PermissionStatus.denied) {
      permissionGranted = await location.requestPermission();
      if (permissionGranted != PermissionStatus.granted) {
        return Future.error('Location services are disabled.');
      }
    }

    locationData = await location.getLocation();
    print(locationData);
    return locationData;
  }

  // List<XFile>? imageFileList = [];
  Future<void> _showChoiceDialog(BuildContext context) {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text(
              "Choose option",
              style: TextStyle(color: Colors.blue),
            ),
            content: SingleChildScrollView(
              child: ListBody(
                children: [
                  const Divider(
                    height: 1,
                    color: Colors.blue,
                  ),
                  ListTile(
                    onTap: () {
                      _openGallery(context);
                    },
                    title: const Text("Gallery"),
                    leading: const Icon(
                      Icons.account_box,
                      color: Colors.blue,
                    ),
                  ),
                  const Divider(
                    height: 1,
                    color: Colors.blue,
                  ),
                  ListTile(
                    onTap: () {
                      _openCamera(context);
                    },
                    title: const Text("Camera"),
                    leading: const Icon(
                      Icons.camera,
                      color: Colors.blue,
                    ),
                  ),
                ],
              ),
            ),
          );
        });
  }

  var myMenuItems = <String>[
    'Logout',
  ];
  void onSelect(item) {
    switch (item) {
      case 'Logout':
        AuthenticationHelper().signOut().then((_) => Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (contex) => const Login()),
            ));
        break;
    }
  }

  String firnumber = "";

  @override
  void initState() {
    super.initState();
    final user = FirebaseAuth.instance.currentUser;
    uid = user!.uid;
  }

  Future<void> onUpload() async {
    const url = "https://f8bf-20-2-82-58.ap.ngrok.io/addReport";

    var x = await getloc();

    // Map d = {
    //   "fir": firnumber,
    //   "uid": uid,
    //   "lat": x.latitude,
    //   "long": x.longitude
    // };

    var request = http.MultipartRequest("POST", Uri.parse(url));

    List<http.MultipartFile> newList = [];

    for (var img in imageFiles) {
      if (img.path != "") {
        var multipartFile = await http.MultipartFile.fromPath(
          'images',
          img.path,
          filename: img.name,
        );
        newList.add(multipartFile);
      }
    }

    request.files.addAll(newList);

    request.fields['fir'] = firnumber;
    request.fields['uid'] = uid;
    request.fields['lat'] = x.latitude.toString();
    request.fields['long'] = x.longitude.toString();

    var resp = await request.send();

    print(resp.statusCode);

    resp.stream.transform(utf8.decoder).listen((value) {
      print(value);
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => FIROutput(value: {value})),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final formKey = GlobalKey<FormState>();

    return Scaffold(
        body: SingleChildScrollView(
      child: Container(
          constraints: BoxConstraints(
            minHeight: MediaQuery.of(context).size.height,
            // appBar: AppBar(
            //   title: const Text("Pick Image Camera"),
            //   backgroundColor: Colors.green,
            // ),
            // body: Center(
            //   child: Container(
            //     child: Column(
            //       mainAxisAlignment: MainAxisAlignment.center,
            //       children: [
            //         Card(
            //           child: (imageFileList == null || imageFileList!.isEmpty)
            //               ? const Text("")
            //               : Image.file(File(imageFileList![0].path)),
            //         ),
            //         MaterialButton(
            //           textColor: Colors.white,
            //           color: Colors.pink,
            //           onPressed: () {
            //             _showChoiceDialog(context);
            //           },
            //           child: const Text("Select Image"),
            //         ),
            //         (imageFileList != null)
            //             ? MaterialButton(
            //                 textColor: Colors.white,
            //                 color: Colors.pink,
            //                 onPressed: () {
            //                   _showChoiceDialog(context);
            //                 },
            //                 child: const Text("Upload Image"),
            //               )
            //             : const Text("")
            //       ],
          ),
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: ExactAssetImage('assets/images/police.jpg'),
              fit: BoxFit.cover,
            ),
          ),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 5.5, sigmaY: 5.5),
            child: Container(
              padding: const EdgeInsets.all(20.0),
              decoration: BoxDecoration(color: Colors.white.withOpacity(0.0)),
              child: Column(
                // crossAxisAlignment: Cro,
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  SizedBox(
                    width: MediaQuery.of(context).size.width,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        PopupMenuButton<String>(
                            iconSize: 35.0,
                            icon: const Icon(color: Colors.white, Icons.menu),
                            onSelected: onSelect,
                            itemBuilder: (BuildContext context) {
                              return myMenuItems.map((String choice) {
                                return PopupMenuItem<String>(
                                  child: Text(choice),
                                  value: choice,
                                );
                              }).toList();
                            }),
                        const Text(
                          "Upload FIR",
                          style: TextStyle(
                              fontSize: 50,
                              color: Colors.white,
                              fontFamily: 'KaushanScript'),
                        ),
                      ],
                    ),
                  ),
                  FutureBuilder(
                      future: getloc(),
                      builder: (ctx, snap) {
                        return Text(
                          "loc${snap.data}",
                          style: const TextStyle(
                            color: Colors.white,
                          ),
                        );
                      }),
                  Form(
                    key: formKey,
                    child: TextFormField(
                      // initialValue: 'Input text',
                      style: const TextStyle(color: Colors.white),
                      decoration: const InputDecoration(
                        labelStyle: TextStyle(color: Colors.white),
                        prefixIcon: Icon(
                          Icons.document_scanner,
                          color: Colors.white,
                        ),
                        labelText: 'FIR Number',
                        border: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.white),
                          borderRadius: BorderRadius.all(
                            Radius.circular(100.0),
                          ),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.white),
                          borderRadius: BorderRadius.all(
                            Radius.circular(100.0),
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.white),
                          borderRadius: BorderRadius.all(
                            Radius.circular(100.0),
                          ),
                        ),
                      ),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please enter FIR NUMBER';
                        }
                        return null;
                      },
                      onChanged: (val) {
                        firnumber = val;
                      },
                    ),
                  ),
                  imageFiles.isNotEmpty
                      ? Wrap(
                          children: imageFiles.map((imageone) {
                            return Container(
                                margin: const EdgeInsets.symmetric(
                                    horizontal: 38.0, vertical: 10.0),
                                child: Card(
                                  child: Image.file(File(imageone.path)),
                                ));
                          }).toList(),
                        )
                      : Container(),

                  //             Container(
                  //               margin: const EdgeInsets.all(20.0),
                  //               // decoration: BoxDecoration(
                  //               //   border: Border.all(width: 1.0),
                  //               //   borderRadius: const BorderRadius.all(Radius.circular(
                  //               //           5.0) //                 <--- border radius here
                  //               //       ),
                  //               // ),
                  //               child:
                  //                   // imageFile.forEach(()=>{

                  //                   // })
                  //                   GridView.count(
                  //     crossAxisCount: 2,
                  //     padding: EdgeInsets.fromLTRB(16.0, 128.0, 16.0, 16.0),
                  //     childAspectRatio: 8.0 / 8.5,
                  //     children: imageFile.map((String name) {
                  //           return  Card(
                  //                 child: (imageFile == null)
                  //                     ? const Text("")
                  //                     : Image.file(File(imageFile!.path)),
                  //               ),
                  //             ),
                  //     }).toList(),
                  //   ),
                  // ),
                  //       Card(
                  //     child: (imageFile == null)
                  //         ? const Text("")
                  //         : Image.file(File(imageFile!.path)),
                  //   ),
                  // ),
                  ElevatedButton(
                    onPressed: () {
                      if (imageFiles.isEmpty) {
                        _showChoiceDialog(context);
                      } else {
                        setState(() {
                          imageFiles = [];
                        });
                      }
                    },
                    style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.all(15.0),
                        primary: Colors.white,
                        shape: const RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(100.0)))),
                    child: Text(
                      imageFiles.isNotEmpty ? 'Clear image' : 'Select Image',
                      style: const TextStyle(
                          fontSize: 24,
                          color: Color.fromARGB(215, 110, 87, 87)),
                    ),
                  ),
                  // MaterialButton(
                  //   textColor: Colors.white,
                  //   color: Colors.pink,
                  //   onPressed: () {
                  //     _showChoiceDialog(context);
                  //   },
                  //   child: const Text("Select Image"),
                  // ),
                  (imageFiles.isNotEmpty)
                      ? ElevatedButton(
                          onPressed: () {
                            // _showChoiceDialog(context);
                            onUpload();
                          },
                          style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.all(15.0),
                              primary: Colors.white,
                              shape: const RoundedRectangleBorder(
                                  borderRadius: BorderRadius.all(
                                      Radius.circular(100.0)))),
                          child: const Text(
                            'Upload Image',
                            style: TextStyle(
                                fontSize: 24,
                                color: Color.fromARGB(215, 110, 87, 87)),
                          ),
                        )
                      //  MaterialButton(
                      //     textColor: Colors.white,
                      //     color: Colors.pink,
                      //     onPressed: () {

                      //     },
                      //     child: const Text("Upload Image"),
                      //   )
                      : const Text(""),
                  const SizedBox(
                    height: 20,
                  )
                ],
              ),
            ),
          )),
    ));
  }

  void _openGallery(BuildContext context) async {
    // final pickedFile = await ImagePicker().pickMultiImage(
    //     // source: ImageSource.gallery,
    //     );
    // setState(() {
    //   imageFiles = pickedFile!;
    // });
    final pickedFile = await ImagePicker().pickMultiImage();

    if (pickedFile!.isNotEmpty) {
      setState(() {
        imageFiles.addAll(pickedFile);
      });
    }

    Navigator.pop(context);
  }

  void _openCamera(BuildContext context) async {
    final pickedFile = await ImagePicker().pickImage(
      source: ImageSource.camera,
    );
    // setState(() {
    //   imageFiles.add(pickedFile!);
    // });
    if (pickedFile != null) {
      setState(() {
        imageFiles.addAll([pickedFile]);
      });
    }
    Navigator.pop(context);
  }
}
