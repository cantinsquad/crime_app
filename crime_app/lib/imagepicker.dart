import 'dart:ffi';
import 'dart:io';
import 'dart:ui';
import 'package:location/location.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:crime_app/authentication.dart';
import 'package:crime_app/login.dart';

class CameraWidget extends StatefulWidget {
  const CameraWidget({super.key});

  @override
  State createState() {
    return CameraWidgetState();
  }
}

class CameraWidgetState extends State {
  List<XFile> imageFiles = [];

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

  @override
  Widget build(BuildContext context) {
    final formKey = GlobalKey<FormState>();
    String firnumber = "";
    return Scaffold(
        body: SingleChildScrollView(
      child: Container(
          constraints: BoxConstraints(
            minHeight: MediaQuery.of(context).size.height,
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
              padding: EdgeInsets.all(20.0),
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
                  imageFiles.length != 0
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
                      if (imageFiles.length == 0) {
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
                      imageFiles.length != 0 ? 'Clear image' : 'Select Image',
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
                  (imageFiles.length != 0)
                      ? ElevatedButton(
                          onPressed: () {
                            // _showChoiceDialog(context);
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
    final pickedFile = await ImagePicker().pickMultiImage(
        // source: ImageSource.gallery,
        );
    setState(() {
      imageFiles = pickedFile!;
    });

    Navigator.pop(context);
  }

  void _openCamera(BuildContext context) async {
    final pickedFile = await ImagePicker().pickImage(
      source: ImageSource.camera,
    );
    setState(() {
      imageFiles.add(pickedFile!);
    });
    Navigator.pop(context);
  }
}
