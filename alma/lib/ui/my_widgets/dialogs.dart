import 'dart:math';

import 'package:flutter/material.dart';

class FormDialog extends StatefulWidget {

  const FormDialog({
    Key? key,
    required this.content,
    this.formKey,
  }) : super(key: key);

  final Widget content;
  final GlobalKey<FormState>? formKey;

  @override
  State<FormDialog> createState() => _FormDialogState();
}

class _FormDialogState extends State<FormDialog> {
  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery
        .of(context)
        .size;
    final cardWidth = min(deviceSize.width * 0.75, 360.0);
    const cardPadding = 16.0;

    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
      content: FittedBox(
        child: Container(
          padding: const EdgeInsets.only(
            left: cardPadding,
            top: cardPadding,
            right: cardPadding,
            bottom: cardPadding,
          ),
          width: cardWidth,
          alignment: Alignment.center,
          child: Form(
            key: widget.formKey,
            child: widget.content,
          ),
        ),
      ),
    );
  }
}
