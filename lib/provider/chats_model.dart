import 'dart:convert';
import 'dart:core';
import 'package:http/http.dart' as http;
import 'package:flutter/cupertino.dart';
import 'package:project24/provider/facility.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Chat {
  final String id;
  final String time;
  final String name;
  final String lastMessage;
  final String avatar;
  final bool status;
  final String idLastMessage;
  var countNotRead;

  Chat({
    required this.id,
    required this.time,
    required this.name,
    required this.lastMessage,
    required this.avatar,
    required this.status,
    required this.idLastMessage,
    required this.countNotRead,
  });

  factory Chat.fromJson(Map<String, dynamic> json) => Chat(
      time: json['lastMessage']['created_at'].toString(),
      id: json['id'].toString(),
      name: json['profile_rec']['name'] ?? "name",
      lastMessage: json['lastMessage']['message'] ?? "....",
      avatar: json['profile_rec']['path_photo'] ?? "..",
      idLastMessage: json['profile_rec']['id_message']??"",
      status: json['profile_rec']["status"] == null ? false : json['profile_rec']["status"] == 0 ? false : true,
      countNotRead: json['countNotread'] ?? 0);
}

class AllChat with ChangeNotifier {
  List<Chat> _allChats = [];
  final String authToken;

  AllChat(this._allChats, this.authToken);

  Future<List<Chat>> fetchAllChatList() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final extractedData =
        json.decode(prefs.getString('userData')!) as Map<String, dynamic>;
    String authToken = extractedData['token'];
    var API = Facilities.ApI + "api/chat/chatsdata";
    var auth = "Bearer" + " " + authToken;
    Map<String, String> headers = {
      'Authorization': auth,
      'X-Requested-With': ' XMLHttpRequest ',
      'Accept': 'application/json',
    };
    print(auth);
    final List<Chat> _loadChat = [];
    try {
      final response = await http.get(Uri.parse(API), headers: headers);
      final extractData = json.decode(response.body);
      print('----------------------////--------------');
      print(extractData);
      print('---------------------////-------');

      final data = (extractData['chats'] as List)
          .map((data) => Chat.fromJson(data))
          .toList();
      _loadChat.addAll(data);
      print("zzzzzlength:${_loadChat.length}");
      _allChats.clear();
      _allChats.addAll(_loadChat);
    } catch (error) {
      print("error fetchAllChatList==>> ${error}");
      throw error;
    }
    return _loadChat;
  }

  List<Chat> get allChats => [..._allChats];

  setCountNotReadZero(id) {
    print("iddddddddddddddddddddddddddddddd${id}");
    Chat chat = allChats.firstWhere((element) => element.id == id);
    if (chat != null) {
      chat.countNotRead = 0;
      notifyListeners();
    }
  }

  findById(id) {
    return allChats.indexWhere((element) => element.id == id);
  }
}
