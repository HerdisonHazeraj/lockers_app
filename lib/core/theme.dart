import 'dart:ui';

import 'package:flutter/material.dart';

class Styles {
  static ThemeData themeData(bool isDarkTheme, BuildContext context) {
    return ThemeData(
      dividerColor: isDarkTheme ? Colors.blueGrey : Colors.grey,
      iconTheme:
          IconThemeData(color: isDarkTheme ? Colors.white : Colors.black),
      shadowColor:
          isDarkTheme ? Color(0xff02020F) : Colors.grey.withOpacity(0.1),
      primarySwatch: Colors.red,
      primaryColor: isDarkTheme ? Color(0xff161616) : Color(0xffececf6),
      // indicatorColor: isDarkTheme ? Colors.green : Colors.blue,
      hintColor: isDarkTheme ? Color(0xff280C0B) : Color(0xffEECED3),
      // highlightColor: isDarkTheme ? Color(0xff372901) : Colors.black12,
      // hoverColor: isDarkTheme ? Color(0xff3A3A3B) : Colors.grey[50],
      // focusColor: isDarkTheme ? Color(0xff0B2512) : Color(0xffA8DAB5),
      // disabledColor: Colors.grey,
      cardColor: isDarkTheme ? Color(0xff191919) : Colors.white,
      canvasColor: isDarkTheme ? Color(0xff262626) : Colors.grey[50],
      brightness: isDarkTheme ? Brightness.dark : Brightness.light,
      buttonTheme: Theme.of(context).buttonTheme.copyWith(
          colorScheme: isDarkTheme ? ColorScheme.dark() : ColorScheme.light()),
      appBarTheme: AppBarTheme(
        elevation: 0.0,
      ),
      textSelectionTheme: TextSelectionThemeData(
          selectionColor: isDarkTheme ? Colors.white : Colors.black54),
    );
  }
}

// bool isDarkTheme = false;

class LightColorTheme {
  // static setTheme(bool newValue) {
  //   isDarkTheme = newValue;
  // }

  static Color primaryBackGroudColor = Color(0xffF5F5FD);
  static Color secondaryBackGroudColor = Colors.white;
  static Color secondary = Color(0xFF01FBCF);
  static const Color primary = Color(0xFFFB3274);
  static Color primaryTextColor = Colors.black;
  static const Color secondaryTextColor = Colors.black54;
  static const Color thirdTextColor = Colors.black38;
}

class DarkColorTheme {
  // static setTheme(bool newValue) {
  //   isDarkTheme = newValue;
  // }

  static Color primaryBackGroudColor = Color(0xFF1F1F1F);
  static Color secondaryBackGroudColor = Color(0xFF181818);
  static Color secondary = Color(0xFF01FBCF);
  static const Color primary = Color(0xFFFB3274);
  static Color primaryTextColor = Colors.white;
  static const Color secondaryTextColor = Colors.black54;
  static const Color thirdTextColor = Colors.black38;
}
