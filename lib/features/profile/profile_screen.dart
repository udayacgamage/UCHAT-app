import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../core/constants/app_colors.dart';
import '../../providers/auth_provider.dart';
import '../../providers/media_provider.dart';
import '../../providers/user_provider.dart';
import '../../providers/chat_provider.dart';
import '../../shared/widgets/avatar_widget.dart';
import '../../shared/widgets/app_button.dart';

/// Profile screen
class ProfileScreen extends ConsumerStatefulWidget {
  const ProfileScreen({super.key});

  @override
  ConsumerState<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends ConsumerState<ProfileScreen> {
  bool _isUpdatingPhoto = false;

  String _initialsFor(String name) {
    final trimmed = name.trim();
    if (trimmed.isEmpty) return '?';
    final parts = trimmed
        .split(RegExp(r'\s+'))
        .where((part) => part.isNotEmpty)
        .toList();
    if (parts.isEmpty) return '?';
    return parts.take(2).map((part) => part[0].toUpperCase()).join();
  }

  Future<void> _changeProfilePhoto(String userId) async {
    if (_isUpdatingPhoto) return;

    setState(() => _isUpdatingPhoto = true);

    try {
      final mediaService = ref.read(mediaServiceProvider);
      final userService = ref.read(userServiceProvider);

      final File? photo = await mediaService.pickImageFromGallery();
      if (photo == null) return;

      await userService.updateUserProfile(userId, newPhoto: photo);

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Profile photo updated')),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to update profile photo: $e')),
      );
    } finally {
      if (mounted) {
        setState(() => _isUpdatingPhoto = false);
      }
    }
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date).inDays;

    if (difference == 0) {
      return 'Today';
    } else if (difference == 1) {
      return 'Yesterday';
    } else if (difference < 7) {
      return '$difference days ago';
    } else if (difference < 30) {
      final weeks = (difference / 7).floor();
      return '$weeks week${weeks > 1 ? 's' : ''} ago';
    } else if (difference < 365) {
      final months = (difference / 30).floor();
      return '$months month${months > 1 ? 's' : ''} ago';
    } else {
      final years = (difference / 365).floor();
      return '$years year${years > 1 ? 's' : ''} ago';
    }
  }

  Widget _buildInfoTile(String label, String value) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: Colors.grey[600],
            ),
          ),
          Text(
            value,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final currentUser = ref.watch(currentUserProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        elevation: 0,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 8),
            child: IconButton(
              icon: const Icon(Icons.settings_outlined),
              tooltip: 'Settings',
              onPressed: () => context.push('/settings'),
            ),
          ),
        ],
      ),
      body: currentUser.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, st) => Center(child: Text('Error: $err')),
        data: (user) {
          if (user == null) {
            return const Center(child: Text('No user logged in'));
          }

          return CustomScrollView(
            slivers: [
              // Header with gradient
              SliverAppBar(
                expandedHeight: 220,
                flexibleSpace: FlexibleSpaceBar(
                  background: Container(
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [AppColors.primary, AppColors.primaryDark],
                      ),
                    ),
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Stack(
                            children: [
                              AvatarWidget(
                                imageUrl: user.photoUrl,
                                initials: _initialsFor(user.name),
                                size: 88,
                                border: Border.all(color: Colors.white, width: 3),
                              ),
                              Positioned(
                                right: 0,
                                bottom: 0,
                                child: InkWell(
                                  onTap: _isUpdatingPhoto
                                      ? null
                                      : () => _changeProfilePhoto(user.uid),
                                  borderRadius: BorderRadius.circular(20),
                                  child: Container(
                                    width: 36,
                                    height: 36,
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      shape: BoxShape.circle,
                                      border: Border.all(color: AppColors.primary, width: 1.5),
                                    ),
                                    child: _isUpdatingPhoto
                                        ? const Padding(
                                            padding: EdgeInsets.all(8),
                                            child: CircularProgressIndicator(strokeWidth: 2),
                                          )
                                        : const Icon(
                                            Icons.photo_camera_outlined,
                                            size: 18,
                                            color: AppColors.primary,
                                          ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          Text(
                            user.name,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),

              // Profile info
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Stats - Dynamic calculation
                      _StatsRow(),
                      const SizedBox(height: 32),

                      // Email
                      Text(
                        'Email',
                        style: Theme.of(context).textTheme.labelLarge,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        user.email,
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                      const SizedBox(height: 32),

                      // Account Info Section
                      Text(
                        'Account Information',
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 16),
                      _buildInfoTile('Member Since', _formatDate(user.createdAt)),
                      const SizedBox(height: 12),
                      _buildInfoTile('User ID', user.uid.substring(0, 12) + '...'),
                      const SizedBox(height: 32),

                      // Logout button
                      AppButton(
                        'Sign Out',
                        onPressed: () async {
                          await ref.read(logoutProvider.future);
                          if (context.mounted) {
                            context.go('/login');
                          }
                        },
                        backgroundColor: AppColors.error,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildStat(String count, String label) {
    return Column(
      children: [
        Text(
          count,
          style: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: AppColors.primary,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            color: AppColors.lightTextSecondary,
          ),
        ),
      ],
    );
  }
}

class _StatsRow extends ConsumerWidget {
  const _StatsRow();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final chatsAsync = ref.watch(chatsStreamProvider);
    final groupsAsync = ref.watch(groupsStreamProvider);

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        // Chats count
        chatsAsync.when(
          data: (chats) => _buildStat('${chats.length}', 'Chats'),
          loading: () => _buildStat('...', 'Chats'),
          error: (_, __) => _buildStat('0', 'Chats'),
        ),

        // Groups count
        groupsAsync.when(
          data: (groups) => _buildStat('${groups.length}', 'Groups'),
          loading: () => _buildStat('...', 'Groups'),
          error: (_, __) => _buildStat('0', 'Groups'),
        ),

        // Media count (placeholder - would need message stream to count media)
        _buildStat('0', 'Media'),
      ],
    );
  }

  Widget _buildStat(String count, String label) {
    return Column(
      children: [
        Text(
          count,
          style: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: AppColors.primary,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            color: AppColors.lightTextSecondary,
          ),
        ),
      ],
    );
  }
}

