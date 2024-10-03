import 'dart:async';
import 'dart:convert';

import 'package:fyp_code/Project_Code/Utils/MB_Info.dart';
import 'package:fyp_code/main.dart';
import 'package:mapbox_gl/mapbox_gl.dart';

import '../Model/DB.dart';
import '../Model/sharedPref.dart';

class HomeController {
  final centersData = RecyclingCentersFetch();
  List<Map<String, dynamic>> _Rcenters = [];

  //retrieve recycling centre data from database
  Future<void> DBData() async {
    try {
      await centersData.retrieveData(); //retrieve data
      _Rcenters = centersData.Rcenters; //store retrieved data in _Rcenters
    } catch (error) {
      print('Error:$error');
    }
  }

  //retrieve potential addresses for list to display
  listSet(String value) async {
    List response = await getParsedResponseForQuery(
        value); //retrieve locations from user input
    return response;
  }

  useCurrentLocationButtonHandler() async {
    LatLng currentLocation =
        getLatLngSHPR(); //retrieves user latitude and longitude from shared preferences
    var response = await getParsedReverseGeocoding(
        currentLocation); //retrieve user address/place
    sharedPreferences.setString(
        'source',
        json.encode(
            response)); //set the returned address/place to shared preferences with key source
    String place =
        response['place']; //initializes place to return place from response map
    return place; //return user Location
  }

  setHome(String text) async {
    //retrieves location of textbox input and stores the coordinates in shared preferences
    List response = await getParsedResponseForQuery(text);
    sharedPreferences.setDouble('homeLat', response[0]['lat']);
    sharedPreferences.setDouble('homeLon', response[0]['lng']);
  }

  preloadDistances() async {
    await DBData(); //retrieve recycling centre data
    //set home loc to user location coordinates
    LatLng homeLoc = LatLng(sharedPreferences.getDouble('homeLat')!,
        sharedPreferences.getDouble('homeLon')!);
    // get user's set location distance from recycling centres
    for (int i = 0; i < _Rcenters.length; i++) {
      Map modifiedResponse = await APIDistance(homeLoc, i);
      saveDirectionsAPIResponse(i, json.encode(modifiedResponse));
    }
  }
}
