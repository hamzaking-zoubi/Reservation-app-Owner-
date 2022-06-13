import 'package:flutter/material.dart';
import '../Screen/addFacility_screen.dart';
import '../Screen/chat_screen.dart';
import '../Screen/homePage.dart';
import '../Screen/order_Screen.dart';
import '../Screen/profile.dart';

class NavigatorBarChange with ChangeNotifier {
  int _currentTab = 2;
  List<Widget> _screen = [
    ProfileScreen(),
    Order(),
    HomePage(),
    ChatScreen(),
    addFacility()
  ];
//NavigatorBarChange(this._currentTab);
  List<Widget> get screen => _screen;

  set currentTab(int tab) {
    this._currentTab = tab;
    notifyListeners();
  }

  int get currentTab => this._currentTab;

  Widget get currentScreen => this._screen[this.currentTab];
}
