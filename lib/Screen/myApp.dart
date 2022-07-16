import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:project24/Screen/profile_screen.dart';
import 'package:project24/Screen/setting.dart';
import 'package:provider/provider.dart';
import '../Widget/_showErrorDialog.dart';
import '../Widget/profile_list_item.dart';
import '../constants.dart';
import '../notificationApi.dart';
import '../provider/auth.dart';

final kTitleTextStyle = TextStyle(
  fontSize: ScreenUtil().setSp(1.7 * kSpacingUnit.w),
  fontWeight: FontWeight.w600,
);

class MyAppli extends StatelessWidget {
  static const routeName = '/ProfileScreen';

  void _showErrorDialog(BuildContext context) {
    showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
              title: Text('Log Out'),
              content: Text("Are you sure"),
              actions: [
                FlatButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Text('NO')),
                FlatButton(
                    onPressed: () {
                      Provider.of<Auth>(context, listen: false)
                          .logout(context)
                          .catchError((error) {
                        showErrorDialog(error, context);
                      }).then((value) {


                      });
                    },
                    child: Text('Yes'))
              ],
            ));
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context);
    var profileInfo = Column(
      children: <Widget>[
        Container(
          height: kSpacingUnit.w * 13,
          width: kSpacingUnit.w * 13,
          margin: EdgeInsets.only(top: kSpacingUnit.w * 2),
          child:Image.asset('images/logo.png')  ,
        ),
        SizedBox(height: kSpacingUnit.w * 2),
        Text(
          'Bookify',
          style: kTitleTextStyle.copyWith(color:Theme.of(context).accentColor  ),

        ),
        SizedBox(height: kSpacingUnit.w * 0.5),
        Text(
          'Dash Bord Application',
          style: kTitleTextStyle,
        ),
        SizedBox(height: kSpacingUnit.w * 3),
      ],
    );
    return Scaffold(
      appBar: AppBar(
        title: Text("Setting"),
        backgroundColor: Theme.of(context).primaryColor,

      ),
      body: Column(
        children: <Widget>[
          SizedBox(height: kSpacingUnit.w * 1),
          profileInfo,
          Expanded(
            child: ListView(
              children: <Widget>[
                ProfileListItem(
                  icon: LineAwesomeIcons.user, //Icons.supervised_user_circle,
                  text: 'Profile',
                  onPress: () {
                    Navigator.of(context).pushNamed(ProfileScreen.routeName);
                  },
                ),
                ProfileListItem(
                  onPress: () {},
                  icon: LineAwesomeIcons.question_circle,
                  text: 'Help & Support',
                ),
                ProfileListItem(
                  onPress: () {
                    Navigator.of(context).pushNamed(SettingScreen.routeName);

                  },
                  icon: LineAwesomeIcons.cog,
                  text: 'Settings',
                ),
                ProfileListItem(
                  icon: LineAwesomeIcons.alternate_sign_out,
                  text: 'Logout',
                  hasNavigation: true,
                  onPress: () {
                    _showErrorDialog(context);
                  },
                ),
                ProfileListItem(
                  onPress: () {

                  },
                  icon: LineAwesomeIcons.question,
                  text: 'About Bookify',
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
