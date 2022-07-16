import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
//import 'package:intl/intl.dart';

class Review extends StatelessWidget {
  static const _STAR_ICON = 'assets/icons/home_screen/bp_star_icon.svg';
  final DateTime time = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.0),
      child: Column(
        children: [
          Row(
            children: [
              CircleAvatar(
                backgroundImage: AssetImage('assets/images/bp_avatar.png'),
                radius: 20,
              ),
              SizedBox(
                width: 8,
              ),
              Text(
                'Anas Bakkar',
                style: TextStyle(
                  fontSize: 14,
                ),
              )
            ],
          ),
          SizedBox(
            height: 8,
          ),
          Row(children: [
            for (int i = 0; i < 4; i++) SvgPicture.asset(_STAR_ICON, height: 20),
            SizedBox(
              width: 12,
            ),
            Text(
            //  '${DateFormat.yMMMd().format(time)}',
              "DataForm",
              style: TextStyle(fontSize: 14),
            )
          ]),
          SizedBox(
            height: 8,
          ),
          Text(
              'Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exertion ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voltate velit esse cillum dolore eu fugiat nulla pariatur anim id est laborum.',
          style: TextStyle(fontSize: 12),
          ),
        ],
      ),
    );
  }
}
