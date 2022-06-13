import 'package:bottom_navy_bar/bottom_navy_bar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../provider/navigatorBarCange.dart';

class MainWidget extends StatefulWidget {
  static final routeName = "/MainWidget";

  @override
  _MainWidgetState createState() => _MainWidgetState();
}

class _MainWidgetState extends State<MainWidget> {
  @override
  Widget build(BuildContext context) {
    return Consumer<NavigatorBarChange>(
        builder: (context, model, child) => Scaffold(
            bottomNavigationBar:
                Consumer<NavigatorBarChange>(builder: (context, model, child) {
              return BottomNavyBar(
                selectedIndex: model.currentTab,
                items: [
                  BottomNavyBarItem(
                    icon: Icon(Icons.settings),
                    activeColor: Theme.of(context).primaryColor,
                    textAlign: TextAlign.center,
                    title: Text(
                      'Setting',
                      style: Theme.of(context)
                          .textTheme
                          .headline6!
                          .copyWith(fontSize: 15, fontWeight: FontWeight.w500),
                    ),
                    //    activeColor: Colors.red,
                  ),
                  BottomNavyBarItem(
                    icon: Icon(Icons.reorder),
                    title: Text(
                      'Order',
                      style: Theme.of(context)
                          .textTheme
                          .headline6!
                          .copyWith(fontSize: 15, fontWeight: FontWeight.w500),
                    ),
                    activeColor: Theme.of(context).primaryColor,
                    textAlign: TextAlign.center,
                    // activeColor: Colors.purpleAccent
                  ),
                  BottomNavyBarItem(
                    icon: Icon(Icons.home),
                    title: Text(
                      'home',
                      style: Theme.of(context)
                          .textTheme
                          .headline6!
                          .copyWith(fontSize: 15, fontWeight: FontWeight.w500),
                    ),
                    activeColor: Theme.of(context).primaryColor,
                    textAlign: TextAlign.center,
                    //   activeColor: Colors.pink
                  ),
                  BottomNavyBarItem(
                    icon: Icon(Icons.message),
                    title: Text(
                      'Chat',
                      style: Theme.of(context).textTheme.headline6,
                    ),
                    activeColor: Theme.of(context).primaryColor,
                    textAlign: TextAlign.center,
                    //   activeColor: Colors.blue
                  ),
                  BottomNavyBarItem(
                    icon: Icon(Icons.add),
                    title: Text(
                      'Add',
                      style: Theme.of(context)
                          .textTheme
                          .headline6!
                          .copyWith(fontSize: 15, fontWeight: FontWeight.w500),
                    ),
                    activeColor: Theme.of(context).primaryColor,
                    textAlign: TextAlign.center,
                    //  activeColor: Colors.blue
                  ),
                ],
                onItemSelected: (int value) {
                  model.currentTab = value;
                  print(model.currentTab);
                },
              );
            }),
            body: model.currentScreen));
  }
}
