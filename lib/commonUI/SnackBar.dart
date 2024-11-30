// ignore_for_file: file_names

import 'package:flutter/material.dart';


void showErrorMessage(BuildContext context, {required String message}) {
  final snackBar = SnackBar(
    backgroundColor: const Color.fromARGB(255, 255, 48, 68),
    duration: const Duration(seconds: 2),
    content: Text(
      message,
      style: const TextStyle(
        color: Colors.white,
      ),
    ),
  );
  ScaffoldMessenger.of(context)
    ..removeCurrentSnackBar()
    ..showSnackBar(snackBar);
}


void showSuccessMessage(BuildContext context, {required String message}) {
  final snackBar = SnackBar(
    backgroundColor: Colors.pink,
    duration: const Duration(seconds: 2),
    content: Text(
      message,
      style: const TextStyle(
        color: Colors.white,
      ),
    ),
  );
  ScaffoldMessenger.of(context)
    ..removeCurrentSnackBar()
    ..showSnackBar(snackBar);
}
