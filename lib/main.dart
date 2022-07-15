import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:project24/Screen/addFacility_screen.dart';
import 'package:project24/Screen/auth_screen.dart';
import 'package:project24/provider/darkTheme.dart';
import 'package:project24/provider/auth.dart';
import 'package:project24/provider/facility.dart';
import 'package:project24/provider/navigatorBarCange.dart';
import 'package:project24/provider/order.dart';
import 'package:project24/provider/profile.dart';
import 'package:project24/pusherController.dart';
import 'package:project24/theme_cusomized.dart';
import 'package:provider/provider.dart';
import 'package:pusher_client/pusher_client.dart';
import 'package:workmanager/workmanager.dart';
import 'Screen/facility_details_screen.dart';
import 'Screen/homePage.dart';
import 'Screen/myApp.dart';
import 'Screen/profile_screen.dart';
import 'Widget/boutton.dart';
import 'notificationApi.dart';
import 'splash_screen.dart';

//import 'package:timezone/data/latest.dart' as tz;
//const simplePeriodicTask = "simplePeriodicTask";
//
//void callbackDispatcher() {
//  Workmanager().executeTask((task, inputData) {
//
//    print("------------------------------------");
//   // print( PusherController().eventStream.toString());
//    print("------------------------------------");
//    return Future.value(true);
//  });
//}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  //tz.initializeTimeZones();
  print("----------1------------");
//  Workmanager().initialize(callbackDispatcher,
//     isInDebugMode: true ,
//    // If enabled it will post a notification whenever the task is running. Handy for debugging tasks
//      );
//
//  Workmanager().registerPeriodicTask("5",
//      simplePeriodicTask,
//
//      // When no frequency is provided the default 15 minutes is set.
//      // Minimum frequency is 15 min. Android will automatically change your frequency to 15 min if you have configured a lower frequency.
//      existingWorkPolicy: ExistingWorkPolicy.replace,
//      frequency: Duration(minutes: 15),
//      //when should it check the link
//      initialDelay: Duration(seconds: 5),
//      //duration before showing the notification
//      constraints: Constraints(
//        networkType: NetworkType.connected,
//      ));
  print("----------------------");
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
          ChangeNotifierProvider(create: (context) => NavigatorBarChange()),
          ChangeNotifierProvider(
            create: (context) => DarkThem()..initialize(),
          ),
          ChangeNotifierProvider(create: (context) => Orders()),
          ChangeNotifierProvider(create: (context) => MyProfile()),
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
                  DetailScreen.routeName: (context) => DetailScreen(),
                  MyAppli.routeName: (context) => MyAppli(),
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
        )
    );
  }
}
