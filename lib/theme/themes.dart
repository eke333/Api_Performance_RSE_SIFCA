import 'package:flutter/material.dart';

class Themes {
  static final ligthTheme = ThemeData(
      primaryColor: const Color(0xFFFFC61A),
      scaffoldBackgroundColor: const Color(0xFFF6F7FB),
      appBarTheme: const AppBarTheme(
          foregroundColor: Color(0xFFA2968A),
          elevation: 0,
          centerTitle: true,
          titleTextStyle: TextStyle(
              color: Colors.white,
              fontStyle: FontStyle.italic,
              fontSize: 24
          )
      ),
      checkboxTheme: CheckboxThemeData(
          fillColor: MaterialStateProperty.resolveWith((states) => Colors.transparent)
      ),
      cardTheme: const CardTheme(
        elevation: 0,
        color: Colors.white,
      ),
      iconTheme: const IconThemeData(
        color: Color(0xFFFFD966),
      ), colorScheme: const ColorScheme.light().copyWith(
          primary: const Color(0xFFFFC61A),
          secondary: const Color(0xFFA2968A),
      ).copyWith(background: const Color(0xFFF6F7FB))
  );
}
