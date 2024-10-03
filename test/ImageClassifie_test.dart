import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:fyp_code/Project_Code/ImageClassifier/ImageClassifierLogic.dart';
import 'package:tflite_v2/tflite_v2.dart';


loadModel() async {
  await Tflite.loadModel(
    model: "assets/Model/model_unquant.tflite",
    labels: "assets/Model/labels.txt",
  );
}

void main() {
  group('classifyImage', () {
    ImageClassifierController controller =ImageClassifierController();
    TestWidgetsFlutterBinding.ensureInitialized();
    loadModel();
    test('should call controller.classifyImage and update state', () async {
      final mockImage = File('/data/data/com.example.fyp_code/cache/2fd73cc5-5d55-4cf9-9b4c-cc69b1b545d6/1000000040.jpg');

        // Mock Output
      var matcher =  [{'confidence': 0.9998337030410767, 'index': 0, 'label': '0 Cardboard'}];
      final output=  await controller.classifyImage(mockImage);
      // Assert
      expect(output, matcher);
    });
  });
}