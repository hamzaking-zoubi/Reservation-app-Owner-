import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../Widget/Reservations.dart';
import '../provider/darkTheme.dart';
import '../provider/order.dart';
class Order extends StatefulWidget {


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
      body: FutureBuilder(
        future: Provider.of<Orders>(context)
            .fetchAllOrderList(),
        builder: (context, AsyncSnapshot<List> snapshot) => snapshot
            .hasData
            ? Consumer<Orders>(
          builder: (context, value, child) => ListView.builder(
              shrinkWrap:true,
              physics:const ScrollPhysics(),
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                return Reservations(
                  id_user:snapshot.data![index].id_user ,
                  id_facility:snapshot.data![index].id_facility ,
                  id:snapshot.data![index].id ,
                  cost:snapshot.data![index].cost ,
                  create_at:snapshot.data![index].create_at ,
                  end_Date:snapshot.data![index].end_Date ,
                  start_date:snapshot.data![index].start_date ,
                );
              }),
        )
            : Center(
          child: CircularProgressIndicator(),
        ),
      ),
      
      
//      ListView.builder(
//          shrinkWrap: true,
//          physics: ScrollPhysics(),
//          itemCount: 5,
//          itemBuilder: (context, int index) {
//            return Column(
//              children: [
//                Reservations(
//                  start_date: ,
//                  end_Date: ,
//                  create_at: ,cost: ,
//                  id: ,id_facility: ,id_user: ,
//
//
//                ),
//                Divider(
//                  height: 2,
//                )
//              ],
//            );
//          }),
    );
  }
}
