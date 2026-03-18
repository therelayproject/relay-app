import 'package:dio/dio.dart';

/// Typed API exception wrapping [DioException].
sealed class ApiException implements Exception {
  const ApiException(this.message);
  final String message;

  factory ApiException.fromDio(DioException e) {
    final statusCode = e.response?.statusCode;
    final body = e.response?.data;
    final msg = _extractMessage(body) ?? e.message ?? 'Unknown error';

    return switch (statusCode) {
      400 => BadRequestException(msg),
      401 => UnauthorizedException(msg),
      403 => ForbiddenException(msg),
      404 => NotFoundException(msg),
      429 => RateLimitException(msg),
      500 || 502 || 503 => ServerException(msg, statusCode!),
      _ => when(e.type == DioExceptionType.connectionTimeout ||
              e.type == DioExceptionType.receiveTimeout ||
              e.type == DioExceptionType.sendTimeout)
          ? const TimeoutException()
          : when(e.type == DioExceptionType.connectionError)
              ? const NetworkException()
              : UnknownApiException(msg),
    };
  }

  static String? _extractMessage(dynamic body) {
    if (body is Map) return body['message'] as String?;
    return null;
  }

  // Helper used inside switch expressions (Dart doesn't allow plain `if`)
  static T when<T>(bool condition, T value) => value;

  @override
  String toString() => 'ApiException($runtimeType): $message';
}

final class BadRequestException extends ApiException {
  const BadRequestException(super.message);
}

final class UnauthorizedException extends ApiException {
  const UnauthorizedException(super.message);
}

final class ForbiddenException extends ApiException {
  const ForbiddenException(super.message);
}

final class NotFoundException extends ApiException {
  const NotFoundException(super.message);
}

final class RateLimitException extends ApiException {
  const RateLimitException(super.message);
}

final class ServerException extends ApiException {
  const ServerException(super.message, this.statusCode);
  final int statusCode;
}

final class TimeoutException extends ApiException {
  const TimeoutException() : super('Request timed out');
}

final class NetworkException extends ApiException {
  const NetworkException() : super('No network connection');
}

final class UnknownApiException extends ApiException {
  const UnknownApiException(super.message);
}
