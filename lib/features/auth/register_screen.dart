import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_strings.dart';
import '../../core/utils/validators.dart';
import '../../shared/widgets/app_button.dart';
import '../../shared/widgets/app_text_field.dart';
import '../../shared/widgets/loading_overlay.dart';
import '../../providers/auth_provider.dart';

/// Register screen
class RegisterScreen extends ConsumerStatefulWidget {
  const RegisterScreen({super.key});

  @override
  ConsumerState<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends ConsumerState<RegisterScreen> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _register() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      await ref.read(registerProvider(
        RegisterParams(
          fullName: _nameController.text.trim(),
          email: _emailController.text.trim(),
          password: _passwordController.text,
        ),
      ).future);

      if (mounted) {
        context.go('/home');
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(e.toString()),
            backgroundColor: AppColors.error,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
      ),
      body: LoadingOverlay(
        isLoading: _isLoading,
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header
                  Text(
                    AppStrings.registerTitle,
                    style: Theme.of(context).textTheme.displaySmall,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    AppStrings.registerSubtitle,
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: AppColors.lightTextSecondary,
                    ),
                  ),
                  const SizedBox(height: 32),

                  // Full name field
                  AppTextField(
                    label: AppStrings.fullNameLabel,
                    hint: AppStrings.fullNameHint,
                    controller: _nameController,
                    prefixIcon: Icons.person_outlined,
                    validator: Validators.validateName,
                  ),
                  const SizedBox(height: 20),

                  // Email field
                  AppTextField(
                    label: AppStrings.emailLabel,
                    hint: AppStrings.emailHint,
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
                    prefixIcon: Icons.email_outlined,
                    validator: Validators.validateEmail,
                  ),
                  const SizedBox(height: 20),

                  // Password field
                  AppTextField(
                    label: AppStrings.passwordLabel,
                    hint: AppStrings.passwordHint,
                    controller: _passwordController,
                    obscureText: true,
                    showPasswordToggle: true,
                    prefixIcon: Icons.lock_outlined,
                    validator: Validators.validatePassword,
                  ),
                  const SizedBox(height: 20),

                  // Confirm password field
                  AppTextField(
                    label: AppStrings.confirmPasswordLabel,
                    hint: AppStrings.confirmPasswordHint,
                    controller: _confirmPasswordController,
                    obscureText: true,
                    showPasswordToggle: true,
                    prefixIcon: Icons.lock_outlined,
                    validator: (value) => Validators.validatePasswordMatch(
                      _passwordController.text,
                      value,
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Terms checkbox
                  Row(
                    children: [
                      Checkbox(
                        value: true,
                        onChanged: (_) {},
                      ),
                      Expanded(
                        child: Text(
                          AppStrings.termsCheckbox,
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 32),

                  // Create account button
                  AppButton(
                    AppStrings.createAccountButton,
                    onPressed: _register,
                    isLoading: _isLoading,
                  ),
                  const SizedBox(height: 16),

                  // Login link
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        AppStrings.alreadyHaveAccount,
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                      TextButton(
                        onPressed: () => context.pop(),
                        child: Text(
                          AppStrings.loginTitle,
                          style: Theme.of(context).textTheme.labelLarge?.copyWith(
                            color: AppColors.primary,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

