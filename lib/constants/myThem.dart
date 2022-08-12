import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
class MyTheme {
  MyTheme._();
  static Color kPrimaryColor = Color(0xFF003580);
//  static Color kPrimaryColorVariant = Color(0xff686795);
  static final kPrimaryDarkenColor = Color(0xFF2D3142);
  static Color kAccentColor = Color(0xFF1F87FE);

  static final TextStyle kAppTitle = GoogleFonts.grandHotel(fontSize: 36);

  static final TextStyle bodyTextMessage =
  TextStyle(fontSize: 13, letterSpacing: 1.5, fontWeight: FontWeight.w600);

  static final TextStyle  headline5= TextStyle(
  color: kPrimaryColor,
  fontSize: 15,
  fontFamily: 'Rubik',
  fontWeight: FontWeight.normal);



  static final TextStyle headline6= TextStyle(
  color: kPrimaryColor,
  fontSize: 18,
  fontFamily: 'Rubik',
  fontWeight: FontWeight.bold);

  static final TextStyle heading2 = TextStyle(
    color: Color(0xff686795),
    fontSize: 18,
    fontWeight: FontWeight.w600,
   // letterSpacing: 1.5,
    wordSpacing: 1.5
  );
  static final TextStyle bodyText1 = TextStyle(
      color: Color(0xffAEABC9),
      fontSize: 14,
     // letterSpacing: 1.2,
      fontWeight: FontWeight.w500);

  static final TextStyle bodyTextTime = TextStyle(
    fontStyle: FontStyle.italic,
    color: Color(0xffAEABC9),
    fontSize: 11,
    fontWeight: FontWeight.bold,
    letterSpacing: 1,
  );
  static final TextStyle chatSenderName = TextStyle(
    color: Colors.white,
    fontSize: 24,
    fontWeight: FontWeight.bold,
    letterSpacing: 1.5,
  );
}