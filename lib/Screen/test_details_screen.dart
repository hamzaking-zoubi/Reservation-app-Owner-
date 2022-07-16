import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';

import '../Widget/boutton.dart';
import '../Widget/review_widget.dart';
import '../constants.dart';
import '../details extension.dart';
import '../provider/facility.dart';
import '../provider/photo.dart';
import '../Screen/addFacility_screen.dart';

class NewDetailsScreen extends StatefulWidget {
  static const routeName = '/Details';

  List<Photo>? facilityImages;
  String? facilityType;
  String? facilityName;
  int? rate;
  String? description;
  int? cost;
  String? location;
  bool? hasWifi;
  bool? hasCoffee;
  bool? hasCondition;
  bool? hasFridge;
  bool? hasTv;
  String? id;

//  NewDetailsScreen(
//      this.facilityImages,
//      this.facilityType,
//      this.facilityName,
//      this.rate,
//      this.description,
//      this.cost,
//      this.location,
//      this.hasWifi,
//      this.hasCoffee,
//      this.hasCondition,
//      this.hasFridge,
//      this.hasTv,
//      this.id);
  //  //PickerDateRange selectedBookingDate;
//  int numberOfBookedDays = 0;

  @override
  _NewDetailsScreenState createState() => _NewDetailsScreenState();
}

class _NewDetailsScreenState extends State<NewDetailsScreen> {
  List<String> getAmenities() {
    List<String> amenities = [];
    if (facility.fridge) amenities.add('Fridge');
    if (facility.air_condition) amenities.add('Condition');
    if (facility.coffee_machine) amenities.add('Coffee');
    if (facility.tv) amenities.add('TV');
    if (facility.wifi) amenities.add('Wifi');
    return amenities;
  }

  static const _BACKWARD_ICON =
      'assets/icons/signin_screen/bp_backward_icon.svg';
  static const _LOADING_IMAGE = 'assets/images/bp_loading.gif';

  Facility facility = Facility(
      id: ' ',
      title: '',
      description: '',
      location: '',
      listImage: [],
      type: '',
      cost: 0.0,
      numberGuests: 0,
      numberRooms: 0,
      wifi: false,
      tv: false,
      fridge: false,
      rate: 0,
      coffee_machine: false,
      air_condition: false);
  bool isInit = true;

  @override
  void didChangeDependencies() {
    if (isInit) {
      final facilityId = ModalRoute.of(context)!.settings.arguments;
      facility =
          Provider.of<Facilities>(context, listen: true).findById(facilityId);
    }
    isInit = false;

    super.didChangeDependencies();
  }

  final controller = PageController();

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: null,
      body: Column(children: [
        Expanded(
          child: SafeArea(
            child: Stack(children: [
              PageView.builder(
                controller: controller,
                itemCount: facility.listImage.length,
                itemBuilder: (BuildContext context, int index) {
                  return Container(
                    height: screenHeight / 2,
                    width: screenWidth,
                    child: Image(
                      image: NetworkImage(
                          '${Facilities.ApI + "${facility.listImage[index].path_photo}"}'),
                      fit: BoxFit.cover,
                    ),
                  );
                },
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    Container(
                      padding: EdgeInsets.only(top: 20, left: 20),
                      // alignment: Alignment.topLeft,
                      child: GestureDetector(
                        onTap: () => Navigator.pop(context),
                        child: Container(
                            //  alignment: Alignment.centerLeft,
                            height: 24,
                            width: 24,
                            child: SvgPicture.asset(
                              _BACKWARD_ICON,
                              color: Theme.of(context).primaryColor,
                            )),
                      ),
                    ),
                    Spacer(),
                    Container(
                      child: GestureDetector(
                        onTap: () async {
                          try {
                            showDialog(
                                context: context,
                                builder: (context) {
                                  return AlertDialog(
                                      title: Text(
                                          "Are you want delete this Facility"),
                                      actions: [
                                        FlatButton(
                                          onPressed: () async {
                                            await Provider.of<Facilities>(
                                                    context,
                                                    listen: false)
                                                .deleteFacilityById(facility.id)
                                                .catchError((error) {
                                              Navigator.of(context).pop();
                                              showDialogError(error, context);
                                            }).then((_) {
                                              Navigator.of(context).popUntil(
                                                  (route) => route.isFirst);
                                              Navigator.of(context)
                                                  .pushReplacement(
                                                      MaterialPageRoute(
                                                          builder: (context) =>
                                                              MainWidget()));
                                            });
                                          },
                                          child: Text('oky'),
                                        ),
                                        FlatButton(
                                            onPressed: () {
                                              Navigator.of(context).pop();
                                            },
                                            child: Text("No"))
                                      ]);
                                });
                          } catch (error) {
                            print(error);
                          }
                        },
                        child: Container(
                          alignment: Alignment.centerRight,
                          height: 24,
                          width: 24,
                          child: Icon(
                            Icons.delete,
                            color: Theme.of(context).primaryColor,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 20,
                    ),
                    Container(
                      child: GestureDetector(
                        onTap: () {
                          Navigator.of(context).pushNamed(addFacility.routeName,
                              arguments: facility.id);
                        },
                        child: Container(
                          alignment: Alignment.centerRight,
                          height: 24,
                          width: 24,
                          child: Icon(
                            Icons.edit,
                            color: Theme.of(context).primaryColor,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ]),
          ),
        ),
        Expanded(
          //color: Colors.white,
          child: SingleChildScrollView(
            child: Column(children: [
              DetailExtension(
                id: facility.id,
                facilityType: facility.type,
                description: facility.description,
                name: facility.title,
                rate: facility.rate,
                location: facility.location,
                //amenities: getAmenities(),
                hasWifi: facility.wifi,
                hasTv: facility.tv,
                hasFridge: facility.fridge,
                hasCondition: facility.air_condition,
                hasCoffee: facility.coffee_machine,
                amenities: getAmenities(),
              ),
              Review(),
              Review(),
              Review(),
              Review(),
              Review(),
            ]),
          ),
        ),
      ]),
    );
  }

  showDialogError(error, context) {
    print(error);
    return showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
              title: Text(" An error occurred"),
              content: Text("Deleting failed"),
              actions: [
                FlatButton(
                    onPressed: () {
                      Navigator.of(ctx).pop();
                    },
                    child: Text("Okay"))
              ],
            ));
  }
}
