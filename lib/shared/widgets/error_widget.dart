import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../shared/theme/text_styles.dart';

/// Error widget for displaying errors
class ErrorWidget extends StatelessWidget {
  final String message;
  final String? title;
  final VoidCallback? onRetry;
  final bool isDismissible;

  const ErrorWidget({
    required this.message,
    this.title,
    this.onRetry,
    this.isDismissible = true,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Icon(
                Icons.error_outline,
                color: AppColors.error,
                size: 24,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (title != null)
                      Text(
                        title!,
                        style: TextStyles.labelLarge.copyWith(
                          color: AppColors.error,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    Text(
                      message,
                      style: TextStyles.bodySmall.copyWith(
                        color: AppColors.lightTextSecondary,
                      ),
                    ),
                  ],
                ),
              ),
              if (isDismissible)
                IconButton(
                  icon: const Icon(Icons.close),
                  color: AppColors.lightTextSecondary,
                  onPressed: () => Navigator.pop(context),
                ),
            ],
          ),
          if (onRetry != null) ...[
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: onRetry,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.error,
              ),
              child: Text(
                'Try Again',
                style: TextStyles.labelMedium.copyWith(
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

