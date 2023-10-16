import 'package:flutter/material.dart';
import 'package:mynotes/utilities/dialogs/generic_dialog.dart';

Future<bool> showDeleteDialog(
  BuildContext context,
) {
  return showGenericDialog<bool>(
    context,
    'Do You Want To Delete This Item ?',
    () => {
      'Cancel': false,
      'Yes': true,
    },
  ).then((value) => value ?? false);
}
