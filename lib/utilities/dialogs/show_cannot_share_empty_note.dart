import 'package:flutter/cupertino.dart';
import 'package:mynotes/utilities/dialogs/generic_dialog.dart';

Future<void> showCannotShareEmptyNote(
  BuildContext context,
) {
  return showGenericDialog<void>(
    context: context,
    title: 'Sharing ...',
    content: 'Can not share empty note!',
    optionsBuilder: () => {
      'OK': null,
    },
  );
}
