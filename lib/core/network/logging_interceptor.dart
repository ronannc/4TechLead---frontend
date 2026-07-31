import 'package:dio/dio.dart';
import 'package:logger/logger.dart';

/// Logs every request/response/error going through [DioClient] — method,
/// URL, headers (sensitive ones redacted), and body — for debugging.
/// Only ever attached in debug builds (see [DioClient]).
class AppLoggingInterceptor extends Interceptor {
  AppLoggingInterceptor({Logger? logger})
    : _logger = logger ?? Logger(printer: PrettyPrinter(methodCount: 0));

  final Logger _logger;

  static const _redactedHeaders = {'authorization', 'cookie', 'set-cookie'};

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    _logger.i(
      '--> ${options.method} ${options.uri}\n'
      'headers: ${_redact(options.headers)}\n'
      'body: ${options.data}',
    );

    handler.next(options);
  }

  @override
  void onResponse(
    Response<dynamic> response,
    ResponseInterceptorHandler handler,
  ) {
    _logger.i(
      '<-- ${response.statusCode} ${response.requestOptions.uri}\n'
      'body: ${response.data}',
    );

    handler.next(response);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    _logger.e(
      '<-- ERROR ${err.response?.statusCode} ${err.requestOptions.uri}\n'
      'body: ${err.response?.data}',
      error: err,
    );

    handler.next(err);
  }

  Map<String, dynamic> _redact(Map<String, dynamic> headers) {
    return {
      for (final entry in headers.entries)
        entry.key: _redactedHeaders.contains(entry.key.toLowerCase())
            ? '***'
            : entry.value,
    };
  }
}
