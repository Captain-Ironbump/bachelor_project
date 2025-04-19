import 'package:equatable/equatable.dart';

class LocalStorageException extends Equatable {
  final String message;
  final String? key;
  final dynamic originalException;

  const LocalStorageException({
    required this.message,
    this.key,
    this.originalException,
  });

  factory LocalStorageException.fromError(
    dynamic error, {
    String? key,
    String? fallbackMessage,
  }) {
    return LocalStorageException(
      message: fallbackMessage ?? 'An error occurred while accessing local storage.',
      key: key,
      originalException: error,
    );
  }

  @override
  List<Object?> get props => [message, key, originalException];

  @override
  String toString() => 'LocalStorageException(message: $message, key: $key, originalException: $originalException)';
}
