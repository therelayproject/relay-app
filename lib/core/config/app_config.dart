/// Runtime configuration loaded from environment variables or build-time
/// constants.  Self-hosted deployments override [apiBaseUrl] at build time via
/// `--dart-define=API_BASE_URL=https://relay.example.com`.
class AppConfig {
  AppConfig._();

  static late String apiBaseUrl;
  static late String wsBaseUrl;
  static late String environment;

  static void init() {
    environment = const String.fromEnvironment(
      'ENV',
      defaultValue: 'production',
    );

    apiBaseUrl = const String.fromEnvironment(
      'API_BASE_URL',
      defaultValue: 'https://api.relay.chat',
    );

    // Derive WS URL from HTTP base by replacing scheme
    final wsOverride = const String.fromEnvironment('WS_BASE_URL');
    if (wsOverride.isNotEmpty) {
      wsBaseUrl = wsOverride;
    } else {
      wsBaseUrl = apiBaseUrl
          .replaceFirst('https://', 'wss://')
          .replaceFirst('http://', 'ws://');
    }
  }

  static bool get isDevelopment => environment == 'development';
}
