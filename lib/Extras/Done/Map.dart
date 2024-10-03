import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:fyp_code/Extras/Done/Material_Chooser.dart';
import 'package:fyp_code/Project_Code/Model/DB.dart';
import 'package:fyp_code/Project_Code/Model/sharedPref.dart';
import 'package:fyp_code/Project_Code/RC_Details/RC_DetailsUI.dart';
import 'package:fyp_code/Project_Code/Utils/MB_Info.dart';
import 'package:fyp_code/main.dart';
import 'package:location/location.dart';
import 'package:mapbox_gl/mapbox_gl.dart';

import 'RCDetails.dart';

class Mapp extends StatefulWidget {
  final String selectedMaterial;

  Mapp({Key? key, required this.selectedMaterial}) : super(key: key);

  @override
  State<Mapp> createState() => _MappState();
}

class _MappState extends State<Mapp> {
  String? currentPolylineId;
  final centersData = RecyclingCentersFetch();
  List<Map<String, dynamic>> get Rcenters => _Rcenters;
  List<Map<String, dynamic>> _Rcenters = [];
  LatLng latlng = getLatLngSHPR();
  LatLng homeLoc = LatLng(sharedPreferences.getDouble('homeLat')!,
      sharedPreferences.getDouble('homeLon')!);
  late CameraPosition startPOS;
  late CameraPosition currentPOS;
  late MapboxMapController controller;
  late Timer locationUpdateTimer;
  final location = Location();
  String locationUpdateError = '';
  bool _isLoading = true;
  int _numUserMarkers = 0;
  Symbol? _userSymbol;
  String? lineId;
  String selectedValue = 'Batteries';
  List<Symbol> _markers = [];

  mapStart(MapboxMapController controller) async {
    this.controller = controller;
  }

  @override
  void initState() {
    super.initState();
    startPOS = CameraPosition(target: homeLoc, zoom: 15);
    currentPOS = CameraPosition(target: getLatLngSHPR(), zoom: 15);
    selectedValue = widget.selectedMaterial;
    initializeData();
  }

  Future<void> initializeData() async {
    getUserLocation();
    await Future.delayed(const Duration(seconds: 2));
    await retrieveData(selectedValue);
    locatio;
    setState(() {
      _isLoading = false;
    });
  }

  Future<void> initializeDropDownData(String material) async {
    getUserLocation();
    await retrieveData(selectedValue);
    await _clearMarkers();
    _addMarkers(_Rcenters);
    locatio;
  }

  Future<void> setGeometry(String transport) async {
    for (int i = 0; i < _Rcenters.length; i++) {
      Map apiResponse = await APIResponse(homeLoc, i, transport);

      saveDirectionsAPIResponse(i, json.encode(apiResponse));
    }
  }

  Future<void> retrieveData(String material) async {
    try {
      final data = MaterialsRecyclingCentersFetch();

      final Rcenters = await data.fetchRC(material);

      _Rcenters = Rcenters;
    } catch (error) {
      print('Error:$error');
    }
  }

  void locatio() {
    for (int i = 0; i > 5; i++) {
      Timer.periodic(const Duration(seconds: 5), (timer) async {
        getWidthSHPR();
      });
    }
  }

  void getUserLocation() async {
    locationUpdateTimer =
        Timer.periodic(const Duration(seconds: 2), (timer) async {
      LocationData userLoc = await location.getLocation();

      LatLng userLatLng = LatLng(userLoc.latitude!, userLoc.longitude!);
      if (_userSymbol == null) {
        _userSymbol = await controller.addSymbol(SymbolOptions(
          geometry: userLatLng,
          iconImage: 'assets/images/user-64.png',
          iconSize: 2,
        ));
      } else {
        controller.updateSymbol(
            _userSymbol!, SymbolOptions(geometry: userLatLng));
      }
      setState(() {
        _updateMarkerCount();
        locationUpdateError = ''; // Reset error
      });
    });
  }

  void _updateMarkerCount() {
    List<Symbol> userSymbols = controller.symbols
        .where(
            (symbol) => symbol.options.iconImage == 'assets/images/user-64.png')
        .toList();
    _numUserMarkers = userSymbols.length;
  }

  Future<void> _clearMarkers() async {
    for (Symbol marker in _markers) {
      await controller.removeSymbol(marker);
    }
    _markers.clear();
  }

  void _addMarkers(List<Map<String, dynamic>> centers) async {
    for (var center in centers) {
      LatLng markerLatLng =
          LatLng(center['reccenterlat'], center['reccenterlon']);

      Symbol marker = await controller.addSymbol(SymbolOptions(
        geometry: markerLatLng,
        iconImage: 'assets/images/recycling-center-64.png',
        iconSize: 1.5,
      ));
      _markers.add(marker);
      Symbol sMarker = await controller.addSymbol(
        SymbolOptions(
          geometry: homeLoc,
          iconImage: 'assets/images/startIcon.png',
          iconSize: 3,
        ),
      );
      _markers.add(sMarker);
    }
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

  void addPolyline(int index, bool removeLayer) async {
    Map geometry = getGeometryFromSharedPrefs(_Rcenters[index]['reccenterid']);
    List<dynamic> rawCoordinates = geometry['coordinates'];
    final _fills = {
      "type": "FeatureCollection",
      "features": [
        {
          "type": "Feature",
          "id": 0,
          "properties": <String, dynamic>{},
          "geometry": geometry,
        },
      ],
    };

    // Remove lineLayer and source if it exists
    if (removeLayer == true) {
      await controller.removeLayer("lines");
      await controller.removeSource("fills");
    }

    double midLat = (_Rcenters[index]['reccenterlat'] +
            sharedPreferences.getDouble('homeLat')) /
        2;
    double midLon = (_Rcenters[index]['reccenterlon'] +
            sharedPreferences.getDouble('homeLon')) /
        2;
    LatLng midPoint = LatLng(midLat, midLon);
    late CameraPosition midPOS = CameraPosition(target: midPoint, zoom: 11);
    controller.animateCamera(CameraUpdate.newCameraPosition(midPOS));

    //Add new source and lineLayer
    await controller.addSource("fills", GeojsonSourceProperties(data: _fills));
    await controller.addLineLayer(
      "fills",
      "lines",
      LineLayerProperties(
        lineColor: Colors.blue.toHexStringRGB(),
        lineCap: "round",
        lineJoin: "round",
        lineWidth: 5,
      ),
    );
  }

  styleLoad() async {
    for (var center in _Rcenters) {
      Symbol marker = await controller.addSymbol(
        SymbolOptions(
          geometry: LatLng(center['reccenterlat'], center['reccenterlon']),
          iconImage: 'assets/images/recycling-center-64.png',
          iconSize: 1.5,
        ),
      );
      _markers.add(marker);
      Symbol sMarker = await controller.addSymbol(
        SymbolOptions(
          geometry: homeLoc,
          iconImage: 'assets/images/startIcon.png',
          iconSize: 3,
        ),
      );
      _markers.add(sMarker);
    }
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
                      builder: (_) => Materials_Chooser(),
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
                  accessToken: dotenv.env['MAPBOX_Pub_Token'],
                  initialCameraPosition: startPOS,
                  onMapCreated: mapStart,
                  onStyleLoadedCallback: styleLoad,
                  myLocationTrackingMode: MyLocationTrackingMode.TrackingGPS,
                  minMaxZoomPreference: const MinMaxZoomPreference(10, 30),
                ),
                Positioned(
                  top: getHeightSHPR() * 0.02,
                  right: getWidthSHPR() * 0.3,
                  child: Container(
                    width: getWidthSHPR() * 0.4,
                    decoration: BoxDecoration(
                      color: Color(0xFF00bf7d),
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
                                selectedValue = newValue!;
                                initializeDropDownData(selectedValue);
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
            controller.animateCamera(
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
          itemCount: _Rcenters.length,
          itemBuilder: (context, index) {
            return ListTile(
              hoverColor: const Color(0xFF00bf7d),
              shape: Border(
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
                    builder: (context) => RC_DetailsView(centerData:_Rcenters[index],index:index,selectedValue:selectedValue, homeloc: homeLoc,),
                  ),
                );
                if (result != null) {
                  int index = result['index'];
                  // Potentially additional polyline data from RCDetails
                  addPolyline(index, true); // Call addPolyline
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
