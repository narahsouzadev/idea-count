import 'package:flutter/material.dart';

/// Centralizes all the visual configurations of the application.
///
/// Keeping the theme in a separate file avoids scattering colors,
/// styles, and visual configurations throughout the project.
///
/// This way, future changes to the visual identity of
/// Idea36 Labs can be made in a single place.
class AppTheme {
  /// Main theme of the application.
  ///
  /// Currently, Idea Count only has a light version,
  /// following the proposal of:
  /// - white background;
  /// - high contrast;
  /// - Idea36 yellow as the action color.
  static ThemeData get lightTheme {
    return ThemeData(
      // Uses Material 3, the current Flutter standard.
      useMaterial3: true,

      // Base color used by the component system.
      //
      // Yellow represents the visual identity of Idea36 Labs.
      colorScheme: ColorScheme.fromSeed(
        seedColor: const Color(0xFFFFC107),
        brightness: Brightness.light,
      ),

      // Default screen background color.
      scaffoldBackgroundColor: Colors.white,

      // Global text configuration.
      textTheme: const TextTheme(
        // Style meant to be used for the main number.
        //
        // The counter will have a larger size defined in the specific
        // widget, but this configuration establishes the base.
        displayLarge: TextStyle(
          fontFamily: 'Inter',
          fontWeight: FontWeight.w700,
          color: Color(0xFF1A1A1A),
        ),

        // Style for smaller texts, such as titles and buttons.
        bodyMedium: TextStyle(
          fontFamily: 'Inter',
          color: Color(0xFF1A1A1A),
        ),
      ),

      // Default configuration for elevated buttons.
      //
      // Custom counter buttons will have their own styles,
      // but this configuration maintains consistency with Material 3.
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          elevation: 0,
        ),
      ),
    );
  }
}