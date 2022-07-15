import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../Widget/details extension.dart';
import '../constants.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:project24/Screen/addFacility_screen.dart';
import '../provider/facility.dart';
import '../provider/photo.dart';
import 'package:project24/Widget/boutton.dart';
class DetailScreen extends StatefulWidget{
  static const routeName = '/details_screen';

  const DetailScreen({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return DetailScreenState();
  }

}


class DetailScreenState extends State<DetailScreen> {

  DetailScreenState();

  static const _LOADING_IMAGE = 'assets/images/bp_loading.gif';
  static const _BACKWARD_ICON =
      'assets/icons/signin_screen/bp_backward_icon.svg';

  @override
  Widget build(BuildContext context) {
    final facilityId = ModalRoute.of(context)!.settings.arguments;
    final facility =
        Provider.of<Facilities>(context, listen: false).findById(facilityId);
//List<Photo> photo=[
//    Photo(path_photo: "https://th.bing.com/th/id/R.a9fd1fe3731d6e4c67d4b280d7512908?rik=Z4VFedr%2b157wag&pid=ImgRaw&r=0")
//    ];

    final _screenWidth = MediaQuery.of(context).size.width;
    final _screenHeight = MediaQuery.of(context).size.height;

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

    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            Center(
              child: SizedBox.expand(
                child: FadeInImage(
                  image: facility.listImage[0] != null
                      ? ResizeImage(
                          // AssetImage('assets/images/facility.jpg'),
                          NetworkImage(Facilities.ApI +
                              "${facility.listImage[0].path_photo}"),
                          width: _screenWidth.round(),
                          height: _screenHeight.round())
                      : ResizeImage(AssetImage('assets/images/facility.jpg'),
                          // NetworkImage(Facilities.ApI+"${facility.listImage[0]}") ,
                          width: _screenWidth.round(),
                          height: _screenHeight.round()),
                  placeholder: AssetImage(_LOADING_IMAGE),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Container(
              padding: EdgeInsets.only(top: 20, left: 20, right: 20),
              // alignment: Alignment.,
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
                                          if (facility != null) {
                                            await Provider.of<Facilities>(
                                                    context,
                                                    listen: false)
                                                .deleteFacilityById(facility.id)
                                                .catchError((error) {
                                              Navigator.of(context).pop();
                                              showDialogError(error, context);
                                            }).then((_) {
                                           //   Navigator.of(context).pop();
//                                              setState(() {
//                                                Navigator.of(context).pop();
//
//                                              });

                                             // Navigator.of(context).pushReplacementNamed(   MainWidget.routeName);

                                              Navigator.of(context)
                                                  .pushNamedAndRemoveUntil(
                                                      MainWidget.routeName,
                                                      (Route<dynamic> route) => false);
                                            });
                                          }
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
                            arguments: facilityId);
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
            // Draggable for extended the info
            DraggableScrollableSheet(
              initialChildSize: .2,
              maxChildSize: .5,
              minChildSize: .2,
              builder: (context, scrollController) => SingleChildScrollView(
                controller: scrollController,
                child: Container(
                  //height: _screenHeight * 0.45,
                  decoration: BoxDecoration(
                      color: kBackgroundColor,
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(20),
                          topRight: Radius.circular(20))),
                  child: Stack(
                    children: [
                      DetailExtension(
                        id: facility.id,
                        cost: facility.cost,
                        title: facility.title,
                        location: facility.location,
                        rate: facility.rate,
                        type: facility.type,
                      ),
                      Positioned(
                        top: 12,
                        left: _screenWidth / 2 - 12,
                        child: Container(
                          width: 24,
                          height: 4,
                          decoration: BoxDecoration(
                              color: kSubTextColor.withOpacity(.3),
                              borderRadius: BorderRadius.circular(6)),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),

      // Bottom contain price and booking button
//      bottomNavigationBar: SizedBox(
//          height: 72,
//          child: Container(
//            padding: PAD_SYM_H20,
//            color: kPrimaryColor,
//            child: Center(
//              child: Row(
//                crossAxisAlignment: CrossAxisAlignment.baseline,
//                textBaseline: TextBaseline.alphabetic,
//                children: [
//                  Text('\$${40}', style: _dtlPriceTextStyle),
//                  Text(' / night', style: _dtlSubTextStyle),
//                  Spacer(),
//                  RawMaterialButton(
//                      elevation: 0,
//                      fillColor: kBackgroundLightColor,
//                      constraints: BoxConstraints(minHeight: 42, minWidth: 100),
//                      onPressed: () =>
//                          Navigator.pushNamed(context, '/calendar'),
//                      shape: RoundedRectangleBorder(
//                          borderRadius: BorderRadius.circular(25)),
//                      child: Text(DTL_BOOKING_TEXT, style: _dtlButtonTextStyle))
//                ],
//              ),
//            ),
//          )),
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
