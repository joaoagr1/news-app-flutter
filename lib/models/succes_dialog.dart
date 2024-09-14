// lib/widgets/success_dialog.dart
import 'package:flutter/cupertino.dart';

class SuccessDialog extends StatelessWidget {
  final String message;
  final VoidCallback onOkPressed;

  SuccessDialog({required this.message, required this.onOkPressed});

  @override
  Widget build(BuildContext context) {
    return CupertinoAlertDialog(
      title: Text(
        'Success',
        style: TextStyle(color: CupertinoColors.activeGreen),
      ),
      content: Text(message),
      actions: [
        CupertinoDialogAction(
          child: Text('OK'),
          onPressed: onOkPressed,
        ),
      ],
    );
  }
}