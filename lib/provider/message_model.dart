import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import './chats_model.dart';
import 'facility.dart';

class Message {
  final String id;
  final String id_send;
  final String id_recipient;
  final String time;
  final bool isRead;
  final String message;

  Message(
      {required this.id,
      required this.id_send,
      required this.id_recipient,
      required this.time,
      required this.isRead,
      required this.message});

  factory Message.fromJson(Map<String, dynamic> json) => Message(
      time: json['created_at'].toString(),
      id: json['id'].toString(),
      message: json['message'].toString(),
      id_send: json['id_send'],
      id_recipient: json['id_send'].toString(),
      isRead: json['read_at']);
}

class AllMessage with ChangeNotifier {
  List<Message> _allMessage = [];

  Future<List<Message>> fetchAllMessageList(id_recipient) async {
    var API = Facilities.ApI + "api/chat/show";
    // var auth = "Bearer" + " " + authToken;
    var auth = "Bearer" + " " + '72|e7caUjGJKQTHaTgirPDKzxCnWvY5YjYNb0vvsre5';
    Map<String, String> headers = {
      'Authorization': auth,
      'X-Requested-With': ' XMLHttpRequest ',
      'Accept': 'application/json',
      'Content-Type': 'application/json',
    };
    print(auth);
    final List<Message> _loadMessage = [];
    try {
      var queryParameters = {"id_recipient": id_recipient.toString()};

      var uri =
          Uri.https('192.168.1.108:8000', '/api/chat/show', queryParameters);

      final response = await http.get(uri, headers: headers);
      // final response = await http.get(Uri.parse(API), headers: headers);
      final extractData = json.decode(response.body);
      print('------------------------------------');
      print(extractData);
      print('------------------------------------');

      final data = (extractData['messages'] as List)
          .map((data) => Message.fromJson(data))
          .toList();
      _loadMessage.addAll(data);
      print("zzzzzlength:${_loadMessage.length}");
      _allMessage.clear();
      _allMessage.addAll(_loadMessage);
    } catch (error) {
      print("error fetchAllMessageList==>> ${error}");
      throw error;
    }
    return _loadMessage;
  }

  broadcast( message) async {
    var API = Facilities.ApI + "api/chat/send";
    // var auth = "Bearer" + " " + authToken;
    var auth = "Bearer" + " " + '72|e7caUjGJKQTHaTgirPDKzxCnWvY5YjYNb0vvsre5';
    Map<String, String> headers = {
      'Authorization': auth,
      'X-Requested-With': ' XMLHttpRequest ',
      'Accept': 'application/json',
      'Content-Type': 'application/json',
    };
    Map<String, dynamic> body = {
      "id_recipient": message.id_recipient,
      "message": message.message
    };

    print(auth);
    try{
    final response = await http.post(Uri.parse(API), headers: headers, body: body);
    print(response);
  }catch(error){
      print(error);
      throw error;
    }

  }

  List<Message> get allMessage => [..._allMessage];

  findById(id) {
    return _allMessage.indexWhere((element) => element.id == id);
  }
}
