import 'package:flutter/material.dart';
import 'dark_Theme.dart';
import 'light_Theme.dart';

class ThemeProvider extends ChangeNotifier {
  //initial theme is light
  ThemeData _themeData = darkTheme;

  //getter
  ThemeData get themeData => _themeData;

  //is it dark theme
  bool get isDarkTheme => _themeData == darkTheme;

  //change theme
  set themeData(ThemeData themeData) {
    _themeData = themeData;
    notifyListeners();
  }

  //toggle theme
  void toggleTheme() {
    _themeData = isDarkTheme ? lightTheme : darkTheme;
    notifyListeners();
  }
}
