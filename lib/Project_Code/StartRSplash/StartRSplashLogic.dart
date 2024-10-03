import 'dart:io';

import 'package:app_settings/app_settings.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fyp_code/Project_Code/Utils/MB_Info.dart';
import 'package:location/location.dart';
import 'package:mapbox_gl/mapbox_gl.dart';
import '../../main.dart';
import '../Model/sharedPref.dart';

class StartRSplashController {
  //retrieves and stores user phone height and width
  void phoneData(BuildContext context) {
    sharedPreferences.setDouble("width", MediaQuery.of(context).size.width);
    sharedPreferences.setDouble('height', MediaQuery.of(context).size.height);
  }

  void Location_Data_prep() async {
    Location location = Location();
    LocationData userLoc = await location.getLocation();//retrieve current location
    LatLng userLatLng = LatLng(userLoc.latitude!, userLoc.longitude!);//user location
    String currentAddress =
        (await getParsedReverseGeocoding(userLatLng))['place'];//sets user location
    //add user coordinates to shared preferences
    sharedPreferences.setDouble('lat', userLoc.latitude!);
    sharedPreferences.setDouble('lon', userLoc.longitude!);
    //add address to shared preferences
    sharedPreferences.setString('current-address', currentAddress);
  }

  Future<bool> checkInternetConnection() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    return (connectivityResult != ConnectivityResult.none);
  }

  //no internet
  void showNoInternetDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          'No Internet Connection',
          style:
              TextStyle(color: Colors.black, fontSize: getWidthSHPR() * 0.04),
        ),
        content: Text(
          'Please connect to the internet and try again.',
          style:
              TextStyle(color: Colors.black, fontSize: getWidthSHPR() * 0.04),
        ),
        actions: [
          TextButton(
            onPressed: () => exit(0),
            child: Text(
              'OK',
              style: TextStyle(
                  color: Colors.black, fontSize: getWidthSHPR() * 0.04),
            ),
          ),
        ],
      ),
    );
  }

  //whats displayed when no location permission
  void noLocationPerm(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          'Location Permission Required',
          style: TextStyle(fontSize: getWidthSHPR() * 0.04),
        ),
        content: Text(
          'This app needs location access to function properly. Please enable',
          style: TextStyle(fontSize: getWidthSHPR() * 0.04),
        ),
        actions: [
          TextButton(
            onPressed: () => SystemNavigator.pop(),
            child: Text(
              'Cancel',
              style: TextStyle(
                  color: Colors.black, fontSize: getWidthSHPR() * 0.04),
            ),
          ),
          TextButton(
            onPressed: () {
              AppSettings.openAppSettings();
            },
            child: Text(
              'Go to Settings',
              style: TextStyle(
                  color: Colors.black, fontSize: getWidthSHPR() * 0.04),
            ),
          ),
        ],
      ),
    );
  }
}
