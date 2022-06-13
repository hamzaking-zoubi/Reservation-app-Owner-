
import 'package:flutter/material.dart';
import 'package:project24/chat/recent_chats.dart';

import 'all_chat.dart';

class ChatPage extends StatelessWidget {
  const ChatPage({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          RecentChats(),
          AllChats(),
        ],
      ),
    );
  }
}
