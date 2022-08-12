import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:project24/provider/facility.dart';
import 'package:provider/provider.dart';
import 'package:pusher_channels_flutter/pusher_channels_flutter.dart';
import 'package:pusher_client/pusher_client.dart';
import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'package:http/http.dart'as http;
import 'notificationApi.dart';

class Order {
  final id;
  final id_facility;
  final id_user;
  final cost;
  final start_date;
  final end_Date;
  final create_at;

  Order(this.id, this.id_facility, this.id_user, this.cost,
      this.start_date, this.end_Date, this.create_at);
}

class Orders with ChangeNotifier {
  List<Order> _orders = [
    new Order("1", "1", "10", 55, true, "1/12/2022", "10/12/2022",)
  ];
  final String authToken;


  Orders(this.authToken, this._orders);
  List<Order> get getData {
    return [..._orders];
  }


  Future<List> fetchAndOrderList(id_facility) async {

    var API =Facilities.ApI + "api/owner/bookings/show";
    var auth = "Bearer" + " " + authToken;
    Map<String, String> headers = {
      'Authorization': auth,
      'X-Requested-With': ' XMLHttpRequest ',
      'Accept': 'application/json',
      'Content-Type': 'application/json',
    };
    print(auth);
    final List<Order> _loadFacility = [];
    try {
      final response = await http.get(Uri.parse(API), headers: headers);
      final extractData = json.decode(response.body);
      print('=======================');
      print(extractData);
      print('=======================');

      final data = (extractData['Data'] as List)
          .map((data) => Facility.fromJson(data))
          .toList();

//      _loadFacility.addAll(data);
//      print("zzzzzlength:${_facilities.length}");
//      _facilities.clear();
//      _facilities.addAll(_loadFacility);
//      //  notifyListeners();
    } catch (error) {
      print("error in fetchAndSetFacilityList::==>> ${error}");
      throw error;
    }
    return [];



    return _orders;
  }

  Order findById(id) {
    var facility;
    try {
      facility = _orders.firstWhere((element) => element.id == id);
    } catch (error) {
      print(
          "eeeeeeeeeeeeeeeeeeeeeeeeeeeerrrrrrrrrrrrrrrrrrrrrooooooooooooooorrrrrrrr${error}");
      throw error;
    }
    return facility;
  }

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
