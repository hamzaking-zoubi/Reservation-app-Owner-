import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:project24/provider/facility.dart';
import 'package:provider/provider.dart';
import '../Widget/facility_item2.dart';
import '../provider/message_model.dart';
import 'package:http/http.dart' as http;
class HomePage extends StatefulWidget {
  static const routeName = "/HomePage";

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
 // var _isInt = true;
  //var _isLoading = false;



//  @override
//  void didChangeDependencies() {
//    if(_isInt){
//    }

//    if (_isInt) {
//      setState(() {
//        _isLoading = true;
//      });
//
//      Provider.of<Facilities>(context, listen: false)
//          .fetchAndSetFacility().catchError((error){
//            print(error);
//      })
//          .then((_) {
//        setState(() {
//          _isLoading = false;
//        });
//      });
//    }
//    _isInt = false;
//  }

  @override
  Widget build(BuildContext context) {
    var facility = Provider
        .of<Facilities>(context, listen: false)
        .getData;
    return Scaffold(
      appBar: AppBar(

        backgroundColor: Theme
            .of(context)
            .primaryColor,
//        actions: [
//          ElevatedButton(onPressed: (){
//
//            Provider.of<Facilities>(context, listen: false).display();
//
//          }, child: Icon(Icons.add))
//
//        ],
        //  backgroundColor:Colors.yellow ,
        title: Text('home Page'),
      ),
      body:
//      _isLoading
//          ? Center(child: CircularProgressIndicator())
//          :
      Padding(
        padding: const EdgeInsets.all(8.0),
        child: FutureBuilder(
          future: Provider.of<Facilities>(context)
              .fetchAndSetFacilityList(),
          builder: (context, AsyncSnapshot<List> snapshot) =>
          snapshot.hasData
              ? Consumer<Facilities>(
            builder: (context, value, child) =>
                ListView.builder(
                    itemCount: snapshot.data!.length,
                    itemBuilder: (context, index) {
                      return FacilityItem(
                        title: snapshot.data![index].title ?? " ",
                        cost: snapshot.data![index].cost ?? "",
                        image: snapshot.data![index].listImage[0] != null
                            ? snapshot.data![index].listImage[0].path_photo : " ",
                        id: snapshot.data![index].id ?? " ",
                        // description: facility[i].description,
                        location: snapshot.data![index].location ?? " ",
                        rate: snapshot.data![index].rate ?? " ",
                        type: snapshot.data![index].type ?? " ",
                      );
                    }),
          )
              : Center(
            child: CircularProgressIndicator(),
          ),
        ),
      ),
    );
  }
}
