import 'dart:ffi';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class CameraWidget extends StatefulWidget {
  const CameraWidget({super.key});

  @override
  State createState() {
    // TODO: implement createState
    return CameraWidgetState();
  }
}

class CameraWidgetState extends State {
  List<XFile>? imageFileList = [];
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

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: const Text("Pick Image Camera"),
        backgroundColor: Colors.green,
      ),
      body: Center(
        child: Container(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Card(
                child: (imageFileList == null || imageFileList!.isEmpty)
                    ? const Text("")
                    : Image.file(File(imageFileList![0].path)),
              ),
              MaterialButton(
                textColor: Colors.white,
                color: Colors.pink,
                onPressed: () {
                  _showChoiceDialog(context);
                },
                child: const Text("Select Image"),
              ),
              (imageFileList != null)
                  ? MaterialButton(
                      textColor: Colors.white,
                      color: Colors.pink,
                      onPressed: () {
                        _showChoiceDialog(context);
                      },
                      child: const Text("Upload Image"),
                    )
                  : const Text("")
            ],
          ),
        ),
      ),
    );
  }

  void _openGallery(BuildContext context) async {
    final pickedFile = await ImagePicker().pickMultiImage();

    if (pickedFile!.isNotEmpty) {
      setState(() {
        imageFileList!.addAll(pickedFile);
      });
    }

    Navigator.pop(context);
  }

  void _openCamera(BuildContext context) async {
    final pickedFile = await ImagePicker().pickImage(
      source: ImageSource.camera,
    );
    if (pickedFile != null) {
      setState(() {
        imageFileList!.addAll([pickedFile]);
      });
    }
    Navigator.pop(context);
  }
}
