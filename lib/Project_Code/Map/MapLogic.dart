import 'dart:async';
import 'package:flutter/material.dart';
import 'package:fyp_code/Project_Code/Model/sharedPref.dart';
import 'package:fyp_code/main.dart';
import 'package:location/location.dart';
import 'package:mapbox_gl/mapbox_gl.dart';
import '../Model/DB.dart';

class MapController {
  final centersData = RecyclingCentersFetch();
  List<Map<String, dynamic>> get Rcenters => _Rcenters;
  List<Map<String, dynamic>> _Rcenters = [];
  LatLng homeLoc = LatLng(sharedPreferences.getDouble('homeLat')!,
      sharedPreferences.getDouble('homeLon')!);
  MapboxMapController? controller;
  late Timer locationUpdateTimer;
  final location = Location();
  String locationUpdateError = '';
  Symbol? _userSymbol;
  final List<Symbol> markers = [];

  void addMarkers(List<Map<String, dynamic>> centers,String material) async {
    await retrieveData(material);//getting filtered data from database
    for (var center in centers) {//for loop to place markers
      LatLng markerLatLng =
          LatLng(center['reccenterlat'], center['reccenterlon']);
      Symbol? marker = await controller?.addSymbol(SymbolOptions(
        geometry: markerLatLng,
        iconImage: 'assets/images/recycling-center-64.png',
        iconSize: 1.5,
      ));
      markers.add(marker!);//adding markers to a list
      Symbol? sMarker = await controller?.addSymbol(
        SymbolOptions(
          geometry: homeLoc,
          iconImage: 'assets/images/startIcon.png',
          iconSize: 3,
        ),
      );
      markers.add(sMarker!);//add markers to list
    }
  }

  Future<void> retrieveData(String material) async {
    try {
      final data = MaterialsRecyclingCentersFetch();

      final Rcenters = await data.fetchRC(material);//retrieve data from database
      _Rcenters = Rcenters;//add data to public variable
    } catch (error) {
      print('Error:$error');
    }
  }


//retrieve user location
  void getUserLocation() async {
    locationUpdateTimer =
        Timer.periodic(const Duration(seconds: 1), (timer) async {//timer that goes off every one second
      LocationData userLoc = await location.getLocation();

      LatLng userLatLng = LatLng(userLoc.latitude!, userLoc.longitude!);
      if (_userSymbol == null) {
        _userSymbol = await controller?.addSymbol(SymbolOptions(
          geometry: userLatLng,
          iconImage: 'assets/images/user-64.png',
          iconSize: 2,
        ));
      } else {
        controller?.updateSymbol(
            _userSymbol!, SymbolOptions(geometry: userLatLng));
      }
    });
  }
  //add polyline to map
  void addPolyline(int index, bool removeLayer) async {
    Map geometry = getGeometryFromSharedPrefs(index);//retrieves geometry from shared preferences
    final _fills = {//creates GEOJSON object
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
      await controller?.removeLayer("lines");
      await controller?.removeSource("fills");
    }
    //calculates mid point and sets map to mid point
    double midLat = (_Rcenters[index]['reccenterlat'] +
            sharedPreferences.getDouble('homeLat')) /
        2;
    double midLon = (_Rcenters[index]['reccenterlon'] +
            sharedPreferences.getDouble('homeLon')) /
        2;
    LatLng midPoint = LatLng(midLat, midLon);
    late CameraPosition midPOS = CameraPosition(target: midPoint, zoom: 11);
    controller?.animateCamera(CameraUpdate.newCameraPosition(midPOS));

    //Add new source and lineLayer
    await controller?.addSource("fills", GeojsonSourceProperties(data: _fills));
    await controller?.addLineLayer(
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
  //clears markers from map
  Future<void> clearMarkers() async {
    for (Symbol marker in markers) {
      await controller?.removeSymbol(marker);//removes symbols based on marker list data
    }
    markers.clear();
  }
  //loads markers at the start
  StyleLoad(String material) async {
    await retrieveData(material);//retrieves filtered recycling centre data
    for (var center in _Rcenters) {//loop to add markers
      Symbol? marker = await controller?.addSymbol(
        SymbolOptions(
          geometry: LatLng(center['reccenterlat'], center['reccenterlon']),
          iconImage: 'assets/images/recycling-center-64.png',
          iconSize: 1.5,
        ),
      );
      markers.add(marker!);//add markers list
      Symbol? sMarker = await controller?.addSymbol(//add marker to map
        SymbolOptions(
          geometry: homeLoc,
          iconImage: 'assets/images/startIcon.png',
          iconSize: 3,
        ),
      );
      markers.add(sMarker!);//add marker data to list
    }
  }
}
