import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:frontend/core/network/api_exception.dart';

DioException _exceptionWithResponse({required int statusCode, required Object? data}) {
  final requestOptions = RequestOptions(path: '/teams');

  return DioException(
    requestOptions: requestOptions,
    response: Response(requestOptions: requestOptions, statusCode: statusCode, data: data),
    type: DioExceptionType.badResponse,
  );
}

void main() {
  group('mapDioException', () {
    test('maps a connection error to NetworkException', () {
      final exception = DioException(
        requestOptions: RequestOptions(path: '/teams'),
        type: DioExceptionType.connectionError,
      );

      expect(mapDioException(exception), isA<NetworkException>());
    });

    test('maps a 422 with errors to ValidationException carrying field messages', () {
      final exception = _exceptionWithResponse(
        statusCode: 422,
        data: {
          'message': 'The given data was invalid.',
          'errors': {
            'name': ['The name field is required.'],
          },
        },
      );

      final result = mapDioException(exception);

      expect(result, isA<ValidationException>());
      expect(
        (result as ValidationException).errors['name'],
        contains('The name field is required.'),
      );
      expect(result.userMessage, 'The name field is required.');
    });

    test('maps a 404 to NotFoundException', () {
      final exception = _exceptionWithResponse(statusCode: 404, data: {'message': 'Not Found'});

      expect(mapDioException(exception), isA<NotFoundException>());
    });

    test('maps a 401 to UnauthenticatedException using the body message', () {
      final exception = _exceptionWithResponse(statusCode: 401, data: {'message': 'Unauthenticated.'});

      final result = mapDioException(exception);

      expect(result, isA<UnauthenticatedException>());
      expect(result.userMessage, 'Unauthenticated.');
    });

    test('maps a 403 to ForbiddenException using the body message', () {
      final exception = _exceptionWithResponse(
        statusCode: 403,
        data: {'message': 'This action is unauthorized.'},
      );

      final result = mapDioException(exception);

      expect(result, isA<ForbiddenException>());
      expect(result.userMessage, 'This action is unauthorized.');
    });

    test('maps a 500 with message to ServerException using that message', () {
      final exception = _exceptionWithResponse(
        statusCode: 500,
        data: {'message': 'Something broke.'},
      );

      final result = mapDioException(exception);

      expect(result, isA<ServerException>());
      expect(result.userMessage, 'Something broke.');
    });

    test('falls back to a generic message when the 500 body has no message', () {
      final exception = _exceptionWithResponse(statusCode: 500, data: 'plain text body');

      final result = mapDioException(exception);

      expect(result, isA<ServerException>());
      expect(result.userMessage, 'Server error. Please try again later.');
    });
  });
}
