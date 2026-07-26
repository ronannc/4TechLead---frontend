/// Environment/configuration values, provided at build/run time via
/// `--dart-define`, e.g.:
///
/// ```sh
/// flutter run --dart-define=API_BASE_URL=https://api.example.com/api/v1
/// ```
class Env {
  Env._();

  static const apiBaseUrl = String.fromEnvironment(
    'API_BASE_URL',
    // Matches backend/.env's NGINX_PORT (8090), not Laravel's own APP_URL
    // (8000, only used when serving via `php artisan serve` outside Docker).
    defaultValue: 'http://localhost:8090/api/v1',
  );
}
