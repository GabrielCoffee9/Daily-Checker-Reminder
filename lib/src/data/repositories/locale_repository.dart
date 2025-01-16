import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocaleRepository extends ChangeNotifier {
  Locale? currentLocale;

  String? get currentLocaleString => _currentLocaleToString();

  LocaleRepository({this.currentLocale}) {
    _getLocaleConfig();
  }

  Future<void> changeLocale({required String locale}) async {
    currentLocale = _stringToLocale(stringLocale: locale);
    await _saveLocaleConfig();
    notifyListeners();
  }

  _saveLocaleConfig() async {
    final prefs = await SharedPreferences.getInstance();
    final currentLocaleString = _currentLocaleToString();

    if (currentLocaleString != null) {
      await prefs.setString('localeConfig', currentLocaleString);
    }
  }

  String? _currentLocaleToString() {
    if (currentLocale == null) return null;

    String localeString = currentLocale!.languageCode;

    if (currentLocale!.countryCode != null) {
      localeString += '_${currentLocale!.countryCode!}';
    }

    return localeString;
  }

  void _getLocaleConfig() async {
    final prefs = await SharedPreferences.getInstance();
    var result = prefs.getString('localeConfig');

    try {
      if (result == null) return;

      currentLocale = _stringToLocale(stringLocale: result);

      notifyListeners();
    } catch (e) {
      return;
    }
  }

  Locale _stringToLocale({required String stringLocale}) {
    Locale resultLocale;

    try {
      if (stringLocale.contains('_')) {
        var stringLocaleSplit = stringLocale.split('_');
        resultLocale = Locale(stringLocaleSplit[0], stringLocaleSplit[1]);
      } else {
        resultLocale = Locale(stringLocale);
      }

      return resultLocale;
    } on Exception catch (e) {
      log(e.toString());
      return Locale('en');
    }
  }
}
