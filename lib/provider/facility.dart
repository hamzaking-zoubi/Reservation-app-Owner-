import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:project24/provider/photo.dart';
import 'package:http/http.dart' as http;
import 'package:project24/provider/chats_model.dart';
import '../http_exception.dart';

class Facility {
  final id;
  final id_user;
  final title;
  final description;
  final location;
  final List<Photo> listImage;
  final cost;
  final type;
  final numberGuests;
  final numberRooms;
  final rate;
  var available;
  final wifi;
  final coffee_machine;
  final air_condition;
  final tv;
  final fridge;

  Facility({
    this.id,
    this.id_user = ' ',
    required this.title,
    required this.description,
    required this.location,
    required this.listImage,
    required this.type,
    required this.cost,
    required this.numberGuests,
    required this.numberRooms,
    this.wifi = false,
    this.rate = 0,
    this.available=true,
    this.air_condition = false,
    this.coffee_machine = false,
    this.fridge = false,
    this.tv = false,
  });

  factory Facility.fromJson(Map<String, dynamic> json) => Facility(
        type: json['type'].toString(),
        cost: json['cost'] == null ? 0.0 : json['cost'].toDouble(),
        title: json["name"].toString(),
        description: json["description"].toString(),
        id: json["id"].toString(),
        numberGuests: json["num_guest"],
        numberRooms: json["num_room"],
        listImage: (json['photos'] as List)
            .map((data) => Photo.fromJson(data))
            .toList(),
        available:json['available']== 0 ? false : true ,
        location: json["location"].toString(),
        air_condition: json["air_condition"] == 0 ? false : true,
        coffee_machine: json["coffee_machine"] == 0 ? false : true,
        fridge: json["fridge"] == 0 ? false : true,
        tv: json["tv"] == 0 ? false : true,
        id_user: json["id_user"].toString(),
        rate: json["rate"] == null ? 0 : json["rate"].toDouble(),
        wifi: json["wifi"] == 0 ? false : true,
      );
}

class Facilities with ChangeNotifier {

  static const ApI = 'http://192.168.137.148:8000/';

  //  static const ApI = 'https://laravelprojectfinal.000webhostapp.com/public/';
  //  static const ApI = 'http://laravelapimk.atwebpages.com/public/';
  final String authToken;
  List<Facility> _facilities = [];

  Facilities(this.authToken, this._facilities);

  Future<void> addFacility(Facility facility) async {
    var API = ApI + "api/facility/store";
    var auth = "Bearer" + " " + authToken;
    Map<String, String> headers = {
      'Authorization': auth,
      'X-Requested-With': ' XMLHttpRequest ',
      'Accept': 'application/json',
      'Content-Type': 'application/json',
    };
    Map<String, String> body = {
      "air_condition": facility.air_condition.toString(),
      "name": facility.title.toString(),
      "location": facility.location.toString(),
      "description": facility.description.toString(),
      "cost": facility.cost.toString(),
      "type": facility.type.toString(),
      "num_guest": facility.numberGuests.toString(),
      "num_room": facility.numberRooms.toString(),
      "wifi": facility.wifi.toString(),
      "coffee_machine": facility.coffee_machine.toString(),
      "fridge": facility.fridge.toString(),
      "tv": facility.tv.toString()
    };
    try {
      var request = http.MultipartRequest('POST', Uri.parse(API));
      request.headers.addAll(headers);
      request.fields.addAll(body);

//      for (int i=0;i<100;i++) {
//        request.files.add(
//            await http.MultipartFile.fromPath("photo_list[]", facility.listImage[0].path_photo));
//      }

      for (var file in facility.listImage) {
        request.files.add(
            await http.MultipartFile.fromPath("photo_list[]", file.path_photo));
      }
      var sendRequest = await request.send();
      var response = await http.Response.fromStream(sendRequest);
      final responseData = json.decode(response.body);
      print(responseData);
      if (response.statusCode >= 400) {}
      if (response.statusCode == 201) {}
      notifyListeners();
    } catch (error) {
      print(error);
      throw error;
    }
  }

  deleteFacilityById(id) async {
    final API = ApI + 'api/facility/delete/$id?_method=DELETE';
    var auth = "Bearer" + " " + authToken;
    Map<String, String> headers = {
      // 'Content-Type': 'multipart/form-data',
      'Authorization': auth,
      //'X-Requested-With': ' XMLHttpRequest ',
      'Accept': 'application/json',
      'Content-Type': 'application/json',
    };
    final existingProductIndex =
        _facilities.indexWhere((prod) => prod.id == id);
    Facility? existingProduct = _facilities[existingProductIndex];
    _facilities.removeAt(existingProductIndex);
    notifyListeners();
    final response = await http.delete(Uri.parse(API), headers: headers);
    final responseData = json.decode(response.body);
    print("--------------------------------------------");
    print(responseData);
    print("--------------------------------------------");

    notifyListeners();
    if (response.statusCode >= 400) {
      _facilities.insert(existingProductIndex, existingProduct);
      notifyListeners();
      throw HttpException('Could not delete product.');
    }
    existingProduct = null;
  }

  Future<List> fetchAndSetFacilityList() async {
    var API = ApI + "api/facility/index";
    var auth = "Bearer" + " " + authToken;
    Map<String, String> headers = {
      'Authorization': auth,
      'X-Requested-With': ' XMLHttpRequest ',
      'Accept': 'application/json',
      'Content-Type': 'application/json',
    };
    print(auth);
    final List<Facility> _loadFacility = [];
    try {
      final response = await http.get(Uri.parse(API), headers: headers);
      final extractData = json.decode(response.body);
      print('=======================');
      print(extractData);
      print('=======================');

      final data = (extractData['Data'] as List)
          .map((data) => Facility.fromJson(data))
          .toList();

      _loadFacility.addAll(data);
      print("zzzzzlength:${_facilities.length}");
      _facilities.clear();
      _facilities.addAll(_loadFacility);
      //  notifyListeners();
    } catch (error) {
      print("error in fetchAndSetFacilityList::==>> ${error}");
      throw error;
    }
    return _loadFacility;
  }

  Future<void> fetchAndSetFacility() async {
    const API = ApI + "api/facility/index";
    var auth = "Bearer" + " " + authToken;
    Map<String, String> headers = {
      'X-Requested-With': ' XMLHttpRequest ',

      // 'Content-Type': 'multipart/form-data',
      'Authorization': auth,
      'Accept': 'application/json',
      'Content-Type': 'application/json',
    };
    try {
      final response = await http.get(Uri.parse(API), headers: headers);
      final extractData = json.decode(response.body);
      final List<Facility> _loadProduct = [];
      //  print(extractData['data']);
      final data = (extractData['Data'] as List)
          .map((data) => Facility.fromJson(data))
          .toList();
      _loadProduct.addAll(data);
      _facilities.clear();
      _facilities = _loadProduct;
      notifyListeners();
    } catch (error) {
      print("error ${error}");
      throw error;
    }
  }

  Future<void> updateFacility(Facility facility, id) async {
    final FacilityId =
        _facilities.indexWhere((element) => element.id == facility.id);
    if (FacilityId >= 0) {
      var API = ApI + 'api/facility/update';
      var auth = "Bearer" + " " + authToken;
      Map<String, String> headers = {
        // 'Content-Type': 'multipart/form-data',
        'Authorization': auth,
        'X-Requested-With': ' XMLHttpRequest ',
        'Accept': 'application/json',
        'Content-Type': 'application/json',
      };
      print(auth);
      Map<String, dynamic> body = {
        "id": facility.id.toString(),
        "air_condition": facility.air_condition,
        "name": facility.title.toString(),
        "location": facility.location.toString(),
        "description": facility.description.toString(),
        "cost": facility.cost.toString(),
        "type": facility.type.toString(),
        "num_guest": facility.numberGuests.toString(),
        "num_room": facility.numberRooms.toString(),
        "wifi": facility.wifi.toString(),
        "coffee_machine": facility.coffee_machine,
        "fridge": facility.fridge,
        "tv": facility.tv
      };

      try {
        var request = await http.post(Uri.parse(API),
            body: json.encode({
              "id": facility.id.toString(),
              "air_condition": facility.air_condition,
              "name": facility.title.toString(),
              "location": facility.location.toString(),
              "description": facility.description.toString(),
              "cost": facility.cost.toString(),
              "type": facility.type.toString(),
              "num_guest": facility.numberGuests.toString(),
              "num_room": facility.numberRooms.toString(),
              "wifi": facility.wifi,
              "coffee_machine": facility.coffee_machine,
              "fridge": facility.fridge,
              "tv": facility.tv
            }),
            headers: headers);

//        var request = http.MultipartRequest('POST', Uri.parse(API));
//        request.headers.addAll(headers);
//        request.fields.addAll(body);
//        for (var file in facility.listImage) {
//          request.files.add(
//              await http.MultipartFile.fromPath("photo_list[]", file.path_photo));
//        }
//        var sendRequest = await request.send();
//        var response = await http.Response.fromStream(sendRequest);
        final responseData = await json.decode(request.body);
        print(responseData);
        if (responseData.statusCode >= 400) {}
        if (responseData.statusCode == 201) {}
        _facilities[FacilityId] = facility;
        notifyListeners();
      } catch (error) {
        print(error);
        throw error;
      }
    }
  }

  Facility findById(id) {
    var facility;
    try {
      facility = _facilities.firstWhere((element) => element.id == id);
    } catch (error) {
      print(
          "eeeeeeeeeeeeeeeeeeeeeeeeeeeerrrrrrrrrrrrrrrrrrrrrooooooooooooooorrrrrrrr${error}");
      throw error;
    }
    return facility;
  }

  Future<void> deleteOneImage(idFacility, idImage) async {
    final API = ApI + 'api/facility/deleteOneImage/$idImage';
    var auth = "Bearer" + " " + authToken;
    Map<String, String> headers = {
      // 'Content-Type': 'multipart/form-data',
      'Authorization': auth,
      'X-Requested-With': ' XMLHttpRequest ',
      'Accept': 'application/json',
      'Content-Type': 'application/json',
    };
    print("deleteOneImage");
    final existingProductIndex =
        _facilities.indexWhere((prod) => prod.id == idFacility);
    final existingPhotoIndex = _facilities[existingProductIndex]
        .listImage
        .indexWhere((element) => element.id == idImage);
    Photo? existingProduct =
        _facilities[existingProductIndex].listImage[existingPhotoIndex];
    _facilities[existingProductIndex].listImage.removeAt(existingProductIndex);
    notifyListeners();
    final response = await http.delete(Uri.parse(API), headers: headers);
    if (response.statusCode >= 400) {
      _facilities[existingProductIndex]
          .listImage
          .insert(existingPhotoIndex, existingProduct);
      notifyListeners();
      throw HttpException('Could not delete Image.');
    }
    existingProduct = null;
  }

  Future<void> addImage(id, listImage) async {
    var API = ApI + "api/facility/addListImage";
    var auth = "Bearer" + " " + authToken;
    Map<String, String> headers = {
      // 'Content-Type': 'multipart/form-data',
      'Authorization': auth,
      'X-Requested-With': ' XMLHttpRequest ',
      'Accept': 'application/json',
      'Content-Type': 'application/json',
    };
    print("addImage");
    try {
      var request = http.MultipartRequest('POST', Uri.parse(API));
      request.headers.addAll(headers);
      request.fields.addAll({"id": id});
      for (var file in listImage) {
        request.files.add(
            await http.MultipartFile.fromPath("photo_list[]", file.path_photo));
      }
      var sendRequest = await request.send();
      var response = await http.Response.fromStream(sendRequest);
      final responseData = json.decode(response.body);
      print(responseData);
      if (response.statusCode >= 400) {}
      if (response.statusCode == 201) {
        fetchAndSetFacility();
        //   final existingProductIndex =
        // _facilities.indexWhere((prod) => prod.id == id);
        // _facilities[existingProductIndex].listImage.addAll(listImage);
      }
      notifyListeners();
    } catch (error) {
      print("-------------------------------");
      print(error);
      print("-------------------------------");
      throw error;
    }
  }

  List<Facility> get getData {
    return [..._facilities];
  }

  Future<void> toggleStatus(id_facility) async {
    const API = ApI + "api/facility/toggleAvailable";
    var auth = "Bearer" + " " + authToken;
    Map<String, String> headers = {
      'X-Requested-With': ' XMLHttpRequest ',
      'Authorization': auth,
      'Accept': 'application/json',
      'Content-Type': 'application/json',
    };
    try {
      final response = await http.post(Uri.parse(API), headers: headers,
          body: json.encode({
        "id_facility": id_facility,
      }));

      final extractData = json.decode(response.body);
      print("===================================");
      print(extractData);
      print("===================================");

    var faci=  findById(id_facility);
    faci.available=extractData['Date']== 0 ? false : true;
    notifyListeners();
    } catch (error) {
      print("error ${error}");
      throw error;
    }
  }
}
