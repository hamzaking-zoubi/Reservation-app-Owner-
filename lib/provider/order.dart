import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:pusher_channels_flutter/pusher_channels_flutter.dart';
import 'package:pusher_client/pusher_client.dart';
import 'dart:async';
import 'dart:convert';
import 'dart:developer';


import '../notificationApi.dart';

class Order {
  final id;
  final id_facility;
  final id_user;
  final cost;
  final state;
  final start_date;
  final end_Date;
  final create_at;

  Order(this.id, this.id_facility, this.id_user, this.cost, this.state,
      this.start_date, this.end_Date, this.create_at);
}

class Orders with ChangeNotifier {
  List<Order> orders = [
    new Order("1", "1", "10", 55, true, "1/12/2022", "10/12/2022", "1/12/2022")
  ];
  static const API_KEY = "44f1ce32e7383ebc0ac1";

  static const API_CLUSTER = "ap2";
  intilize() {
    PusherOptions options = PusherOptions(
      cluster: "ap2",
    );
    PusherClient pusher = PusherClient(
      "44f1ce32e7383ebc0ac1",
      options,
      enableLogging: false,
      autoConnect: false,
    );
    pusher.connect();
    pusher.onConnectionStateChange((state) {
      print(
          "previousState: ${state!.previousState}, currentState: ${state.currentState}");
    });
    pusher.onConnectionError((error) {
      print("errornnnnn: ${error!.message}");
    });
    Channel channel = pusher.subscribe("hamza");
    channel.bind("noti", (onEvent) {
        print("-------------------------");
        final data = json.decode(onEvent!.data.toString());
        print("->>>${data}");

        NotificationApi.showNotification(
          title: data['tittle'],
          body: data['body'],
          payload: "oz.ss",
        );
        print("-------------------------");

    });

// Unsubscribe from channel
//    pusher.unsubscribe("hamza");
//
//    pusher.disconnect();
  }
}
