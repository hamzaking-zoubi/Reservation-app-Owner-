import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:project24/Screen/addFacility_screen.dart';
import 'package:project24/Screen/auth_screen.dart';
import 'package:project24/provider/chats_model.dart';
import 'package:project24/provider/darkTheme.dart';
import 'package:project24/provider/auth.dart';
import 'package:project24/provider/facility.dart';
import 'package:project24/provider/navigatorBarCange.dart';
import 'package:project24/provider/order.dart';
import 'package:project24/provider/profile.dart';
import 'package:project24/provider/reviews.dart';
import 'Screen/myApp/profile_screen.dart';
import 'provider/pusherController.dart';
import 'constants/theme_cusomized.dart';
import 'package:provider/provider.dart';
import 'Screen/myApp/aboutBookyFi.dart';
import 'Screen/homePage.dart';
import 'Screen/myApp/myApp.dart';
import 'Screen/order_to_oneFacility.dart';
import 'Screen/myApp/setting.dart';

import 'Screen/test_details_screen.dart';
import 'Widget/boutton.dart';
import 'provider/notificationApi.dart';
import 'components/splash_screen.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
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
                Facilities(auth.token ?? " ",
                    previous!.getData == null ? [] : previous.getData),
          ),
          ChangeNotifierProxyProvider<Auth, Reviews>(
            create: (_) => Reviews('', []),
            update: (BuildContext context, auth, Reviews? previous) =>
                Reviews(auth.token ?? " ",
                    previous!.getData == null ? [] : previous.getData),
          ),
          ChangeNotifierProvider(create: (context) => NavigatorBarChange()),
          ChangeNotifierProvider(create: (context) => PusherController()),
          ChangeNotifierProvider(
            create: (context) => DarkThem()..initialize(),
          ),
          ChangeNotifierProxyProvider<Auth, Orders>(
            create: (_) => Orders('', []),
            update: (BuildContext context, auth, Orders? previous) =>
                Orders(auth.token ?? " ",
                    previous!.getData == null ? [] : previous.getData),
          ),
          ChangeNotifierProvider(create: (context) => MyProfile()),
          ChangeNotifierProxyProvider<Auth, AllChat>(
            create: (_) => AllChat([], ' '),
            update: (BuildContext context, auth, AllChat? previous) => AllChat(
                previous!.allChats == null ? [] : previous.allChats,
                auth.token ?? " ",
                //auth.userId ?? " "
            ),
          ),
        ],
        child: Consumer2<Auth, DarkThem>(
            builder: (ctx, auth, them, _) => MaterialApp(
                debugShowCheckedModeBanner: false,
                // themeMode: ThemeMode.light,
                theme: them.darkTheme ? buildDarkTheme() : buildLightTheme(),
                routes: {
                  AuthScreen.routeName: (context) => AuthScreen(),
                  addFacility.routeName: (context) => addFacility(),
                  HomePage.routeName: (context) => HomePage(),
                  MainWidget.routeName: (context) => MainWidget(),
                  MyAppli.routeName: (context) => MyAppli(),
                  ProfileScreen.routeName: (context) => ProfileScreen(),
                  SettingScreen.routeName: (context) => SettingScreen(),
                  NewDetailsScreen.routeName: (context) => NewDetailsScreen(),
                  OrderToOneFacility.routeName: (context) => OrderToOneFacility(),
                  AboutBookyFy.routeName:(context)=>AboutBookyFy(),
                },
                title: 'Flutter Demo',
                home: auth.isAuth
                    ? MainWidget()
                    : FutureBuilder(
                        future: auth.tryAutoLogin(),
                        builder: (ctx, authResultSnapShot) =>
                            authResultSnapShot.connectionState == ConnectionState.waiting
                                ? SplashScreen()
                                : AuthScreen()))));
  }
}
