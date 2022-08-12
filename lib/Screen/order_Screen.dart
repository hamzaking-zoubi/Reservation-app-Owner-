import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../Widget/Reservations.dart';
import '../provider/darkTheme.dart';
class Order extends StatefulWidget {
  final payload;

  Order({this.payload});

  @override
  _OrderState createState() => _OrderState();
}

class _OrderState extends State<Order> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        title: Text('Order'),
      ),
      body: ListView.builder(
          shrinkWrap: true,
          physics: ScrollPhysics(),
          itemCount: 5,
          itemBuilder: (context, int index) {
            return Column(
              children: [
//                Reservations(
//                  start_date: ,
//                  end_Date: ,
//                  create_at: ,cost: ,
//                  id: ,id_facility: ,id_user: ,
//
//
//                ),
                Divider(
                  height: 2,
                )
              ],
            );
          }),
    );
  }
}
