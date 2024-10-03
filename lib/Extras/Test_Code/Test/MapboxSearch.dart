//library mapbox_search;
//import 'dart:core';
//import 'package:flutter/material.dart';
// import 'package:fyp_code/Test_Code/Test/tokens.dart';
// import 'package:mapbox_search/mapbox_search.dart';
//
// class TheHomePage  {
//
//
//   final MAPBOX_KEY = MBtoken;
//
//   Future<void> main() async {
//     final apiKey = MAPBOX_KEY; //Set up a test api key before running
//     MapBoxSearch.init(apiKey);
//
//     await geoCoding(apiKey).catchError(print);
//     await placesSearch(apiKey).catchError(print);
//   }
//
//   ///Reverse GeoCoding sample call
//   Future geoCoding(String apiKey) async {
//     var geoCodingService = GeoCoding(
//       country: "BR",
//       limit: 5,
//     );
//
//     var addresses = await geoCodingService.getAddress((
//     lat: -19.984846,
//     long: -43.946852,
//     ));
//
//     addresses.fold(
//           (success) => print(success),
//           (failure) => print(failure),
//     );
//
//     print(addresses.success);
//   }
//
//   ///Places search sample call
//   Future placesSearch(String apiKey) async {
//     var placesService = GeoCoding(
//       apiKey: apiKey,
//       country: "BR",
//       limit: 5,
//     );
//
//     var places = await placesService.getPlaces(
//       "patio",
//       proximity: Proximity.LatLong(
//         lat: -19.984634,
//         long: -43.9502958,
//       ),
//     );
//
//     print(places);
//   }
//
//}