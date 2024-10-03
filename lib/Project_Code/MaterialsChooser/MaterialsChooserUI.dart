import 'package:flutter/material.dart';
import 'package:fyp_code/Project_Code/Home/HomeUI.dart';
import 'package:fyp_code/Project_Code/ImageClassifier/ImageClassifierUI.dart';
import 'package:fyp_code/Project_Code/MaterialsChooser/MaterialsChooserLogic.dart';
import 'package:fyp_code/Project_Code/Model/sharedPref.dart';

class MaterialsChooserView extends StatefulWidget {
  const MaterialsChooserView({super.key});

  @override
  State<MaterialsChooserView> createState() => _MaterialsState();
}

class _MaterialsState extends State<MaterialsChooserView> {
  MaterialsChooserController controller = MaterialsChooserController();
  String selectedMaterial = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: getHeightSHPR() * 0.1,
        leading: IconButton(
            iconSize: getWidthSHPR() * 0.1,
            onPressed: () => {
                  //brings you back to home.dart page
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const HomeView(),
                    ),
                  ),
                },
            icon: const Icon(Icons.arrow_back, semanticLabel: "Start Page")),
        title: Text(
          "Material Chooser",
          style: TextStyle(
            fontSize: getWidthSHPR() * 0.1,
            fontWeight: FontWeight.bold,
          ),
        ),
        bottom: PreferredSize(
          preferredSize: Size.zero,
          child: Text(
            'Please Choose Material To Recycle',
            style: TextStyle(
              fontSize: getWidthSHPR() * 0.04,
            ),
          ),
        ),
        backgroundColor: const Color(0xFF00bf7d),
        centerTitle: true,
      ),
      body: ListView(
        children: [
          ListTile(
              title: Text(
                "Batteries",
                style: TextStyle(fontSize: getWidthSHPR() * 0.04),
              ),
              tileColor: Colors.white,
              shape: const Border(
                bottom: BorderSide(
                  color: Colors.black,
                  width: 2.0,
                ), // Adjust as needed
              ),
              onTap: () {
                //brings you to mapp class passing batteries to the class
                setState(() {
                  selectedMaterial = 'Batteries'; // Update the state variable
                });
                controller.navigtion(selectedMaterial, context);
              }),
          ListTile(
            title: Text(
              "Food",
              style: TextStyle(fontSize: getWidthSHPR() * 0.04),
            ),
            tileColor: Colors.white,
            shape: const Border(
              bottom: BorderSide(
                color: Colors.black,
                width: 2.0,
              ), // Adjust as needed
            ),
            onTap: () {
              setState(() {
                selectedMaterial = 'Food'; // Update the state variable
              });
              //brings you to mapp class passing Food to the class
              controller.navigtion(selectedMaterial, context);
            },
          ),
          ListTile(
            title: Text("Glass",
                style: TextStyle(fontSize: getWidthSHPR() * 0.04)),
            tileColor: Colors.white,
            shape: const Border(
              bottom: BorderSide(
                color: Colors.black,
                width: 2.0,
              ), // Adjust as needed
            ),
            onTap: () {
              setState(() {
                selectedMaterial = 'Glass'; // Update the state variable
              });
              //brings you to mapp class passing Glass to the class
              controller.navigtion(selectedMaterial, context);
            },
          ),
          ListTile(
            title: Text("Cardboard",
                style: TextStyle(fontSize: getWidthSHPR() * 0.04)),
            tileColor: Colors.white,
            shape: const Border(
              bottom: BorderSide(
                color: Colors.black,
                width: 2.0,
              ), // Adjust as needed
            ),
            onTap: () {
              //brings you to mapp class passing Cardboard to the class
              setState(() {
                selectedMaterial = 'Cardboard'; // Update the state variable
              });
              controller.navigtion(selectedMaterial, context);
            },
          ),
          ListTile(
            title: Text("Textiles",
                style: TextStyle(fontSize: getWidthSHPR() * 0.04)),
            tileColor: Colors.white,
            shape: const Border(
              bottom: BorderSide(
                color: Colors.black,
                width: 2.0,
              ), // Adjust as needed
            ),
            onTap: () {
              setState(() {
                selectedMaterial = 'Textiles'; // Update the state variable
              });
              //brings you to mapp class passing Clothes to the class
              controller.navigtion(selectedMaterial, context);
            },
          ),
          ListTile(
            title: Text("Metal",
                style: TextStyle(fontSize: getWidthSHPR() * 0.04)),
            tileColor: Colors.white,
            shape: const Border(
              bottom: BorderSide(
                color: Colors.black,
                width: 2.0,
              ), // Adjust as needed
            ),
            onTap: () {
              setState(() {
                selectedMaterial = 'Metal'; // Update the state variable
              });
              //brings you to mapp class passing Metal to the class
              controller.navigtion(selectedMaterial, context);
            },
          ),
          ListTile(
            title: Text("Paper",
                style: TextStyle(fontSize: getWidthSHPR() * 0.04)),
            tileColor: Colors.white,
            shape: const Border(
              bottom: BorderSide(
                color: Colors.black,
                width: 2.0,
              ), // Adjust as needed
            ),
            onTap: () {
              setState(() {
                selectedMaterial = 'Paper'; // Update the state variable
              });
              //brings you to mapp class passing Paper to the class
              controller.navigtion(selectedMaterial, context);
            },
          ),
          ListTile(
            title: Text("Plastic",
                style: TextStyle(fontSize: getWidthSHPR() * 0.04)),
            tileColor: Colors.white,
            shape: const Border(
              bottom: BorderSide(
                color: Colors.black,
                width: 2.0,
              ), // Adjust as needed
            ),
            onTap: () {
              setState(() {
                selectedMaterial = 'Plastic'; // Update the state variable
              });
              //brings you to mapp class passing Plastic to the class
              controller.navigtion(selectedMaterial, context);
            },
          ),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton: SizedBox(
        width: getWidthSHPR() * 0.15,
        height: getWidthSHPR() * 0.15,
        child: FloatingActionButton(
          heroTag: "routeToClassifier",
          backgroundColor: const Color(0xFF00bf7d),
          onPressed: () {
            //brings you to materialClassifier.dart
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const ImageClassifierView()),
            );
          },
          child: Icon(
            Icons.add_a_photo,
            size: getWidthSHPR() * 0.095,
            color: Colors.black,
            semanticLabel: "Material Classifer",
          ),
        ),
      ),
    );
  }
}
