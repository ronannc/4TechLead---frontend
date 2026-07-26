import 'package:dio/dio.dart';

/// Base type for errors surfaced by the network layer. Repositories let
/// these propagate; [BaseViewModel.runCatching] catches them and exposes
/// [userMessage] as user-facing error state.
sealed class ApiException implements Exception {
  const ApiException(this.userMessage);

  final String userMessage;

  @override
  String toString() => '$runtimeType: $userMessage';
}

class NetworkException extends ApiException {
  const NetworkException() : super('No internet connection. Please try again.');
}

/// Maps a Laravel 422 validation response (`{message, errors: {field: [msgs]}}`).
class ValidationException extends ApiException {
  ValidationException(this.errors) : super(_firstMessage(errors));

  final Map<String, List<String>> errors;

  static String _firstMessage(Map<String, List<String>> errors) {
    for (final messages in errors.values) {
      if (messages.isNotEmpty) {
        return messages.first;
      }
    }

    return 'Validation failed.';
  }
}

class NotFoundException extends ApiException {
  const NotFoundException() : super('The requested resource was not found.');
}

/// 401 — not authenticated (missing/expired/invalid token, or wrong login
/// credentials). [AuthInterceptor] reacts to this by clearing the session.
class UnauthenticatedException extends ApiException {
  const UnauthenticatedException([String? message])
    : super(message ?? 'Your session has expired. Please sign in again.');
}

/// 403 — authenticated, but not permitted. Just an in-place error; does not
/// trigger a session sign-out.
class ForbiddenException extends ApiException {
  const ForbiddenException([String? message])
    : super(message ?? "You don't have permission to do that.");
}

class ServerException extends ApiException {
  const ServerException(super.userMessage);
}

/// Translates a [DioException] into a typed [ApiException] the ViewModel
/// layer can branch on, based on Laravel's standard error response shapes.
ApiException mapDioException(DioException exception) {
  if (exception.type == DioExceptionType.connectionError ||
      exception.type == DioExceptionType.connectionTimeout ||
      exception.type == DioExceptionType.receiveTimeout ||
      exception.type == DioExceptionType.sendTimeout) {
    return const NetworkException();
  }

  final statusCode = exception.response?.statusCode;
  final data = exception.response?.data;

  if (statusCode == 422 && data is Map && data['errors'] is Map) {
    final rawErrors = (data['errors'] as Map).cast<String, dynamic>();
    final errors = rawErrors.map(
      (field, messages) => MapEntry(field, List<String>.from(messages as List)),
    );

    return ValidationException(errors);
  }

  final bodyMessage = (data is Map && data['message'] is String) ? data['message'] as String : null;

  if (statusCode == 401) {
    return UnauthenticatedException(bodyMessage);
  }

  if (statusCode == 403) {
    return ForbiddenException(bodyMessage);
  }

  if (statusCode == 404) {
    return const NotFoundException();
  }

  return ServerException(bodyMessage ?? 'Server error. Please try again later.');
}
