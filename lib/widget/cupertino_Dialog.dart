import 'package:assingment/widget/style.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CupertinoDialog extends StatefulWidget {
  CupertinoDialog({super.key, contex});

  @override
  State<CupertinoDialog> createState() => _CupertinoDialogState();
}

class _CupertinoDialogState extends State<CupertinoDialog> {
  @override
  Widget build(BuildContext context) {
    return _showDialog(context);
  }

  _showDialog(BuildContext context) {
    showCupertinoDialog(
      context: context,
      builder: (context) => CupertinoAlertDialog(
        content: SizedBox(
          height: 50,
          width: 50,
          child: Center(
            child: CircularProgressIndicator(
              color: blue,
            ),
          ),
        ),
      ),
    );
  }
}
