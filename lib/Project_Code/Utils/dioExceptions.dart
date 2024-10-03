import 'package:dio/dio.dart';

//this class will handle exceptions found when using dio trying to get API information
class DioExceptions implements Exception {
  DioExceptions.fromDioError(DioException dioException) {
    switch (dioException.type) {
      case DioExceptionType.cancel:
        message = "Request to API server was cancelled";
        break;
      case DioExceptionType.connectionTimeout:
        message = "Connection timeout with API server";
        break;
      case DioExceptionType.receiveTimeout:
        message = "Receive timeout in connection with API server";
        break;
      case DioExceptionType.sendTimeout:
        message = "Send timeout in connection with API server";
        break;
      case DioExceptionType.badResponse:
        message = handleError(
            dioException.response!.statusCode!, dioException.response!.data);
        break;
      case DioExceptionType.connectionError:
        message = "Connection to API server failed due to internet connection";
        break;
      default:
        message = "Something went wrong";
        break;
    }
  }

  late String message;

  //handles bad response messages
  String handleError(int statusCode, dynamic error) {
    switch (statusCode) {
      case 400:
        return 'Bad request';
      case 404:
        if (error is Map && error.containsKey("message")) {
          return error["message"];
        } else {
          return 'Resource not found'; // Handle potential missing message
        }
      case 500:
        return 'Internal server error';
      default:
        return 'Oops something went wrong';
    }
  }

  @override
  String toString() => message;
}
