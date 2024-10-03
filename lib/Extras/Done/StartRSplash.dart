import 'package:app_settings/app_settings.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fyp_code/Project_Code/Home/HomeLogic.dart';
import 'package:fyp_code/Project_Code/Model/DB.dart';
import 'package:fyp_code/Project_Code/Model/sharedPref.dart';
import 'package:fyp_code/Project_Code/Utils/MB_Info.dart';
import 'package:fyp_code/main.dart';
import 'package:location/location.dart';
import 'package:mapbox_gl/mapbox_gl.dart';
import 'package:fyp_code/Project_Code/Home/HomeUI.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

class SRS extends StatefulWidget {
  const SRS({super.key});

  @override
  State<SRS> createState() => _SRSState();
}

class _SRSState extends State<SRS> {
  final centersData = RecyclingCentersFetch();
  List<Map<String, dynamic>> _Rcenters = [];

  @override
  void initState() {
    super.initState();
    checkAndRequestLocation();
  }

  //retrieves phone size and sets it to sharedPreferences
  void phoneData() {
    sharedPreferences.setDouble("width", MediaQuery.of(context).size.width);
    sharedPreferences.setDouble('height', MediaQuery.of(context).size.height);
  }

  //checks if user is connected to internet
  Future<bool> checkInternetConnection() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    return (connectivityResult != ConnectivityResult.none);
  }

  //what will be shown if the user isn't conncted to the internet
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
            onPressed: () => SystemNavigator.pop(),
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

  //checks if user has given location permissions
  Future<void> checkAndRequestLocation() async {
    var status = await Permission.location.status;

    if (status.isGranted) {
      //if the permissions is given
      Location_Data();
    } else if (status.isDenied) {
      //if the status is denied try again
      if (await Permission.location.request().isGranted) {
        Location_Data();
      } else {
        // Permission still denied guide the user to settings
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
  }

  //retrieves location data for the user and puts it in shared preferences
  void Location_Data() async {
    Location location = Location();

    if (await checkInternetConnection()) {
      LocationData userLoc = await location.getLocation();
      LatLng userLatLng = LatLng(userLoc.latitude!, userLoc.longitude!);
      String currentAddress =
          (await getParsedReverseGeocoding(userLatLng))['place'];

      sharedPreferences.setDouble('lat', userLoc.latitude!);
      sharedPreferences.setDouble('lon', userLoc.longitude!);
      sharedPreferences.setString('current-address', currentAddress);
      //HomeController homeController = HomeController();
      Navigator.pushAndRemoveUntil(
          context, MaterialPageRoute(builder: (_) => HomeView()), (route) => false);
    } else {
      showNoInternetDialog(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    phoneData();
    return Material(
      color: const Color(0xFF00bf7d),
      child: Center(child: Image.asset('assets/images/Logo.png')),
    );
  }
}
