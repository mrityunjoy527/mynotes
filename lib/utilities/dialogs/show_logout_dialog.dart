import 'package:flutter/material.dart';
import 'package:mynotes/utilities/dialogs/generic_dialog.dart';

Future<bool> showLogOutDialog(
  BuildContext context,
  String text,
) {
  return showGenericDialog<bool>(
    context,
    text,
    () => {
      'Cancel': false,
      'Yes': true,
    },
  ).then((value) => value ?? false);
}
