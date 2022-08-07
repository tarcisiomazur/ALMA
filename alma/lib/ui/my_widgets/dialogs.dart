import 'package:flutter/material.dart';

class FormDialog extends StatefulWidget {
  const FormDialog({
    Key? key,
    this.children = const <Widget>[],
  }) : super(key: key);

  final List<Widget> children;

  @override
  State<FormDialog> createState() => _FormDialogState();
}

class _FormDialogState extends State<FormDialog> {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(

    );
  }
}
