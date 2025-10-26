import 'package:flutter/material.dart';

class Dimensions {
  static double screenHeight = 0;
  static double screenWidth = 0;

  static void init(BuildContext context) {
    final size = MediaQuery.of(context).size;
    screenHeight = size.height;
    screenWidth = size.width;
  }

  static double height(double inputHeight) {
    return screenHeight * (inputHeight / 812.0);
  }

  static double width(double inputWidth) {
    return screenWidth * (inputWidth / 375.0);
  }

  static double font(double inputFontSize) {
    return width(inputFontSize);
  }

  static double radius(double inputRadius) {
    return width(inputRadius);
  }

  // Optional helpers
  static double icon(double input) => width(input);
  static EdgeInsets paddingAll(double input) => EdgeInsets.all(width(input));
  static EdgeInsets paddingSym({double h = 0, double v = 0}) =>
      EdgeInsets.symmetric(horizontal: width(h), vertical: height(v));

  // Fractions of screen
  static double fracH(double fraction) => screenHeight * fraction;
  static double fracW(double fraction) => screenWidth * fraction;
}
