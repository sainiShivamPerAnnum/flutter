import 'package:felloapp/util/ui_constants.dart';
import 'package:flutter/material.dart';

Future<dynamic> showErrorDialog(
    String title, String content, BuildContext context) {
  return showDialog(
    context: context,
    builder: (ctx) => AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(UiConstants.padding),
      ),
      title: Text(title),
      content: Text(content),
    ),
  );
}
