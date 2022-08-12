import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/svg.dart';
import '../Screen/test_details_screen.dart';
import '../constants/constants.dart';
import '../components/details extension.dart';
import '../provider/facility.dart';
class FacilityItem extends StatelessWidget {
  final id;
  final title;
  final location;
  final image;
  final cost;
  final rate;
  final type;

  FacilityItem({
    required this.id,
    required this.title,
    required this.rate,
    required this.type,
    required this.image,
    required this.location,
    required this.cost,
  });

  static const _LOADING_IMAGE = 'assets/images/bp_loading.gif';
  static const _BOOKMARK_ICON = 'assets/icons/home_screen/bp_bookmark_icon.svg';
  static const _LOCATION_ICON = 'assets/icons/home_screen/bp_location_icon.svg';
  static const _STAR_ICON = 'assets/icons/home_screen/bp_star_icon.svg';

  @override
  Widget build(BuildContext context) {
    final _bodTitleTextStyle = Theme.of(context)
        .textTheme
        .headline5!
        .copyWith(color: kPrimaryDarkenColor, fontWeight: FontWeight.w500);
    final _bodBody2TextStyle = Theme.of(context).textTheme.bodyText2;
    final _bodBody1TextStyle = Theme.of(context).textTheme.bodyText1;

    return GestureDetector(
      onTap: () {
        Navigator.of(context).pushNamed(NewDetailsScreen.routeName, arguments: id);
      },
      child: Container(
          width: double.infinity,
          height: 289,
          child: Card(
            elevation: 10,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            child: Column(
              children: [
                Padding(
                  padding: EdgeInsets.all(12),
                  child: Stack(
                    children: [
                      Container(
                        width: double.infinity,
                        height: 154,
                        child: ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: FadeInImage.assetNetwork(
                                image: Facilities.ApI + '${image}',
                                placeholder: _LOADING_IMAGE,

                                width: double.infinity,
                                fit: BoxFit.cover)),
                      ),
                      Positioned(
                        left: 12,
                        bottom: 12,
                        child: Container(
                          width: 120,
                          height: 20,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                              color: kBackgroundColor,
                              borderRadius: BorderRadius.circular(12)),
                          child: Text("Start From:\$${cost}",
                              style: _bodBody2TextStyle),
                        ),
                      )
                    ],
                  ),
                ),
                Padding(
                  padding: PAD_SYM_H16,
                  child: Row(
                    children: [
                      Text('${type}', style: _bodBody1TextStyle),
                      Spacer(),
                      SvgPicture.asset(_BOOKMARK_ICON)
                    ],
                  ),
                ),
                SIZED_BOX_H06,
                Padding(
                  padding: PAD_SYM_H16,
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text('${title}', style: _bodTitleTextStyle),
                  ),
                ),
                Spacer(),
                Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    child: Row(
                      children: [
                        SvgPicture.asset(_LOCATION_ICON),
                        SIZED_BOX_W06,
                        RichText(
                            text: TextSpan(children: [
                          TextSpan(
                              text: '${location}',
                              style: _bodBody1TextStyle!
                                  .copyWith(color: kPrimaryDarkenColor)),
                          //  TextSpan(text: ' km', style: _bodBody2TextStyle),
                        ])),
                       SIZED_BOX_W20,
                        SIZED_BOX_W06,
                        for (int i = 0; i < rate; i++)
                          SvgPicture.asset(_STAR_ICON, height: 20),
//                        Text('${rate}',
//                            style: _bodBody1TextStyle.copyWith(
//                                color: kPrimaryDarkenColor))
                      ],
                    ))
              ],
            ),
          )),
    );
  }
}
