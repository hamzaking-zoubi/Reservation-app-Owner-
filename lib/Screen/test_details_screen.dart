import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';

import '../Widget/boutton.dart';
import '../Widget/review_widget.dart';
import '../components/details extension.dart';
import '../constants/constants.dart';
import '../provider/facility.dart';
import '../provider/photo.dart';
import '../Screen/addFacility_screen.dart';
import '../provider/reviews.dart';
import 'order_to_oneFacility.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

class NewDetailsScreen extends StatefulWidget {
  static const routeName = '/Details';

  List<Photo>? facilityImages;
  String? facilityType;
  String? facilityName;
  var rate;
  String? description;
  double? cost;
  String? location;
  bool? hasWifi;
  bool? hasCoffee;
  bool? hasCondition;
  bool? hasFridge;
  bool? hasTv;
  String? id;

  @override
  _NewDetailsScreenState createState() => _NewDetailsScreenState();
}

class _NewDetailsScreenState extends State<NewDetailsScreen> {
  double cost = 1.0;
  PickerDateRange? selectedBookingDate;
  int numberOfBookedDays = 0;
  Reviews? reviews;

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
      cost: 0,
      numberGuests: 0,
      numberRooms: 0,
      wifi: false,
      tv: false,
      fridge: false,
      rate: 0,
      available: true,
      coffee_machine: false,
      air_condition: false);
  bool isInit = true;

  @override
  void didChangeDependencies() {
    if (isInit) {
      final facilityId = ModalRoute.of(context)!.settings.arguments;
      facility = Provider.of<Facilities>(context, listen: true).findById(facilityId);
      reviews = Provider.of<Reviews>(context, listen: false);
      reviews!.setChannelName("User.Comment.Facility.${facility.id}");
      reviews!.setEventName("CommentEvent");
      reviews!.subscribePusher();

      controller.addListener(() {
        if (_controller.position.maxScrollExtent == _controller.offset) {
          if (reviews!.url_next_page != null)
            reviews!.fetchNextReview(facilityId);
        }
      });
    }
    isInit = false;

    super.didChangeDependencies();
  }



  void _showPaymentConfirmation() {
    numberOfBookedDays = selectedBookingDate!.endDate!
            .difference(selectedBookingDate!.startDate!)
            .inDays +
        1;
    showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
              title: Text('Payment Confirmation'),
              content: Text(
                  'This will cost you ${numberOfBookedDays * facility.cost}\$ , Are you sure you want to book?'),
              actions: [
                TextButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: Text('Cancel')),
                TextButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: Text('Ok'))
              ],
            ));
  }

  void _onSelectionChanged(DateRangePickerSelectionChangedArgs args) {
    selectedBookingDate = args.value;


    print(selectedBookingDate);
  }

  void pickStartReservationDate() {
    showDateRangePicker(
            builder: (ctx, child) {
              return Theme(
                data: Theme.of(context).copyWith(
                  colorScheme: ColorScheme.light(
                    primary: kPrimaryColor, // <-- SEE HERE
                    onPrimary: Colors.white, // <-- SEE HERE
                    onSurface: Colors.blueAccent, // <-- SEE HERE
                  ),
                ),
                child: child!,
              );
            },
            context: context,
            //initialDate: DateTime.now(),
            firstDate: DateTime.now(),
            lastDate: DateTime(2023))
        .then((pickedDate) {
      if (pickedDate == null) return;
      /*setState(() {
        _reservationStartDate = pickedDate;
        print(_reservationStartDate.toString().substring(0, 10));
      });*/
    });
  }

  void pickReservationDate() {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            backgroundColor: Colors.white,
            title: Text('Select booking dates'),
            actions: [
              TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: Text('Cancel')),
              TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    _showPaymentConfirmation();
                  },
                  child: Text('Ok'))
            ],
            content: Container(
              width: 300,
              height: 300,
              child: SfDateRangePicker(
                //rangeSelectionColor: kPrimaryColor,
                selectionColor: kPrimaryColor,
                endRangeSelectionColor: kPrimaryColor,
                startRangeSelectionColor: kPrimaryColor,
                view: DateRangePickerView.month,
                enablePastDates: false,
                onSelectionChanged: _onSelectionChanged,
                selectionMode: DateRangePickerSelectionMode.range,
                maxDate: DateTime(2023, 03, 25, 10, 0, 0),
                monthCellStyle: DateRangePickerMonthCellStyle(
                    blackoutDatesDecoration: BoxDecoration(
                        color: Colors.grey,
                        border: Border.all(width: 1),
                        shape: BoxShape.circle)),
                monthViewSettings: DateRangePickerMonthViewSettings(
                    blackoutDates: [
                      DateTime(2022, 06, 30),
                      DateTime(2022, 07, 01)
                    ]),
              ),
            ),
          );
          /*SfDateRangePicker(
      view: DateRangePickerView.year,
      enablePastDates : false,
      onSelectionChanged: _onSelectionChanged,
      selectionMode: DateRangePickerSelectionMode.range,
      maxDate: DateTime(2023, 03, 25, 10 , 0, 0),
      monthViewSettings: DateRangePickerMonthViewSettings(blackoutDates:[DateTime(2020, 03, 18), DateTime(2020, 03, 19)]),
    );*/
        });
  }

  final controller = PageController();
  final _controller = ScrollController();

  @override
  Widget build(BuildContext context) {
    final _dtlPriceTextStyle = Theme.of(context)
        .textTheme
        .headline3!
        .copyWith(color: kBackgroundLightColor, fontWeight: FontWeight.w500);

    final _dtlSubTextStyle = Theme.of(context)
        .textTheme
        .headline5!
        .copyWith(color: kBackgroundLightColor, fontWeight: FontWeight.normal);

    final _dtlButtonTextStyle = Theme.of(context).textTheme.headline6!.copyWith(
        color: kPrimaryColor, fontWeight: FontWeight.w600, fontSize: 14);

    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      body: Column(children: [
        Expanded(
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
            Container(
              color: Color(0xFFFFFF).withOpacity(0.4),
              // color: Colors.black.withOpacity(0.3),
              child: Padding(
                padding: const EdgeInsets.only(
                    top: 16.0, left: 10, bottom: 10, right: 10),
                child: Row(
                  children: [
                    Container(
                      padding: EdgeInsets.only(top: 20, left: 20),
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
                    Padding(
                      padding: const EdgeInsets.only(top: 8),
                      child: Container(
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
                                                  .deleteFacilityById(
                                                      facility.id)
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
                                            child: Text(
                                              'oky',
                                              style: TextStyle(
                                                  color: Theme.of(context)
                                                      .primaryColor),
                                            ),
                                          ),
                                          FlatButton(
                                              onPressed: () {
                                                Navigator.of(context).pop();
                                              },
                                              child: Text("No",
                                                  style: TextStyle(
                                                      color: Theme.of(context)
                                                          .primaryColor)))
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
                    ),
                    SizedBox(
                      width: 20,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 8),
                      child: Container(
                        child: GestureDetector(
                          onTap: () {
                            Navigator.of(context).pushNamed(
                                addFacility.routeName,
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
                    ),
                    SizedBox(
                      width: 20,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 8),
                      child: Container(
                        child: GestureDetector(
                          onTap: () {
                            Navigator.of(context).pushNamed(
                                OrderToOneFacility.routeName,
                                arguments: facility.id);
                          },
                          child: Container(
                            alignment: Alignment.centerRight,
                            height: 24,
                            width: 24,
                            child: Icon(
                              Icons.reorder,
                              color: Theme.of(context).primaryColor,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ]),
        ),
        Expanded(
          //color: Colors.white,
          child: SingleChildScrollView(
            child: Column(children: [
              DetailExtension(
                available: facility.available,
                id: facility.id,
                facilityType: facility.type,
                description: facility.description,
                name: facility.title,
                rate: facility.rate,
                location: facility.location,
                hasWifi: facility.wifi,
                hasTv: facility.tv,
                hasFridge: facility.fridge,
                hasCondition: facility.air_condition,
                hasCoffee: facility.coffee_machine,
                amenities: getAmenities(),
              ),


              FutureBuilder(
                  future: Provider.of<Reviews>(context, listen: false)
                      .fetchReview(facility.id),
                  builder: ((ctx, resultSnapShot) => resultSnapShot.connectionState == ConnectionState.waiting
                      ? Center(child: CircularProgressIndicator())
                      : Consumer<Reviews>(
                          builder: (ctx, fetchedReviews, child) =>
                              ListView.builder(
                                shrinkWrap: true,
                                physics: const ScrollPhysics(),
                                controller: _controller,
                                itemBuilder: (context, index) {
                                if (index < fetchedReviews.review.length) {
                                  return ReviewItem(
                                      time: fetchedReviews.review[index].time,
                                      id: fetchedReviews.review[index].id,
                                      name: fetchedReviews.review[index].name,
                                      rate: fetchedReviews.review[index].rate,
                                      comment: fetchedReviews.review[index].comment,
                                      id_facility: fetchedReviews.review[index].id_facility,
                                      id_user: fetchedReviews.review[index].id_user,
                                      path_photo: fetchedReviews.review[index].path_photo,
                                    );
                                } else {
                                    if (fetchedReviews.url_next_page != null) {
                                      return const Padding(padding: EdgeInsets.symmetric(vertical: 32.0),
                                        child: Center(child: CircularProgressIndicator()),
                                      );
                                    }
                                    return const SizedBox(
                                      height: 0,
                                    );
                                  }
                                },
                              itemCount: fetchedReviews.review.length + 1,
                              )))),

//              FutureBuilder(
//                future: Provider.of<Reviews>(context).fetchAndReviewList1(facility.id),
//                builder: (context, AsyncSnapshot<List> snapshot) => snapshot
//                    .hasData
//                    ? Consumer<Reviews>(
//                  builder: (context, fetchedReviews, child) => ListView.builder(
//                      shrinkWrap:true,
//                      physics:ScrollPhysics(),
//                     controller: _controller,
//                      itemCount: fetchedReviews.review.length,
//                      itemBuilder: (context, index) {
//                        return ReviewItem(
//                          time: fetchedReviews.review[index].time,
//                          id: fetchedReviews.review[index].id,
//                          name: fetchedReviews.review[index].name,
//                          rate: fetchedReviews.review[index].rate,
//                          comment: fetchedReviews.review[index].comment,
//                          id_facility: fetchedReviews.review[index].id_facility,
//                          id_user: fetchedReviews.review[index].id_user,
//                          path_photo: fetchedReviews.review[index].path_photo,
//                        );
//                      }),
//                )
//                    : Center(
//                  child: CircularProgressIndicator(),
//                ),
//              ),
            ]),
          ),
        ),
        Container(
          height: 65,
          child: Container(
            padding: PAD_SYM_H20,
            color: kPrimaryColor,
            child: Center(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.baseline,
                textBaseline: TextBaseline.alphabetic,
                children: [
                  Text('\$${facility.cost}', style: _dtlPriceTextStyle),
                  Text(' / night', style: _dtlSubTextStyle),
                  Spacer(),
                  RawMaterialButton(
                      elevation: 0,
                      fillColor: kBackgroundLightColor,
                      constraints: BoxConstraints(minHeight: 42, minWidth: 100),
                      onPressed: () => pickReservationDate(),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25)),
                      child: Text(DTL_BOOKING_TEXT, style: _dtlButtonTextStyle))
                ],
              ),
            ),
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


//FutureBuilder(
//future: Provider.of<Reviews>(context).fetchAndReviewList1(facility.id),
//builder: (context, AsyncSnapshot<List> snapshot) => snapshot
//    .hasData
//? Consumer<Reviews>(
//builder: (context, fetchedReviews, child) => ListView.builder(
//shrinkWrap:true,
//physics:ScrollPhysics(),
//
//itemCount: snapshot.data!.length,
//itemBuilder: (context, index) {
//return
//ReviewItem(
//time: snapshot.data![index].time,
//id: snapshot.data![index].id,
//name: snapshot.data![index].name,
//rate: snapshot.data![index].rate,
//comment: snapshot.data![index].comment,
//id_facility: snapshot.data![index].id_facility,
//id_user: snapshot.data![index].id_user,
//path_photo: snapshot.data![index].path_photo,
//);
//}),
//)
//: Center(
//child: CircularProgressIndicator(),
//),
//),
