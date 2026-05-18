import 'dart:io';

import 'package:dio/dio.dart';

class ErrorHandler {
  static String handleError(dynamic e) {
    if (e is DioException) {
      if (e.type == DioExceptionType.connectionError) {
        return "No internet connection";
      }

      if (e.type == DioExceptionType.badResponse) {
        final errorObj = e.response?.data;

        if (errorObj is String) {
          return errorObj;
        } else if (errorObj is Map && errorObj.values.isNotEmpty) {
          final error = errorObj;
          if (error.values.first is String) {
            return error.values.first;
          } else if (error.values.first is List &&
              error.values.first.isNotEmpty) {
            return error.values.first.first;
          } else if (error.values.first is Map &&
              error.values.first.isNotEmpty) {
            return error.values.first.values.first;
          } else {
            return "Error: Unexpected";
          }
        } else {
          return "Hello";
        }
      } else {
        return "something went worng";
      }
    } else if (e is SocketException) {
      return "No internet connect";
    } else {
      return "Error: something went wrong";
    }
  }
}
