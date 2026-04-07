import 'package:flutter/material.dart';

import '../theme/app_colors.dart';

/// Pill-shaped Material 3 app bar from the Electrify Figma (`Yläpalkki` /
/// `XR/XR App Bar`). 376×72, radius 36, primary-container background.
///
/// The leading icon opens the drawer; the trailing icon is a customizable
/// action (default: notifications).
class XrAppBar extends StatelessWidget implements PreferredSizeWidget {
  const XrAppBar({
    super.key,
    required this.title,
    this.leadingIcon = Icons.menu,
    this.onLeadingTap,
    this.trailingIcon = Icons.notifications_outlined,
    this.onTrailingTap,
    this.showLeading = true,
    this.showTrailing = true,
  });

  final String title;
  final IconData leadingIcon;
  final VoidCallback? onLeadingTap;
  final IconData trailingIcon;
  final VoidCallback? onTrailingTap;
  final bool showLeading;
  final bool showTrailing;

  static const double _barHeight = 72;
  static const double _topPadding = 60;
  static const double _bottomPadding = 16;

  @override
  Size get preferredSize =>
      const Size.fromHeight(_barHeight + _topPadding + _bottomPadding);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(13, _topPadding, 13, _bottomPadding),
      child: Container(
        height: _barHeight,
        decoration: BoxDecoration(
          color: AppColors.primaryContainer,
          borderRadius: BorderRadius.circular(36),
        ),
        child: Stack(
          alignment: Alignment.center,
          children: [
            Center(
              child: Text(
                title,
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      color: AppColors.onPrimaryContainer,
                    ),
              ),
            ),
            if (showLeading)
              Positioned(
                left: 12,
                top: 12,
                child: _IconButton(
                  icon: leadingIcon,
                  onTap: onLeadingTap,
                ),
              ),
            if (showTrailing)
              Positioned(
                right: 12,
                top: 12,
                child: _IconButton(
                  icon: trailingIcon,
                  onTap: onTrailingTap,
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _IconButton extends StatelessWidget {
  const _IconButton({required this.icon, this.onTap});

  final IconData icon;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 48,
      height: 48,
      child: IconButton(
        icon: Icon(icon, size: 24, color: AppColors.onPrimaryContainer),
        onPressed: onTap,
        padding: EdgeInsets.zero,
      ),
    );
  }
}
