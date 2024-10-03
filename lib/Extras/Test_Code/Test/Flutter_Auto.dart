// import 'package:flutter/material.dart';
// import 'package:google_places_autocomplete_text_field/google_places_autocomplete_text_field.dart';
// import 'package:google_places_autocomplete_text_field/model/prediction.dart';
// import 'tokens.dart';
//
//
//
// class MyHomePage extends StatefulWidget {
//   MyHomePage({super.key, required this.title});
//
//   final String title;
//
//   @override
//   State<MyHomePage> createState() => _MyHomePageState();
// }
//
// class _MyHomePageState extends State<MyHomePage> {
//   final _yourGoogleAPIKey = G_Token;
//
//   // only needed if you build for the web
//   final _yourProxyURL = 'https://your-proxy.com/';
//
//   final _textController = TextEditingController();
//   final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
//   AutovalidateMode _autovalidateMode = AutovalidateMode.disabled;
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text(widget.title),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(20),
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Form(
//               key: _formKey,
//               autovalidateMode: _autovalidateMode,
//               child: GooglePlacesAutoCompleteTextFormField(
//                 textEditingController: _textController,
//                 googleAPIKey: _yourGoogleAPIKey,
//                 decoration: const InputDecoration(
//                   hintText: 'Enter your address',
//                   labelText: 'Address',
//                   labelStyle: TextStyle(color: Colors.purple),
//                   border: OutlineInputBorder(),
//                 ),
//                 validator: (value) {
//                   if (value!.isEmpty) {
//                     return 'Please enter some text';
//                   }
//                   return null;
//                 },
//                 // proxyURL: _yourProxyURL,
//                 maxLines: 1,
//                 overlayContainer: (child) => Material(
//                   elevation: 1.0,
//                   color: Colors.green,
//                   borderRadius: BorderRadius.circular(12),
//                   child: child,
//                 ),
//                 itmClick: (Prediction prediction) =>
//                 _textController.text = prediction.description!,
//               ),
//             ),
//             const SizedBox(height: 24),
//             TextButton(
//               onPressed: _onSubmit,
//               child: const Text('Submit'),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   Future<void> _onSubmit() async {
//     if (!_formKey.currentState!.validate()) {
//       setState(() => _autovalidateMode = AutovalidateMode.always);
//       return;
//     }
//
//     print(_textController.text+" Hello");
//   }
// }