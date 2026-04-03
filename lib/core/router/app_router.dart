import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../features/splash/splash_screen.dart';
import '../../features/auth/login_screen.dart';
import '../../features/auth/register_screen.dart';
import '../../features/auth/forgot_password_screen.dart';
import '../../features/home/home_screen.dart';
import '../../features/chat/chat_screen.dart';
import '../../features/home/search_users_screen.dart';
import '../../features/chat/create_group_screen.dart';
import '../../features/profile/profile_screen.dart';
import '../../features/settings/settings_screen.dart';
import '../../providers/auth_provider.dart';
import '../../providers/app_lock_provider.dart';
import '../../features/splash/lock_screen.dart';

// GoRouter provider
final goRouterProvider = Provider<GoRouter>((ref) {
  final authState = ref.watch(authStateProvider);
  final isLocked = ref.watch(appLockProvider); // Watch lock state

  return GoRouter(
    initialLocation: '/splash',
    redirect: (BuildContext context, GoRouterState state) {
      // Show splash while checking auth state
      if (authState.isLoading) {
        return '/splash';
      }

      // Get current location
      final isLoggingIn = state.matchedLocation == '/login' ||
          state.matchedLocation == '/register' ||
          state.matchedLocation == '/forgot-password' ||
          state.matchedLocation == '/splash';

      // Redirect to login if not authenticated
      if (authState.asData?.value == null) {
        return isLoggingIn ? null : '/login';
      }
      
      // If authenticated but app is locked
      if (isLocked) {
        return '/lock';
      }

      // If unlocked and on lock screen, go home
      if (!isLocked && state.matchedLocation == '/lock') {
        return '/home';
      }

      // Redirect to home if authenticated and on login page
      if (isLoggingIn) {
        return '/home';
      }

      return null;
    },
    routes: [
      // Splash
      GoRoute(
        path: '/splash',
        name: 'splash',
        builder: (context, state) => const SplashScreen(),
      ),

      // Lock Screen
      GoRoute(
        path: '/lock',
        name: 'lock',
        builder: (context, state) => const LockScreen(),
      ),

      // Auth routes
      GoRoute(
        path: '/login',
        name: 'login',
        builder: (context, state) => const LoginScreen(),
      ),

      GoRoute(
        path: '/register',
        name: 'register',
        builder: (context, state) => const RegisterScreen(),
      ),

      GoRoute(
        path: '/forgot-password',
        name: 'forgot-password',
        builder: (context, state) => const ForgotPasswordScreen(),
      ),

      // Home
      GoRoute(
        path: '/home',
        name: 'home',
        builder: (context, state) => const HomeScreen(),
      ),

      // Chat
      GoRoute(
        path: '/chat/:chatId',
        name: 'chat',
        builder: (context, state) {
          final isGroup = state.uri.queryParameters['isGroup'] == 'true';
          return ChatScreen(
            chatId: state.pathParameters['chatId']!,
            isGroup: isGroup,
          );
        },
      ),

      // Search Users
      GoRoute(
        path: '/search-users',
        name: 'search-users',
        builder: (context, state) => const SearchUsersScreen(),
      ),

      // Create Group
      GoRoute(
        path: '/create-group',
        name: 'create-group',
        builder: (context, state) => const CreateGroupScreen(),
      ),

      // Profile
      GoRoute(
        path: '/profile',
        name: 'profile',
        builder: (context, state) => const ProfileScreen(),
      ),

      // Settings
      GoRoute(
        path: '/settings',
        name: 'settings',
        builder: (context, state) => const SettingsScreen(),
      ),
    ],
  );
});

