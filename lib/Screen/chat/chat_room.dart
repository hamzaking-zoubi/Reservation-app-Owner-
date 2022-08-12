import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../components/time_ago.dart';
import '../../constants/myThem.dart';
import '../../provider/chats_model.dart';
import '../../provider/facility.dart';
import '../../provider/message_model.dart';
import '../../provider/pusherController.dart';


class ChatRoom extends StatefulWidget {
  @override
  _ChatRoomState createState() => _ChatRoomState();
  final String name;
  final id;
  final countNotRead;
  final String id_recipient;
  final bool statuse;
  final String avatar;

  ChatRoom(
      {required this.countNotRead,
      required this.id,
      required this.name,
      required this.id_recipient,
      required this.statuse,
      required this.avatar});
}

class _ChatRoomState extends State<ChatRoom> {
  final ScrollController _scrollController = ScrollController();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _controller = TextEditingController();

  final Map<String, dynamic> _formData = {'message': ''};
  late final PusherController pusher;
  var _isInt = true;
  var _isLoading = false;
  String? myId;

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    if (_isInt) {
      setState(() {
        _isLoading = true;
      });

      pusher = Provider.of<PusherController>(context);
      pusher.getMyId().then((value) {
        myId = value;
        print("id:::::::::::::::${myId}");
        print("id_recipinet:::::::::::::::${widget.id_recipient}");
        pusher.setEventName("ChatEvent");
        pusher.setChannelName("private-Room.Chat.${myId}");
        pusher.TheSender = widget.id_recipient;
        pusher.nameSender = widget.name;
        pusher.subscribePusher();
      });
      pusher.fetchMessageList(widget.id_recipient).then((value) {
        pusher.readMessage(widget.id_recipient);
        Provider.of<AllChat>(context, listen: false)
            .setCountNotReadZero(widget.id);
      }).catchError((error) {
        print("error in didChangeDependencies chatRoom${error}");
      }).then((_) {
        setState(() {
          _isLoading = false;
        });
      });
    }
    _isInt = false;
  }

  void sendMessage(controller, String id_recipient) {
    _formKey.currentState!.save();
    pusher.sendMessage(_formData['message'], id_recipient);
    controller.clear();
    _scrollController.animateTo(
      0.0,
      curve: Curves.easeOut,
      duration: const Duration(milliseconds: 300),
    );
  }

  Future<void> onRefresh() async {
    if(pusher.nextUrl!=null) {
      pusher.fetchNextMatched(widget.id_recipient);
    }
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            if (Navigator.canPop(context)) {
              pusher.disconnectPusher();
              Navigator.of(context).pop();
            }
          },
        ),
        toolbarHeight: height / 12,
        backgroundColor: Theme.of(context).primaryColor,
        centerTitle: false,
        title: Row(
          children: [
            Center(
              child: CircleAvatar(
                radius: 30,
                backgroundImage:
                    NetworkImage(Facilities.ApI + '${widget.avatar}'),
              ),
            ),
            SizedBox(
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
      ),
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: Column(
          children: <Widget>[
            Expanded(
              child: Container(
                child: _isLoading
                    ? Center(child: CircularProgressIndicator())
                    : RefreshIndicator(
                        onRefresh: onRefresh,
                        child: ListView.builder(
                          physics: const AlwaysScrollableScrollPhysics(),
                          controller: _scrollController,
                          reverse: true,
                          padding: EdgeInsets.only(top: 15.0),
                          itemCount: pusher.messages.length,
                          itemBuilder: (BuildContext context, int index) {
                            final Message message = pusher.messages[index];
                            bool isMe = false;
                            if (myId == message.id_send) {
                              isMe = true;
                            }
                            if (message.isRead == false) {
                              pusher.setIsReadKnow(message);
                            }
                            return Conversation(
                              time: message.time,
                              image: widget.avatar,
                              isMe: isMe,
                              message: message.message,
                            );
                          },
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

  Container buildChatComposer() {
    return Container(
      padding: EdgeInsets.only(left: 20, right: 20, bottom: 10, top: 10),
      //color: Colors.white,
      //height: 100,
      child: Row(
        children: [
          Expanded(
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 14),
              height: 60,
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(30),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.emoji_emotions_outlined,
                    color: Colors.grey[500],
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Expanded(
                    child: Form(
                      key: _formKey,
                      child: TextFormField(
                        controller: _controller,
                        textCapitalization: TextCapitalization.sentences,
                        onSaved: (value) {
                          _formData['message'] = value;
                        },
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: 'Type your message ...',
                          hintStyle: TextStyle(color: Colors.grey[500]),
                        ),
                      ),
                    ),
                  ),
                  Icon(
                    Icons.attach_file,
                    color: Colors.grey[500],
                  )
                ],
              ),
            ),
          ),
          SizedBox(
            width: 16,
          ),
          InkWell(
            onTap: () {
              sendMessage(_controller, widget.id_recipient);
            },
            child: CircleAvatar(
              // backgroundColor: MyTheme.kAccentColor,
              child: Icon(
                Icons.send,
                color: Colors.white,
              ),
            ),
          )
        ],
      ),
    );
  }
}

class Conversation extends StatelessWidget {
  final bool isMe;
  final String image;
  final String message;
  final String time;

  const Conversation(
      {Key? key,
      required this.isMe,
      required this.image,
      required this.message,
      required this.time})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 10),
      child: Column(
        children: [
          Row(
            mainAxisAlignment:
                isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              if (!isMe)
                CircleAvatar(
                  radius: 15,
                  backgroundImage: NetworkImage(Facilities.ApI + '${image}'),
                ),
              const SizedBox(
                width: 10,
              ),
              Padding(
                padding: isMe
                    ? const EdgeInsets.only(right: 3)
                    : const EdgeInsets.only(right: 0),
                child: Container(
                  padding: const EdgeInsets.all(10),
                  constraints: BoxConstraints(
                      maxWidth: MediaQuery.of(context).size.width * 0.6),
                  decoration: BoxDecoration(
                      color: isMe ? MyTheme.kAccentColor : Colors.grey[200],
                      borderRadius: BorderRadius.only(
                        topLeft: const Radius.circular(16),
                        topRight: const Radius.circular(16),
                        bottomLeft: Radius.circular(isMe ? 12 : 0),
                        bottomRight: Radius.circular(isMe ? 0 : 12),
                      )),
                  child: Text(
                    message,
                    softWrap: true,
                    style: MyTheme.bodyTextMessage.copyWith(
                        color: isMe ? Colors.white : Colors.grey[800]),
                  ),
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.only(top: 5, right: 4),
            child: Row(
              mainAxisAlignment:
                  isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
              children: [
                if (!isMe)
                  SizedBox(
                    width: 40,
                  ),
                Icon(
                  Icons.done_all,
                  size: 20,
                  //  color: MyTheme.bodyTextTime.color,
                ),
                SizedBox(
                  width: 8,
                ),
                // TimeAgo.isSameDay(time)
                //  ? Container()
                //  :
                Container(
                  child: Text(
                    "${TimeAgo.timeAgoSinceDate(time)}",
                    // TimeAgo.timeAgoSinceDate(time.timeStamp),
                    // time.toString(),
                    style: MyTheme.bodyTextTime,
                    softWrap: false,
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
