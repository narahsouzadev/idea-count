import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// Circular button used by the counter controls.
///
/// This widget was separated from the main screen to:
/// - avoid repeated code;
/// - facilitate visual adjustments;
/// - allow reuse in other parts of the application in the future.
class CounterButton extends StatelessWidget {
  /// Icon displayed inside the button.
  final IconData icon;

  /// Function executed when the user taps the button.
  final VoidCallback onPressed;

  /// Defines whether the button is the primary action.
  ///
  /// The add button (+) gets yellow highlighting.
  /// The remove button (-) gets a secondary color.
  final bool isPrimary;

  /// Button constructor.
  const CounterButton({
    super.key,
    required this.icon,
    required this.onPressed,
    this.isPrimary = false,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      // Button size.
      width: 110,
      height: 110,

      child: ElevatedButton(
        // Adds a light haptic feedback upon tap before executing the action.
        onPressed: () {
          HapticFeedback.lightImpact();
          onPressed();
        },

        // Removes the default internal padding of the button.
        style: ElevatedButton.styleFrom(
          padding: EdgeInsets.zero,

          // Perfectly circular button.
          shape: const CircleBorder(),

          // Defines the color according to the action type.
          backgroundColor: isPrimary
              ? const Color(0xFFFFC107) // Idea36 Yellow (+ button)
              : const Color(0xFFF5F5F5), // Light Gray (- button)

          // Removes strong shadow to maintain a minimalist style.
          elevation: 0,

          // Defines the visual behavior during the tap.
          overlayColor: Colors.black12,
        ),

        child: Icon(
          icon,

          // Size of the + or - symbol.
          size: 36,

          // Color of the + or - symbol.
          color: const Color(0xFF5B4300),
        ),
      ),
    );
  }
}