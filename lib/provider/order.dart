import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';

class Order {
  final id;
  final id_facility;
  final  id_user;
  final cost;
  final state;
  final start_date;
  final end_Date;
  final create_at;

  Order(this.id, this.id_facility, this.id_user, this.cost, this.state,
      this.start_date, this.end_Date, this.create_at);
}

class Orders with ChangeNotifier{
  List<Order>orders=[
    new Order("1", "1", "10", 55, true, "1/12/2022", "10/12/2022","1/12/2022" )







  ];
}