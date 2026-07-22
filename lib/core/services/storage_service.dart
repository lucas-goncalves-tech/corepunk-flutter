import 'dart:async';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class StorageService {
  static SharedPreferences? _prefs;
  static Timer? _saveDebounceTimer;
  static bool _hasPendingPriceSave = false;
  static bool _hasPendingTranslationSave = false;

  static const String _storageVersionKey = 'storage_version_v3';

  static final Map<String, double> _pricesMap = {};
  static final Map<String, String> _translationsMap = {};

  static Future<void> init() async {
    _prefs ??= await SharedPreferences.getInstance();

    final currentVer = _prefs?.getString('app_storage_version');
    if (currentVer != _storageVersionKey) {
      await _prefs?.remove('saved_item_translations');
      await _prefs?.setString('app_storage_version', _storageVersionKey);
    }

    _loadPricesFromDisk();
    _loadTranslationsFromDisk();
  }

  static void _loadPricesFromDisk() {
    final rawJson = _prefs?.getString('saved_ingredient_prices');
    if (rawJson != null && rawJson.isNotEmpty) {
      try {
        final Map<String, dynamic> decoded = jsonDecode(rawJson);
        decoded.forEach((key, value) {
          if (value is num) {
            _pricesMap[key] = value.toDouble();
          }
        });
      } catch (_) {}
    }
  }

  static void _loadTranslationsFromDisk() {
    final rawJson = _prefs?.getString('saved_item_translations');
    if (rawJson != null && rawJson.isNotEmpty) {
      try {
        final Map<String, dynamic> decoded = jsonDecode(rawJson);
        decoded.forEach((key, value) {
          if (value is String) {
            _translationsMap[key] = value;
          }
        });
      } catch (_) {}
    }
  }

  static Map<String, double> getAllPrices() {
    return Map.unmodifiable(_pricesMap);
  }

  static String? getTranslation(String cacheKey) {
    return _translationsMap[cacheKey];
  }

  static void savePriceDebounced(String slug, double price) {
    _pricesMap[slug] = price;
    _hasPendingPriceSave = true;
    _scheduleDebouncedDiskSave();
  }

  static void saveTranslationDebounced(String cacheKey, String jsonString) {
    _translationsMap[cacheKey] = jsonString;
    _hasPendingTranslationSave = true;
    _scheduleDebouncedDiskSave();
  }

  static void _scheduleDebouncedDiskSave() {
    _saveDebounceTimer?.cancel();
    _saveDebounceTimer = Timer(const Duration(milliseconds: 1500), () async {
      _flushToDisk();
    });
  }

  static Future<void> _flushToDisk() async {
    _prefs ??= await SharedPreferences.getInstance();

    if (_hasPendingPriceSave) {
      _hasPendingPriceSave = false;
      await _prefs?.setString('saved_ingredient_prices', jsonEncode(_pricesMap));
    }

    if (_hasPendingTranslationSave) {
      _hasPendingTranslationSave = false;
      await _prefs?.setString('saved_item_translations', jsonEncode(_translationsMap));
    }
  }
}
