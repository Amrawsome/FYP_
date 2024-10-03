import 'dart:convert';
import 'package:fyp_code/main.dart';
import 'package:mapbox_gl/mapbox_gl.dart';

//returns latlng for current position
LatLng getLatLngSHPR() {
  return LatLng(
      sharedPreferences.getDouble('lat')!, sharedPreferences.getDouble('lon')!);
}

//returns phone width
double getWidthSHPR() {
  final double widthValue =
      sharedPreferences.getDouble('width') ?? 0.0; // Replace 'your_width_key'
  return widthValue;
}

//returns phone height
double getHeightSHPR() {
  final double heightValue =
      sharedPreferences.getDouble('height') ?? 0.0; // Replace 'your_width_key'
  return heightValue;
}

//returns distance,duration,geometry
Map getResponseSharedPrefs(int index) {
  //print("sharedPref.dart");
  String key = 'RecyclingCentre--$index';
  String? responseString = sharedPreferences.getString(key);

  if (responseString == null) {
    print('Response is null');
    return {}; // Response not found in Shared Preferences
  }
  Map response = json.decode(responseString);
  // print(response);
  return response;
}

//gets distance form shared pref
num getDistanceSHPR(int index) {
  num distance = getResponseSharedPrefs(index)['distance'];
  return distance;
}

//gets duration from shared pref
num getDurationFromSharedPrefs(int index) {
  num duration = getResponseSharedPrefs(index)['duration'];
  return duration;
}

//gets geometry fomr shared pref
Map getGeometryFromSharedPrefs(int index) {
  Map geometry = getResponseSharedPrefs(index)['geometry'];
  return geometry;
}

//retrieved current address set in splash screen
String getCurrentAddressFromSharedPrefs() {
  return sharedPreferences.getString('current-address')!;
}
