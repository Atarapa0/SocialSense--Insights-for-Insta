import 'package:flutter/material.dart';
import 'dart:ui' as ui;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:socialsense/core/localization/app_localizations.dart';

/// Uygulama ayarları provider'ı
/// Tema ve dil yönetimini sağlar
class AppSettingsProvider extends ChangeNotifier {
  static const String _themeKey = 'theme_mode';
  static const String _languageKey = 'language_code';
  static const String _firstLaunchKey = 'first_launch_done';

  ThemeMode _themeMode = ThemeMode.dark;
  AppLanguage _language = AppLanguage.turkish;

  ThemeMode get themeMode => _themeMode;
  AppLanguage get language => _language;
  Locale get locale => Locale(_language.code);

  bool get isDarkMode => _themeMode == ThemeMode.dark;

  /// Ayarları yükle
  Future<void> loadSettings() async {
    final prefs = await SharedPreferences.getInstance();

    // Tema yükle
    final themeIndex = prefs.getInt(_themeKey) ?? 1; // Varsayılan: dark
    _themeMode = themeIndex == 0 ? ThemeMode.light : ThemeMode.dark;

    // Dil yükle - ilk sefer ise telefonun dilini kullan
    final isFirstLaunch = prefs.getBool(_firstLaunchKey) ?? true;

    if (isFirstLaunch) {
      // Telefonun dilini algıla
      final systemLocale = ui.PlatformDispatcher.instance.locale;
      final systemLangCode = systemLocale.languageCode;

      // Desteklenen dillerde mi kontrol et
      if (systemLangCode == 'en') {
        _language = AppLanguage.english;
      } else {
        // Türkçe veya desteklenmeyen diller için Türkçe
        _language = AppLanguage.turkish;
      }

      // İlk açılış yapıldı olarak işaretle
      await prefs.setBool(_firstLaunchKey, true);
      await prefs.setString(_languageKey, _language.code);
    } else {
      // Daha önce kaydedilmiş dili kullan
      final langCode = prefs.getString(_languageKey) ?? 'tr';
      _language = langCode == 'en' ? AppLanguage.english : AppLanguage.turkish;
    }

    notifyListeners();
  }

  /// Tema modunu değiştir
  Future<void> setThemeMode(ThemeMode mode) async {
    _themeMode = mode;
    notifyListeners();

    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_themeKey, mode == ThemeMode.light ? 0 : 1);
  }

  /// Tema modunu toggle et
  Future<void> toggleTheme() async {
    await setThemeMode(
      _themeMode == ThemeMode.dark ? ThemeMode.light : ThemeMode.dark,
    );
  }

  /// Dili değiştir
  Future<void> setLanguage(AppLanguage lang) async {
    _language = lang;
    notifyListeners();

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_languageKey, lang.code);
  }

  /// Dili toggle et
  Future<void> toggleLanguage() async {
    await setLanguage(
      _language == AppLanguage.turkish
          ? AppLanguage.english
          : AppLanguage.turkish,
    );
  }
}
