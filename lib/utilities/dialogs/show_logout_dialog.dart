import 'package:flutter/material.dart';
import 'package:mynotes/utilities/dialogs/generic_dialog.dart';

Future<bool> showLogOutDialog(
  BuildContext context,
) {
  return showGenericDialog<bool>(
    context,
    'Do You Really Want To Log Out ?',
    () => {
      'Cancel': false,
      'Yes': true,
    },
  ).then((value) => value ?? false);
}
