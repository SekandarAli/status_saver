import 'package:flutter/material.dart';

 class ColorsTheme{
   static Color textColor = Colors.black.withOpacity(0.7);
   static MaterialColor themeColorOld = Colors.deepOrange;
   static Color themeColor = Color(0xffc3ff00);
   static Color dismissColor = Colors.red;
   static  Color primaryColor = Color(0xff067d70);
   static Color lightGrey = Colors.grey.shade400;
   static Color black = Colors.black;
   static Color white = Colors.white;
   static Color backgroundColor = Colors.grey.shade200;
   static Color buttonColor = Colors.blue.shade400;
 }


class Palette {
  static const MaterialColor kToDark = MaterialColor(
    0xff067d70, // 0% comes in here, this will be color picked if no shade is selected when defining a Color property which doesn’t require a swatch.
    <int, Color>{
      50: Color(0xff067d70 ),//10%
      100: Color(0xff067d70),//20%
      200: Color(0xff067d70),//30%
      300: Color(0xff067d70),//40%
      400: Color(0xff067d70),//50%
      500: Color(0xff067d70),//60%
      600: Color(0xff067d70),//70%
      700: Color(0xff067d70),//80%
      800: Color(0xff067d70),//90%
      900: Color(0xff067d70),//100%
    },
  );
}