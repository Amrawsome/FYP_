import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:fyp_code/Project_Code/Utils/dioExceptions.dart';
import 'package:mapbox_gl/mapbox_gl.dart';

String start_URL =
    'https://api.mapbox.com/directions/v5/mapbox'; //default start to url
String P_Token = dotenv.env['MAPBOX_Pub_Token']!; //mapbox token from env file
String transportType = 'cycling';
String transportType2 = 'driving';
String transportType3 = 'walking';

Dio dio = Dio(); //initializing dio
Future getCyclingRoute(LatLng start, LatLng finish) async {
  String api_URL =
      '$start_URL/$transportType/${start.longitude},${start.latitude};${finish.longitude},${finish.latitude}?alternatives=true&continue_straight=true&geometries=geojson&language=en&overview=full&steps=true&access_token=$P_Token';

  try {
    dio.options.contentType = Headers.jsonContentType;
    final resData = await dio.get(api_URL); //retrieve data from api url
    return resData.data;
  } catch (e) {
    final errorMessage =
        DioExceptions.fromDioError(e as DioException).toString();
    debugPrint(errorMessage); //print the error message
  }
}

Future getWalkingRoute(LatLng start, LatLng finish) async {
  String api_URL =
      '$start_URL/$transportType3/${start.longitude},${start.latitude};${finish.longitude},${finish.latitude}?alternatives=true&continue_straight=true&geometries=geojson&language=en&overview=full&steps=true&access_token=$P_Token';
  try {
    dio.options.contentType = Headers.jsonContentType;
    final resData = await dio.get(api_URL);
    return resData.data;
  } catch (e) {
    final errorMessage =
        DioExceptions.fromDioError(e as DioException).toString();
    debugPrint(errorMessage);
  }
}

Future getCarRoute(LatLng start, LatLng finish) async {
  String api_URL =
      '$start_URL/$transportType2/${start.longitude},${start.latitude};${finish.longitude},${finish.latitude}?alternatives=true&continue_straight=true&geometries=geojson&language=en&overview=full&steps=true&access_token=$P_Token';
  try {
    dio.options.contentType = Headers.jsonContentType;
    final resData = await dio.get(api_URL);
    return resData.data;
  } catch (e) {
    final errorMessage =
        DioExceptions.fromDioError(e as DioException).toString();
    debugPrint(errorMessage);
  }
}
