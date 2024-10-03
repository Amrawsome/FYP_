import 'dart:io';

import 'package:flutter/material.dart';
import 'package:fyp_code/Project_Code/Model/sharedPref.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tflite_v2/tflite_v2.dart';

class ImageClassifierController {
  String selectedMaterial = '';
  final _imagePicker = ImagePicker();

  void startingInfo(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {//waits till first frame is loaded
      showDialog(//show dialog
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            semanticLabel: "instructions",
            title: Text(
              "Image Classifier",
              style: TextStyle(fontSize: getWidthSHPR() * 0.05),
            ),
            content: Text(
              """Instructions: \n1.Press the plus button in bottom right to open your gallery.
            \n 2. Choose the picture of the material you want to identify.
            \n 3. Please choose if the material has been identified correctly.
            \n\n Please note that clear images with good lighting where the material is the main focus of the photo and the background is not cluttered will give the best chances for success 
            \n If you don't have a picture you can press the camera icon to open your camera and take a picture it will then appear in your gallery 
            \n At the moment Cardboard, Glass, Metal, Paper and Plastic can be identified, please hold on for more options in the future""",
              style: TextStyle(fontSize: getWidthSHPR() * 0.035),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text(
                  "OK",
                  style: TextStyle(
                      fontSize: getWidthSHPR() * 0.04, color: Colors.black),
                ),
              ),
            ],
          );
        },
      );
    });
  }

  //loads model from assets
  loadModel() async {
    await Tflite.loadModel(
      model: "assets/Model/model_unquant.tflite",
      labels: "assets/Model/labels.txt",
    );
  }


  Future<XFile> takePhoto() async {
    //taking photo and retrieving taken photo
    try {
      final XFile? photo =
          await _imagePicker.pickImage(source: ImageSource.camera);//retrieves picture data from taken picture
      if (photo != null) {
        return photo;//returns data
      } else {
        return XFile("");//return blank file
      }
    } catch (e) {
      print(e);
      return XFile("");
    }
  }
  //classifies image based on model
  classifyImage(File image) async {
    var output = await Tflite.runModelOnImage(
      path: image.path,
      numResults: 1,//results returned
      threshold: 0.5,//the confidence threshold for result
      imageMean: 127.5,
      imageStd: 127.5,
    );
    return output;
  }
}
