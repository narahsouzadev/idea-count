import 'package:flutter/material.dart';

/// Modal dialog that asks the user to confirm a counter reset.
///
/// Accepts an [onConfirm] callback invoked only when the user
/// taps the destructive "Reset" action.
class ResetConfirmationDialog extends StatelessWidget {
  /// Called when the user confirms the reset action.
  final VoidCallback onConfirm;

  const ResetConfirmationDialog({super.key, required this.onConfirm});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Reset counter?'),
      content: const Text(
        'This action will reset your current count to zero. Do you wish to continue?',
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text(
            'Cancel',
            style: TextStyle(color: Colors.grey),
          ),
        ),
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
            onConfirm();
          },
          child: const Text(
            'Reset',
            style: TextStyle(
              color: Color(0xFFD32F2F),
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }
}
