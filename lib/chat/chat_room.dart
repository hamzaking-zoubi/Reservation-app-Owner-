import 'package:flutter/material.dart';

import '../myThem.dart';
import '../provider/user_model.dart';
import 'chat_composer.dart';
import 'conversation.dart';




class ChatRoom extends StatefulWidget {
  const ChatRoom({ required this.user}) ;

  @override
  _ChatRoomState createState() => _ChatRoomState();
  final User user;
}

class _ChatRoomState extends State<ChatRoom> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 100,
        centerTitle: false,
        title: Row(
          children: [
            CircleAvatar(
              radius: 30,
              backgroundImage: AssetImage(
                widget.user.avatar,
              ),
            ),
            SizedBox(
              width: 20,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.user.name,
                  style: MyTheme.chatSenderName,
                ),
                Text(
                  'online',
                  style: MyTheme.bodyText1.copyWith(fontSize: 18),
                ),
              ],
            ),
          ],
        ),
        elevation: 0,
      ),
      backgroundColor: MyTheme.kPrimaryColor,
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: Column(
          children: [
            Expanded(
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30),
                  ),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30),
                  ),
                  child: Conversation(user: widget.user),
                ),
              ),
            ),
            buildChatComposer()
          ],
        ),
      ),
    );
  }
}
