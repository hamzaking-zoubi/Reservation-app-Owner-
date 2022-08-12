import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:project24/provider/facility.dart';
import 'service_card.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../constants/constants.dart';
import 'package:flutter_svg/flutter_svg.dart';
//import 'package:intl/intl.dart';

class DetailExtension extends StatelessWidget {
  final String facilityType;
  final  rate;
  final String name;
  final String description;
  final String location;
  final List<String> amenities;
  final bool hasWifi;
  final bool hasCoffee;
  final bool hasCondition;
  final bool hasFridge;
  final bool hasTv;
  final bool available;
  String id;

  DetailExtension(
      {
        required this.available,
      required  this.id,
     required this.name,
     required this.facilityType,
     required this.description,
     required this.rate,
     required this.location,
     required this.amenities,
     required this.hasWifi,
    required  this.hasCoffee,
     required this.hasCondition,
     required this.hasFridge,
    required this.hasTv});

  static const _BOOKMARK_ICON = 'assets/icons/home_screen/bp_bookmark_icon.svg';
  static const _LOCATION_ICON = 'assets/icons/home_screen/bp_location_icon.svg';
  static const _STAR_ICON = 'assets/icons/home_screen/bp_star_icon.svg';


  @override
  Widget build(BuildContext context) {
    final _dtlTypeTextStyle =
    Theme.of(context).textTheme.subtitle2!.copyWith(color: kTagHotelColor);

    final _dtlTitleTextStyle = Theme.of(context).textTheme.headline2;
    final _dtlSubTitleTextStyle = Theme.of(context)
        .textTheme
        .headline5
        !.copyWith(color: kPrimaryDarkenColor, fontWeight: FontWeight.w500);
    final _dtlSub1TextStyle = Theme.of(context)
        .textTheme
        .subtitle1
        !.copyWith(color: kPrimaryDarkenColor, fontWeight: FontWeight.w600);
    final _dtlBody1TextStyle = Theme.of(context)
        .textTheme
        .bodyText1
        !.copyWith(color: kPrimaryDarkenColor, fontWeight: FontWeight.normal);
    bool isavailable = available;

    return Padding(
      padding: PAD_SYM_H20,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.only(top: 10),
            child: Row(
              children: [
                Text(facilityType, style: _dtlTypeTextStyle),
                Spacer(),
               Switch1(vailable: available,id:id ,),
              ],
            ),
          ),
          //SIZED_BOX_H06,
          Text(name, style: _dtlTitleTextStyle),
          SIZED_BOX_H12,
          Row(
            children: [
              SvgPicture.asset(_LOCATION_ICON, height: 20),
              SIZED_BOX_W06,
              Text(
                '$location',
                style: _dtlSub1TextStyle,
              ),

              SIZED_BOX_W20,
              for (int i = 0; i < rate; i++)
                SvgPicture.asset(_STAR_ICON, height: 20),
              SIZED_BOX_W06,

            ],
          ),
          Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Padding(
              padding: EdgeInsets.fromLTRB(0, 12, 20, 12),
              child: Text(description,
                  style: _dtlSub1TextStyle.copyWith(
                      height: 1.5,
                      color: kSubTextColor,
                      fontWeight: FontWeight.normal)),
            ),
            Text(DTL_AMENITY_TEXT, style: _dtlSubTitleTextStyle),
            SIZED_BOX_H06,
            Row(children: [
              hasWifi
                  ? ServiceCard(
                onPressed:(){} ,
                      name: 'Wifi',
                      fontSize: 12,
                      size: 45,
                      iconUrl: 'assets/icons/detail_screen/wifi.svg',
                      radius: 12,
                      color: kBackgroundLightColor
              )
                  : SizedBox(
                      width: 1,
                    ),
              SizedBox(
                width: 10,
              ),
              hasCoffee
                  ? ServiceCard(
                  onPressed:(){} ,
                      name: 'Coffee',
                      fontSize: 12,
                      size: 45,
                      iconUrl: 'assets/icons/detail_screen/coffe_machine.svg',
                      radius: 12,
                      color: kBackgroundLightColor
              )
                  : SizedBox(
                      width: 1,
                    ),
              SizedBox(
                width: 10,
              ),
              hasCondition
                  ? ServiceCard(
                  onPressed:(){} ,
                      name: 'Conditioner',
                      fontSize: 12,
                      size: 45,
                      iconUrl: 'assets/icons/detail_screen/air-conditioner.svg',
                      radius: 12,
                      color: kBackgroundLightColor
              )
                  : SizedBox(
                      width: 1,
                    ),
              SizedBox(
                width: 10,
              ),
              hasTv
                  ? ServiceCard(
                  onPressed:(){} ,
                      name: 'TV',
                      fontSize: 12,
                      size: 45,
                      iconUrl: 'assets/icons/detail_screen/tv.svg',
                      radius: 12,
                      color: kBackgroundLightColor
              )
                  : SizedBox(
                      width: 1,
                    ),
              SizedBox(
                width: 10,
              ),
              hasFridge
                  ? ServiceCard(
                  onPressed:(){} ,
                      name: 'Fridge',
                      fontSize: 12,
                      size: 45,
                      iconUrl: 'assets/icons/detail_screen/air-conditioner.svg',
                      radius: 12,
                      color: kBackgroundLightColor
              )
                  : SizedBox(
                      width: 1,
                    ),
            ]),
          ])
        ],
      ),
    );
  }
}

class Switch1 extends StatefulWidget {

bool  vailable;
String id;
Switch1({required this.vailable,required this.id});

  @override
  _Switch1State createState() => _Switch1State(vailable);
}

class _Switch1State extends State<Switch1> {
  bool isavailable ;
  _Switch1State(this.isavailable);
  @override
  Widget build(BuildContext context) {
    return Container(
      child:Switch(
          value:isavailable ,
          onChanged: (value){
        setState(() {
       Provider.of<Facilities>(context,listen:false ).toggleStatus(widget.id);
          isavailable=value;
        });
      }) ,
    );
  }
}


//
//
//
//}
