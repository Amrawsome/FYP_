import 'package:flutter/material.dart';

import '../widgets/listView.dart';

class Hometest extends StatelessWidget {
  Hometest({super.key});

  List<String> products = ["Bed", "Sofa", "Chair"];
  List<String> productDetails = [
    "King size bed",
    "King size sofa",
    "Wooden chair"
  ];
  List<int> price = [3000, 2500, 1860];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Custom Widget"),
        centerTitle: true,
        backgroundColor: Colors.black38,
      ),
      backgroundColor: Colors.grey.shade800,
      body: ListView(
        children: [
          ListTile(


          ),
          ListTileWidget(
            title: "Mouse",
            subTitle: "A4Tech Mouse ",

          ),
          ListTileWidget(
            title: "Laptop",
            subTitle: "beatsAudio Laptop Core i7 ",
            leadingIcon: Icons.laptop,
            listTileColor: Colors.yellow,
            trailingIcon: Icons.shopping_cart,
            iconColor: Colors.blue,
          ),
        ],
      ),
    );
  }
}
