import 'package:flutter/material.dart';
import 'package:word_note_app/constants.dart';

void showSnack(GlobalKey<ScaffoldMessengerState> scaffoldMessengerState, String message)
{
  debugPrint('Called showSnack: $message');
  scaffoldMessengerState.currentState.showSnackBar(SnackBar(
    content: Text(message),
    duration: Duration(seconds: snackBarDuration),
  ));
}