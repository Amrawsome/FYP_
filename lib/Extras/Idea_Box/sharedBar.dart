// import 'package:flutter/material.dart';
// import 'package:fyp_code/Project_Code/Views/Map.dart';
// import 'package:fyp_code/Project_Code/Views/Cards.dart';
//
// class sharedBar extends StatefulWidget {
//   const sharedBar({super.key});
//
//   @override
//   State<sharedBar> createState() => _sharedBarState();
// }
//
// class _sharedBarState extends State<sharedBar> {
//   final List<Widget> _screens = [Mapp(), RecCards()];
//   int page = 0;
//
//
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: _screens[page],
//       bottomNavigationBar: BottomNavigationBar(
//         onTap: (currentpage) {
//           setState(() {
//             page = currentpage;
//           });
//         },
//         items: const [
//           BottomNavigationBarItem(icon: Icon(Icons.map), label:'Recycling Center Maps'),
//           BottomNavigationBarItem(icon: Icon(Icons.recycling),label:'Recycling Centers')
//         ],
//       ),
//     );
//   }
// }
