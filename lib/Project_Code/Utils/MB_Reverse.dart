import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:fyp_code/Project_Code/Utils/dioExceptions.dart';
import 'package:mapbox_gl/mapbox_gl.dart';

String baseUrl = 'https://api.mapbox.com/geocoding/v5/mapbox.places';
String accessToken = dotenv.env['MAPBOX_Pub_Token']!;

Dio _dio = Dio();

Future getReverseGeocodingGivenLatLngUsingMapbox(LatLng latLng) async {
  String query = '${latLng.longitude},${latLng.latitude}'; //getting lat lng
  String url = '$baseUrl/$query.json?access_token=$accessToken'; //api url
  url = Uri.parse(url).toString();
  //print(url);
  try {
    _dio.options.contentType = Headers.jsonContentType;
    final responseData = await _dio.get(url); //getting api data
    return responseData.data; //returning data
  } catch (e) {
    final errorMessage = DioExceptions.fromDioError(e as DioException)
        .toString(); //initialize the error message
    debugPrint(errorMessage); //print error message
  }
}
