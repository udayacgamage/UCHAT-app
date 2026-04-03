import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../shared/theme/text_styles.dart';

/// Typing indicator widget
class TypingIndicator extends StatefulWidget {
  final String? typingUserName;
  final bool isVisible;

  const TypingIndicator({
    this.typingUserName,
    this.isVisible = false,
    super.key,
  });

  @override
  State<TypingIndicator> createState() => _TypingIndicatorState();
}

class _TypingIndicatorState extends State<TypingIndicator>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late List<Animation<double>> _animations;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    )..repeat();

    _animations = List.generate(3, (index) {
      return Tween<double>(begin: 0, end: 1).animate(
        CurvedAnimation(
          parent: _animationController,
          curve: Interval(index * 0.3, 1.0, curve: Curves.easeInOut),
        ),
      );
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!widget.isVisible) {
      return const SizedBox.shrink();
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          if (widget.typingUserName != null)
            Text(
              '${widget.typingUserName} is typing...',
              style: TextStyles.bodySmall.copyWith(
                color: AppColors.lightTextSecondary,
              ),
            ),
          const SizedBox(height: 4),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: List.generate(3, (index) {
              return ScaleTransition(
                scale: _animations[index],
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 3),
                  child: Container(
                    width: 8,
                    height: 8,
                    decoration: BoxDecoration(
                      color: AppColors.primary.withOpacity(0.6),
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
              );
            }),
          ),
        ],
      ),
    );
  }
}

