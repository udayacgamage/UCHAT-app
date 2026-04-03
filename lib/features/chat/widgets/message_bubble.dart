import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../shared/theme/text_styles.dart';

/// Message bubble widget for displaying messages
class MessageBubble extends StatelessWidget {
  final String senderName;
  final String content;
  final String? mediaUrl;
  final DateTime timestamp;
  final bool isSent;
  final bool isRead;
  final bool isDelivered;
  final VoidCallback? onLongPress;
  final VoidCallback? onTap;

  const MessageBubble({
    required this.senderName,
    required this.content,
    this.mediaUrl,
    required this.timestamp,
    required this.isSent,
    this.isRead = false,
    this.isDelivered = false,
    this.onLongPress,
    this.onTap,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: isSent ? Alignment.centerRight : Alignment.centerLeft,
      child: GestureDetector(
        onLongPress: onLongPress,
        onTap: onTap,
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            color: isSent ? AppColors.sentBubble : AppColors.receivedBubble,
            borderRadius: BorderRadius.circular(18),
          ),
          child: Column(
            crossAxisAlignment:
                isSent ? CrossAxisAlignment.end : CrossAxisAlignment.start,
            children: [
              if (!isSent)
                Text(
                  senderName,
                  style: TextStyles.labelSmall.copyWith(
                    color: AppColors.primary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              if (mediaUrl != null)
                Padding(
                  padding: const EdgeInsets.only(bottom: 8.0),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: CachedNetworkImage(
                      imageUrl: mediaUrl!,
                      width: 200,
                      height: 200,
                      fit: BoxFit.cover,
                      placeholder: (context, url) => Container(
                        width: 200,
                        height: 200,
                        color: Colors.grey[300],
                        child: const Center(child: CircularProgressIndicator()),
                      ),
                      errorWidget: (context, url, error) => const Icon(Icons.error),
                    ),
                  ),
                ),
              const SizedBox(height: 4),
              Text(
                content,
                style: TextStyles.bodyMedium.copyWith(
                  color: isSent ? AppColors.sentText : AppColors.receivedText,
                ),
              ),
              const SizedBox(height: 4),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    '${timestamp.hour}:${timestamp.minute.toString().padLeft(2, '0')}',
                    style: TextStyles.labelSmall.copyWith(
                      color: isSent
                          ? Colors.white70
                          : AppColors.lightTextSecondary,
                    ),
                  ),
                  if (isSent) ...[
                    const SizedBox(width: 4),
                    Icon(
                      isRead ? Icons.done_all : Icons.done,
                      size: 16,
                      color: isRead ? Colors.blue : Colors.white70,
                    ),
                  ],
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
