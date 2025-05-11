import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:part_catalog/core/service_locator.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:part_catalog/features/suppliers/api/api_connection_mode.dart';
import 'package:part_catalog/core/utils/logger_config.dart';

// --- Провайдер для GlobalApiSettingsService ---
final globalApiSettingsServiceProvider =
    Provider<GlobalApiSettingsService>((ref) {
  return locator<GlobalApiSettingsService>();
});
// --- Конец провайдера ---

class GlobalApiSettingsService {
  final _logger = AppLoggers.core;
  static const String _apiModeKey = 'api_connection_mode';
  static const String _proxyUrlKey = 'proxy_url';

  Future<SharedPreferences> get _prefs async => SharedPreferences.getInstance();

  Future<ApiConnectionMode> getApiConnectionMode() async {
    try {
      final prefs = await _prefs;
      final modeName = prefs.getString(_apiModeKey);
      return ApiConnectionModeExtension.fromName(modeName);
    } catch (e, s) {
      _logger.e('Error getting API connection mode', error: e, stackTrace: s);
      return ApiConnectionMode.direct; // Значение по умолчанию при ошибке
    }
  }

  Future<void> setApiConnectionMode(ApiConnectionMode mode) async {
    try {
      final prefs = await _prefs;
      await prefs.setString(_apiModeKey, mode.name);
      _logger.i('API connection mode set to: ${mode.name}');
    } catch (e, s) {
      _logger.e('Error setting API connection mode', error: e, stackTrace: s);
    }
  }

  Future<String?> getProxyUrl() async {
    try {
      final prefs = await _prefs;
      return prefs.getString(_proxyUrlKey);
    } catch (e, s) {
      _logger.e('Error getting proxy URL', error: e, stackTrace: s);
      return null;
    }
  }

  Future<void> setProxyUrl(String? url) async {
    try {
      final prefs = await _prefs;
      if (url == null || url.isEmpty) {
        await prefs.remove(_proxyUrlKey);
        _logger.i('Proxy URL removed');
      } else {
        await prefs.setString(_proxyUrlKey, url);
        _logger.i('Proxy URL set to: $url');
      }
    } catch (e, s) {
      _logger.e('Error setting proxy URL', error: e, stackTrace: s);
    }
  }
}
