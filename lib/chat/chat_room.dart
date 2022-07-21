import 'package:flutter/material.dart';

import '../myThem.dart';
import '../provider/chats_model.dart';
import '../provider/facility.dart';
import 'chat_composer.dart';
import 'conversation.dart';

class ChatRoom extends StatefulWidget {
  @override
  _ChatRoomState createState() => _ChatRoomState();
  final String name;
  final String id_user;
  final bool statuse;
  final String avatar;

  ChatRoom(
      {required this.name,
      required this.id_user,
      required this.statuse,
      required this.avatar});
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
              backgroundImage:
                  NetworkImage(Facilities.ApI + '${widget.avatar}'),
            ),
            const SizedBox(
              width: 20,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.name,
                  style: MyTheme.chatSenderName,
                ),
                widget.statuse
                    ? Text(
                        'online',
                        style: MyTheme.bodyText1.copyWith(fontSize: 18),
                      )
                    : Text(
                        'offline',
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
                  child: Conversation(
                    id: widget.id_user,
                  ),
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
