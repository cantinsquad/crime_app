import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:location/location.dart';

import 'home.dart';

class ImageFromGalleryEx extends StatefulWidget {
  // ignore: prefer_typing_uninitialized_variables
  final type;
  const ImageFromGalleryEx(this.type, {super.key});

  @override
  ImageFromGalleryExState createState() => ImageFromGalleryExState(type);
}

class ImageFromGalleryExState extends State<ImageFromGalleryEx> {
  var _image;
  var imagePicker;
  var type;

  ImageFromGalleryExState(this.type);

  @override
  void initState() {
    super.initState();
    imagePicker = ImagePicker();
  }

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

  @override
  Widget build(BuildContext context) {
    TextEditingController cont = TextEditingController();
    final formKey = GlobalKey<FormState>();
    String firnumber = "";
    return Scaffold(
      appBar: AppBar(
          title: Text(type == ImageSourceType.camera
              ? "Image from Camera"
              : "Image from Gallery")),
      body: Column(
        children: <Widget>[
          const SizedBox(
            height: 52,
          ),
          Center(
            child: GestureDetector(
              onTap: () async {
                var source = type == ImageSourceType.camera
                    ? ImageSource.camera
                    : ImageSource.gallery;
                XFile image = await imagePicker.pickImage(
                    source: source,
                    imageQuality: 50,
                    preferredCameraDevice: CameraDevice.rear);
                setState(() {
                  _image = File(image.path);
                });
              },
              child: Container(
                width: 200,
                height: 200,
                decoration: BoxDecoration(color: Colors.red[200]),
                child: _image != null
                    ? Image.file(
                        _image,
                        width: 200.0,
                        height: 200.0,
                        fit: BoxFit.fitHeight,
                      )
                    : Container(
                        decoration: BoxDecoration(color: Colors.red[200]),
                        width: 200,
                        height: 200,
                        child: Icon(
                          Icons.camera_alt,
                          color: Colors.grey[800],
                        ),
                      ),
              ),
            ),
          ),
          FutureBuilder(
              future: getloc(),
              builder: (ctx, snap) {
                return Text("loc" + snap.data.toString());
              }),
          Form(
            key: formKey,
            child: TextFormField(
              // initialValue: 'Input text',

              decoration: const InputDecoration(
                labelStyle: TextStyle(color: Colors.black),
                prefixIcon: Icon(
                  Icons.document_scanner,
                  color: Colors.white,
                ),
                labelText: 'FIR Number',
                border: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.black),
                  borderRadius: BorderRadius.all(
                    Radius.circular(100.0),
                  ),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.black),
                  borderRadius: BorderRadius.all(
                    Radius.circular(100.0),
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.black),
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
          IconButton(
              onPressed: () {
                print(firnumber);
              },
              icon: Icon(Icons.send))
        ],
      ),
    );
  }
}
