//import 'package:circular_profile_avatar/circular_profile_avatar.dart';
import 'package:flutter/material.dart';
import 'package:project24/Widget/top_bar.dart';
import '../constants/constants.dart';
import '../components/custom_clipper.dart';

class StackContainer extends StatelessWidget {

  final userName;
  final userImage;

  const StackContainer({
    this.userName,
    this.userImage
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 300.0,
      child: Stack(
        children: <Widget>[
          Container(),
          ClipPath(
            clipper: MyCustomClipper(),
            child: Container(
              height: 300.0,
              color: Theme.of(context).primaryColor,
              /*decoration: BoxDecoration(
                image: DecorationImage(
                  image: NetworkImage("https://picsum.photos/200"),
                  fit: BoxFit.cover,
                ),
              ),*/
            ),
          ),
          Align(
            alignment: Alignment(0, 1),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                CircleAvatar(
                  backgroundImage : /*NetworkImage(onlineApi + userImage) != null ? NetworkImage(onlineApi + userImage) :*/ NetworkImage('https://i.pravatar.cc/300'),//NetworkImage('https://i.pravatar.cc/300'),
                  radius: 60.0,
                  /*"https://i.pravatar.cc/300",
                  borderWidth: 4.0,
                  radius: 60.0,*/
                ),
                SizedBox(height: 10.0),
                Text(
                  '$userName',
                  style: TextStyle(
                    fontSize: 21.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                /*Text(
                  "Developer",
                  style: TextStyle(
                    fontSize: 12.0,
                    color: Colors.grey[700],
                  ),
                ),*/
              ],
            ),
          ),
          TopBar(),
        ],
      ),
    );
  }
}