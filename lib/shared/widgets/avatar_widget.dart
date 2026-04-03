import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../core/constants/app_colors.dart';
import '../../shared/theme/text_styles.dart';

/// Circular avatar widget with optional online indicator
class AvatarWidget extends StatelessWidget {
  final String? imageUrl;
  final String? initials;
  final double size;
  final Color? backgroundColor;
  final bool showOnlineIndicator;
  final bool isOnline;
  final VoidCallback? onTap;
  final Border? border;

  const AvatarWidget({
    this.imageUrl,
    this.initials,
    this.size = 48,
    this.backgroundColor,
    this.showOnlineIndicator = false,
    this.isOnline = false,
    this.onTap,
    this.border,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Stack(
        children: [
          Container(
            width: size,
            height: size,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: backgroundColor ?? AppColors.primaryLight,
              border: border,
            ),
            child: imageUrl != null && imageUrl!.isNotEmpty
                ? ClipOval(
                    child: CachedNetworkImage(
                      imageUrl: imageUrl!,
                      fit: BoxFit.cover,
                      placeholder: (context, url) => Container(
                        color: AppColors.primaryLight,
                      ),
                      errorWidget: (context, url, error) =>
                          _buildPlaceholder(),
                    ),
                  )
                : _buildPlaceholder(),
          ),
          if (showOnlineIndicator)
            Positioned(
              right: 0,
              bottom: 0,
              child: Container(
                width: size * 0.35,
                height: size * 0.35,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: isOnline ? AppColors.online : AppColors.offline,
                  border: Border.all(
                    color: AppColors.surface,
                    width: 2,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildPlaceholder() {
    final text = initials ?? '';
    return Container(
      color: backgroundColor ?? AppColors.primaryLight,
      child: Center(
        child: Text(
          text,
          style: TextStyles.heading5.copyWith(
            color: AppColors.primary,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}

