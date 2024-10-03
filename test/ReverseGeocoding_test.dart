import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fyp_code/Project_Code/Utils/MB_Reverse.dart';
import 'package:mapbox_gl/mapbox_gl.dart';
import 'package:mockito/mockito.dart';
import 'package:dio/dio.dart';  // Import the actual Dio library
import 'package:fyp_code/Project_Code/Utils/dioExceptions.dart';
 // Import where your function is located

class MockDio extends Mock implements Dio {}

Future<void> main() async {
  await dotenv.load(fileName: "assets/config/.env");
  group('getReverseGeocodingGivenLatLngUsingMapbox', () {
    test('should return data on successful response', () async {
      // Set up
      String mockResponse = "Griffin\'s Londis";

      // Act
      final result1 = await getReverseGeocodingGivenLatLngUsingMapbox(LatLng(53.3498, -6.2603));
      List<dynamic> features = result1['features'];
      Map<String, dynamic> firstFeature = features[0];
      print(firstFeature);
      String result = firstFeature['text'];
      print(result);
      // Assert
      expect(result, mockResponse); // Or process the result data as needed
    });
  });
}
