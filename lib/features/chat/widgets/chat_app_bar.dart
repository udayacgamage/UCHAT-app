import 'package:flutter/material.dart';
import '../../../models/user_model.dart';
import '../../../shared/widgets/avatar_widget.dart';
import '../../../shared/widgets/online_indicator.dart';
import '../../../shared/theme/text_styles.dart';
import '../../../core/constants/app_colors.dart';

/// Chat screen app bar with user info and online status
class ChatAppBar extends StatelessWidget implements PreferredSizeWidget {
  final UserModel otherUser;
  final VoidCallback onPressed;
  final bool isGroup;

  const ChatAppBar({
    required this.otherUser,
    required this.onPressed,
    this.isGroup = false,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      elevation: 1,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back),
        onPressed: () => Navigator.of(context).pop(),
      ),
      title: GestureDetector(
        onTap: onPressed,
        child: Row(
          children: [
            // Avatar with online indicator
            Stack(
              children: [
                AvatarWidget(
                  imageUrl: otherUser.photoUrl,
                  initials: otherUser.name.substring(0, 1).toUpperCase(),
                  size: 40,
                ),
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: OnlineIndicator(
                    isOnline: otherUser.isOnline,
                    size: 14,
                  ),
                ),
              ],
            ),
            const SizedBox(width: 12),
            // User info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    otherUser.name,
                    style: TextStyles.heading6.copyWith(
                      color: Theme.of(context).brightness == Brightness.dark
                          ? AppColors.darkTextPrimary
                          : AppColors.lightTextPrimary,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 2),
                  Text(
                    otherUser.isOnline ? 'Online' : 'Offline',
                    style: TextStyles.labelSmall.copyWith(
                      color: otherUser.isOnline
                          ? AppColors.success
                          : AppColors.lightTextSecondary,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.call),
          onPressed: () {
            // TODO: Implement voice call
          },
        ),
        IconButton(
          icon: const Icon(Icons.info_outline),
          onPressed: onPressed,
        ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

