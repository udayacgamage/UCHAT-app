import 'package:flutter/material.dart';

/// Reusable app logo that uses the image asset (logo_adaptive.png).
class AppLogoWidget extends StatelessWidget {
  final double size;
  final bool showLabel;
  final String label;
  final double labelSpacing;
  final Color textColor;

  const AppLogoWidget({
    super.key,
    this.size = 120,
    this.showLabel = true,
    this.label = 'UCHAT',
    this.labelSpacing = 16,
    this.textColor = Colors.white,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Image logo asset
        Image.asset(
          'assets/logo_adaptive.png',
          width: size,
          height: size,
          fit: BoxFit.contain,
        ),
        if (showLabel) ...[
          SizedBox(height: labelSpacing),
          Text(
            label,
            style: TextStyle(
              color: textColor,
              fontSize: size * 0.32,
              fontWeight: FontWeight.w700,
              height: 1,
              letterSpacing: 1.2,
            ),
          ),
        ],
      ],
    );
  }
}

