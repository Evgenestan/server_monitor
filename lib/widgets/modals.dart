import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class CustomDialog extends StatelessWidget {
  const CustomDialog({Key key, @required this.title, @required this.actions, this.description}) : super(key: key);
  final String title;
  final String description;
  final List<Widget> actions;

  @override
  Widget build(BuildContext context) {
    return kIsWeb || Platform.isAndroid
        ? AlertDialog(
            title: Text(title),
            content: description == null ? null : Text(description),
            actions: actions,
          )
        : CupertinoAlertDialog(
            title: Text(title),
            content: description == null ? null : Text(description),
            actions: actions,
          );
  }
}
