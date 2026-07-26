import 'package:dio/dio.dart';

import '../auth/auth_session.dart';

/// Attaches `Authorization: Bearer <token>` to every outgoing request when
/// there's an active [AuthSession]. On a 401 response, signs the session
/// out (clears the token) — go_router's `redirect` then sends the user back
/// to the login screen.
class AuthInterceptor extends Interceptor {
  AuthInterceptor(this._authSession);

  final AuthSession _authSession;

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    final token = _authSession.token;

    if (token != null) {
      options.headers['Authorization'] = 'Bearer $token';
    }

    handler.next(options);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    if (err.response?.statusCode == 401) {
      _authSession.signOut();
    }

    handler.next(err);
  }
}
