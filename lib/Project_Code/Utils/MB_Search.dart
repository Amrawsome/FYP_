import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:fyp_code/Project_Code/Utils/dioExceptions.dart';
import 'package:fyp_code/main.dart';

String baseUrl = 'https://api.mapbox.com/geocoding/v5/mapbox.places';
String accessToken = dotenv.env['MAPBOX_Pub_Token']!;
String searchType =
    'place%2Cpostcode%2Caddress%2Cplace'; //what will be returned for the search list
String searchResultsLimit = '5'; //how many results will return
String proximity =
    '${sharedPreferences.getDouble('lon')}%2C${sharedPreferences.getDouble('lat')}';
String country = 'IE'; //country for search results

Dio _dio = Dio();

Future getSearchResultsFromQueryUsingMapbox(String query) async {
  String url =
      '$baseUrl/$query.json?country=$country&limit=$searchResultsLimit&proximity=$proximity&access_token=$accessToken';
  url = Uri.parse(url).toString();
  try {
    _dio.options.contentType = Headers.jsonContentType;
    final responseData = await _dio.get(url); //getting api data from url
    return responseData.data; //returns api data
  } catch (e) {
    //prints error message
    final errorMessage =
        DioExceptions.fromDioError(e as DioException).toString();
    debugPrint(errorMessage);
  }
}
