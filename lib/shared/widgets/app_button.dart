import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../shared/theme/text_styles.dart';

/// Reusable app button widget
class AppButton extends StatelessWidget {
  final String label;
  final VoidCallback onPressed;
  final bool isLoading;
  final bool isEnabled;
  final ButtonStyle? style;
  final Color? backgroundColor;
  final Color? textColor;
  final double? width;
  final double height;
  final IconData? icon;

  const AppButton(
    this.label, {
    required this.onPressed,
    this.isLoading = false,
    this.isEnabled = true,
    this.style,
    this.backgroundColor,
    this.textColor,
    this.width,
    this.height = 48,
    this.icon,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final ButtonStyle buttonStyle = style ??
        ElevatedButton.styleFrom(
          backgroundColor: backgroundColor ?? AppColors.primary,
          disabledBackgroundColor: AppColors.inputBorder,
          minimumSize: Size(width ?? double.infinity, height),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
        );

    return ElevatedButton(
      onPressed: isLoading || !isEnabled ? null : onPressed,
      style: buttonStyle,
      child: isLoading
          ? SizedBox(
              height: 24,
              width: 24,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                valueColor: AlwaysStoppedAnimation<Color>(
                  textColor ?? Colors.white,
                ),
              ),
            )
          : Row(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                if (icon != null) ...[
                  Icon(icon, color: textColor ?? Colors.white),
                  const SizedBox(width: 8),
                ],
                Text(
                  label,
                  style: TextStyles.labelLarge.copyWith(
                    color: textColor ?? Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
    );
  }
}

