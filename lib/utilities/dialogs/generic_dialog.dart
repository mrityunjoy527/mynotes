import 'package:flutter/material.dart';

typedef DialogBuilder = Map<String, Object?> Function();

Future<T?> showGenericDialog<T>(
  BuildContext context,
  String text,
  DialogBuilder optionsBuilder,
) {
  return showDialog(
    context: context,
    builder: (context) {
      final options = optionsBuilder();
      return AlertDialog(
        title: const Text(
          'An Error Occurred',
        ),
        content: Text(
          text,
        ),
        actions: options.keys.map((optionTitle) {
          return TextButton(
            onPressed: () {
              final value = options[optionTitle];
              if (value != null) {
                Navigator.of(context).pop(value);
              } else {
                Navigator.of(context).pop();
              }
            },
            child: Text(optionTitle),
          );
        }).toList(),
      );
    },
  );
}
