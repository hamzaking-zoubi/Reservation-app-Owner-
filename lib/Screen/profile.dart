import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:provider/provider.dart';
import '../Widget/profile_list_item.dart';
import '../constants.dart';
import '../provider/auth.dart';

final kTitleTextStyle = TextStyle(
  fontSize: ScreenUtil().setSp(1.7 * kSpacingUnit.w),
  fontWeight: FontWeight.w600,
);

class ProfileScreen extends StatelessWidget {
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
                      Provider.of<Auth>(context, listen: false).logout(context);
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
          height: kSpacingUnit.w * 10,
          width: kSpacingUnit.w * 10,
          margin: EdgeInsets.only(top: kSpacingUnit.w * 2),
          child: InkWell(
            onTap: () {

            },
            child: Stack(
              children: <Widget>[
                CircleAvatar(
                  radius: kSpacingUnit.w * 5,
                  backgroundImage: AssetImage('assets/images/bp_avatar.png'),
                ),
                Align(
                  alignment: Alignment.bottomRight,
                  child: Container(
                    height: kSpacingUnit.w * 2.5,
                    width: kSpacingUnit.w * 2.5,
                    decoration: BoxDecoration(
                      color: Theme.of(context).accentColor,
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      heightFactor: kSpacingUnit.w * 1.5,
                      widthFactor: kSpacingUnit.w * 1.5,
                      child: Icon(
                        LineAwesomeIcons.pen,
                        color: kPrimaryColor,
                        size: ScreenUtil().setSp(kSpacingUnit.w * 1.5),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        SizedBox(height: kSpacingUnit.w * 2),
        Text(
          'Nicolas Adams',
          style: kTitleTextStyle,
        ),
        SizedBox(height: kSpacingUnit.w * 0.5),
        Text(
          'nicolasadams@gmail.com',
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
                  icon:LineAwesomeIcons.user ,  //Icons.supervised_user_circle,
                  text: 'Profile',
                  onPress: () {},
                ),
                ProfileListItem(
                  onPress: () {},
                  icon: LineAwesomeIcons.question_circle,
                  text: 'Help & Support',
                ),
                ProfileListItem(
                  onPress: () {},
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
                  onPress: () {},
                  icon: LineAwesomeIcons.orcid,
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
