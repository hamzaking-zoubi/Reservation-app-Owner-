import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../myThem.dart';
import '../provider/chats_model.dart';
import '../provider/facility.dart';
import 'chat_room.dart';

class AllChats extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: EdgeInsets.only(top: 10),
          child: Row(
            children: [
              Text(
                'All Chats',
                style: MyTheme.heading2,
              ),
              Spacer(),
              IconButton(onPressed: () {}, icon: Icon(Icons.search_rounded))
            ],
          ),
        ),
        FutureBuilder(
            future: Provider.of<AllChat>(context).fetchAllChatList(),
            builder: ((context, AsyncSnapshot<List<Chat>> snapshot) => snapshot
                    .hasData
                ? ListView.builder(
              itemCount:snapshot.data!.length ,
                    shrinkWrap: true,
                    physics: const ScrollPhysics(),
                    itemBuilder: ((context, index) => Column(
                          children: [
                            ItemChat(
                              avatar: snapshot.data![index].avatar,
                              countNotRead: snapshot.data![index].countNotRead,
                              lastMessage: snapshot.data![index].lastMessage,
                              name: snapshot.data![index].name,
                              time: snapshot.data![index].time,
                              id: snapshot.data![index].id,
                              status: snapshot.data![index].status,
                            ),
                            const Divider(height: 2,)
                          ],
                        )))
                : const Center(
                    child: CircularProgressIndicator(),
                  ))),
      ],
    );
  }
}

class ItemChat extends StatelessWidget {
  final String lastMessage;
  final String name;
  final int countNotRead;
  final String avatar;
  final String time;
  final String id;
  final bool status;

  ItemChat(
      {required this.lastMessage,
      required this.name,
      required this.countNotRead,
      required this.avatar,
      required this.time,
      required this.id,
      required this.status
      });

  @override
  Widget build(BuildContext context) {
    var wd = MediaQuery.of(context).size.width;
    return Container(
        width: wd,
        // height:75 ,
           padding: const EdgeInsets.all(4),
        margin: const EdgeInsets.only(top: 20),
        child: Row(
          children: [
            CircleAvatar(
              radius: 28,
              backgroundImage: NetworkImage(Facilities.ApI +'${avatar}'),
            ),
            SizedBox(
              width: 20,
            ),
            GestureDetector(
              onTap: () {
                          Navigator.push(context,
                              CupertinoPageRoute(builder: (context) {
                            return ChatRoom(name:name ,id_user:id ,statuse:status ,avatar:avatar ,);
                          }));
              },
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    // width: wd / 2.25,
                    child: Text(
                      name,
                      style: MyTheme.heading2.copyWith(
                        fontSize: 16,
                      ),
                      softWrap: false,
                    ),
                  ),
                  Container(
                    width: wd / 2.25,
                    child: Text(
                      lastMessage,
                      style: MyTheme.bodyText1,
                      softWrap: false,
                    ),
                  ),
                ],
              ),
            ),
            Spacer(),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                countNotRead == 0
                    ? Icon(
                        Icons.done_all,
                        color: MyTheme.bodyTextTime.color,
                      )
                    : CircleAvatar(
                        radius: 8,
                        backgroundColor: Colors.red,
                        child: Text(
                          countNotRead.toString(),
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 11,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                SizedBox(
                  height: 10,
                ),
                Container(
                  width: wd / 8,
                  child: Text(
                    time.toString(),
                    style: MyTheme.bodyTextTime,
                    softWrap: false,
                  ),
                )
              ],
            ),
          ],
        ));
  }
}
