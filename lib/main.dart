import 'package:flutter/material.dart';

import 'package:project24/Screen/addFacility_screen.dart';
import 'package:project24/Screen/auth_screen.dart';
import 'package:project24/provider/darkTheme.dart';
import 'package:project24/provider/auth.dart';
import 'package:project24/provider/facility.dart';
import 'package:project24/provider/navigatorBarCange.dart';
import 'package:project24/theme_cusomized.dart';
import 'package:provider/provider.dart';

import 'Screen/facility_details_screen.dart';
import 'Screen/homePage.dart';
import 'Screen/profile.dart';
import 'Widget/boutton.dart';
import 'splash_screen.dart';
void main() async {

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (context) => Auth()),
          ChangeNotifierProxyProvider<Auth, Facilities>(
            create: (_) => Facilities('', []),
            update: (BuildContext context, auth, Facilities? previous) =>
                Facilities(auth.token!,
                    previous!.getData == null ? [] : previous.getData),
          ),
          ChangeNotifierProvider(create: (context) => NavigatorBarChange()),
          ChangeNotifierProvider( create:(context)=> DarkThem(),),

        ],
        child: Consumer2<Auth,DarkThem>(
            builder: (ctx, auth,them ,_) =>

              MaterialApp(
              debugShowCheckedModeBanner: false,
              themeMode: ThemeMode.light,
              theme: them.darkTheme ? buildDarkTheme() : buildLightTheme(),
             // themeCustomed,
              routes: {
                AuthScreen.routeName: (context) => AuthScreen(),
                addFacility.routeName: (context) => addFacility(),
                HomePage.routeName: (context) => HomePage(),
                MainWidget.routeName: (context) => MainWidget(),
                DetailScreen.routeName: (context) => DetailScreen(),
                ProfileScreen.routeName: (context) => ProfileScreen(),
              },
              title: 'Flutter Demo',
              home: auth.isAuth
                  ? MainWidget()
                  : FutureBuilder(
                      future: auth.tryAutoLogin(),
                      builder: (ctx, authResultSnapShot) =>
                          authResultSnapShot.connectionState == ConnectionState.waiting
                              ? SplashScreen()
                              : AuthScreen()
              )
          )
        ));
  }
}
