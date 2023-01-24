

import 'package:flutter/material.dart';

import '../resourses/colors_app.dart';



class AppTheme{


  static  ThemeData get light=> ThemeData(
      progressIndicatorTheme: ProgressIndicatorThemeData(
          color: colorPrimary
      ),
      appBarTheme: AppBarTheme(color: colorBackground),
      textSelectionTheme: TextSelectionThemeData(cursorColor: colorPrimary)
  );


}