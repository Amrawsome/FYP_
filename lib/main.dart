import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:fyp_code/Project_Code/StartRSplash/StartRSplashUI.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter/services.dart';

late SharedPreferences sharedPreferences;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  //ensures orientation is portrait only
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  //retrieves shared preferences
  sharedPreferences = await SharedPreferences.getInstance();
  //loads env file to be used in the app
  await dotenv.load(fileName: "assets/config/.env");
  String S_URL = dotenv.env['SUPABASE_URL']!;
  String S_Token = dotenv.env['SUPABASE_TOKEN']!;
  //Connects to Supabase using details from env file
  await Supabase.initialize(
    url: S_URL,
    anonKey: S_Token,
  );
  //runs app

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const StartRSplashView(),
    );
  }
}
