import 'package:flutter/material.dart';

const Color purple40 = Color(0xFF6650a4);
const Color purple80 = Color(0xFFD0BCFF);
const Color purpleGrey40 = Color(0xFF625b71);
const Color purpleGrey80 = Color(0xFFCCC2DC);
const Color pink40 = Color(0xFF7D5260);
const Color pink80 = Color(0xFFEFB8C8);

final ColorScheme lightColorScheme = ColorScheme(
  brightness: Brightness.light,
  primary: purple40,
  onPrimary: Colors.white,
  secondary: purpleGrey40,
  onSecondary: Colors.white,
  tertiary: pink40,
  onTertiary: Colors.white,
  background: Colors.white,
  onBackground: Colors.black,
  surface: Colors.white,
  onSurface: Colors.black,
  error: Colors.red,
  onError: Colors.white,
);

final ColorScheme darkColorScheme = ColorScheme(
  brightness: Brightness.dark,
  primary: purple80,
  onPrimary: Colors.black,
  secondary: purpleGrey80,
  onSecondary: Colors.black,
  tertiary: pink80,
  onTertiary: Colors.black,
  background: Colors.black,
  onBackground: Colors.white,
  surface: Colors.black,
  onSurface: Colors.white,
  error: Colors.red.shade400,
  onError: Colors.black,
);

ThemeData stepOnTrackTheme({required bool isDarkMode}) {
  return ThemeData(
    colorScheme: isDarkMode ? darkColorScheme : lightColorScheme,
    useMaterial3: true,
    // Aggiungi qui la tipografia se vuoi
  );
}
/*
* MaterialApp(
  theme: stepOnTrackTheme(isDarkMode: false),   // Light theme
  darkTheme: stepOnTrackTheme(isDarkMode: true), // Dark theme
  themeMode: ThemeMode.system, // O ThemeMode.light / ThemeMode.dark
  home: MyHomePage(),
)

* */