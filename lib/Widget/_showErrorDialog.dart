import 'package:flutter/material.dart';


showErrorDialog(error,context) {
  return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('An error occured'),
          content: Text("${error}"),
          actions: [
            FlatButton(
                onPressed: () => Navigator.of(context).pop(),
                child: Text('Okay'))
          ],
        );
      });
}


