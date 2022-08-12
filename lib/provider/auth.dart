import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:project24/provider/facility.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../Screen/auth_screen.dart';

class Auth with ChangeNotifier {
  var _token;
  var _userId;

  bool get isAuth {
    if (_token !=null) {
      return true;
    }
    return false;
  }

  String? get token {
    if (_token != null) {
      return _token;
    }
    return null;
  }

  String get userId {
    return _userId;
  }

  Future<void> signIn(String email, String password) async {
    var API = Facilities.ApI + 'api/auth/login';
    print(API);
    Map<String, String> headers = {
      //'Content-Type': 'multipart/form-data',
      'X-Requested-With': ' XMLHttpRequest ',
      'Accept': 'application/json',
      'Content-Type': 'application/json',
    };
    final http.Response response;
    try {
      response = await http.post(Uri.parse(API),
          headers: headers,
          body: json.encode({
            "email": email,
            "password": password,
          }));

      var responseData = await json.decode(response.body);
      if (response.statusCode == 201) {
        _token = responseData['token'].toString();
        _userId = responseData['user']['id'].toString();
        print("============================================");
        print(_token);
        print(_userId);
        print("============================================");

        final prefs = await SharedPreferences.getInstance();
        final userData = json.encode({
          'token': _token,
          'userId': _userId,
        });
        prefs.setString('userData', userData);
        print(_token);
        print(_userId);
        notifyListeners();
      } else if (responseData["Error"] != null) {
        if (responseData["Error"]['email'] != null)
          throw responseData["Error"]['email'].toString();
        if (responseData["Error"]['password'] != null)
          throw responseData["Error"]['password'].toString();
        if(response.statusCode >=400)
          throw 'error';
      }
    } catch (erorr) {
      print(erorr);
      throw erorr;
    }
  }

  Future<void> signUp(String email, String password, String confirmPassword,
      String name) async {
    const API = Facilities.ApI + 'api/auth/register';
    Map<String, String> headers = {
      'X-Requested-With': ' XMLHttpRequest ',
      'Accept': 'application/json',
      'Content-Type': 'application/json',
    };
    print(email);
    print(name);
    print(password);
    print(confirmPassword);
    final http.Response response;
    try {
      response = await http.post(Uri.parse(API),
          headers: headers,
          body: json.encode({
            "name": name,
            "email": email,
            "password": password,
            "password_c": confirmPassword,
            // "amount":10,
            "rule": "1"
          }));
      var responseData = await json.decode(response.body);
      print(responseData);
      if (response.statusCode == 201) {
        _token = responseData['token'].toString();
        _userId = responseData['user']['id'].toString();
        print("============================================");
        print(_token);
        print(_userId);
        print("============================================");
        final prefs = await SharedPreferences.getInstance();
        final userData = json.encode({
          'token': _token,
          'userId': _userId,
        });
        prefs.setString('userData', userData);
        print("lkrogrogorehg");
        print("lkrogrogorehg${_token}");
        notifyListeners();
        //    return true;
      }
      else if (responseData["Error"] != null) {
        if (responseData["Error"]['email'] != null)
          throw responseData["Error"]['email'].toString();
        if (responseData["Error"]['password'] != null)
          throw responseData["Error"]['password'].toString();
        if(response.statusCode >=400)
          throw 'error';
      }
    } catch (erorr) {
      print(erorr);
      throw erorr;
    }
    //   return false;
  }

  Future<void> logout(context) async {
    var API = Facilities.ApI + 'api/auth/logout?_method=DELETE';
    // var API = 'http://192.168.43.215:8000/api/auth/logout';
    String tokenAuthorization = "Bearer" + " " + _token;
    Map<String, String> headers = {
      'X-Requested-With': ' XMLHttpRequest ',
      'Accept': 'application/json',
      'Content-Type': 'application/json',
      'Authorization': tokenAuthorization
    };
    final http.Response response;
    try {
      response = await http.post(Uri.parse(API), headers: headers);
      var responseData = json.decode(response.body);
      print(responseData);
      if (response.statusCode == 201) {
        _token = null;
        _userId = null;
        final shP = await SharedPreferences.getInstance();
        shP.clear();
        Navigator.of(context).pushNamedAndRemoveUntil(
            AuthScreen.routeName, (Route<dynamic> route) => false);
//        Navigator.of(context).pushReplacementNamed(
//            AuthScreen.routeName);
      }
      if(response.statusCode>=400)
        throw 'some thing error ';
    } catch (errore) {
      print(errore);
      throw errore;
    }
  }

  Future<bool> tryAutoLogin() async {
    final prefs = await SharedPreferences.getInstance();
    if (!prefs.containsKey('userData')) {
      return false;
    }
    final extractedData =
        json.decode(prefs.getString('userData')!) as Map<String, dynamic>;
    _token = extractedData['token'];
    _userId = extractedData['userId'];
    notifyListeners();
    return true;
  }
}
