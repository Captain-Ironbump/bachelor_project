import 'dart:io';

import 'package:equatable/equatable.dart';

class NetworkExcpetion extends Equatable {
  late final String message;
  late final int? statusCode;

  NetworkExcpetion.fromHttpError(dynamic error,
      {int? statusCode, String? responseBody}) {
    statusCode = statusCode;
    if (error is HttpException) {
      message = 'Error when calling';
    }
  }

  @override
  List<Object?> get props => [message, statusCode];
}
