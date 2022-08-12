import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:project24/provider/facility.dart';

import '../components/time_ago.dart';
//import 'package:intl/intl.dart';

class ReviewItem extends StatelessWidget {
  static const _STAR_ICON = 'assets/icons/home_screen/bp_star_icon.svg';
  final id;
  final id_facility;
  final id_user;
  final comment;
  final rate;
  final time;
  final name;
  final path_photo;

  ReviewItem(
      {required this.id,
      required this.id_facility,
      required this.id_user,
      required this.comment,
      required this.rate,
      required this.time,
      required this.name,
      required this.path_photo});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.0),
      child: Column(
        children: [
          Row(
            children: [
              CircleAvatar(
                backgroundImage: NetworkImage(Facilities.ApI + path_photo),
                radius: 20,
              ),
              SizedBox(
                width: 8,
              ),
              Text(
                name,
                style: TextStyle(
                  fontWeight:FontWeight.bold ,
                  fontSize: 17,
                ),
              )
            ],
          ),
          SizedBox(
            height: 8,
          ),
          Row(children: [
            for (int i = 0; i < rate; i++)
              SvgPicture.asset(_STAR_ICON, height: 20),
            SizedBox(
              width: 12,
            ),
            Text(
              "${TimeAgo.timeAgoSinceDate(time)}",
              style: TextStyle(fontSize: 14),
            )
          ]),
          SizedBox(
            height: 8,
          ),
          Align(
            alignment:Alignment.topLeft ,
            child: Text(
              comment,
              style: TextStyle(fontSize: 16
              ,color:Colors.black
              ),
            ),
          ),
        ],
      ),
    );
  }
}
