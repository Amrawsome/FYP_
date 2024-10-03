import 'dart:io';

import 'package:flutter/material.dart';
import 'package:fyp_code/Project_Code/ImageClassifier/ImageClassifierLogic.dart';
import 'package:fyp_code/Project_Code/Map/MapUI.dart';
import 'package:fyp_code/Project_Code/MaterialsChooser/MaterialsChooserUI.dart';
import 'package:gallery_saver/gallery_saver.dart';

import 'package:image_picker/image_picker.dart';

import '../Model/sharedPref.dart';

class ImageClassifierView extends StatefulWidget {
  const ImageClassifierView({super.key});

  @override
  State<ImageClassifierView> createState() => _IMGClassifierState();
}

class _IMGClassifierState extends State<ImageClassifierView> {
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

    controller.loadModel().then((value) {
      //loads learned model for classifier
      setState(() {
        _loading = false; //changes loading state
      });
    });
    controller.startingInfo(context); //shows instructions
  }

  //allows you to get image from gallery
  pickImage() async {
    var image = await _imagePicker.pickImage(
        source: ImageSource.gallery); //image data for image for gallery
    if (image == null) return null;
    setState(() {
      _loading = true; //changes loading state
      _image = File(image.path); //set image data
    });
    classifyImage(_image); //uses image data to classify
  }

  //allows access to camera to take photo
  Future<void> takePhoto() async {
    //saving taken photo to gallery
    try {
      final XFile takenPhoto = await controller.takePhoto();
      await GallerySaver.saveImage(takenPhoto.path);

      // Check if save was successful
      setState(() {
        _capturedImage = File(takenPhoto.path);
      });
    } catch (e) {
      print(e);
    }
  }

  //looks at image from gallery and uses model to identify the material
  classifyImage(File image) async {
    var output = await controller.classifyImage(image);
    setState(() {
      _loading = false; //changes loading state
      _outputs = output!; //adds received data to variable
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
                      builder: (_) => MaterialsChooserView(),
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
                  const SizedBox(
                    height: 20,
                  ),
                  _outputs != null &&
                          _outputs!
                              .isNotEmpty //checking that outputs is not null and not empty
                      ? Column(children: [
                          Text(
                            "${_outputs?[0]["label"]}"
                                .replaceAll(RegExp(r'[0-9]'), ''),
                            //displays returned label for material
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: getWidthSHPR() * 0.06,
                                background: Paint()..color = Colors.white,
                                fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 10),
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
                                  });
                                  if (_image.existsSync()) {
                                    _image.delete();
                                    _capturedImage.delete();
                                  }
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) => MappView(
                                        selectedMaterial: selectedMaterial
                                            .trim(), //passed material to map
                                      ),
                                    ),
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
                                              fontSize: getWidthSHPR() * 0.05),
                                        ),
                                        content: Text(
                                          "Sorry The Material Couldn't be identified \nWould you like to try again with a different image?",
                                          style: TextStyle(
                                              fontSize: getWidthSHPR() * 0.035),
                                        ),
                                        actions: [
                                          TextButton(
                                            onPressed: () {
                                              Navigator.pop(context);
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (_) =>
                                                      MaterialsChooserView(),
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
                                                _capturedImage = File('');
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
                                ),
                              ),
                            ],
                          ),
                        ])
                      : Text(
                          "Classification Waiting",
                          style: TextStyle(fontSize: getWidthSHPR() * 0.05),
                        ),
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
