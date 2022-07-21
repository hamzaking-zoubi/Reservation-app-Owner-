import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'package:flutter/cupertino.dart';
import 'package:project24/provider/message_model.dart';
import 'package:pusher_client/pusher_client.dart';
import 'package:intl/intl.dart';

class PusherController with ChangeNotifier {
  static final PusherController _pusherController =
      PusherController._internal();

  factory PusherController() {
    return _pusherController;
  }

  String? _message;
  Channel? _channel;

  get message => _message;

  PusherController._internal();

  List<Message> messages = [];

  void sendMessage(String text, String id_recipient) {
    final String time = DateFormat('mm:ss a').format(DateTime.now());

    if (text != '') {
      Message mass=  Message(
          isRead: false,
          id: ' ',
          id_recipient: id_recipient,
          id_send: ' ',
          time: time,
          message: text);



      messages.insert(
        0,
          mass
      );
    //  AllMessage x;
    //x.   broadcast(mass);
      notifyListeners();
    }
  }

  PusherClient? pusher;
  Channel? channel;
  StreamController<String> _eventData = StreamController<String>.broadcast();

  Sink get _inEventData => _eventData.sink;

  Stream get eventStream => _eventData.stream;
  String channelName = "";
  String prevChannelName = "";
  String eventName = "";

  initPusher() {
    PusherOptions options = PusherOptions(
//      auth: PusherAuth(
//          headers: {
//    'Authorization': 'Bearer ',
//    'Content-Type': 'application/json',
//    'Accept': 'application/json'
//    }
//
//    ),
      cluster: "ap2",

    );
    pusher = PusherClient("98034be202413ea485fc", options,
        autoConnect: true, enableLogging: true);




  }

  void setChannelName(String name) {
    channelName = name;
    print("channelName: ${channelName}");
  }

  void setEventName(String name) {
    eventName = name;
    print("eventName: ${eventName}");
  }

  void subscribePusher() {
    channel = pusher!.subscribe(channelName);
    pusher!.onConnectionStateChange((state) {
      log("previousState: ${state!.previousState}, currentState: ${state.currentState}");
    });
    pusher!.onConnectionError((error) {
      log("error: ${error!.message}");
    });
    channel!.bind(eventName, (last) {
      print("-------------------------");
      final data = json.decode(last!.data.toString());
      if (last.data != null) {
        messages.insert(
            0,
            Message(
                time: data['message']['created_at'].toString(),
                id: data['message']['id'].toString(),
                message: data['message']['message'].toString(),
                id_send: data['message']['id_send'],
                id_recipient: data['message']['id_send'].toString(),
                isRead: data['message']['read_at']));

        notifyListeners();
      }

      _inEventData.add(last.data);
      prevChannelName = eventName;
    });
  }

  void connectPusher() {
    pusher!.connect();
  }

  void disconnectPusher() async {
    await channel!.unbind(eventName);
    await pusher!.disconnect();
  }
}
