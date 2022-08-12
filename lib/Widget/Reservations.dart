import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../constants/myThem.dart';

class Reservations extends StatelessWidget {
  final id;
  final id_facility;
  final id_user;
  final cost;
  final start_date;
  final end_Date;
  final create_at;


  Reservations({required this.id,required this.id_facility,
    required this.id_user,required this.cost,
    required  this.start_date,required this.end_Date,required this.create_at
  });

  @override
  Widget build(BuildContext context) {
    var wd = MediaQuery.of(context).size.width;
    return Container(
        width: wd,
        height: 75,
        padding: const EdgeInsets.all(4),
        margin: const EdgeInsets.only(top: 20),
        child: Row(
          children: [
            CircleAvatar(
              radius: 28,
              backgroundImage: AssetImage("assets/images/bp_avatar.png"),
            ),
            SizedBox(
              width: 20,
            ),
            GestureDetector(
              onTap: () {
                print(wd);
//                        Navigator.push(context,
//                            CupertinoPageRoute(builder: (context) {
//                              return ChatRoom(
//                                user: recentChat.sender,
//                              );
//                            }));
              },
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Container(
                    width: wd / 2.25,
                    child: Text(
                      "SHAHER JREIDAH",
                      style: MyTheme.heading2.copyWith(
                        fontSize: 16,
                      ),
                    ),
                  ),
                  Container(
                    child: Text(
                      "Accountant",
                      style: MyTheme.bodyText1,
                    ),
                  ),
                  Container(
                    width: wd / 2.25,
                    child: Text(
                      "60 mutual Connection hanaa",
                      style: MyTheme.bodyText1,
                      softWrap: false,
                    ),
                  ),
                ],
              ),
            ),
            Spacer(),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              //  crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Container(
                    width: wd / 8,
                    height: wd / 8,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(28),
                        border: Border.all(width: 2)),
                    child: IconButton(
                      onPressed: () {},
                      icon: Icon(Icons.close),
                    )),
                SizedBox(
                  width: 5,
                ),
                Container(
                  width: wd / 8,
                  height: wd / 8,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(28),
                      border: Border.all(
                          width: 2, color: Theme.of(context).accentColor)),
                  child: IconButton(
                    onPressed: () {},
                    icon: Icon(Icons.check),
                    color: Theme.of(context).accentColor,
                  ),
                ),
              ],
            ),
          ],
        ));
  }
}