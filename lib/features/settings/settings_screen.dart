import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/constants/app_colors.dart';
import '../../providers/settings_provider.dart';
import '../../providers/theme_provider.dart';
import '../../shared/widgets/app_logo_widget.dart';

/// Settings screen
class SettingsScreen extends ConsumerStatefulWidget {
  const SettingsScreen({super.key});

  @override
  ConsumerState<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends ConsumerState<SettingsScreen> {
  bool _notificationsEnabled = true;
  bool _readReceiptsEnabled = true;
  bool _lastSeenVisible = true;

  @override
  Widget build(BuildContext context) {
    final biometricEnabled = ref.watch(biometricSettingsProvider).value ?? false;
    final isDarkMode = ref.watch(themeProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
      ),
      body: ListView(
        children: [
          const SizedBox(height: 20),
          const Center(
            child: AppLogoWidget(
              size: 100,
              label: 'UCHAT',
              labelSpacing: 12,
            ),
          ),
          const SizedBox(height: 20),

          // Display settings
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Text(
              'Display',
              style: Theme.of(context).textTheme.labelLarge,
            ),
          ),
          _buildToggleTile(
            'Dark Mode',
            isDarkMode,
            (value) {
              ref.read(themeProvider.notifier).toggleTheme();
            },
          ),

          const Divider(),

          // Notifications
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Text(
              'Notifications',
              style: Theme.of(context).textTheme.labelLarge,
            ),
          ),
          _buildToggleTile(
            'Message Notifications',
            _notificationsEnabled,
            (value) {
              setState(() => _notificationsEnabled = value);
            },
          ),

          const Divider(),

          // Privacy
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Text(
              'Privacy',
              style: Theme.of(context).textTheme.labelLarge,
            ),
          ),
          _buildToggleTile(
            'Read Receipts',
            _readReceiptsEnabled,
            (value) {
              setState(() => _readReceiptsEnabled = value);
            },
          ),
          _buildToggleTile(
            'Show Last Seen',
            _lastSeenVisible,
            (value) {
              setState(() => _lastSeenVisible = value);
            },
          ),

          const Divider(),

          // Security
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Text(
              'Security',
              style: Theme.of(context).textTheme.labelLarge,
            ),
          ),
          _buildToggleTile(
            'Biometric Lock',
            biometricEnabled,
            (value) {
              ref.read(biometricSettingsProvider.notifier).toggleBiometric(value);
            },
          ),
          const SizedBox(height: 8),
          _buildActionTile(
            'Change Password',
            Icons.lock_outline,
            () {
              // Handle password change
            },
          ),

          const Divider(),

          // Dangerous zone
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Text(
              'Danger Zone',
              style: Theme.of(context).textTheme.labelLarge?.copyWith(
                color: AppColors.error,
              ),
            ),
          ),
          _buildActionTile(
            'Clear All Chats',
            Icons.delete_sweep,
            () {
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text('Clear All Chats?'),
                  content: const Text(
                    'This action cannot be undone. All messages will be deleted locally.',
                  ),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('Cancel'),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                        // Handle clear chats
                      },
                      child: const Text('Delete', style: TextStyle(color: AppColors.error)),
                    ),
                  ],
                ),
              );
            },
            isDestructive: true,
          ),

          const SizedBox(height: 24),
          Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              child: Text(
                'developed by udaya chathuranga',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: AppColors.lightTextSecondary,
                    ),
              ),
            ),
          ),
          const SizedBox(height: 12),
        ],
      ),
    );
  }

  Widget _buildToggleTile(String title, bool value, ValueChanged<bool> onChanged) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title, style: Theme.of(context).textTheme.bodyMedium),
          Switch(
            value: value,
            onChanged: onChanged,
            activeTrackColor: AppColors.primary,
          ),
        ],
      ),
    );
  }

  Widget _buildActionTile(
    String title,
    IconData icon,
    VoidCallback onTap, {
    bool isDestructive = false,
  }) {
    return ListTile(
      leading: Icon(
        icon,
        color: isDestructive ? AppColors.error : AppColors.primary,
      ),
      title: Text(
        title,
        style: TextStyle(
          color: isDestructive ? AppColors.error : null,
        ),
      ),
      onTap: onTap,
    );
  }
}
