import 'package:flutter/material.dart';

class MySnackbar {
  static void show(BuildContext? context, String message) {
    if (context == null) {
      return;
    }

    FocusScope.of(context).requestFocus(FocusNode());

    ScaffoldMessenger.of(context).removeCurrentSnackBar();

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontSize: 13,
            // fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.deepPurple,
        duration: const Duration(seconds: 1),
      ),
    );
  }
}
