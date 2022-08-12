import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import '../constants/constants.dart';

import '../constants/constants.dart';


final kTitleTextStyle = TextStyle(
  fontSize:ScreenUtil().setSp(kSpacingUnit.w * 1.7),
  fontWeight: FontWeight.w600,
);

class ProfileListItem extends StatelessWidget {
  final IconData icon;
  final String text;
  void nothing(){}
  final bool hasNavigation;
  final onPress;
  const ProfileListItem({
    required this.icon,
    required this.text,
    this.hasNavigation = true,
    required this.onPress
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPress,
      child: Container(

        height: kSpacingUnit.w * 5.5,
        margin: EdgeInsets.symmetric(
          horizontal: kSpacingUnit.w * 3,
        ).copyWith(
          bottom: kSpacingUnit.w * 2,
        ),
        padding: EdgeInsets.symmetric(
          horizontal: kSpacingUnit.w * 2,
        ),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(kSpacingUnit.w * 3),
         border:Border.all( color:Colors.black87,width:1  )
        ),
        child: Row(
          children: <Widget>[
            Icon(
              this.icon,
              size: kSpacingUnit.w * 2.5,
            ),
            SizedBox(width: kSpacingUnit.w * 1.5),
            Text(
              this.text,
              style: kTitleTextStyle.copyWith(
                fontWeight: FontWeight.w500,
              ),
            ),
            Spacer(),
            if (this.hasNavigation)
              Icon(
                LineAwesomeIcons.angle_right,
                size: kSpacingUnit.w * 2.5,
              ),
          ],
        ),
      ),
    );
  }
}