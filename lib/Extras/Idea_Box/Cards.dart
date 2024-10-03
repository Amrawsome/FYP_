// import 'package:flutter/material.dart';
// import 'package:flutter/painting.dart';
// import 'package:flutter/widgets.dart';
// import 'package:fyp_code/Project_Code/Utils/sharedPref.dart';
// import 'package:url_launcher/url_launcher.dart';
// import '../Model/DB.dart';
// import 'package:flutter/cupertino.dart';
//
// class RecCards extends StatefulWidget {
//   const RecCards({Key? key}) : super(key: key);
//
//   @override
//   State<RecCards> createState() => _RecCardsState();
// }
//
// class _RecCardsState extends State<RecCards> {
//   List<Map<String, dynamic>> _Rcenters = [];
//   final centersData = RecyclingCentersFetch();
//
//   @override
//   void initState() {
//     super.initState();
//     DBData();
//   }
//
//   Future<void> DBData() async {
//     try {
//       await centersData.retrieveData();
//      // print(centersData.Rcenters);
//       //print("Cards.dart");
//       setState(() {
//         _Rcenters = centersData.Rcenters;
//       });
//     } catch (error) {
//       print('Error:$error');
//     }
//   }
//
//   Widget cardButtons(IconData iconData, String label) {
//     return Padding(
//       padding: const EdgeInsets.only(right: 10),
//       child: ElevatedButton(
//         onPressed: () {},
//         style: ElevatedButton.styleFrom(
//           padding: const EdgeInsets.all(5),
//           minimumSize: Size.zero,
//         ),
//         child: Row(
//           children: [
//             Icon(iconData, size: 16),
//             const SizedBox(width: 2),
//             Text(label)
//           ],
//         ),
//       ),
//     );
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Recycling Centers'),
//       ),
//       body: SafeArea(
//         child: SingleChildScrollView(
//           physics: const ScrollPhysics(),
//           child: Padding(
//             padding: const EdgeInsets.all(15),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               mainAxisSize: MainAxisSize.min,
//               children: [
//                 const CupertinoTextField(
//                   prefix: Padding(
//                     padding: EdgeInsets.only(left: 15),
//                     child: Icon(Icons.search),
//                   ),
//                   padding: EdgeInsets.all(15),
//                   placeholder: 'Search Recycling Center name',
//                   style: TextStyle(color: Colors.white),
//                   decoration: BoxDecoration(
//                     color: Colors.black54,
//                     borderRadius: BorderRadius.all(Radius.circular(5)),
//                   ),
//                 ),
//                 const SizedBox(height: 5),
//                 ListView.builder(
//                   physics: const NeverScrollableScrollPhysics(),
//                   shrinkWrap: true,
//                   padding: EdgeInsets.zero,
//                   itemCount: _Rcenters.length,
//                   itemBuilder: (BuildContext context, int index) {
//                     Uri url = Uri.parse('');
//                     return Card(
//                       clipBehavior: Clip.antiAlias,
//                       shape: RoundedRectangleBorder(
//                           borderRadius: BorderRadius.circular(15)),
//                       child: Row(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           Container(
//                             height: 500,
//                             width: MediaQuery.of(context).size.width * 0.905,
//                             padding: const EdgeInsets.all(25),
//                             child: Column(
//                               crossAxisAlignment: CrossAxisAlignment.start,
//                               children: [
//                                 Flexible(
//                                   child: Text(
//                                     _Rcenters[index]['reccentername'],
//                                     style: const TextStyle(
//                                         fontWeight: FontWeight.bold,
//                                         fontSize: 20),
//                                   ),
//                                 ),
//                                 InkWell(
//                                   child: Text(
//                                     "Website Link",
//                                     style: TextStyle(
//                                         fontSize: 15, color: Colors.blue),
//                                   ),
//                                   onTap: () => launchUrl(url = Uri.parse(
//                                       _Rcenters[index]['reccenterlink'])),
//                                 ),
//                                 Padding(
//                                   padding: const EdgeInsets.only(bottom: 15),
//                                 ),
//                                 Text('Monday: ' +
//                                     _Rcenters[index]['reccentermon']),
//                                 Text('Tuesday: ' +
//                                     _Rcenters[index]['reccentertues']),
//                                 Text('Wednesday: ' +
//                                     _Rcenters[index]['reccenterwed']),
//                                 Text('Thursday: ' +
//                                     _Rcenters[index]['reccenterthur']),
//                                 Text('Friday: ' +
//                                     _Rcenters[index]['reccenterfri']),
//                                 Text('Saturday: ' +
//                                     _Rcenters[index]['reccentersat']),
//                                 Text('Sunday: ' +
//                                     _Rcenters[index]['reccentersun']),
//                                 Text('Bank Holidays: ' +
//                                     _Rcenters[index]['reccenterbankholiday']),
//                                 Text('Check The Website For More Information'),
//                                 Padding(
//                                   padding: const EdgeInsets.only(top: 15),
//                                   child: Text(
//                                     'Distance: ${(getDistanceSHPR(index) / 1000).toStringAsFixed(2)}km',
//                                     style: TextStyle(fontSize: 15),
//                                   ),
//                                 ),
//                                 Row(
//                                   children: [
//                                     cardButtons(
//                                         Icons.nordic_walking, 'Walking'),
//                                     cardButtons(Icons.pedal_bike, 'Cycling'),
//                                     cardButtons(Icons.car_repair, 'Driving'),
//                                   ],
//                                 ),
//                               ],
//                             ),
//                           ),
//                         ],
//                       ),
//                     );
//                   },
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
