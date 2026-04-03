import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../core/constants/app_colors.dart';
import '../../providers/auth_provider.dart';
import '../../shared/widgets/app_logo_widget.dart';

/// Splash screen with auto-navigation
class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat();

    _checkAuth();
  }

  Future<void> _checkAuth() async {
    // Wait for minimum splash duration
    await Future.delayed(const Duration(seconds: 2));

    if (!mounted) return;

    // Use ref.read to get the current state.
    // If it's loading, we wait for the next state update.
    final authState = ref.read(authStateProvider);

    if (authState.isLoading) {
      try {
        final user = await ref.read(authStateProvider.future);
        if (mounted) {
          context.go(user != null ? '/home' : '/login');
        }
      } catch (e) {
        if (mounted) {
          context.go('/login');
        }
      }
    } else {
      authState.whenData((user) {
        if (mounted) {
          context.go(user != null ? '/home' : '/login');
        }
      });
      if (authState.hasError && mounted) {
        context.go('/login');
      }
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              AppColors.primary,
              AppColors.primaryDark,
            ],
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const AppLogoWidget(
                size: 150,
                label: 'UCHAT',
                labelSpacing: 20,
                textColor: Colors.white,
              ),
              const SizedBox(height: 60),

              // Animated spinner
              RotationTransition(
                turns: _animationController,
                child: Icon(
                  Icons.lock_rounded,
                  size: 60,
                  color: Colors.white.withValues(alpha: 0.8),
                ),
              ),
              const Spacer(),
              
              // Loading progress bar at bottom
              Padding(
                padding: const EdgeInsets.only(bottom: 40),
                child: SizedBox(
                  width: 100,
                  height: 4,
                  child: LinearProgressIndicator(
                    backgroundColor: Colors.white.withValues(alpha: 0.2),
                    valueColor: AlwaysStoppedAnimation<Color>(
                      Colors.white.withValues(alpha: 0.8),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
