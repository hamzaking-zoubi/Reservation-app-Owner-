import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../Widget/profile_item_card.dart';
import '../../Widget/profile_stack_container.dart';
import '../../provider/profile.dart';


class ProfileScreen extends StatefulWidget {
  static const routeName = '/ProfileScreen';

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
        future: Provider.of<MyProfile>(context).fetchProfileInfo(),
        builder: ((ctx,  AsyncSnapshot<Profile> snapshot) =>
        snapshot.connectionState == ConnectionState.waiting
                ? Padding(
                    padding: const EdgeInsets.all(14.0),
                    child: Center(child: CircularProgressIndicator()),
                  )
                : SingleChildScrollView(
                    child: Column(
                      children: <Widget>[
                        StackContainer(
                          userName: snapshot.data!.userName,
                          userImage: snapshot.data!.profilePhoto,
                        ),
                        ListView(
                          children: [
                            CardItem(
                                icon: Icons.email,
                                fieldName: 'Email',
                                fieldValue: snapshot.data!.email),
                            CardItem(
                                icon: Icons.person,
                                fieldName: 'Name',
                                fieldValue: snapshot.data!.userName),
                            CardItem(
                              icon: Icons.phone,
                              fieldName: 'PhoneNumber',
                              fieldValue: snapshot.data!.phone,
                            ),
                            CardItem(
                              icon: Icons.person_outline,
                              fieldName: 'Gender',
                              fieldValue: snapshot.data!.gender,
                            ),
                            CardItem(
                              icon: Icons.hourglass_bottom,
                              fieldName: 'Age',
                              fieldValue: snapshot.data!.age,
                            ),
                          ],
                          //CardItem(),
                          physics: NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                        )
                      ],
                    ),
                  )),
      ),
    );
  }
}
