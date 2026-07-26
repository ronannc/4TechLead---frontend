import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

import '../auth/auth_session.dart';
import '../config/env.dart';
import 'auth_interceptor.dart';
import 'logging_interceptor.dart';

/// Thin wrapper around a configured [Dio] instance — base URL, timeouts,
/// the auth interceptor, and the debug-only logging interceptor. Services
/// depend on [dio], never on `Dio()` directly, so every HTTP call in the
/// app shares this config.
class DioClient {
  DioClient(AuthSession authSession, {Dio? dio}) : _dio = dio ?? Dio() {
    _dio.options = _dio.options.copyWith(
      baseUrl: Env.apiBaseUrl,
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 10),
      headers: {'Accept': 'application/json'},
    );

    _dio.interceptors.add(AuthInterceptor(authSession));

    if (kDebugMode) {
      _dio.interceptors.add(AppLoggingInterceptor());
    }
  }

  final Dio _dio;

  Dio get dio => _dio;
}
