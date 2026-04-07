import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'app_colors.dart';

/// Material 3 type scale using Roboto, matching the Figma `material-theme`
/// type styles (headline-medium, title-large, body-large, body-medium,
/// label-large, label-medium).
class AppTypography {
  AppTypography._();

  static TextTheme build() {
    final base = GoogleFonts.robotoTextTheme();

    return base.copyWith(
      headlineMedium: base.headlineMedium?.copyWith(
        fontSize: 28,
        height: 36 / 28,
        letterSpacing: 0,
        color: AppColors.onSurface,
      ),
      titleLarge: base.titleLarge?.copyWith(
        fontSize: 22,
        height: 28 / 22,
        letterSpacing: 0,
        color: AppColors.onSurface,
      ),
      bodyLarge: base.bodyLarge?.copyWith(
        fontSize: 16,
        height: 24 / 16,
        letterSpacing: 0.5,
        color: AppColors.onSurface,
      ),
      bodyMedium: base.bodyMedium?.copyWith(
        fontSize: 14,
        height: 20 / 14,
        letterSpacing: 0.25,
        color: AppColors.onSurfaceVariant,
      ),
      labelLarge: base.labelLarge?.copyWith(
        fontSize: 14,
        height: 20 / 14,
        letterSpacing: 0.1,
        fontWeight: FontWeight.w500,
        color: AppColors.onSurfaceVariant,
      ),
      labelMedium: base.labelMedium?.copyWith(
        fontSize: 12,
        height: 16 / 12,
        letterSpacing: 0.5,
        fontWeight: FontWeight.w500,
        color: AppColors.onSurfaceVariant,
      ),
    );
  }
}
