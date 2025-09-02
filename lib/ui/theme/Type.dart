import 'package:flutter/material.dart';

final TextTheme typography = TextTheme(
  bodyLarge: TextStyle(
    fontFamily: 'Roboto', // Flutter usa Roboto come default, ma puoi cambiare
    fontWeight: FontWeight.normal,
    fontSize: 16,
    height: 1.5, // lineHeight / fontSize = 24/16 = 1.5
    letterSpacing: 0.5,
  ),
);
/*
*ThemeData stepOnTrackTheme({required bool isDarkMode}) {
  return ThemeData(
    colorScheme: isDarkMode ? darkColorScheme : lightColorScheme,
    textTheme: typography,
    useMaterial3: true,
  );
}

* */