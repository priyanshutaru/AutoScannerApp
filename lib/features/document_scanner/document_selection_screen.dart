// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'common_dacument_picker.dart';

class DocumentSelectionController extends GetxController{

  List<String> aadhaarFrontBase64ImageList = [];
  List<String> aadhaarFrontImagePathList = [];
  RxString aadhaarFrontImage = "Aadhaar Front".obs;


  List<String> aadhaarBackBase64ImageList = [];
  List<String> aadhaarBackImagePathList = [];
  RxString aadhaarBackImage = "Aadhaar Back".obs;


  List<String> panCardBase64ImageList = [];
  List<String> panCardImagePathList = [];
  RxString panCardImage = "Pan Card Image".obs;


  List<String> voterIdBase64ImageList = [];
  List<String> voterIdImagePathList = [];
  RxString voterIdImage = "Voter Id Image".obs;

}

class DocumentSelectionScreen extends StatefulWidget {
  const DocumentSelectionScreen({super.key});

  @override
  State<DocumentSelectionScreen> createState() => _DocumentSelectionScreenState();
}

class _DocumentSelectionScreenState extends State<DocumentSelectionScreen> {

  DocumentSelectionController controller = Get.put(DocumentSelectionController());

  @override
  void initState() {
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Upload Documents"),
      ),
      body:  SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(8.0),
          child: Column(
            children: [
              CommonDocumentPicker(imagePath: controller.aadhaarFrontImagePathList, base64OfImage: controller.aadhaarFrontBase64ImageList, imageName: controller.aadhaarFrontImage.value,),
              SizedBox(height: 20,),
              CommonDocumentPicker(imagePath: controller.aadhaarBackImagePathList, base64OfImage: controller.aadhaarBackBase64ImageList, imageName: controller.aadhaarBackImage.value,),
              SizedBox(height: 20,),
              CommonDocumentPicker(imagePath: controller.panCardImagePathList, base64OfImage: controller.panCardBase64ImageList, imageName: controller.panCardImage.value,),
              SizedBox(height: 20,),
              CommonDocumentPicker(imagePath: controller.voterIdImagePathList, base64OfImage: controller.voterIdBase64ImageList, imageName: controller.voterIdImage.value,),
              SizedBox(height: 20,),
            ],
          ),
        ),
      ),
    );
  }
}
