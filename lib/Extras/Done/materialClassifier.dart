import 'dart:io';

import 'package:flutter/material.dart';
import 'package:fyp_code/Extras/Done/Material_Chooser.dart';
import 'package:fyp_code/Project_Code/ImageClassifier/ImageClassifierLogic.dart';

import 'package:fyp_code/Project_Code/Model/sharedPref.dart';
import 'package:gallery_saver/gallery_saver.dart';

import 'package:image_picker/image_picker.dart';
import 'package:tflite_v2/tflite_v2.dart';

import 'Map.dart';

class IMGClassifier extends StatefulWidget {
  const IMGClassifier({super.key});

  @override
  State<IMGClassifier> createState() => _IMGClassifierState();
}

class _IMGClassifierState extends State<IMGClassifier> {
  ImageClassifierController controller = ImageClassifierController();
  String selectedMaterial = '';
  late bool _loading;
  late File _image = File("");
  late File _capturedImage = File("");
  late List? _outputs = [];
  final _imagePicker = ImagePicker();

  void initState() {
    super.initState();
    _loading = true;

    loadModel().then((value) {
      setState(() {
        _loading = false;
      });

    });
    WidgetsBinding.instance.addPostFrameCallback((_) {
      showDialog(
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
    //adding alert to show instructions and extra information


  //loads model from assets
  loadModel() async {
    await Tflite.loadModel(
      model: "assets/Model/model_unquant.tflite",
      labels: "assets/Model/labels.txt",
    );
  }

  //allows you to get image from gallery
  pickImage() async {
    var image = await _imagePicker.pickImage(source: ImageSource.gallery);
    if (image == null) return null;
    setState(() {
      _loading = true;
      _image = File(image.path);
    });
    classifyImage(_image);
  }

  //allows access to camera to take photo
  Future<void> takePhoto() async {
    try {
      final XFile? photo =
          await _imagePicker.pickImage(source: ImageSource.camera);
      if (photo != null) {
        final bool? success = await GallerySaver.saveImage(photo.path);
        if (success ?? false) {
          // Check if save was successful
          setState(() {
            _capturedImage = File(photo.path);
          });
        } else {}
      }
    } catch (e) {
      print(e);
    }
  }

  //looks at image from gallery and uses model to identify the material
  classifyImage(File image) async {
    var output = await Tflite.runModelOnImage(
      path: image.path,
      numResults: 1,
      threshold: 0.5,
      imageMean: 127.5,
      imageStd: 127.5,
    );

    setState(() {
      _loading = false;
      _outputs = output!;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: getHeightSHPR() * 0.1,
        backgroundColor: const Color(0xFF00bf7d),
        title: Text(
          'Material Classifier',
          style: TextStyle(
            fontSize: getWidthSHPR() * 0.08,
            fontWeight: FontWeight.bold,
          ),
        ),
        leading: IconButton(
            iconSize: getWidthSHPR() * 0.1,
            onPressed: () => {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => Materials_Chooser(),
                    ),
                  ),
                },
            icon:
                Icon(Icons.arrow_back, semanticLabel: "Choose Materials Page")),
      ),
      body: _loading
          ? Container(
              alignment: Alignment.center,
              child: CircularProgressIndicator(),
            )
          : Container(
              padding: EdgeInsets.fromLTRB(0, 0, 0, 75),
              width: MediaQuery.of(context).size.width,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _image.path.isNotEmpty //checking if image path is empty
                      ? Container(
                          //if it is not
                          child: Image.file(_image),
                          height: 500,
                          width: MediaQuery.of(context).size.width - 200,
                        )
                      : Container(
                          //if it is
                          // A placeholder when no image is selected
                          child: Text(
                          "No image choosen",
                          style: TextStyle(fontSize: getWidthSHPR() * 0.05),
                        )),
                  SizedBox(
                    height: 20,
                  ),
                  _outputs != null &&
                          _outputs!
                              .isNotEmpty //checking that outputs is not null and not empty
                      ? Column(children: [
                          Text(
                            "${_outputs?[0]["label"]}"
                                .replaceAll(RegExp(r'[0-9]'), ''),
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: getWidthSHPR() * 0.06,
                                background: Paint()..color = Colors.white,
                                fontWeight: FontWeight.bold),
                          ),
                          SizedBox(height: 10),
                          Text(
                            "Is This The Correct Material?",
                            style: TextStyle(fontSize: getWidthSHPR() * 0.038),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              ElevatedButton(
                                onPressed: () {
                                  setState(() {
                                    selectedMaterial =
                                        '${_outputs?[0]['label']}'
                                            .replaceAll(RegExp(r'[0-9]'), '');
                                    print(selectedMaterial);
                                    print(selectedMaterial.trim());
                                  });
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (_) => Mapp(
                                            selectedMaterial:
                                                selectedMaterial.trim())),
                                  );
                                },
                                child: Text(
                                  'Yes',
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontSize: getWidthSHPR() * 0.035),
                                ),
                              ),
                              SizedBox(width: 10),
                              ElevatedButton(
                                  onPressed: () {
                                    showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return AlertDialog(
                                          title: Text(
                                            "Reclassification",
                                            style: TextStyle(
                                                fontSize:
                                                    getWidthSHPR() * 0.05),
                                          ),
                                          content: Text(
                                            "Sorry The Material Couldn't be identified \nWould you like to try again with a different image?",
                                            style: TextStyle(
                                                fontSize:
                                                    getWidthSHPR() * 0.035),
                                          ),
                                          actions: [
                                            TextButton(
                                              onPressed: () {
                                                Navigator.pop(context);
                                                Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                    builder: (_) =>
                                                        Materials_Chooser(),
                                                  ),
                                                );
                                                // Close dialog
                                              },
                                              child: Text(
                                                'Cancel',
                                                style: TextStyle(
                                                    fontSize:
                                                        getWidthSHPR() * 0.04,
                                                    color: Colors.black),
                                              ),
                                            ),
                                            TextButton(
                                              onPressed: () {
                                                setState(() {
                                                  _image = File('');
                                                  _outputs = [];
                                                });
                                                Navigator.pop(context);
                                                // Close dialog
                                              },
                                              child: Text(
                                                'Try Again',
                                                style: TextStyle(
                                                    fontSize:
                                                        getWidthSHPR() * 0.04,
                                                    color: Colors.black),
                                              ),
                                            ),
                                          ],
                                        );
                                      },
                                    );
                                  },
                                  child: Text(
                                    'No',
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontSize: getWidthSHPR() * 0.035),
                                  )),
                            ],
                          ),
                        ])
                      : Text(
                          "Classification Waiting",
                          style: TextStyle(fontSize: getWidthSHPR() * 0.05),
                        )
                ],
              ),
            ),
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        // Aligns the FABs to the right
        children: [
          SizedBox(
            width: getWidthSHPR() * 0.15,
            height: getWidthSHPR() * 0.15,
            child: FloatingActionButton(
              heroTag: "pickingImage",
              backgroundColor: const Color(0xFF00bf7d),
              onPressed: pickImage,
              tooltip: 'Pick Image',
              child: Icon(
                Icons.add,
                size: getWidthSHPR() * 0.095,
                color: Colors.black,
                semanticLabel: "Choose Image",
              ),
            ),
          ),
          SizedBox(width: 10),
          SizedBox(
            width: getWidthSHPR() * 0.15,
            height: getWidthSHPR() * 0.15,
            child: FloatingActionButton(
              heroTag: "takingPicture",
              backgroundColor: const Color(0xFF00bf7d),
              onPressed: takePhoto,
              child: Icon(Icons.camera_alt_rounded,
                  size: getWidthSHPR() * 0.095,
                  color: Colors.black,
                  semanticLabel: "Take Picture"),
            ),
          ),
        ],
      ),
    );
  }
}
