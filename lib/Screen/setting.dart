import 'package:babstrap_settings_screen/babstrap_settings_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../notificationApi.dart';
import '../provider/darkTheme.dart';
import '../theme_cusomized.dart';

class SettingScreen extends StatefulWidget {
  static const routeName = '/SettingScreen';

  @override
  _SettingScreenState createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
  bool darkState = false;
  bool isInit = true;

  @override
  void didChangeDependencies() {
    if (isInit) {
      var appModel = Provider.of<DarkThem>(context, listen: false);
      setState(() {
        darkState = appModel.darkTheme;
      });
    }
    isInit = false;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    var appModel = Provider.of<DarkThem>(context);
    return Consumer<DarkThem>(builder: (context, them, _) {
      return MaterialApp(
        debugShowCheckedModeBanner: false,
        debugShowMaterialGrid: false,
        theme: them.darkTheme ? buildDarkTheme() : buildLightTheme(),
        home: Scaffold(
          // backgroundColor: Colors.white.withOpacity(.94),
          appBar: AppBar(
            leading: IconButton(
              icon: Icon(Icons.arrow_back),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            //  automaticallyImplyLeading: true,
            title: Text(
              "Settings",
              // style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
            ),
            centerTitle: true,
            //  backgroundColor: Colors.transparent,
            //  elevation: 0,
          ),
          body: Padding(
            padding: const EdgeInsets.all(10),
            child: ListView(
              children: [
                // user card
                SimpleUserCard(
                  userName: "",
                  userProfilePic: AssetImage("images/logo.png"),
                ),
                SettingsGroup(
                  items: [
                    SettingsItem(
                      titleStyle:TextStyle(color:Colors.black87 ,fontWeight: FontWeight.bold) ,
                      onTap: () {},
                      icons: Icons.notifications,
                      iconStyle: IconStyle(),
                      title: 'Notification',
                      subtitle: "Make Bookyfi'App get notification",
                      trailing: Switch.adaptive(
                        value: true,
                        onChanged: (value) {
                          NotificationApi.showNotification(
                            title: "Oz Cohen",
                            body: "Hey!! this is my first Notification!",
                            payload: "oz.ss",
                          );
                        },
                      ),
                    ),
                    SettingsItem(
                      onTap: () {},
                      icons: Icons.fingerprint,
                      iconStyle: IconStyle(
                          //  iconsColor: Colors.white,
                          //   withBackground: true,
                          //backgroundColor: Colors.red,
                          ),
                      title: 'Privacy',
                      titleStyle:TextStyle(color:Colors.black87,fontWeight: FontWeight.bold ) ,
                      subtitle: "Lock Ziar'App to improve your privacy",
                    ),
                    SettingsItem(
                      onTap: () {},
                      icons: Icons.dark_mode_rounded,
                      iconStyle: IconStyle(
                          //     iconsColor: Colors.white,
                          //withBackground: true,
                          // backgroundColor: Colors.red,
                          ),
                      title: 'Dark mode',
                      subtitle: "Automatic",
                      titleStyle:TextStyle(color:Colors.black87,fontWeight: FontWeight.bold ) ,
                      trailing: Switch.adaptive(
                        value: darkState,
                        onChanged: (value) {
                          // appModel.darkTheme = !appModel.darkTheme;
                          //appModel.darkTheme(appModel.darkTheme );
                          setState(() {
                            darkState = value;
                            them.darkTheme = !them.darkTheme;
                          });
                        },
                      ),
                    ),
                  ],
                ),
                SettingsGroup(
                  items: [
                    SettingsItem(
                      onTap: () {},
                      icons: Icons.translate,
                      titleStyle:TextStyle(color:Colors.black87 , fontWeight: FontWeight.bold) ,
                      iconStyle: IconStyle(
                          //      backgroundColor: Colors.purple,
                          ),
                      title: 'Language ',
                      subtitle: "Change  the Language ",
                    ),
                  ],
                ),
                // You can add a settings title
//              SettingsGroup(
//                settingsGroupTitle: "Account",
//                items: [
//                  SettingsItem(
//                    onTap: () {},
//                    icons: Icons.exit_to_app_rounded,
//                    title: "Sign Out",
//                  ),
//                  SettingsItem(
//                    onTap: () {},
//                    icons: CupertinoIcons.repeat,
//                    title: "Change email",
//                  ),
//                  SettingsItem(
//                    onTap: () {},
//                    icons: CupertinoIcons.delete_solid,
//                    title: "Delete account",
//                    titleStyle: TextStyle(
//                      color: Colors.red,
//                      fontWeight: FontWeight.bold,
//                    ),
//                  ),
//                ],
//              ),
              ],
            ),
          ),
        ),
      );
    });
  }
}
