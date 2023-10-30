import 'package:flutter/cupertino.dart';
import 'package:mynotes/utilities/dialogs/generic_dialog.dart';

Future<void> showPasswordResetLinkSent(
  BuildContext context,
) async {
  return showGenericDialog<void>(
    context: context,
    title: 'Password Reset Link',
    content: 'Password reset link has been sent to your email',
    optionsBuilder: () => {
      'OK': null,
    },
  );
}
