import 'package:flutter/material.dart';
import 'constants.dart';

final themeCustomed = ThemeData(

    primaryColor: kPrimaryColor,
   // accentColor:kPrimaryDarkenColor ,
    backgroundColor: kBackgroundLightColor,
    scaffoldBackgroundColor: kBackgroundColor,


    textTheme: TextTheme(

        headline1: TextStyle(
            color: kPrimaryDarkenColor,
            fontSize: 40,
            fontFamily: 'Rubik',
            fontWeight: FontWeight.w500),
        headline2: TextStyle(
            color: kPrimaryDarkenColor,
            fontSize: 32,
            fontFamily: 'Rubik',
            fontWeight: FontWeight.w500),
        headline3: TextStyle(
            color: kPrimaryDarkenColor,
            fontSize: 28,
            fontFamily: 'Rubik',
            fontWeight: FontWeight.w500),
        headline4:  TextStyle(
            color: kPrimaryColor,
            fontSize: 30,
            fontFamily: 'Rubik',
            fontWeight: FontWeight.bold
        ),
        headline5: TextStyle(
            color: kPrimaryColor,
            fontSize: 15,
            fontFamily: 'Rubik',
            fontWeight: FontWeight.normal),



        headline6: TextStyle(
            color: kPrimaryColor,
            fontSize: 18,
            fontFamily: 'Rubik',
            fontWeight: FontWeight.bold),

        subtitle1:
        TextStyle( fontSize: 18, fontFamily: 'Rubik'),
        subtitle2: TextStyle(
            color: kPrimaryDarkenColor, fontSize: 14, fontFamily: 'Rubik'),
        bodyText2: TextStyle(
            color: kPrimaryColor,
            fontWeight: FontWeight.w500,
            fontSize: 10,
            fontFamily: 'Rubik'),
        bodyText1: TextStyle(
            color: kTagRentColor,
            fontWeight: FontWeight.w500,
            fontSize: 12,
            fontFamily: 'Rubik')),);

ThemeData buildLightTheme() {
    final ThemeData base = ThemeData.light();
    return base.copyWith(
//        buttonColor: Colors.redAccent,
//        cardColor: Colors.white,
//        accentColor: Colors.redAccent,
        primaryColor: kPrimaryColor,
        // accentColor:kPrimaryDarkenColor ,
        backgroundColor: kBackgroundLightColor,
        scaffoldBackgroundColor: kBackgroundColor,
    );
}

ThemeData buildDarkTheme() {
    final ThemeData base = ThemeData.dark();
    return base.copyWith(
        buttonColor: Colors.blueAccent,
        cardColor: Colors.grey[800],
        backgroundColor: Colors.grey[800],
     //   primaryColor: Colors.blue[900],
        primaryColor: Colors.blue,
        accentColor: Colors.blueAccent,
    );
}