import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';

/// Online status indicator widget
class OnlineIndicator extends StatelessWidget {
  final bool isOnline;
  final double size;
  final EdgeInsetsGeometry padding;

  const OnlineIndicator({
    required this.isOnline,
    this.size = 12,
    this.padding = const EdgeInsets.all(2),
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding,
      decoration: BoxDecoration(
        color: isOnline ? AppColors.success : AppColors.lightTextSecondary,
        shape: BoxShape.circle,
        border: Border.all(
          color: Theme.of(context).scaffoldBackgroundColor,
          width: 2,
        ),
      ),
      width: size,
      height: size,
    );
  }
}

