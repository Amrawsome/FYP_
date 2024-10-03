import 'dart:convert';

import 'package:fyp_code/Project_Code/Utils/MB_Info.dart';
import 'package:mapbox_gl/mapbox_gl.dart';



class RC_DetailsController {
  //retrieve polyline data for walking route
  Future<void> walkingPolyline(LatLng homeLoc, int index) async {
    String transport = 'walking';
    Map apiResponse = await APIResponse(homeLoc, index, transport);
    saveDirectionsAPIResponse(index, json.encode(apiResponse));
  }
  //retrieve polyline data for cycling route
  Future<void> cyclingPolyline(LatLng homeLoc, int index) async {
    String transport = 'walking';
    Map apiResponse = await APIResponse(homeLoc, index, transport);
    saveDirectionsAPIResponse(index, json.encode(apiResponse));
  }
  //retrieve polyline data for driving route
  Future<void> drivingPolyline(LatLng homeLoc, int index) async {
    String transport = 'walking';
    Map apiResponse = await APIResponse(homeLoc, index, transport);
    saveDirectionsAPIResponse(index, json.encode(apiResponse));
  }


}
