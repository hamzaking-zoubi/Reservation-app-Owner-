import 'package:flutter/material.dart';

import '../chat/all_chat.dart';
import '../myThem.dart';

class ChatScreen extends StatefulWidget {
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,

        title: Center(
          child: Text(
            'Chattie',
            style: MyTheme.kAppTitle,
          ),
        ),

        elevation: 0,
      ),
      backgroundColor: Theme.of(context).primaryColor,
      body: Column(
        children: [
          Expanded(
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 20),
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30),
                  )),
              child: AllChats(),
            ),
          )
        ],
      ),

    );
  }
}
