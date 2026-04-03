import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../shared/theme/text_styles.dart';

/// Custom text field widget with validation
class AppTextField extends StatefulWidget {
  final String label;
  final String? hint;
  final TextEditingController? controller;
  final String? Function(String?)? validator;
  final TextInputType keyboardType;
  final bool obscureText;
  final bool showPasswordToggle;
  final IconData? prefixIcon;
  final IconData? suffixIcon;
  final VoidCallback? onSuffixIconPressed;
  final ValueChanged<String>? onChanged;
  final int? maxLines;
  final int? minLines;
  final int? maxLength;
  final bool enabled;
  final String? errorText;
  final TextInputAction textInputAction;
  final FocusNode? focusNode;

  const AppTextField({
    required this.label,
    this.hint,
    this.controller,
    this.validator,
    this.keyboardType = TextInputType.text,
    this.obscureText = false,
    this.showPasswordToggle = false,
    this.prefixIcon,
    this.suffixIcon,
    this.onSuffixIconPressed,
    this.onChanged,
    this.maxLines = 1,
    this.minLines,
    this.maxLength,
    this.enabled = true,
    this.errorText,
    this.textInputAction = TextInputAction.done,
    this.focusNode,
    super.key,
  });

  @override
  State<AppTextField> createState() => _AppTextFieldState();
}

class _AppTextFieldState extends State<AppTextField> {
  late bool _obscureText;

  @override
  void initState() {
    super.initState();
    _obscureText = widget.obscureText;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          widget.label,
          style: TextStyles.labelLarge.copyWith(
            color: AppColors.lightTextPrimary,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: widget.controller,
          focusNode: widget.focusNode,
          keyboardType: widget.keyboardType,
          obscureText: _obscureText,
          onChanged: widget.onChanged,
          maxLines: _obscureText ? 1 : widget.maxLines,
          minLines: widget.minLines,
          maxLength: widget.maxLength,
          enabled: widget.enabled,
          textInputAction: widget.textInputAction,
          decoration: InputDecoration(
            hintText: widget.hint,
            prefixIcon: widget.prefixIcon != null ? Icon(widget.prefixIcon) : null,
            suffixIcon: _buildSuffixIcon(),
            counterText: '',
            errorText: widget.errorText,
            errorStyle: TextStyles.labelSmall.copyWith(
              color: AppColors.error,
            ),
          ),
        ),
        if (widget.errorText != null && widget.errorText!.isNotEmpty) ...[
          const SizedBox(height: 8),
          Text(
            widget.errorText!,
            style: TextStyles.labelSmall.copyWith(
              color: AppColors.error,
            ),
          ),
        ],
      ],
    );
  }

  Widget? _buildSuffixIcon() {
    if (widget.showPasswordToggle) {
      return IconButton(
        icon: Icon(
          _obscureText ? Icons.visibility_off : Icons.visibility,
          color: AppColors.lightTextSecondary,
        ),
        onPressed: () {
          setState(() => _obscureText = !_obscureText);
        },
      );
    }

    if (widget.suffixIcon != null) {
      return IconButton(
        icon: Icon(widget.suffixIcon, color: AppColors.lightTextSecondary),
        onPressed: widget.onSuffixIconPressed,
      );
    }

    return null;
  }
}

