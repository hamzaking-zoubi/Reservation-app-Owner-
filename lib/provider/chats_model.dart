import 'dart:convert';
import 'dart:core';
import 'package:http/http.dart' as http ;
import 'package:flutter/cupertino.dart';
import 'package:project24/provider/facility.dart';

class Chat {
  final String id;
  final String name;
  final String lastMessage;
  final String avatar;
  final bool status;
  final String idLastMessage;
  final String time;
  final int countNotRead;
  final int current_page;
  String? url_next_page;
  String? url_first_page;
  String? url_last_page;

  Chat({
    required this.id,
    required this.name,
    required this.lastMessage,
    required this.avatar,
    required this.status,
    required this.idLastMessage,
    required this.time,
    required this.countNotRead,
    required this.current_page,
    this.url_next_page = '',
    this.url_first_page = '',
    this.url_last_page = '',
  });


  factory Chat.fromJson(Map<String, dynamic> json) =>
      Chat(
          time:json['lastMessage']['created_at'].toString(),
          id: json['id'].toString(),
          name:json['profile_rec']['name'].toString(),
          lastMessage:json['lastMessage']['message'],
          avatar:json['profile_rec']['path_photo'].toString(),
          current_page:json["current_page"]==null ? 1 :json['current_page'],
          idLastMessage:json['profile_rec']['id_message'].toString(),
          status:json['profile_rec']["status"]== 0 ? false : true,
          countNotRead: json['countNotread'] ?? 0
      );
}

class AllChat with ChangeNotifier {
  List<Chat> _allChats = [];
  final String authToken;
  //final String _userId;
  AllChat(this._allChats, this.authToken);

  Future<List<Chat>> fetchAllChatList() async {
    var API = Facilities.ApI + "api/chat/Show_all_chats";
    // var auth = "Bearer" + " " + authToken;
    var auth = "Bearer" + " " + '72|e7caUjGJKQTHaTgirPDKzxCnWvY5YjYNb0vvsre5';
    Map<String, String> headers = {
      'Authorization': auth,
      'X-Requested-With': ' XMLHttpRequest ',
      'Accept': 'application/json',
      'Content-Type': 'application/json',
    };
    print(auth);
    final List<Chat> _loadChat = [];
    try {
      final response = await http.get(Uri.parse(API), headers: headers);
      final extractData = json.decode(response.body);
      print('------------------------------------');
      print(extractData);
      print('----------------------------');

      final data = (extractData['Chats'] as List)
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
    //return [..._allChats];
  }

  List<Chat> get allChats => [..._allChats];

  findById(id) {
    return allChats.indexWhere((element) => element.id == id);
  }

}
