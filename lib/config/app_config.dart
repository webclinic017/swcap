import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:google_fonts/google_fonts.dart';
import 'package:swcap/notifier/theme_notifier.dart';


class AppConfig {

  static Color kDarkColor = Color(0xff212121);
  static Color kMediumDarkColor = Color(0xff484848);
  static Color kDeepDarkColor = Color(0xff000000);


  static Color kLightColor = Color(0xffffffff);
  static Color kMediumLightColor = Color(0xffe0e0e0);
  static Color kDeepLightColor = Color(0xffaeaeae);

  static bool kIsWebs = kIsWeb;
  static bool kIsAndroid = Platform.isAndroid;
  static bool kIsWindows = Platform.isWindows;

  static ThemeData get lightTheme {
    return ThemeData(
      primaryColor: kMediumLightColor,
      scaffoldBackgroundColor: kLightColor,
      buttonTheme: ButtonThemeData(
        buttonColor: kDeepLightColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16)
        )
      )
    );
  }



  static ThemeData get darkTheme {
    return ThemeData(
      primaryColor: kMediumDarkColor,
      scaffoldBackgroundColor: kDarkColor,
      inputDecorationTheme: InputDecorationTheme(
        labelStyle: GoogleFonts.poppins(
          color: Colors.white,
        )
      ),
      textTheme: TextTheme(
        headline1: GoogleFonts.poppins(
          color: Colors.white,
        ),
        bodyText2: GoogleFonts.poppins(
          color: Colors.white
        )
      ),
      buttonTheme: ButtonThemeData(
        buttonColor: kMediumDarkColor,
        focusColor: kMediumDarkColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16)
        )
      )
    );
  }

  

}