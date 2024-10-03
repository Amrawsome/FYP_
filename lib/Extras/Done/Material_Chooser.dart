
import 'package:flutter/material.dart';
import 'package:fyp_code/Extras/Done/Home.dart';
import 'package:fyp_code/Extras/Done/Map.dart';
import 'package:fyp_code/Extras/Done/materialClassifier.dart';
import 'package:fyp_code/Project_Code/Model/sharedPref.dart';


class Materials_Chooser extends StatefulWidget {
  const Materials_Chooser({super.key});

  @override
  State<Materials_Chooser> createState() => _MaterialsState();
}

class _MaterialsState extends State<Materials_Chooser> {
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
                      builder: (_) => Home(),
                    ),
                  ),
                },
            icon: Icon(Icons.arrow_back, semanticLabel: "Start Page")),
        title: Text(
          "Recycle Route",
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
      body: Container(
        child: ListView(
          children: [
            ListTile(
              title: Text(
                "Batteries",
                style: TextStyle(fontSize: getWidthSHPR() * 0.04),
              ),
              tileColor: Colors.white,
              shape: Border(
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
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (_) => Mapp(selectedMaterial: selectedMaterial)),
                );
              },
            ),
            ListTile(
              title: Text(
                "Food",
                style: TextStyle(fontSize: getWidthSHPR() * 0.04),
              ),
              tileColor: Colors.white,
              shape: Border(
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
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (_) => Mapp(selectedMaterial: selectedMaterial)),
                );
              },
            ),
            ListTile(
              title: Text("Glass",
                  style: TextStyle(fontSize: getWidthSHPR() * 0.04)),
              tileColor: Colors.white,
              shape: Border(
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
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (_) => Mapp(selectedMaterial: selectedMaterial)),
                );
              },
            ),
            ListTile(
              title: Text("Cardboard",
                  style: TextStyle(fontSize: getWidthSHPR() * 0.04)),
              tileColor: Colors.white,
              shape: Border(
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
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (_) => Mapp(selectedMaterial: selectedMaterial)),
                );
              },
            ),
            ListTile(
              title: Text("Textiles",
                  style: TextStyle(fontSize: getWidthSHPR() * 0.04)),
              tileColor: Colors.white,
              shape: Border(
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
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (_) => Mapp(selectedMaterial: selectedMaterial)),
                );
              },
            ),
            ListTile(
              title: Text("Metal",
                  style: TextStyle(fontSize: getWidthSHPR() * 0.04)),
              tileColor: Colors.white,
              shape: Border(
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
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (_) => Mapp(selectedMaterial: selectedMaterial)),
                );
              },
            ),
            ListTile(
              title: Text("Paper",
                  style: TextStyle(fontSize: getWidthSHPR() * 0.04)),
              tileColor: Colors.white,
              shape: Border(
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
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (_) => Mapp(selectedMaterial: selectedMaterial)),
                );
              },
            ),
            ListTile(
              title: Text("Plastic",
                  style: TextStyle(fontSize: getWidthSHPR() * 0.04)),
              tileColor: Colors.white,
              shape: Border(
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
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (_) => Mapp(selectedMaterial: selectedMaterial)),
                );
              },
            ),
          ],
        ),
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
              MaterialPageRoute(builder: (_) => IMGClassifier()),
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
