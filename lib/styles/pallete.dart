import 'package:flutter/material.dart';

class AppColor {
  static MaterialColor colorScheme = const MaterialColor(
    0xFFFFAE00,
    <int, Color>{
      50: Color(0xFFFFAE00),
      100: Color(0xFFFFAE00),
      200: Color(0xFFFFAE00),
      300: Color(0xFFFFAE00),
      400: Color(0xFFFFAE00),
      500: Color(0xFFFFAE00),
      600: Color(0xFFFFAE00),
      700: Color(0xFFFFAE00),
      800: Color(0xFFFFAE00),
      900: Color(0xFFFFAE00),
    },
  );

  // ignore: constant_identifier_names
  static const Color dark = Color(0xFF212121);
  static const Color accentDark = Color.fromARGB(255, 39, 39, 39);
  static const Color hintText = Color.fromARGB(255, 188, 188, 188);
  static  Color accentLight = const Color.fromARGB(255, 245, 245, 245);
  static const Color green = Color(0xff00b7e2);
  static const Color error = Color(0xFFFF1100);
  static const Color valid = Color(0xff00b7e2);
  static const Color white = Color.fromRGBO(255, 255, 255, 1);
}
