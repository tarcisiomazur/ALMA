import 'package:alma/ui/my_widgets/dialogs.dart';
import 'package:flutter/material.dart';

void showErrorDialog(BuildContext context,String message){
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(message),
      backgroundColor: Theme.of(context).errorColor,
    ),
  );
}

void showSuccessDialog(BuildContext context,String message){
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(message),
      backgroundColor: Colors.green,
    ),
  );
}

Future<bool> showConfirmDialog(BuildContext context,String message) async {
  var result = await showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        content: Text(message),
        actions: <Widget>[
          // usually buttons at the bottom of the dialog
          TextButton(
            child: Text(
              "Cancelar",
              style: TextStyle(
                  color: Theme.of(context).textTheme.bodyText1!.color
              ),
            ),
            onPressed: () {
              Navigator.of(context).pop(false);
            },
          ),
          TextButton(
            child: Text(
              "Excluir",
              style: TextStyle(
                color: Color(0xFFDD0000)
              ),
            ),
            onPressed: () {
              Navigator.of(context).pop(true);
            },
          ),
        ],
      );
    },
  );
  return result == true;
}