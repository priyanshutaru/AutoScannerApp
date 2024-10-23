// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, sized_box_for_whitespace, avoid_print, unnecessary_string_interpolations

import 'dart:io';
import 'dart:convert'; // Import for Base64 encoding
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:async';
import 'package:cunning_document_scanner/cunning_document_scanner.dart';

class CommonDocumentPicker extends StatefulWidget {
  final List<String> imagePath;
  final List<String> base64OfImage;
  final String imageName;

  const CommonDocumentPicker({
    Key? key,
    required this.imagePath,
    required this.base64OfImage,
    required this.imageName,
  }) : super(key: key);

  @override
  State<CommonDocumentPicker> createState() => _CommonDocumentPickerState();
}

class _CommonDocumentPickerState extends State<CommonDocumentPicker> {
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    initPlatformState();
  }


// this is working fine
  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initPlatformState() async {}

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          DottedBorder(
            color: Colors.black,
            strokeWidth: 1,
            dashPattern: [4, 4],
            borderType: BorderType.RRect,
            radius: Radius.circular(8.0),
            child: GestureDetector(
              onTap: showOptionDialog,
              child: Container(
                height: 150, // Adjust the height as needed
                width: double.infinity,
                child: Row(
                  children: [
                    // Left side showing the image if available or the camera icon if not
                    Expanded(
                      child: widget.imagePath.isNotEmpty
                          ? Padding(
                        padding: const EdgeInsets.only(
                            top: 8.0, bottom: 8.0, left: 8.0),
                        child: Image.file(
                          File(widget.imagePath.first),
                          fit: BoxFit.cover,
                        ),
                      )
                          : Container(
                        color: Colors.grey[300],
                        child: Center(
                          child: Icon(
                            Icons.camera_alt,
                            size: 48.0,
                            color: Colors.black54,
                          ),
                        ),
                      ),
                    ),
                    // Right side showing the text with imageName
                    Expanded(
                      child: Container(
                        color: Colors.white,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              widget.imageName,
                              style: TextStyle(
                                  fontSize: 16.0, color: Colors.black),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void showOptionDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Select Option'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: Icon(Icons.photo_library),
                title: Text('Select from Gallery'),
                onTap: () {
                  Navigator.pop(context); // Close the dialog
                  _pickImageFromGallery();
                },
              ),
              ListTile(
                leading: Icon(Icons.camera_alt),
                title: Text('Use Camera'),
                onTap: () {
                  Navigator.pop(context); // Close the dialog
                  onPressed();
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void _pickImageFromGallery() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        widget.imagePath.clear();
        widget.base64OfImage.clear(); // Clear the base64 list before adding new data

        widget.imagePath.add(image.path); // Store the image path for backend usage

        // Convert image to Base64
        final bytes = File(image.path).readAsBytesSync();
        final base64Image = base64Encode(bytes);
        widget.base64OfImage.add(base64Image); // Store the Base64 string in the list

        // Print the image path and Base64 string for each image
        print('${widget.imageName} Image Path List Length Is ---------------------------: ${widget.imagePath.length}');
        print('${widget.imageName}  Image Base64 List Length Is ---------------------------: ${widget.base64OfImage.length}');
        print('Image Path: ${image.path}');
        print('$base64Image');
      });
    }
  }

  void onPressed() async {
    List<String> pictures;
    try {
      pictures = await CunningDocumentScanner.getPictures() ?? [];
      if (!mounted) return;
      setState(() {
        widget.imagePath.clear();
        widget.base64OfImage.clear(); // Clear the base64 list before adding new data

        widget.imagePath.addAll(pictures);

        // Convert each image to Base64 and add it to the list
        for (var picture in pictures) {
          final bytes = File(picture).readAsBytesSync();
          final base64Image = base64Encode(bytes);
          widget.base64OfImage.add(base64Image);

          // Print the image path and Base64 string for each image
          print('${widget.imageName} Image Path List Length Is ---------------------------: ${widget.imagePath.length}');
          print('${widget.imageName}  Image Base64 List Length Is ---------------------------: ${widget.base64OfImage.length}');
          print('${widget.imageName}  Image Path: $picture');
          print('------------------------------------------');
          print('$base64Image');
        }
      });
    } catch (exception) {
      // Handle exception here
      print('Error: $exception');
    }
  }
}
