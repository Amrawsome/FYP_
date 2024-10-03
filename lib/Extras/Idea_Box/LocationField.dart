// import 'dart:async';
// import 'dart:convert';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/widgets.dart';
// import 'package:fyp_code/Project_Code/Model/sharedPref.dart';
// import 'package:fyp_code/Project_Code/Views/Home.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:mapbox_gl/mapbox_gl.dart';
//
// import '../../main.dart';
// import '../Utils/MB_Info.dart';
//
// class LocationField extends StatefulWidget {
//   final TextEditingController textEditingController;
//
//   const LocationField({
//     Key? key,
//     required this.textEditingController,
//   }) : super(key: key);
//
//   @override
//   State<LocationField> createState() => _LocationFieldState();
// }
//
// class _LocationFieldState extends State<LocationField> {
//   Timer? searchOnStoppedTyping;
//   String query = '';
//
//   _onChangeHandler(value) {
//     Home.of(context)?.isLoadingState = true;
//     // Set isLoading = true in parent
//     // Make sure that requests are not made
//     // until 1 second after the typing stops
//     if (searchOnStoppedTyping != null) {
//       setState(() => searchOnStoppedTyping?.cancel());
//     }
//     setState(() => searchOnStoppedTyping =
//         Timer(const Duration(seconds: 1), () => _searchHandler(value)));
//   }
//
//   _searchHandler(String value) async {
//     List response = await getParsedResponseForQuery(value);
//
//     // Set responses and isDestination in parent
//     Home.of(context)?.responsesState = response;
//     setState(() => query = value);
//   }
//
//   _useCurrentLocationButtonHandler() async {
//     LatLng currentLocation = getLatLngSHPR();
//     //print(currentLocation);
//     // Get the response of reverse geocoding and do 2 things:
//     // 1. Store encoded response in shared preferences
//     // 2. Set the text editing controller to the address
//     var response = await getParsedReverseGeocoding(currentLocation);
//     sharedPreferences.setString('source', json.encode(response));
//     String place = response['place'];
//     widget.textEditingController.text = place;
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     String placeholderText = 'Please Enter Starting Location';
//     IconData? iconData = Icons.my_location;
//     return Padding(
//       padding: const EdgeInsets.only(top: 0, bottom: 0, left: 0, right: 0),
//       child: CupertinoTextField(
//         style: TextStyle(
//             fontSize: getHeightSHPR() * 0.021,
//             fontWeight: FontWeight.bold,
//             color: Colors.black),
//         controller: widget.textEditingController,
//         padding: const EdgeInsets.symmetric(horizontal: 10),
//         placeholder: placeholderText,
//         placeholderStyle: GoogleFonts.rubik(color: Colors.black),
//         decoration: const BoxDecoration(
//           // color: Color(0xFF00bf7d),
//           color: Colors.white,
//           borderRadius: BorderRadius.zero,
//         ),
//         //padding: EdgeInsets.all(20.0),
//         onChanged: _onChangeHandler,
//         suffix: IconButton(
//           onPressed: () => _useCurrentLocationButtonHandler(),
//           padding: const EdgeInsets.all(10),
//           constraints: const BoxConstraints(),
//           icon: Icon(
//             iconData,
//             size: 20,
//             color: Colors.black,
//             semanticLabel: "Current Location",
//           ),
//         ),
//       ),
//     );
//   }
// }
