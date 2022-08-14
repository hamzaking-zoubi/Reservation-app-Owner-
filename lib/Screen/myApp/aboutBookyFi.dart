import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:io';

class AboutBookyFy extends StatelessWidget {
  static const routeName = "/AboutBookyFy";

  void whatsAppOpen() async {
   var whatsappUrl ="whatsapp://send?phone=+963945675744";
    await canLaunch(whatsappUrl)? launch(whatsappUrl):print("open whatsapp app link or do a snackbar with notification that there is no whatsapp installed");
  }

  void launchWhatsApp({
    required int phone,
    required String message,
  }) async {
    String url() {
      if (Platform.isAndroid) {
        return "https://wa.me/$phone/?text=${Uri.parse(message)}";
      } else {
        return "https://api.whatsapp.com/send?phone=$phone=${Uri.parse(message)}";
      }
    }

    if (await canLaunch(url())) {
      await launch(url());
    } else {
      throw 'Could not launch ${url()}';
    }
  }

  @override
  Widget build(BuildContext context) {
    double wd = MediaQuery.of(context).size.width;
    double hg = MediaQuery.of(context).size.height;
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: Text("AboutBookyFy"),
          backgroundColor: Theme.of(context).primaryColor,
        ),
        body: ListView(
          padding: EdgeInsets.only(top: 60),
          children: [
            Container(
              child: Center(
                child: Image.asset("images/photo_2022-08-10_14-08-14.jpg"),
                // child: Image.asset("images/Final1.png"),
              ),
            ),
            SizedBox(height: 20),
            Center(
              child: Container(
                margin: EdgeInsets.all(15),
                // padding:EdgeInsets.all(9) ,
                decoration: BoxDecoration(
                  border: Border.all(
                    width: 1,
                    color: Theme.of(context).accentColor,
                  ),
                  borderRadius: BorderRadius.circular(7),
                ),
                child: Card(
                  child: Text(
                    "n particular, this means that within a build method, "
                    "the build context of the widget of the build method is not"
                    " the same as the build context of the widgets returned by"
                    "that build method. This can lead to some tricky cases. For example,"
                    "        Theme.of(context) looks for the nearest enclosing Theme of the given build context.",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w400),
                    softWrap: true,
                  ),
                ),
              ),
            ),
            SizedBox(height: 30),
            // Image.asset("assets/images/facebook.png"),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                InkWell(
                  onTap: () {},
                  child: Container(
                    height: 75,
                    width: 75,
                    child: CircleAvatar(
                      backgroundImage: AssetImage("assets/images/facebook.png"),
                    ),
                  ),
                ),
                InkWell(
                  onTap: () {
                    whatsAppOpen();
                    //launchWhatsApp(phone: 0945675744, message: 'Hello');
                  },
                  child: Container(
                    height: 75,
                    width: 75,
                    child: CircleAvatar(
                      backgroundImage: AssetImage("assets/images/whatsapp.png"),
                    ),
                  ),
                ),
                InkWell(
                  onTap: () {
                    whatsAppOpen();
                  },
                  child: Container(
                    height: 75,
                    width: 75,
                    child: CircleAvatar(
                      backgroundImage: AssetImage("assets/images/telegram.png"),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ));
  }
}
