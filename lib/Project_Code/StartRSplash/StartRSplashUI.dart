import 'package:flutter/material.dart';
import 'package:fyp_code/Project_Code/StartRSplash/StartRSplashLogic.dart';
import 'package:permission_handler/permission_handler.dart';

import '../Home/HomeUI.dart';

class StartRSplashView extends StatefulWidget {
  const StartRSplashView({super.key});

  @override
  State<StartRSplashView> createState() => _StartRSplashViewState();
}

class _StartRSplashViewState extends State<StartRSplashView> {
  StartRSplashController controller = StartRSplashController();

  @override
  void initState() {
    super.initState();
    //calls phone data from logic class to retrieve length and width of phone
    WidgetsBinding.instance
        .addPostFrameCallback((_) => controller.phoneData(context));
    checkAndRequestLocation();
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
        controller.noLocationPerm(context);
      }
    }
  }

  //retrieves location data for the user and puts it in shared preferences
  Future<void> Location_Data() async {
    if (await controller.checkInternetConnection()) {
      controller.Location_Data_prep();
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (_) => const HomeView()),
          (route) => false);
    } else {
      controller.showNoInternetDialog(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    controller.phoneData(context);
    return Material(
      color: const Color(0xFF00bf7d),
      child: Center(
        child: Image.asset('assets/images/Logo.png'),
      ),
    );
  }
}
