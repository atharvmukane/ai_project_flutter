// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'storage_manager.dart';

// 'Outfit'

class ThemeNotifier with ChangeNotifier {
//
  final lightTheme = ThemeData(
    primaryColor: const Color(0xFF975EFF),
    brightness: Brightness.light,
    fontFamily: 'Inter',
    // backgroundColor: const Color(0xFFF7F8FC),
    scaffoldBackgroundColor: const Color(0xFFF7F8FC),
    dividerColor: Colors.white54,
    disabledColor: Colors.purple[300],
    textTheme: const TextTheme(
      bodyLarge: TextStyle(fontWeight: FontWeight.w600, fontFamily: 'Inter'),
      bodyMedium: TextStyle(fontWeight: FontWeight.w500, fontFamily: 'Inter'),
      bodySmall: TextStyle(fontWeight: FontWeight.w400, fontFamily: 'Inter'),

      //   headline7: TextStyle(fontWeight: FontWeight.w600,fontFamily: 'Roboto'),
      // headline8: TextStyle(fontWeight: FontWeight.w500,fontFamily: 'Roboto'),
      // headline9: TextStyle(fontWeight: FontWeight.w400,fontFamily: 'Roboto'),
    ),
  );

  final darkTheme = ThemeData(
    primarySwatch: Colors.grey,
    primaryColor: Colors.black,
    brightness: Brightness.dark,
    fontFamily: 'Inter',
    scaffoldBackgroundColor: const Color(0xFF212121),
    disabledColor: Colors.purple[300],
    dividerColor: Colors.black12,
    textTheme: const TextTheme(),
  );

  ThemeData? _themeData;
  ThemeData? getTheme() => _themeData;

  ThemeNotifier() {
    StorageManager.readData('themeMode').then((value) {
      print('value read from storage: ' + value.toString());
      var themeMode = value ?? 'light';
      if (themeMode == 'light') {
        _themeData = lightTheme;
      } else {
        print('setting dark theme');
        _themeData = darkTheme;
      }
      notifyListeners();
    });
  }

  void setDarkMode() async {
    _themeData = darkTheme;
    StorageManager.saveData('themeMode', 'dark');
    notifyListeners();
  }

  void setLightMode() async {
    _themeData = lightTheme;
    StorageManager.saveData('themeMode', 'light');
    notifyListeners();
  }
}
