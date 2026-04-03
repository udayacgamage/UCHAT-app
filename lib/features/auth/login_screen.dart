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

/// Login screen
class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  String? _emailError;
  String? _passwordError;
  bool _isLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _login() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      await ref.read(loginProvider(
        LoginParams(
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

  void _loginWithGoogle() async {
    setState(() => _isLoading = true);

    try {
      await ref.read(googleLoginProvider.future);
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
                  const SizedBox(height: 24),
                  Icon(
                    Icons.shield_rounded,
                    size: 64,
                    color: AppColors.primary,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    AppStrings.loginTitle,
                    style: Theme.of(context).textTheme.displaySmall,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    AppStrings.loginSubtitle,
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: AppColors.lightTextSecondary,
                    ),
                  ),
                  const SizedBox(height: 32),

                  // Email field
                  AppTextField(
                    label: AppStrings.emailLabel,
                    hint: AppStrings.emailHint,
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
                    errorText: _emailError,
                    prefixIcon: Icons.email_outlined,
                    onChanged: (_) {
                      if (_emailError != null) {
                        setState(() => _emailError = null);
                      }
                    },
                    validator: (value) {
                      final error = Validators.validateEmail(value);
                      if (error != null) {
                        setState(() => _emailError = error);
                      }
                      return error;
                    },
                  ),
                  const SizedBox(height: 20),

                  // Password field
                  AppTextField(
                    label: AppStrings.passwordLabel,
                    hint: AppStrings.passwordHint,
                    controller: _passwordController,
                    obscureText: true,
                    showPasswordToggle: true,
                    errorText: _passwordError,
                    prefixIcon: Icons.lock_outlined,
                    onChanged: (_) {
                      if (_passwordError != null) {
                        setState(() => _passwordError = null);
                      }
                    },
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        final error = AppStrings.passwordRequired;
                        setState(() => _passwordError = error);
                        return error;
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 12),

                  // Forgot password link
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      onPressed: () => context.push('/forgot-password'),
                      child: Text(
                        AppStrings.forgotPassword,
                        style: Theme.of(context).textTheme.labelLarge?.copyWith(
                          color: AppColors.primary,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Sign in button
                  AppButton(
                    AppStrings.signInButton,
                    onPressed: _login,
                    isLoading: _isLoading,
                  ),
                  const SizedBox(height: 16),

                  // Google sign in button
                  OutlinedButton.icon(
                    onPressed: _isLoading ? null : _loginWithGoogle,
                    icon: const Icon(Icons.g_translate),
                    label: Text(
                      AppStrings.signInWithGoogle,
                      style: Theme.of(context).textTheme.labelLarge,
                    ),
                    style: OutlinedButton.styleFrom(
                      minimumSize: const Size(double.infinity, 48),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                  ),
                  const SizedBox(height: 32),

                  // Register link
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        AppStrings.dontHaveAccount,
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                      TextButton(
                        onPressed: () => context.push('/register'),
                        child: Text(
                          AppStrings.register,
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

