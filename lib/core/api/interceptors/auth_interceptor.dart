import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../storage/secure_storage.dart';

/// Attaches the Bearer token to every request and handles 401 token refresh.
class AuthInterceptor extends Interceptor {
  AuthInterceptor(this._ref);

  final Ref _ref;

  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    final token = await _ref.read(secureStorageProvider).readAccessToken();
    if (token != null) {
      options.headers['Authorization'] = 'Bearer $token';
    }
    handler.next(options);
  }

  @override
  Future<void> onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {
    if (err.response?.statusCode == 401) {
      // Attempt silent token refresh
      final refreshed = await _tryRefreshToken();
      if (refreshed) {
        // Retry original request with new token
        final token =
            await _ref.read(secureStorageProvider).readAccessToken();
        final opts = err.requestOptions
          ..headers['Authorization'] = 'Bearer $token';
        try {
          final response = await Dio().fetch(opts);
          return handler.resolve(response);
        } catch (_) {}
      }
      // Refresh failed — clear session and bubble the error
      await _ref.read(secureStorageProvider).clearTokens();
    }
    handler.next(err);
  }

  Future<bool> _tryRefreshToken() async {
    final storage = _ref.read(secureStorageProvider);
    final refreshToken = await storage.readRefreshToken();
    if (refreshToken == null) return false;

    try {
      // POST /auth/refresh — use a plain Dio without this interceptor
      final dio = Dio();
      final response = await dio.post(
        '/auth/refresh',
        data: {'refreshToken': refreshToken},
      );
      final newAccessToken = response.data['accessToken'] as String?;
      final newRefreshToken = response.data['refreshToken'] as String?;
      if (newAccessToken == null) return false;

      await storage.writeTokens(
        accessToken: newAccessToken,
        refreshToken: newRefreshToken ?? refreshToken,
      );
      return true;
    } catch (_) {
      return false;
    }
  }
}
