import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:project24/provider/facility.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Profile {
  final int id;
  final String userName;
  final String email;
  final String phone;
  final String age;
  final String gender;
  final int amount;
  final String profilePhoto;

  Profile(
      {required this.id,
      required this.age,
      required this.gender,
      required this.email,
      required this.phone,
      required this.userName,
      required this.amount,
      required this.profilePhoto});
}

class MyProfile extends ChangeNotifier {
//   Profile  _myProfile =new Profile(id: 1, age:"199", gender: "male", email: "dde", phone: "09222", userName: "eef", amount:
//   12, profilePhoto: "ddd");

  // Profile get myProfile => _myProfile;

  Future<Profile> fetchProfileInfo() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final extractedData =
        json.decode(prefs.getString('userData')!) as Map<String, dynamic>;
    String token = extractedData['token'];
    final url = Uri.parse(Facilities.ApI + "api/profile/show");

    Map<String, String> headers = {
      'Accept': 'application/json',
      'Content-Type': 'application/json',
      'Authorization': "Bearer " + token
    };
    var _myProfile;
    try {
      final response = await http.get(url, headers: headers);
      final profileData = json.decode(response.body);
      print(response.body);
        _myProfile = Profile(
          id: profileData['profile']['id_user']??0,
          age: profileData['profile']['age']??"18",
          gender: profileData['profile']['gender']??"male",
          email: profileData['user']['email']??'**@gmail.com',
          phone: profileData['profile']['phone']??"+09******",
          userName: profileData['user']['name']??'n**',
          amount: profileData['user']['amount']??0,
          profilePhoto: profileData['profile']['path_photo']??''
        );
    } catch (e) {
      print(e);
    }
    return _myProfile;
  }
}
