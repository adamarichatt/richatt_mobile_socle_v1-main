import 'package:flutter/material.dart';
import 'package:richatt_mobile_rimeet/utils/theme/custom_themes/appbar_theme.dart';
import 'package:richatt_mobile_rimeet/utils/theme/custom_themes/bottom_sheet_theme.dart';
import 'package:richatt_mobile_rimeet/utils/theme/custom_themes/checkbox_theme.dart';
import 'package:richatt_mobile_rimeet/utils/theme/custom_themes/chip_theme.dart';
import 'package:richatt_mobile_rimeet/utils/theme/custom_themes/elevated_button_theme.dart';
import 'package:richatt_mobile_rimeet/utils/theme/custom_themes/outline_button_theme.dart';
import 'package:richatt_mobile_rimeet/utils/theme/custom_themes/text_field_theme.dart';
import 'package:richatt_mobile_rimeet/utils/theme/custom_themes/text_theme.dart';

class RAppTheme {
  RAppTheme._();

  static ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    fontFamily: 'poppins',
    brightness: Brightness.light,
    primaryColor: Colors.blue,
    textTheme: RTextTheme.lightTextTheme,
    chipTheme: RChipTheme.lightChipTheme,
    scaffoldBackgroundColor: Colors.white,
    appBarTheme: RAppBarTheme.lightAppBarTheme,
    checkboxTheme: RCheckboxTheme.lightCheckboxTheme,
    bottomSheetTheme: RBottomSheetTheme.lightBottomSheetTheme,
    elevatedButtonTheme: RElevatedButtonTheme.lightElevatedButtonTheme,
    outlinedButtonTheme: ROutlinedButtonTheme.lightOutlinedButtonTheme,
    inputDecorationTheme: RTextFormFieldTheme.lightInputDecorationTheme,
  );
  static ThemeData darkTheme = ThemeData(
    useMaterial3: true,
    fontFamily: 'poppins',
    brightness: Brightness.dark,
    primaryColor: const Color.fromARGB(255, 20, 83, 210),
    textTheme: RTextTheme.darkTextTheme,
    chipTheme: RChipTheme.darkChipTheme,
    scaffoldBackgroundColor: Colors.black,
    appBarTheme: RAppBarTheme.darkAppBarTheme,
    checkboxTheme: RCheckboxTheme.darkCheckboxTheme,
    bottomSheetTheme: RBottomSheetTheme.darkBottomSheetTheme,
    elevatedButtonTheme: RElevatedButtonTheme.darkElevatedButtonTheme,
    outlinedButtonTheme: ROutlinedButtonTheme.darkOutlinedButtonTheme,
    inputDecorationTheme: RTextFormFieldTheme.darkInputDecorationTheme,
  );
}
