import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:fyp_code/Project_Code/Map/MapUI.dart';
//passes material to next screen
class MaterialsChooserController {
  void navigtion(String selectedMaterial, BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (_) => MappView(selectedMaterial: selectedMaterial)),
    );
  }
}
