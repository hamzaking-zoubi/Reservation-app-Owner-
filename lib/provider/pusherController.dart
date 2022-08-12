import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:math' as math;
import 'package:flutter/cupertino.dart';
import 'notificationApi.dart';
import 'package:project24/provider/facility.dart';
import 'package:project24/provider/message_model.dart';
import 'package:pusher_client/pusher_client.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class PusherController with ChangeNotifier {
  String? _message;
  static final PusherController _pusherController =
      PusherController._internal();

  PusherController._internal();

  factory PusherController() {
    return _pusherController;
  }

  get message => _message;
  String? nextUrl;

  List<Message> messages = [];
  PusherClient? pusher;
  Channel? channel;
  String? _TheSender;
  String? _nameSender;

  get TheSender => _TheSender;

  get nameSender => _nameSender;

  set TheSender(value) {
    _TheSender = value;
  }

  set nameSender(value) {
    _nameSender = value;
  }

  String channelName = "";
  String prevChannelName = "";
  String eventName = "";

  Future<void> fetchMessageList(id_recipient) async {
    String authToken = await getToken();
    var API = Facilities.ApI + "api/chat/show?id_recipient=${id_recipient}";
    var auth = "Bearer" + " " + authToken;
    Map<String, String> headers = {
      'Authorization': auth,
      'X-Requested-With': ' XMLHttpRequest ',
      'Accept': 'application/json',
      'Content-Type': 'application/json',
    };
    print(auth);
    final List<Message> _loadedMessage = [];

    try {
      final response = await http.get(Uri.parse(API), headers: headers);
      final extractData = json.decode(response.body);
      print('------------------------------------');
      print(extractData);
      print('------------------------------------');
      final data = (extractData['messages'] as List)
          .map((data) => Message.fromJson(data))
          .toList();
      _loadedMessage.addAll(data);
      messages = _loadedMessage;
      print('------------------------------------');
      nextUrl = extractData['url_next_page'];
      print('next url : $nextUrl');
      print('first total :  ${extractData['total_items']}\n');
      print("size massege :");
      print(messages.length);
      print('------------------------------------');
      notifyListeners();
    } catch (error) {
      print("error fetchAllMessageList==>> ${error}");
      throw error;
    }
  }

  Future<void> fetchNextMatched(id_recipient) async {
    String authToken = await getToken();
    var auth = "Bearer" + " " + authToken;
    Map<String, String> headers = {
      'Authorization': auth,
      'X-Requested-With': ' XMLHttpRequest ',
      'Accept': 'application/json',
      'Content-Type': 'application/json',
    };
    final List<Message> _loadedMessage = [];
    var next = nextUrl! + "&id_recipient=${id_recipient}";
    print(auth);
    try {
      final response = await http.get(Uri.parse(next), headers: headers);
      final extractData = json.decode(response.body);
      final data = (extractData['messages'] as List)
          .map((data) => Message.fromJson(data))
          .toList();
      _loadedMessage.addAll(data);
      messages.addAll(_loadedMessage);
      nextUrl = extractData['url_next_page'];
      notifyListeners();
    } catch (error) {
      print("error fetchNextMessageList==>> ${error}");
      throw error;
    }
  }

  Future<void> initPusher() async {
    var endpoint = Facilities.ApI + "api/broadcasting/auth";
    String authToken = await getToken();
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

  Future<String> getToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final extractedData =
        json.decode(prefs.getString('userData')!) as Map<String, dynamic>;
    String authToken = extractedData['token'];
    return authToken;
  }

  Future<String> getMyId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final extractedData =
        json.decode(prefs.getString('userData')!) as Map<String, dynamic>;
    String id = extractedData['userId'];
    return id;
  }

  void setChannelName(String name) {
    channelName = name;
    print("channelName: ${channelName}");
  }

  void setEventName(String name) {
    eventName = name;
    print("eventName: ${eventName}");
  }

  void connectPusher() {
    pusher!.connect();
  }

  void disconnectPusher() async {
    await channel!.unbind(eventName);
    await pusher!.unsubscribe(channelName);
    await pusher!.disconnect();
  }

  Future<void> broadcast(Message message) async {
    String authToken = await getToken();
    var API = Facilities.ApI + "api/chat/send";
    var auth = "Bearer" + " " + authToken;
    Map<String, String> headers = {
      'Authorization': auth,
      'X-Requested-With': ' XMLHttpRequest ',
      'Accept': 'application/json',
      'Content-Type': 'application/json',
    };
    print(auth);
    try {
      final response = await http.post(Uri.parse(API),
          headers: headers,
          body: json.encode({
            "id_recipient": message.id_recipient,
            "message": message.message.toString()
          }));
      print(json.decode(response.body));
      print(response.statusCode);
    } catch (error) {
      print("in broad cast ${error}");
      throw error;
    }
  }

  void readMessage(idMessage) async {
    String authToken = await getToken();
    var API = Facilities.ApI + "api/chat/read";
    var auth = "Bearer" + " " + authToken;
    Map<String, String> headers = {
      'Authorization': auth,
      'X-Requested-With': ' XMLHttpRequest ',
      'Accept': 'application/json',
      'Content-Type': 'application/json',
    };
    try {
      final response = await http.post(Uri.parse(API),
          headers: headers, body: json.encode({"id_send": idMessage}));
      print(json.decode(response.body));
      print(response.statusCode);
      // notifyListeners();
    } catch (error) {
      print("in read message cast ${error}");
      throw error;
    }
  }

  setIsReadKnow(Message message) {
    message.isRead = true;
    notifyListeners();
  }

  void sendMessage(String text, String id_recipient) async {
    final String time =
        DateFormat("yyyy-MM-dd HH:mm:ss").format(DateTime.now());
    if (text != '') {
      String myId = await getMyId();
      Message mess = Message(
          isRead: true,
          id: ' ',
          id_recipient: id_recipient,
          id_send: myId,
          time: time,
          message: text);
      messages.insert(0, mess);
      broadcast(mess);
      notifyListeners();
    }
  }

  void subscribePusher() async {
    await initPusher();
    connectPusher();
    channel = await pusher!.subscribe(channelName);
    pusher!.onConnectionStateChange((state) {
      log("previousState: ${state!.previousState}, currentState: ${state.currentState}");
    });
    pusher!.onConnectionError((error) {
      log("error: ${error!.message}");
    });
    channel!.bind(eventName, (last) {
      var data = json.decode(last!.data.toString());
      if (last.data != null) {
        String id = data['message']['id_send'].toString();

        if (id == _TheSender.toString()) {
          messages.insert(
              0,
              Message(
                  time: data['message']['created_at'].toString(),
                  id: data['message']['id'].toString(),
                  message: data['message']['message'].toString(),
                  id_send: data['message']['id_send'],
                  id_recipient: data['message']['id_send'].toString(),
                  isRead: true));
          readMessage(data['message']['id_send']);
          notifyListeners();
        } else {
          var random = math.Random();
          int id1 = random.nextInt(100000);
          NotificationApi.showNotification(
              body: data['message']['message'].toString(),
              id: id1,
              title: _nameSender);
        }
      }

      prevChannelName = eventName;
    });
  }
}
