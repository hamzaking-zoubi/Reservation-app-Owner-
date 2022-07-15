import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'package:flutter/cupertino.dart';
import 'package:pusher_client/pusher_client.dart';

import 'notificationApi.dart';

//instantiate Pusher Class

class PusherController with ChangeNotifier {
  static final PusherController _pusherController = PusherController._internal();

  factory PusherController() {
    return _pusherController;
  }

  PusherController._internal();

  PusherClient? pusher;
  Channel? channel;
  StreamController<String> _eventData = StreamController<String>.broadcast();

  Sink get _inEventData => _eventData.sink;

  Stream get eventStream => _eventData.stream;
  String channelName = "hamza";
  String prevChannelName = "";
  String eventName = "noti";

  initPusher()  {
    PusherOptions options = PusherOptions(
      cluster: "ap2",
    );
    pusher = PusherClient("ed9964680b53ce88cdb8", options,

        autoConnect: true,
        enableLogging: true

    );

    print("------------11-------------");
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

    channel!.bind("noti", (onEvent) {
      print("-------------------------");
      final data = json.decode(onEvent!.data.toString());
      print("->>>${data}");
      if (onEvent.data != null) {
         NotificationApi.showNotification(
          title: "data['tittle']",
          body: "data['body']",
          payload: "oz.ss",
        );
      }

      _inEventData.add(onEvent.data);

      prevChannelName = eventName;
    });
  }

  void connectPusher() {
    pusher!.connect();
  }

  Future<void> getNo() async {
    await initPusher();
    connectPusher();
    subscribePusher();
  }

  void disconnectPusher() async {
    await channel!.unbind(eventName);
    await pusher!.disconnect();
  }
}
