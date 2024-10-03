import 'dart:async';
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fyp_code/Extras/Done/Material_Chooser.dart';
import 'package:fyp_code/Project_Code/Model/DB.dart';
import 'package:fyp_code/Project_Code/Model/sharedPref.dart';

import 'package:fyp_code/Project_Code/Utils/MB_Info.dart';
import 'package:fyp_code/main.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mapbox_gl/mapbox_gl.dart';



class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();

  static _HomeState? of(BuildContext context) =>
      context.findAncestorStateOfType<_HomeState>();
}

class _HomeState extends State<Home> {
  TextEditingController startingController = TextEditingController();
  final centersData = RecyclingCentersFetch();
  List<Map<String, dynamic>> _Rcenters = [];
  bool isLoading = false;
  bool isEmptyResponse = true;
  bool hasResponded = false;
  bool isResponseForDestination = false;
  String noRequest = 'Please enter an address, a place or a location to search';
  String noResponse = 'No results found for the search';
  List responses = [];
  var text = '';
  Timer? searchOnStoppedTyping;
  String query = '';
  bool _isButtonDisabled = false;

  @override
  void initState() {
    super.initState();
    DBData(); //run on start
  }

  void responsesState(List responses) {
    setState(() {
      this.responses = responses;
      hasResponded = true;
      isEmptyResponse = responses.isEmpty;
    });
    Future.delayed(
      const Duration(milliseconds: 500),
      () => setState(() {
        isLoading = false;
      }),
    );
  }

  //method retrieve recycling centre data
  Future<void> DBData() async {
    try {
      await centersData.retrieveData();
      setState(() {
        _Rcenters = centersData.Rcenters;
      });
    } catch (error) {
      print('Error:$error');
    }
  }

  //setting loading state
  void isLoadingState(bool isLoading) {
    setState(() {
      this.isLoading = isLoading;
    });
  }

  onChangeHandler(value) {
    isLoadingState(true);
    // Set isLoading = true in parent
    // Make sure that requests are not made
    // until 1 second after the typing stops
    if (searchOnStoppedTyping != null) {
      setState(() => searchOnStoppedTyping?.cancel());
    }
    setState(() => searchOnStoppedTyping =
        Timer(const Duration(seconds: 1), () => _searchHandler(value)));
  }

  _searchHandler(String value) async {
    print("started");
    List response = await getParsedResponseForQuery(value);
    // Set responses and isDestination in parent
    print(response);
    responsesState(response); // Use the _homeState
    setState(() => query = value);
  }

  useCurrentLocationButtonHandler() async {
    LatLng currentLocation = getLatLngSHPR();
    //print(currentLocation);
    // Get the response of reverse geocoding and do 2 things:
    // 1. Store encoded response in shared preferences
    // 2. Set the text editing controller to the address
    var response = await getParsedReverseGeocoding(currentLocation);
    sharedPreferences.setString('source', json.encode(response));
    String place = response['place'];
    startingController.text = place;
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
            Padding(
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
                  // color: Color(0xFF00bf7d),
                  color: Colors.white,
                  borderRadius: BorderRadius.zero,
                ),
                //padding: EdgeInsets.all(20.0),
                onChanged: onChangeHandler,
                suffix: IconButton(
                  onPressed: () => useCurrentLocationButtonHandler(),
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
            isLoading
                ? const LinearProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white))
                : Container(),
            isEmptyResponse
                ? Padding(
                    padding: const EdgeInsets.only(top: 20),
                    child: Center(
                        child: Text(hasResponded ? noResponse : noRequest)))
              :ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: responses.length,
              itemBuilder: (BuildContext context, int index) {
                return Column(
                  children: [
                    ListTile(
                      onTap: () {
                        String text = responses[index]['place'];
                        startingController.text = text;
                        print(text);
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
                          style: const TextStyle(fontWeight: FontWeight.bold)),
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
                          setState(() {
                            text = startingController.text;
                            //print(text);
                          });
                          List response = await getParsedResponseForQuery(text);
                          sharedPreferences.setDouble(
                              'homeLat', response[0]['lat']);
                          sharedPreferences.setDouble(
                              'homeLon', response[0]['lng']);
                          LatLng homeLoc = LatLng(
                              sharedPreferences.getDouble('homeLat')!,
                              sharedPreferences.getDouble('homeLon')!);
                          setState(() {
                            _isButtonDisabled = true; // Disable button
                          });
                          //print('homeLat');
                          //print(sharedPreferences.getDouble('homeLat'));
                          for (int i = 0; i < _Rcenters.length; i++) {
                            Map modifiedResponse =
                                await APIResponse(homeLoc, i, 'cycling');
                            saveDirectionsAPIResponse(
                                i, json.encode(modifiedResponse));
                          }
                          setState(() {
                            _isButtonDisabled = false; // Disable button
                          });

                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => Materials_Chooser(),
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
