import 'package:flutter_dotenv/flutter_dotenv.dart';

/// Loads environment configuration from `.env` and `--dart-define` values.
class AppConfig {
  AppConfig._();

  static Future<void> load() async {
    try {
      await dotenv.load(fileName: '.env');
    } catch (_) {
      // `.env` is optional for local dev; `--dart-define` can supply values instead.
    }
  }

  /// Reserved for Phase 2 Gemini summarization — not used yet.
  static String get geminiApiKey => _value('GEMINI_API_KEY');

  static String get devToApiBase =>
      _value('DEV_TO_API_BASE', fallback: 'https://dev.to/api');

  static String _value(String key, {String fallback = ''}) {
    final fromDefine = String.fromEnvironment(key, defaultValue: '');
    if (fromDefine.isNotEmpty) return fromDefine;

    final fromEnv = dotenv.env[key];
    if (fromEnv != null && fromEnv.isNotEmpty) return fromEnv;

    return fallback;
  }
}
