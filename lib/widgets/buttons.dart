import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:server_monitor/constants.dart';

class MyButton extends StatelessWidget {
  const MyButton({Key key, this.onPressed, this.title}) : super(key: key);
  final VoidCallback onPressed;
  final String title;
  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: InkWell(
        onTap: onPressed,
        child: Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            border: Border.all(width: 2, color: mainColor),
            color: mainColor.withOpacity(0.2),
          ),
          child: Text(title, textAlign: TextAlign.center),
        ),
      ),
    );
  }
}
