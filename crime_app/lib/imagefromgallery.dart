import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:location/location.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';

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
  var uid = "";
  List<XFile>? imageFileList = [];

  ImageFromGalleryExState(this.type);

  @override
  void initState() {
    super.initState();
    final user = FirebaseAuth.instance.currentUser;
    uid = user!.uid;

    imagePicker = ImagePicker();
  }

  Future<LocationData> getloc() async {
    Location location = new Location();

    bool _serviceEnabled;
    PermissionStatus _permissionGranted;
    LocationData _locationData;

    _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled) {
        return Future.error('Location services are disabled.');
      }
    }

    _permissionGranted = await location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        return Future.error('Location services are disabled.');
      }
    }

    _locationData = await location.getLocation();
    print(_locationData);
    return _locationData;
  }

  @override
  Widget build(BuildContext context) {
    TextEditingController cont = new TextEditingController();
    final _formKey = GlobalKey<FormState>();
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
                final pickedFile = await ImagePicker().pickMultiImage();

                if (pickedFile!.isNotEmpty) {
                  setState(() {
                    imageFileList!.addAll(pickedFile);
                    _image = File(imageFileList![0].path);
                  });
                }
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
            key: _formKey,
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
              onPressed: () async {
                final url = "https://f8bf-20-2-82-58.ap.ngrok.io/addReport";

                var x = await getloc();

                // Map d = {
                //   "fir": firnumber,
                //   "uid": uid,
                //   "lat": x.latitude,
                //   "long": x.longitude
                // };

                var request = http.MultipartRequest("POST", Uri.parse(url));

                List<http.MultipartFile> newList = [];

                for (var img in imageFileList!) {
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
                });
              },
              icon: Icon(Icons.send))
        ],
      ),
    );
  }
}
