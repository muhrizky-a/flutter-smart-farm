import 'package:flutter/material.dart';

void showSnackBar(
  BuildContext context,
  String message,
) {
  var snackBar = SnackBar(
    content: Text(message),
    behavior: SnackBarBehavior.floating,
  );
  ScaffoldMessenger.of(context).hideCurrentSnackBar();
  ScaffoldMessenger.of(context).showSnackBar(snackBar);
}

void showSnackBarWithKey(
  GlobalKey<ScaffoldMessengerState> scaffoldKey,
  String message,
) {
  var snackBar = SnackBar(
    content: Text(message),
    behavior: SnackBarBehavior.floating,
  );

  scaffoldKey.currentState?.showSnackBar(snackBar);
}
