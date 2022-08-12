import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../Widget/Reservations.dart';
import '../provider/facility.dart';
import '../provider/order.dart';



class OrderToOneFacility extends StatelessWidget {
  static const String  routeName="/OrderToOneFacility";
  @override
  Widget build(BuildContext context) {
    final facilityId = ModalRoute.of(context)!.settings.arguments;
    return Scaffold(
      appBar:AppBar(
        title:Text("Reservations") ,
        backgroundColor:Theme.of(context).primaryColor ,
      ) ,
      body: FutureBuilder(
        future: Provider.of<Orders>(context)
            .fetchAndOrderList(facilityId),
        builder: (context, AsyncSnapshot<List> snapshot) => snapshot
            .hasData
            ? Consumer<Orders>(
          builder: (context, value, child) => ListView.builder(
              shrinkWrap:true,
              physics:ScrollPhysics(),

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
    );
  }
}

