import 'dart:ui';

import 'package:flutter/material.dart';

class Styles {
  static ThemeData themeData(bool isDarkTheme, BuildContext context) {
    return ThemeData(
      elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
        elevation: 10.0,
        shadowColor: isDarkTheme ? Colors.black : Colors.grey.withOpacity(0.1),
        backgroundColor: isDarkTheme ? Color(0xff35454C) : Colors.black54,
        foregroundColor: isDarkTheme ? Colors.white : Colors.white,
      )),
      dividerColor: isDarkTheme ? Colors.blueGrey : Color(0xffCCCCCC),
      iconTheme:
          IconThemeData(color: isDarkTheme ? Colors.white : Colors.black),
      shadowColor:
          isDarkTheme ? Color(0xff02020F) : Colors.grey.withOpacity(0.1),
      primaryColor: isDarkTheme ? Color(0xff161616) : Color(0xffececf6),
      indicatorColor: isDarkTheme ? Colors.blue : Colors.blue,
      hintColor: isDarkTheme ? Colors.white : Colors.black54,
      focusColor:
          isDarkTheme ? Color(0xff020219) : Color.fromARGB(255, 218, 171, 168),
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

class ColorTheme {
  static Color secondary = Color(0xFF01FBCF);
  static const Color primary = Color(0xFFFB3274);

  static const Color secondaryTextColor = Colors.black54;
  static const Color thirdTextColor = Colors.black38;
}
