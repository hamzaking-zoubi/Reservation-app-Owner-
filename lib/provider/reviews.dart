import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:project24/provider/facility.dart';
import 'package:http/http.dart ' as http;
import 'package:pusher_client/pusher_client.dart';

class Review {
  final id;
  final id_facility;
  final id_user;
  final comment;
  final rate;
  final time;
  final name;
  final path_photo;

  Review({required this.id,
    required this.id_facility,
    required this.id_user,
    required this.comment,
    required this.rate,
    required this.time,
    required this.name,
    required this.path_photo});

  factory Review.fromJson(Map<String, dynamic> json) =>
      Review(
          id_facility: json['id_facility'].toString(),
          rate: json["rate"] == null ? 1 : json["rate"].toDouble(),
          id_user: json['id_user'].toString(),
          id: json['id'].toString(),
          comment: json['comment'].toString(),
          name: json['user']['name'].toString(),
          path_photo: json['user']['path_photo'].toString(),
          time: json['created_at'].toString());
}

class Reviews with ChangeNotifier {
  final String authToken;
  List<Review> review = [];
  String? url_next_page;
  PusherClient? pusher;
  Channel? channel;
  String channelName = "";
  String prevChannelName = "";
  String eventName = "";

  Reviews(this.authToken, this.review);

  List<Review> get getData {
    return [...review];
  }

  Future<void> fetchNextReview(id_facility) async {
    var API = url_next_page! + "&id_recipient=${id_facility}";

    var auth = "Bearer" + " " + authToken;
    Map<String, String> headers = {
      'Authorization': auth,
      'X-Requested-With': ' XMLHttpRequest ',
      'Accept': 'application/json',
      'Content-Type': 'application/json',
    };
    print(auth);
    final List<Review> _loadReview = [];
    try {
      final response = await http.get(Uri.parse(API), headers: headers);
      final extractedData = json.decode(response.body);
      print(response.body);
      final data = (extractedData['reviews'] as List)
          .map((data) => Review.fromJson(data))
          .toList();
      url_next_page = extractedData['url_next_page'];
      _loadReview.addAll(data);
      print('\ntotal :  ${extractedData['total_items']}\n');
      //print('length : ${_facilities.length}');
      review.addAll(_loadReview);
    } catch (e) {
      print(e.toString());
    }
    notifyListeners();
  }

  Future<void> fetchReview(id_facility) async {
    var API =
        Facilities.ApI + "api/user/review/show?id_facility=${id_facility}";

    var auth = "Bearer" + " " + authToken;
    Map<String, String> headers = {
      'Authorization': auth,
      'X-Requested-With': ' XMLHttpRequest ',
      'Accept': 'application/json',
      'Content-Type': 'application/json',
    };
    print(auth);
    final List<Review> _loadReview = [];

    try {
      print('anas3');
      final response = await http.get(Uri.parse(API), headers: headers);
      final extractedData = json.decode(response.body);
      print(response.body);
      final data = (extractedData['reviews'] as List)
          .map((data) => Review.fromJson(data))
          .toList();
      url_next_page = extractedData['url_next_page'];
      print('next url : $url_next_page');
      print('first total :  ${extractedData['total_items']}\n');
      _loadReview.addAll(data);
      review = _loadReview;
    } catch (e) {
      print(e.toString());
    }
    notifyListeners();
  }

//////////////////////////////

  void setChannelName(String name) {
    channelName = name;
    print("channelName: ${channelName}");
  }

  void setEventName(String name) {
    eventName = name;
    print("eventName: ${eventName}");
  }

  Future<void> initPusher() async {
    PusherOptions options = PusherOptions(cluster: "ap2");
    pusher = PusherClient("98034be202413ea485fc", options,
        autoConnect: false, enableLogging: true);
  }

  void connectPusher() {
    pusher!.connect();
  }

  void disconnectPusher() async {
    await channel!.unbind(eventName);
    await pusher!.unsubscribe(channelName);
    await pusher!.disconnect();
  }

  void subscribePusher() async {
    await initPusher();
    connectPusher();
    channel = await pusher!.subscribe(channelName);
    pusher!.onConnectionStateChange((state) {
      log("previousState: ${state!.previousState}, currentState: ${state
          .currentState}");
    });
    pusher!.onConnectionError((error) {
      log("error: ${error!.message}");
    });
    channel!.bind(eventName, (last) {
      var data = json.decode(last!.data.toString());
      print(data);
      if (last.data != null) {
        print("-------------------");
       // print("--${data["Data"]["comment"]['id_facility']}");
        print("-${data["comment"]['id_user']}");
//print(review.length);
//          review.add(
//                Review(
//                    id_facility: data["comment"]['id_facility'].toString(),
//                    rate: data["comment"]["rate"] == null ? 1 : data["Data"]["comment"]["rate"].toDouble(),
//                    id_user:data["comment"]['id_user'].toString(),
//                    id: data["Data"]["comment"]['id'].toString(),
//                    comment: data["Data"]["comment"]['comment'].toString(),
//                    name: data["Data"]['user']['name'].toString(),
//                    path_photo: data["Data"]['user']['path'].toString(),
//                    time: data["Data"]["comment"]['created_at'].toString()
//                ));
//print(review.length);
        notifyListeners();
      }

      prevChannelName = eventName;
    });
  }
}
//Data: {
//  "comment":
//{
//  "id":17,
//"id_facility":122,
//"id_user":76,
//"comment":"ggrth\u0621dff\u0621rmd\u0624\u064addgu;",
//"rate":1,
//"created_at":"2022-08-13T19:40:04.000000Z",
//"updated_at":"2022-08-13T19:40:06.000000Z"},
//"user":{
//  "name":"falfreddsfo","path":"uploads\/Users\/defult_profile.png"
//}
//}