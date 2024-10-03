import 'package:mapbox_gl/mapbox_gl.dart';
import 'package:fyp_code/Project_Code/Model/DB.dart';
import '../../main.dart';
import 'MB_Nav.dart';
import 'MB_Reverse.dart';
import 'MB_Search.dart';

final centersData = RecyclingCentersFetch();
List<Map<String, dynamic>> _Rcenters = [];

//Retrieves recycling centers from the database
Future<void> retrieveData() async {
  try {
    await centersData.retrieveData();
    _Rcenters = centersData.Rcenters;
  } catch (error) {
    print('Error:$error');
  }
}

//method containing a switch statement to return
// the correct routing data based on the start Lat Lng index and transport type
Future<Map> APIResponse(
    LatLng currentLatLng, int index, String transport) async {
  switch (transport) {
    case 'driving':
      return APIDrivingResponse(currentLatLng, index);

    case 'walking':
      return APIWalkingResponse(currentLatLng, index);

    case 'cycling':
      return APICyclingResponse(currentLatLng, index);

    default:
      print("Error Transport type wrong default reply");
      return {'error': 'Invalid transport type'};
  }
}

Future<Map> APIDistance(LatLng currentLatLng, int index) async {
  await retrieveData(); //retrieves centres infomration

  final response = await getCyclingRoute(
      currentLatLng,
      LatLng(
          (_Rcenters[index]['reccenterlat']),
          (_Rcenters[index][
          'reccenterlon']))); //calls get cycling route data to retrieve api response data
  //initializing variables to response data

  num distance = response['routes'][0]['distance'];
  //adding previously initialized data to a map to be returned
  Map modifiedResponse = {
    "distance": distance,
  };
  return modifiedResponse;
}

//method returns cycling route data
Future<Map> APICyclingResponse(LatLng currentLatLng, int index) async {
  await retrieveData(); //retrieves centres infomration

  final response = await getCyclingRoute(
      currentLatLng,
      LatLng(
          (_Rcenters[index]['reccenterlat']),
          (_Rcenters[index][
              'reccenterlon']))); //calls get cycling route data to retrieve api response data
  //initializing variables to response data
  Map geometry = response['routes'][0]['geometry'];
  num duration = response['routes'][0]['duration'];
  num distance = response['routes'][0]['distance'];
  //adding previously initialized data to a map to be returned
  Map modifiedResponse = {
    "geometry": geometry,
    "duration": duration,
    "distance": distance,
  };
  return modifiedResponse;
}

Future<Map> APIWalkingResponse(LatLng currentLatLng, int index) async {
  await retrieveData();

  final response = await getCyclingRoute(
      currentLatLng,
      LatLng((_Rcenters[index]['reccenterlat']),
          (_Rcenters[index]['reccenterlon'])));

  Map geometry = response['routes'][0]['geometry'];
  num duration = response['routes'][0]['duration'];
  num distance = response['routes'][0]['distance'];

  Map modifiedResponse = {
    "geometry": geometry,
    "duration": duration,
    "distance": distance,
  };
  return modifiedResponse;
}

Future<Map> APIDrivingResponse(LatLng currentLatLng, int index) async {
  await retrieveData();

  final response = await getCyclingRoute(
      currentLatLng,
      LatLng((_Rcenters[index]['reccenterlat']),
          (_Rcenters[index]['reccenterlon'])));

  Map geometry = response['routes'][0]['geometry'];
  num duration = response['routes'][0]['duration'];
  num distance = response['routes'][0]['distance'];

  Map modifiedResponse = {
    "geometry": geometry,
    "duration": duration,
    "distance": distance,
  };
  return modifiedResponse;
}

//saving routing data to shared Preferences
Future<void> saveDirectionsAPIResponse(int index, String response) async {
  sharedPreferences.setString('RecyclingCentre--$index', response);
}

//returning string having whitespace removed from start and end
String getValidatedQueryFromQuery(String query) {
  String validatedQuery = query.trim();
  return validatedQuery;
}

Future<List> getParsedResponseForQuery(String value) async {
  List parsedResponses = []; //empty list to hold responses

  String query = getValidatedQueryFromQuery(value); //returning clean query

  if (query == '') return parsedResponses; //return list if the query is empty

  var response = (await getSearchResultsFromQueryUsingMapbox(
      query)); //returns search results from api

  List features = response['features']; //list to hold search results
  for (var feature in features) {
    //for loop to go through the search results
    Map response = {
      //format what gonna be shown
      'name': feature['text'],
      'address': feature['place_name'],
      'place': feature['place_name'],
      'location': LatLng(feature['center'][1], feature['center'][0]),
      'lng': feature['center'][0],
      'lat': feature['center'][1]
    };
    parsedResponses.add(response); //add response to list
  }

  return parsedResponses; //return the list
}

Future<Map> getParsedReverseGeocoding(LatLng latLng) async {
  try {
    var response = (await getReverseGeocodingGivenLatLngUsingMapbox(latLng));

    Map feature = response['features'][0];

    Map revGeocode = {
      'name': feature['text'],
      'address': feature['place_name'].split('${feature['text']}, ')[1],
      'place': feature['place_name'],
      'location': latLng
    };

    return revGeocode;
  } catch (error) {
    print('Error in getParsedReverseGeocoding: $error');
    rethrow; // Rethrow the error for it to propagate up
  }
}
