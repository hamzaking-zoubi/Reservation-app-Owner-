import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:project24/provider/facility.dart';
import 'package:provider/provider.dart';
import 'package:pusher_channels_flutter/pusher_channels_flutter.dart';
import 'package:pusher_client/pusher_client.dart';
import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'package:http/http.dart' as http;
import 'notificationApi.dart';

class Order {
  final id;
  final id_facility;
  final id_user;
  final cost;
  final start_date;
  final end_Date;
  final create_at;

  Order(
      {required this.id,
      required this.id_facility,
      required this.id_user,
      required this.cost,
      required this.start_date,
      required this.end_Date,
      required this.create_at});

  factory Order.fromJson(Map<String, dynamic> json) => Order(
        id: json["id"].toString(),
        id_facility: json["id_facility"].toString(),
        id_user: json["id_user"].toString(),
        cost: json["cost"]== null ? 0.0 : json['cost'].toDouble(),
        create_at: json["create_at"].toString(),
        end_Date: json["end_Date"].toString(),
        start_date: json["start_date"].toString(),
      );
}

class Orders with ChangeNotifier {
  List<Order> _orders = [];
  final String authToken;
  PusherClient? pusher;
  Channel? channel;
  Orders(this.authToken, this._orders);

  List<Order> get getData {
    return [..._orders];
  }


  Future<List> fetchOneOrderList(id_facility) async {
    var API = Facilities.ApI + "api/owner/bookings/facility?id_facility=${id_facility}";
    var auth = "Bearer" + " " + authToken;
    Map<String, String> headers = {
      'Authorization': auth,
      'X-Requested-With': ' XMLHttpRequest',
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

      final data = (extractData['bookings'] as List)
          .map((data) => Order.fromJson(data))
          .toList();

      _loadFacility.addAll(data);
//      print("zzzzzlength:${_facilities.length}");
//      _facilities.clear();
//      _facilities.addAll(_loadFacility);
//      //  notifyListeners();
    } catch (error) {
      print("error in fetchAndSetFacilityList::==>> ${error}");
      throw error;
    }
    return _loadFacility;


  }
  Future<List> fetchAllOrderList() async {
    var API = Facilities.ApI + "api/owner/bookings/show";
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

      final data = (extractData['bookings'] as List)
          .map((data) => Order.fromJson(data))
          .toList();

      _loadFacility.addAll(data);
//      print("zzzzzlength:${_facilities.length}");
//      _facilities.clear();
//      _facilities.addAll(_loadFacility);
//      //  notifyListeners();
    } catch (error) {
      print("error in fetchAndSetFacilityList::==>> ${error}");
      throw error;
    }
    return _loadFacility;
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
  Future<void> initPusher() async {
    var endpoint = Facilities.ApI + "api/broadcasting/auth";
    var auth = "Bearer" + " " + authToken;
    PusherAuth auth1 = PusherAuth(
      endpoint.trim().toString(),
      headers: {
        'Authorization': auth,
      },
    );
    PusherOptions options = PusherOptions(auth: auth1, cluster: "ap2");
    pusher = PusherClient("98034be202413ea485fc", options,
        autoConnect: false, enableLogging: true);
  }
  void connectPusher() {
    pusher!.connect();
  }

  void disconnectPusher() async {
    await channel!.unbind("eventName");
    await pusher!.unsubscribe("channelName");
    await pusher!.disconnect();
  }

  void subscribePusher() async {
    await initPusher();
    connectPusher();
    channel = await pusher!.subscribe("channelName");
    pusher!.onConnectionStateChange((state) {
      log("previousState: ${state!.previousState}, currentState: ${state.currentState}");
    });
    pusher!.onConnectionError((error) {
      log("error: ${error!.message}");
    });
    channel!.bind("eventName", (last) {
      var data = json.decode(last!.data.toString());
//      if (last.data != null) {
//        String id = data['message']['id_send'].toString();
//
//        if (id == _TheSender.toString()) {
//          messages.insert(
//              0,
//              Message(
//                  time: data['message']['created_at'].toString(),
//                  id: data['message']['id'].toString(),
//                  message: data['message']['message'].toString(),
//                  id_send: data['message']['id_send'],
//                  id_recipient: data['message']['id_send'].toString(),
//                  isRead: true));
//          readMessage(data['message']['id_send']);
//          notifyListeners();
//        } else {
//          var random = math.Random();
//          int id1 = random.nextInt(100000);
//          NotificationApi.showNotification(
//              body: data['message']['message'].toString(),
//              id: id1,
//              title: _nameSender);
//        }
//      }
//
//      prevChannelName = eventName;
    });
  }
}
