import 'package:flutter/material.dart';

/// Color tokens extracted from the Electrify Figma file
/// (`material-theme/sys/light-medium-contrast`).
///
/// These are hand-tuned in Figma, so we use them directly instead of
/// deriving the palette from a single seed color.
class AppColors {
  AppColors._();

  // Brand
  static const Color primary = Color(0xFF497847);
  static const Color primaryContainer = Color(0xFF497847);
  static const Color onPrimary = Color(0xFFFFFFFF);
  static const Color onPrimaryContainer = Color(0xFF0E120D);

  static const Color secondary = Color(0xFF61725D);
  static const Color secondaryContainer = Color(0xFF61725D);
  static const Color onSecondary = Color(0xFFFFFFFF);
  static const Color onSecondaryContainer = Color(0xFFFFFFFF);

  // Surfaces
  static const Color surface = Color(0xFFFFFFFF);
  static const Color surfaceContainer = Color(0xFFE6E9E0);
  static const Color surfaceContainerHigh = Color(0xFFE6E9E0);
  static const Color onSurface = Color(0xFF0E120D);
  static const Color onSurfaceVariant = Color(0xFF323830);

  // Outline / fallback
  static const Color outline = Color(0xFF49454F);
  static const Color outlineVariant = Color(0xFFCAC4D0);

  // Status
  static const Color error = Color(0xFFB3261E);
  static const Color onError = Color(0xFFFFFFFF);
}
