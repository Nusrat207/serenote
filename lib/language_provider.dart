import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LanguageProvider extends ChangeNotifier {
  Locale _locale = const Locale('en');

  Locale get locale => _locale;

  LanguageProvider() {
    _loadLocale();
  }

  void _loadLocale() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? languageCode = prefs.getString('language_code');
    if (languageCode != null) {
      _locale = Locale(languageCode);
      notifyListeners();
    }
  }

  void setLocale(Locale locale) async {
    if (!['en', 'bn'].contains(locale.languageCode)) return;
    
    _locale = locale;
    notifyListeners();
    
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('language_code', locale.languageCode);
  }

  bool isEnglish() => _locale.languageCode == 'en';
  bool isBangla() => _locale.languageCode == 'bn';
}