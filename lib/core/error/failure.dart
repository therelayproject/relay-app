/// Typed failure sealed class for the domain layer.
///
/// Repositories catch infrastructure exceptions and map them to [Failure]
/// subtypes so that presentation code never has to import `dio` or
/// platform-specific packages.
sealed class Failure {
  const Failure(this.message);
  final String message;
}

final class NetworkFailure extends Failure {
  const NetworkFailure([super.message = 'No network connection']);
}

final class ServerFailure extends Failure {
  const ServerFailure(super.message, {this.statusCode});
  final int? statusCode;
}

final class AuthFailure extends Failure {
  const AuthFailure([super.message = 'Authentication required']);
}

final class NotFoundFailure extends Failure {
  const NotFoundFailure([super.message = 'Resource not found']);
}

final class ValidationFailure extends Failure {
  const ValidationFailure(super.message, {this.fields = const {}});
  final Map<String, String> fields;
}

final class UnknownFailure extends Failure {
  const UnknownFailure([super.message = 'An unexpected error occurred']);
}
