import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:fyp_code/Project_Code/Map/MapLogic.dart';
import 'package:fyp_code/Project_Code/MaterialsChooser/MaterialsChooserUI.dart';
import 'package:fyp_code/Project_Code/Model/sharedPref.dart';
import 'package:fyp_code/Project_Code/RC_Details/RC_DetailsUI.dart';
import 'package:fyp_code/Project_Code/Utils/MB_Info.dart';
import 'package:fyp_code/main.dart';
import 'package:location/location.dart';
import 'package:mapbox_gl/mapbox_gl.dart';
import '../Model/DB.dart';

class MappView extends StatefulWidget {
  final String selectedMaterial;

  MappView({Key? key, required this.selectedMaterial}) : super(key: key);

  @override
  State<MappView> createState() => _MapState();
}

class _MapState extends State<MappView> {
  MapboxMapController? controller;
  MapController control = MapController();

  List<Map<String, dynamic>> get Rcenters => _Rcenters;
  List<Map<String, dynamic>> _Rcenters = [];
  LatLng homeLoc = LatLng(sharedPreferences.getDouble('homeLat')!,
      sharedPreferences.getDouble('homeLon')!);
  late CameraPosition startPOS;
  late CameraPosition currentPOS;
  late Timer locationUpdateTimer;
  String locationUpdateError = '';
  bool _isLoading = true;
  String selectedValue = 'Batteries';

  mapStart(MapboxMapController controller) async {
    this.controller = controller;
    control.controller = controller;//sets controller class map controller
  }

  @override
  void initState() {
    super.initState();
    //sets camera positions
    startPOS = CameraPosition(target: homeLoc, zoom: 15);
    currentPOS = CameraPosition(target: getLatLngSHPR(), zoom: 15);
    //retrieve material that was passed
    selectedValue = widget.selectedMaterial;
    initializeData();
  }
  //call methods on start
  Future<void> initializeData() async {
    getUserLocation();//retrieves and displays user location
    await Future.delayed(const Duration(seconds: 2));
    await retrieveData(selectedValue);//gets recycling center data
    setState(() {
      _isLoading = false;//stops loading state
    });
  }
  //initializes data when material is changes in drop down
  Future<void> initializeDropDownData(String material) async {
    getUserLocation();
    await retrieveData(selectedValue);
    await control.clearMarkers();
    //add centre markers to map
    control.addMarkers(_Rcenters, selectedValue);
  }
  //retrieve filtered centre data
  Future<void> retrieveData(String material) async {
    try {
      final data = MaterialsRecyclingCentersFetch();
      final Rcenters = await data.fetchRC(material);
      setState(() {
        _Rcenters = Rcenters;
      });
    } catch (error) {
      print('Error:$error');
    }
  }
  //retrieves user location
  void getUserLocation() async {
    control.getUserLocation();
    setState(() {
      locationUpdateError = ''; // Reset error
    });
  }

  void didPush() {
    // User has navigated to this screen, restart location updates
    getUserLocation();
  }

  void didPopNext() {
    // User has navigated away, pause location updates
    locationUpdateTimer.cancel();
  }

  @override
  void dispose() {
    // Check if the timer is active
    locationUpdateTimer.cancel();
    super.dispose();
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: getHeightSHPR() * 0.1,
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
        title: Text(
          'Recycling Map',
          style: TextStyle(
            fontSize: getWidthSHPR() * 0.08,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: const Color(0xFF00bf7d),
      ),
      body: _isLoading
          ? Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CircularProgressIndicator(),
                  SizedBox(height: 20),
                  Text(
                    'Loading Recycling Center Data...',
                    style: TextStyle(fontSize: getWidthSHPR() * 0.05),
                  ),
                ],
              ),
            )
          : Stack(
              children: [
                MapboxMap(
                  accessToken: dotenv.env['MAPBOX_Pub_Token'],//mapbox token
                  initialCameraPosition: startPOS,//setting starting position
                  onMapCreated: mapStart,
                  onStyleLoadedCallback: () async {
                    await control.StyleLoad(selectedValue);//sets markers on start
                  },
                  myLocationTrackingMode: MyLocationTrackingMode.TrackingGPS,//tracking method
                  minMaxZoomPreference: const MinMaxZoomPreference(10, 30),//max and min zoom
                ),
                Positioned(
                  top: getHeightSHPR() * 0.02,
                  right: getWidthSHPR() * 0.3,
                  child: Container(
                    width: getWidthSHPR() * 0.4,
                    decoration: BoxDecoration(
                      color: const Color(0xFF00bf7d),
                      border: Border.all(
                        color: Colors.black,
                        width: 2.0,
                      ),
                    ),
                    child: DropdownButtonHideUnderline(
                      child: Center(
                        child: DropdownButton<String>(
                          value: selectedValue,
                          dropdownColor: Color(0xFF00bf7d),
                          items: [
                            'Batteries',
                            'Food',
                            'Glass',
                            'Cardboard',
                            'Textiles',
                            'Metal',
                            'Paper',
                            'Plastic',
                          ].map<DropdownMenuItem<String>>(
                            (String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(
                                  value,
                                  style: TextStyle(
                                      fontSize: getWidthSHPR() * 0.038),
                                ),
                              );
                            },
                          ).toList(),
                          onChanged: (newValue) {
                            setState(
                              () {
                                selectedValue = newValue!;//change dropdown to current value
                                initializeDropDownData(selectedValue);//change app state for new value
                              },
                            );
                          },
                        ),
                      ),
                    ),
                  ),
                )
              ],
            ),
      floatingActionButton: SizedBox(
        width: getWidthSHPR() * 0.15,
        height: getWidthSHPR() * 0.15,
        child: FloatingActionButton(
          backgroundColor: const Color(0xFF00bf7d),
          onPressed: () {
            control.controller?.animateCamera(
              CameraUpdate.newCameraPosition(currentPOS),
            );
          },
          child: Icon(Icons.my_location,
              size: getWidthSHPR() * 0.095,
              color: Colors.black,
              semanticLabel: "Current Location"),
        ),
      ),
      endDrawer: Drawer(
        child: ListView.builder(
          itemCount: _Rcenters.length,//list size
          itemBuilder: (context, index) {
            return ListTile(
              hoverColor: const Color(0xFF00bf7d),
              shape: const Border(
                bottom: BorderSide(
                  color: Colors.black,
                  width: 2.0,
                ), // Adjust as needed
              ),
              leading: Icon(Icons.recycling),
              title: Text(
                _Rcenters[index]['reccentername'],
                style: TextStyle(fontSize: getWidthSHPR() * 0.05),
              ),
              subtitle: Text(
                '${(getDistanceSHPR(_Rcenters[index]['reccenterid']) / 1000).toStringAsFixed(2)}km',
                style: TextStyle(fontSize: getWidthSHPR() * 0.04),
              ),
              onTap: () async {
                print(index);
                dynamic result = await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => RC_DetailsView(
                      centerData: _Rcenters[index],
                      index: Rcenters[index]['reccenterid'],
                      selectedValue: selectedValue,
                      homeloc: homeLoc,
                    ),
                  ),
                );
                if (result != null) {
                  int index = result['index'];
                  // Potentially additional polyline data from RCDetails
                  control.addPolyline(index, true); // Call addPolyline
                }
                // Close the drawer (if it's open)
                if (Scaffold.of(context).isDrawerOpen) {
                  Navigator.pop(context); // Close the drawer
                }
              },
            );
          },
        ),
      ),
    );
  }
}
