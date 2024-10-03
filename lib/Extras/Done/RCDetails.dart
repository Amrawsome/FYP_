import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fyp_code/Extras/Done/Map.dart';
import 'package:fyp_code/Project_Code/Model/sharedPref.dart';
import 'package:fyp_code/Project_Code/Utils/MB_Info.dart';
import 'package:fyp_code/main.dart';
import 'package:mapbox_gl/mapbox_gl.dart';

import 'package:url_launcher/url_launcher.dart';

class RCDetails extends StatelessWidget {
  final Map<String, dynamic> centerData;
  final int index;
  final String selectedValue;

  RCDetails(this.centerData, this.index, this.selectedValue);

  @override
  Widget build(BuildContext context) {
    LatLng homeLoc = LatLng(sharedPreferences.getDouble('homeLat')!,
        sharedPreferences.getDouble('homeLon')!);
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: getHeightSHPR() * 0.1,
        title: Text(
          "Recycling Centre Details",
          style: TextStyle(fontSize: getWidthSHPR() * 0.06),
        ),
        backgroundColor: const Color(0xFF00bf7d),
        leading: IconButton(
            iconSize: getWidthSHPR() * 0.1,
            onPressed: () => {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => Mapp(selectedMaterial: selectedValue),
                    ),
                  ),
                },
            icon: Icon(Icons.arrow_back, semanticLabel: "Map Page")),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(8, 0, 0, 0),
                child: Text(
                  centerData['reccentername'],
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: getWidthSHPR() * 0.05),
                ),
              ),
              Offstage(
                offstage: true,
                child: Text(centerData['reccenterid'].toString()),
              ),
              Text(
                'Monday: ' + centerData['reccentermon'],
                style: TextStyle(fontSize: getWidthSHPR() * 0.038),
              ),
              Text(
                'Tuesday: ' + centerData['reccentertues'],
                style: TextStyle(fontSize: getWidthSHPR() * 0.038),
              ),
              Text(
                'Wednesday: ' + centerData['reccenterwed'],
                style: TextStyle(fontSize: getWidthSHPR() * 0.038),
              ),
              Text(
                'Thursday: ' + centerData['reccenterthur'],
                style: TextStyle(fontSize: getWidthSHPR() * 0.038),
              ),
              Text(
                'Friday: ' + centerData['reccenterfri'],
                style: TextStyle(fontSize: getWidthSHPR() * 0.038),
              ),
              Text(
                'Saturday: ' + centerData['reccentersat'],
                style: TextStyle(fontSize: getWidthSHPR() * 0.038),
              ),
              Text(
                'Sunday: ' + centerData['reccentersun'],
                style: TextStyle(fontSize: getWidthSHPR() * 0.038),
              ),
              Text(
                'Bank Holidays: ' + centerData['reccenterbankholiday'],
                style: TextStyle(fontSize: getWidthSHPR() * 0.038),
              ),
              Text(
                'Some Materials May Be Charged ',
                style: TextStyle(
                    color: Colors.red,
                    fontWeight: FontWeight.bold,
                    fontSize: getWidthSHPR() * 0.043),
              ),
              Text(
                'Check The Website For More Information',
                style: TextStyle(fontSize: getWidthSHPR() * 0.038),
              ),
              InkWell(
                child: Text(
                  "Website Link",
                  style: TextStyle(
                      fontSize: getWidthSHPR() * 0.045, color: Colors.blue),
                ),
                onTap: () => launchUrl(Uri.parse(centerData['reccenterlink'])),
              ),
              SizedBox(height: 20),
              Center(
                  child: Text(
                "Directions:",
                style: TextStyle(
                    fontSize: getWidthSHPR() * 0.05,
                    fontWeight: FontWeight.bold),
              )),
              //holds buttons to draw polyline depending on transport type
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: getWidthSHPR() * 0.15,
                    height: getWidthSHPR() * 0.15,
                    decoration: BoxDecoration(
                        color: const Color(0xFF00bf7d),
                        border: Border.all(
                            color: Colors.black, // Color of the border
                            width: 2, // Thickness of the border
                            style: BorderStyle.solid),
                        borderRadius: BorderRadius.circular(10.0)),
                    margin: EdgeInsets.all(5.0),
                    child: IconButton(
                      icon: Icon(Icons.nordic_walking,
                          semanticLabel: "walking route",
                          size: getWidthSHPR() * 0.095),
                      onPressed: () async {

                      },
                    ),
                  ),
                  Container(
                      width: getWidthSHPR() * 0.15,
                      height: getWidthSHPR() * 0.15,
                      decoration: BoxDecoration(
                          color: const Color(0xFF00bf7d),
                          border: Border.all(
                              color: Colors.black, // Color of the border
                              width: 2, // Thickness of the border
                              style: BorderStyle.solid),
                          borderRadius: BorderRadius.circular(10.0)),
                      margin: EdgeInsets.all(5.0),
                      child: IconButton(
                          icon: Icon(Icons.pedal_bike,
                              semanticLabel: "cycling route",
                              size: getWidthSHPR() * 0.095),
                          onPressed: () async {
                            String transport = 'cycling';
                            Map apiResponse =
                                await APIResponse(homeLoc, index, transport);
                            //print(apiResponse);
                            saveDirectionsAPIResponse(
                                index, json.encode(apiResponse));
                            final polylineData = {
                              "index": index,
                              // Other polyline data if needed
                            };
                            Navigator.pop(context, polylineData);
                          })),
                  Container(
                    width: getWidthSHPR() * 0.15,
                    height: getWidthSHPR() * 0.15,
                    decoration: BoxDecoration(
                        color: const Color(0xFF00bf7d),
                        border: Border.all(
                            color: Colors.black,
                            width: 2,
                            style: BorderStyle.solid),
                        borderRadius: BorderRadius.circular(10.0)),
                    margin: EdgeInsets.all(5.0),
                    child: IconButton(
                      icon: Icon(Icons.drive_eta,
                          semanticLabel: "driving route",
                          size: getWidthSHPR() * 0.095),
                      onPressed: () async {
                        String transport = 'driving';
                        Map apiResponse =
                            await APIResponse(homeLoc, index, transport);
                        saveDirectionsAPIResponse(
                            index, json.encode(apiResponse));
                        final polylineData = {
                          "index": index,
                        };
                        Navigator.pop(context, polylineData);
                      },
                    ),
                  ),
                ],
              ),
              Text(
                'Distance: ${(getDistanceSHPR(centerData['reccenterid']) / 1000).toStringAsFixed(2)}km',
                style: TextStyle(
                    fontSize: getWidthSHPR() * 0.041,
                    fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 20),
              Text(
                "Recycling Center Address",
                style: TextStyle(
                    fontSize: getWidthSHPR() * 0.05,
                    fontWeight: FontWeight.bold),
              ),
              Text(
                centerData['reccenteraddress'],
                style: TextStyle(fontSize: getWidthSHPR() * 0.039),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
