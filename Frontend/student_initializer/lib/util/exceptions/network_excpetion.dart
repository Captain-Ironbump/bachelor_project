import 'dart:io';

import 'package:equatable/equatable.dart';

class NetworkException extends Equatable {
  final String message;  // Change to non-late, final variable
  final int? statusCode;

  // Constructor now always initializes 'message' and 'statusCode'
  NetworkException.fromHttpError(dynamic error, {this.statusCode, String? responseBody})
      : message = _getErrorMessage(error) {
    // You can log or handle 'responseBody' if necessary.
  }

  // Helper function to decide what the error message should be
  static String _getErrorMessage(dynamic error) {
    if (error is HttpException) {
      return 'Error when calling the API';
    } else if (error is SocketException) {
      return 'No internet connection';
    } else {
      return 'Unknown error occurred';
    }
  }

  @override
  List<Object?> get props => [message, statusCode];
}

