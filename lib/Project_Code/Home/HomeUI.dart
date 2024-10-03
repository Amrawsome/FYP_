import 'dart:async';
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fyp_code/Project_Code/Home/HomeLogic.dart';
import 'package:fyp_code/Project_Code/MaterialsChooser/MaterialsChooserUI.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../main.dart';
import '../Model/sharedPref.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  HomeController controller = HomeController();
  TextEditingController startingController = TextEditingController();
  bool isLoading = false;
  bool isEmptyResponse = true;
  bool hasResponded = false;
  List responses = [];
  String noRequest = 'Please enter an address, a place or a location to search';
  String noResponse = 'No results found for the search';
  Timer? searchOnStoppedTyping;
  bool _isButtonDisabled = false;
  String text = '';
  String query = '';


  void responsesState(List responses) {
    setState(() {
      this.responses = responses;//add addresses to responses list
      hasResponded = true;//change bool value to true
      isEmptyResponse = responses.isEmpty;
    });
    Future.delayed(
      const Duration(milliseconds: 500),
      () => setState(() {
        isLoading = false;//stops loading
      }),
    );
  }

  void LoadingState(bool isLoading) {
    setState(() {
      this.isLoading = isLoading;//changes loading values
    });
  }

  onChangeHandler(value) {
    LoadingState(true);
    // Set isLoading = true in parent
    // Make sure that requests are not made
    // until 1 second after the typing stops
    if (searchOnStoppedTyping != null) {
      setState(() => searchOnStoppedTyping?.cancel());
    }
    setState(() =>
        searchOnStoppedTyping = Timer(const Duration(seconds: 1), () async {
          List home = await controller.listSet(value);//retrieve address values
          responsesState(home);//chnage app state to activate list
          setState(() => query = value);
        }));
  }

  @override
  Widget build(BuildContext context) {
    String placeholderText =
        'Please Enter Starting Location'; //setting text for box
    IconData? iconData = Icons.my_location; //setting icon
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: getHeightSHPR() * 0.1,
        automaticallyImplyLeading: false,
        leading: null,
        title: Text(
          "Recycle Route",
          style: TextStyle(
            fontSize: getWidthSHPR() * 0.1,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: const Color(0xFF00bf7d),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              margin: EdgeInsets.fromLTRB(0, 50, 0, 0),
              height: getHeightSHPR() * 0.25,
              width: getWidthSHPR() * 0.25,
              child: const FittedBox(
                fit: BoxFit.cover,
                child: Image(
                  image: AssetImage('assets/images/Logo.png'),
                ),
              ),
            ),
            SizedBox(height: getHeightSHPR() * 0.1),
            Container(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.black, width: 3),
              ),
              child: Padding(
                padding:
                    const EdgeInsets.only(top: 0, bottom: 0, left: 0, right: 0),
                child: CupertinoTextField(
                  style: TextStyle(
                      fontSize: getHeightSHPR() * 0.021,
                      fontWeight: FontWeight.bold,
                      color: Colors.black),
                  controller: startingController,
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  placeholder: placeholderText,
                  placeholderStyle: GoogleFonts.rubik(color: Colors.black),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.zero,
                  ),
                  //padding: EdgeInsets.all(20.0),
                  onChanged: onChangeHandler,
                  suffix: IconButton(
                    onPressed: () async {
                      startingController.text =//set textbox to user address
                          await controller.useCurrentLocationButtonHandler();
                    },
                    padding: const EdgeInsets.all(10),
                    constraints: const BoxConstraints(),
                    icon: Icon(
                      iconData,
                      size: 20,
                      color: Colors.black,
                      semanticLabel: "Current Location",
                    ),
                  ),
                ),
              ),
            ),
            isLoading
                ? const LinearProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white))
                : Container(),
            isEmptyResponse
                ? Padding(
                    padding: const EdgeInsets.only(top: 20),
                    child: Center(
                        child: Text(hasResponded ? noResponse : noRequest)))
                : ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: responses.length,
                    itemBuilder: (BuildContext context, int index) {
                      return Column(
                        children: [
                          ListTile(
                            onTap: () {
                              String text = responses[index]['place'];
                              startingController.text = text;//set address in text box
                              sharedPreferences.setString(
                                  'source', json.encode(responses[index]));
                            },
                            leading: const SizedBox(
                              height: double.infinity,
                              child: CircleAvatar(
                                child: Icon(Icons.map),
                                backgroundColor: Color(0xFF00bf7d),
                              ),
                            ),
                            title: Text(responses[index]['name'],
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold)),
                            subtitle: Text(responses[index]['address'],
                                overflow: TextOverflow.ellipsis),
                          ),
                          const Divider(),
                        ],
                      );
                    },
                  ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: SizedBox(
                width: 150,
                height: 60,
                child: TextButton(
                  onPressed: _isButtonDisabled
                      ? null
                      : () async {
                          text = startingController.text;
                          await controller.setHome(text);//sets location to starting point
                          setState(() {
                            _isButtonDisabled = true; // Disable button
                          });
                          await controller.preloadDistances();//gets distances from starting location
                          setState(() {
                            _isButtonDisabled = false; // Disable button
                          });
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => MaterialsChooserView(),
                            ),
                          );
                        },
                  style: TextButton.styleFrom(
                    foregroundColor: Colors.white,
                    backgroundColor: Colors.black,
                  ),
                  child: Text(
                    'Next',
                    style: TextStyle(fontSize: getWidthSHPR() * 0.04),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
