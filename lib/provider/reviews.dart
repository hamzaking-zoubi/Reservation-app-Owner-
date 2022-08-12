import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:project24/provider/facility.dart';
import 'package:http/http.dart 'as http;
class Review {
  final id;
  final id_facility;
  final id_user;
  final comment;
  final rate;
  final time;
  final name;
  final path_photo;

  Review(
      {required this.id,
      required this.id_facility,
      required this.id_user,
      required this.comment,
      required this.rate,
      required this.time,
      required this.name,
      required this.path_photo});

  factory Review.fromJson(Map<String, dynamic> json) => Review(
      id_facility: json['id_facility'].toString(),
      rate: json["rate"] == null ? 0 : json["rate"].toDouble(),
      id_user: json['id_user'].toString(),
      id: json['id'].toString(),
      comment: json['comment'].toString(),
      name: json['user']['name'].toString(),
      path_photo: json['user']['path_photo'].toString(),
      time: json['created_at'].toString());
}
class Reviews with ChangeNotifier{

  final String authToken;
  List<Review> _Review = [];

  Reviews(this.authToken, this._Review);
  List<Review> get getData {
    return [..._Review];
  }

  Future<List> fetchAndReviewList(id_facility ) async {
    var API =Facilities.ApI+ "api/user/review/show?id_facility=3";
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
      final extractData = json.decode(response.body);
      print('=======================');
      print(extractData);
      print('=======================');

      final data = (extractData['reviews'] as List)
          .map((data) => Review.fromJson(data))
          .toList();

      _loadReview.addAll(data);
      print("zzzzzlength:${_Review.length}");
      _Review.clear();
      _Review.addAll(data);
      //  notifyListeners();
    } catch (error) {
      print("error in fetchAndSetFacilityList::==>> ${error}");
      throw error;
    }
    return _loadReview;
  }


}