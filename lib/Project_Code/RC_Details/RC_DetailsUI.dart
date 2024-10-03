
import 'package:flutter/material.dart';
import 'package:fyp_code/Project_Code/Map/MapUI.dart';
import 'package:fyp_code/Project_Code/Model/sharedPref.dart';
import 'package:fyp_code/Project_Code/RC_Details/RC_DetailsLogic.dart';
import 'package:mapbox_gl/mapbox_gl.dart';

import '../../main.dart';

import 'package:url_launcher/url_launcher.dart';

class RC_DetailsView extends StatefulWidget {
  const RC_DetailsView(
      {super.key,
        //needed for the class
      required this.centerData,
      required this.index,
      required this.selectedValue, required this.homeloc});

  final Map<String, dynamic> centerData;
  final int index;
  final String selectedValue;
  final LatLng homeloc;

  @override
  State<RC_DetailsView> createState() => _RC_DetailsViewState();
}

class _RC_DetailsViewState extends State<RC_DetailsView> {
  RC_DetailsController controller = RC_DetailsController();
  late Map<String, dynamic> centerData;
  late int index;
  late String selectedValue;
  late LatLng homeloc;
  @override
  void initState() {
    super.initState();
    centerData = widget.centerData;
    index = widget.index;
    selectedValue = widget.selectedValue;
    homeloc = widget.homeloc;
  }

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
                      builder: (_) => MappView(selectedMaterial: selectedValue),
                    ),
                  ),
                },
            icon: const Icon(Icons.arrow_back, semanticLabel: "Map Page")),
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
              const SizedBox(height: 20),
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
                    margin: const EdgeInsets.all(5.0),
                    child: IconButton(
                      icon: Icon(Icons.nordic_walking,
                          semanticLabel: "walking route",
                          size: getWidthSHPR() * 0.095),
                      onPressed: () async {
                        await controller.walkingPolyline(homeLoc, index);
                        final polylineData = {
                          "index": index,
                          // Other polyline data if needed
                        };
                        Navigator.pop(context, polylineData);
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
                      margin: const EdgeInsets.all(5.0),
                      child: IconButton(
                          icon: Icon(Icons.pedal_bike,
                              semanticLabel: "cycling route",
                              size: getWidthSHPR() * 0.095),
                          onPressed: () async {
                            await controller.cyclingPolyline(homeLoc, index);
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
                    margin: const EdgeInsets.all(5.0),
                    child: IconButton(
                      icon: Icon(Icons.drive_eta,
                          semanticLabel: "driving route",
                          size: getWidthSHPR() * 0.095),
                      onPressed: () async {
                       await controller.drivingPolyline(homeLoc, index);
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
              const SizedBox(height: 20),
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
