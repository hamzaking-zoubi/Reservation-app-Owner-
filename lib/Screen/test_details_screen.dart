//import 'package:flutter/material.dart';
//import 'package:rhrs_app/components/details%20extension.dart';
//import 'package:rhrs_app/models/facility.dart';
//import 'package:rhrs_app/models/facility_photo.dart';
//import 'package:rhrs_app/widgets/review_widget.dart';
//import 'package:syncfusion_flutter_datepicker/datepicker.dart';
//
//import '../constants.dart';
//
//class NewDetailsScreen extends StatefulWidget {
//  static const routeName = '/Details';
//
//  final List<FacilityPhoto> facilityImages;
//  final String facilityType;
//  final String facilityName;
//  final int rate;
//  final String description;
//  final int cost;
//  final String location;
//  final bool hasWifi;
//  final bool hasCoffee;
//  final bool hasCondition;
//  final bool hasFridge;
//  final bool hasTv;
//  String id;
//  PickerDateRange selectedBookingDate;
//  int numberOfBookedDays = 0;
//
//  NewDetailsScreen(
//      {this.id,
//      this.rate,
//      this.facilityType,
//      this.description,
//      this.cost,
//      this.facilityName,
//      this.facilityImages,
//      this.location,
//      this.hasWifi,
//      this.hasCoffee,
//      this.hasCondition,
//      this.hasFridge,
//      this.hasTv});
//
//  @override
//  _NewDetailsScreenState createState() => _NewDetailsScreenState();
//}
//
//class _NewDetailsScreenState extends State<NewDetailsScreen> {
//  List<String> getAmenities() {
//    List<String> amenities = [];
//    if (widget.hasFridge) amenities.add('Fridge');
//    if (widget.hasCondition) amenities.add('Condition');
//    if (widget.hasCoffee) amenities.add('Coffee');
//    if (widget.hasTv) amenities.add('TV');
//    if (widget.hasWifi) amenities.add('Wifi');
//    return amenities;
//  }
//
//  void _showPaymentConfirmation() {
//    widget.numberOfBookedDays = widget.selectedBookingDate.endDate
//            .difference(widget.selectedBookingDate.startDate)
//            .inDays +
//        1;
//    showDialog(
//        context: context,
//        builder: (ctx) => AlertDialog(
//              title: Text('Payment Confirmation'),
//              content: Text(
//                  'This will cost you ${widget.numberOfBookedDays * widget.cost}\$ , Are you sure you want to book?'),
//              actions: [
//                TextButton(
//                    onPressed: () => Navigator.of(context).pop(),
//                    child: Text('Cancel')),
//                TextButton(
//                    onPressed: () => Navigator.of(context).pop(),
//                    child: Text('Ok'))
//              ],
//            ));
//  }
//
//  void _onSelectionChanged(DateRangePickerSelectionChangedArgs args) {
//    widget.selectedBookingDate = args.value;
//    print(widget.selectedBookingDate);
//  }
//
//  void pickStartReservationDate() {
//    showDateRangePicker(
//            builder: (ctx, child) {
//              return Theme(
//                data: Theme.of(context).copyWith(
//                  colorScheme: ColorScheme.light(
//                    primary: kPrimaryColor, // <-- SEE HERE
//                    onPrimary: Colors.white, // <-- SEE HERE
//                    onSurface: Colors.blueAccent, // <-- SEE HERE
//                  ),
//                ),
//                child: child,
//              );
//            },
//            context: context,
//            //initialDate: DateTime.now(),
//            firstDate: DateTime.now(),
//            lastDate: DateTime(2023))
//        .then((pickedDate) {
//      if (pickedDate == null) return;
//      /*setState(() {
//        _reservationStartDate = pickedDate;
//        print(_reservationStartDate.toString().substring(0, 10));
//      });*/
//    });
//  }
//
//  void pickReservationDate() {
//    showDialog(
//        context: context,
//        builder: (context) {
//          return AlertDialog(
//            backgroundColor: Colors.white,
//            title: Text('Select booking dates'),
//            actions: [
//              TextButton(
//                  onPressed: () => Navigator.of(context).pop(),
//                  child: Text('Cancel')),
//              TextButton(
//                  onPressed: () {
//                    Navigator.of(context).pop();
//                    _showPaymentConfirmation();
//                  },
//                  child: Text('Ok'))
//            ],
//            content: Container(
//              width: 300,
//              height: 300,
//              child: SfDateRangePicker(
//                //rangeSelectionColor: kPrimaryColor,
//                selectionColor: kPrimaryColor,
//                endRangeSelectionColor: kPrimaryColor,
//                startRangeSelectionColor: kPrimaryColor,
//                view: DateRangePickerView.month,
//                enablePastDates: false,
//                onSelectionChanged: _onSelectionChanged,
//                selectionMode: DateRangePickerSelectionMode.range,
//                maxDate: DateTime(2023, 03, 25, 10, 0, 0),
//                monthCellStyle: DateRangePickerMonthCellStyle(
//                    blackoutDatesDecoration: BoxDecoration(
//                        color: Colors.grey,
//                        border: Border.all(width: 1),
//                        shape: BoxShape.circle)),
//                monthViewSettings: DateRangePickerMonthViewSettings(
//                    blackoutDates: [
//                      DateTime(2022, 06, 30),
//                      DateTime(2022, 07, 01)
//                    ]),
//              ),
//            ),
//          );
//          /*SfDateRangePicker(
//      view: DateRangePickerView.year,
//      enablePastDates : false,
//      onSelectionChanged: _onSelectionChanged,
//      selectionMode: DateRangePickerSelectionMode.range,
//      maxDate: DateTime(2023, 03, 25, 10 , 0, 0),
//      monthViewSettings: DateRangePickerMonthViewSettings(blackoutDates:[DateTime(2020, 03, 18), DateTime(2020, 03, 19)]),
//    );*/
//        });
//  }
//
//  final controller = PageController();
//
//  @override
//  Widget build(BuildContext context) {
//    double screenHeight = MediaQuery.of(context).size.height;
//    double screenWidth = MediaQuery.of(context).size.width;
//
//    final _dtlPriceTextStyle = Theme.of(context)
//        .textTheme
//        .headline3
//        .copyWith(color: kBackgroundLightColor, fontWeight: FontWeight.w500);
//
//    final _dtlSubTextStyle = Theme.of(context)
//        .textTheme
//        .headline5
//        .copyWith(color: kBackgroundLightColor, fontWeight: FontWeight.normal);
//
//    final _dtlButtonTextStyle = Theme.of(context).textTheme.headline6.copyWith(
//        color: kPrimaryColor, fontWeight: FontWeight.w600, fontSize: 14);
//
//    return Scaffold(
//      appBar: null,
//      body: Column(children: [
//        Expanded(
//          child: Stack(children: [
//            PageView(controller: controller, children: [
//              /*Container(
//                height: screenHeight / 2,
//                width: screenWidth,
//                child: SafeArea(
//                  child: Image(
//                    image: NetworkImage(
//                        'https://wallpaperaccess.com/full/2637581.jpg'),
//                    //AssetImage('assets/images/facility.jpg'),
//                    fit: BoxFit.cover,
//                  ),
//                ),
//              ),*/
//              Container(
//                height: screenHeight / 2,
//                width: screenWidth,
//                child: SafeArea(
//                  child: Image(
//                    image: AssetImage('assets/images/facility.jpg'),
//                    fit: BoxFit.cover,
//                  ),
//                ),
//              ),
//            ]),
//            Padding(
//              padding: const EdgeInsets.all(8.0),
//              child: Row(
//                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                  children: [
//                    SafeArea(
//                        child: IconButton(
//                            icon: Icon(
//                              Icons.arrow_back_ios,
//                              color: Colors.white,
//                            ),
//                            onPressed: () {
//                              Navigator.pop(context);
//                            })),
//                    SafeArea(
//                        child: IconButton(
//                            icon: Icon(
//                              Icons.chat,
//                              color: Colors.white,
//                            ),
//                            onPressed: () {})),
//                  ]),
//            ),
//          ]),
//        ),
//        Expanded(
//          //color: Colors.white,
//          child: SingleChildScrollView(
//            child: Column(children: [
//              DetailExtension(
//                id: widget.id,
//                facilityType: widget.facilityType,
//                description: widget.description,
//                name: widget.facilityName,
//                rate: widget.rate,
//                location: widget.location,
//                //amenities: getAmenities(),
//                hasWifi: widget.hasWifi,
//                hasTv: widget.hasTv,
//                hasFridge: widget.hasFridge,
//                hasCondition: widget.hasCondition,
//                hasCoffee: widget.hasCoffee,
//              ),
//              Review(),
//              Review(),
//              Review(),
//              Review(),
//              Review(),
//            ]),
//          ),
//        ),
//        Container(
//          height: 65,
//          child: Container(
//            padding: PAD_SYM_H20,
//            color: kPrimaryColor,
//            child: Center(
//              child: Row(
//                crossAxisAlignment: CrossAxisAlignment.baseline,
//                textBaseline: TextBaseline.alphabetic,
//                children: [
//                  Text('\$${widget.cost}', style: _dtlPriceTextStyle),
//                  Text(' / night', style: _dtlSubTextStyle),
//                  Spacer(),
//                  RawMaterialButton(
//                      elevation: 0,
//                      fillColor: kBackgroundLightColor,
//                      constraints: BoxConstraints(minHeight: 42, minWidth: 100),
//                      onPressed: () => pickReservationDate(),
//                      shape: RoundedRectangleBorder(
//                          borderRadius: BorderRadius.circular(25)),
//                      child: Text(DTL_BOOKING_TEXT, style: _dtlButtonTextStyle))
//                ],
//              ),
//            ),
//          ),
//        ),
//      ]),
//    );
//  }
//}
