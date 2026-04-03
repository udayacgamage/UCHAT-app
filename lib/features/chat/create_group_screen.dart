import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:uuid/uuid.dart';
import '../../models/user_model.dart';
import '../../providers/chat_provider.dart';
import '../../providers/user_provider.dart';
import '../../providers/auth_provider.dart';
import '../../shared/widgets/app_button.dart';
import '../../shared/widgets/app_text_field.dart';
import '../../shared/widgets/avatar_widget.dart';

class CreateGroupScreen extends ConsumerStatefulWidget {
  const CreateGroupScreen({super.key});

  @override
  ConsumerState<CreateGroupScreen> createState() => _CreateGroupScreenState();
}

class _CreateGroupScreenState extends ConsumerState<CreateGroupScreen> {
  final _nameController = TextEditingController();
  final _descController = TextEditingController();
  final List<UserModel> _selectedMembers = [];
  bool _isLoading = false;

  void _addMember() async {
    // Navigate to user search and wait result
    final user = await showSearch(
      context: context,
      delegate: UserSearchDelegate(ref),
    );

    if (user != null && !_selectedMembers.any((m) => m.uid == user.uid)) {
      setState(() {
        _selectedMembers.add(user);
      });
    }
  }

  void _removeMember(UserModel user) {
    setState(() {
      _selectedMembers.removeWhere((m) => m.uid == user.uid);
    });
  }

  Future<void> _createGroup() async {
    final name = _nameController.text.trim();
    if (name.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a group name')),
      );
      return;
    }

    if (_selectedMembers.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please add at least 1 member')),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      final authService = ref.read(authServiceProvider);
      final currentUser = authService.currentUser;
      if (currentUser == null) {
        throw StateError('User not logged in');
      }

      final groupId = const Uuid().v4();
      final memberIds = _selectedMembers.map((u) => u.uid).toList()
        ..add(currentUser.uid); // Add creator

      await ref.read(chatServiceProvider).createGroup(
        groupId: groupId,
        name: name,
        description: _descController.text.trim(),
        memberIds: memberIds,
        createdBy: currentUser.uid,
      );

      if (mounted) {
        context.pushReplacement('/chat/$groupId?isGroup=true');
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to create group: $e')),
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
      appBar: AppBar(title: const Text('New Group')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            AppTextField(
              controller: _nameController,
              label: 'Group Name',
              hint: 'Enter group name',
            ),
            const SizedBox(height: 16),
            AppTextField(
              controller: _descController,
              label: 'Description',
              hint: 'Optional description',
            ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Members (${_selectedMembers.length})',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                IconButton(
                  icon: const Icon(Icons.person_add),
                  onPressed: _addMember,
                ),
              ],
            ),
            Expanded(
              child: ListView.builder(
                itemCount: _selectedMembers.length,
                itemBuilder: (context, index) {
                  final user = _selectedMembers[index];
                  return ListTile(
                    leading: AvatarWidget(
                      imageUrl: user.photoUrl,
                      initials: user.name.isNotEmpty ? user.name[0] : '?',
                      size: 32,
                    ),
                    title: Text(user.name),
                    trailing: IconButton(
                      icon: const Icon(Icons.remove_circle_outline),
                      onPressed: () => _removeMember(user),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 16),
            AppButton(
              'Create Group',
              onPressed: () => _createGroup(),
              isLoading: _isLoading,
            ),
          ],
        ),
      ),
    );
  }
}

class UserSearchDelegate extends SearchDelegate<UserModel?> {
  final WidgetRef ref;

  UserSearchDelegate(this.ref);

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(icon: const Icon(Icons.clear), onPressed: () => query = ''),
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: () => close(context, null),
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return _buildSearchResults();
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return _buildSearchResults();
  }

  Widget _buildSearchResults() {
    if (query.isEmpty) return Container();

    return FutureBuilder<List<UserModel>>(
      future: ref.read(searchUsersProvider(query).future),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }
        final users = snapshot.data ?? [];
        if (users.isEmpty) {
          return const Center(child: Text('No users found'));
        }
        return ListView.builder(
          itemCount: users.length,
          itemBuilder: (context, index) {
            final user = users[index];
            return ListTile(
              leading: AvatarWidget(
                imageUrl: user.photoUrl,
                initials: user.name.isNotEmpty ? user.name[0] : '?',
                size: 32,
              ),
              title: Text(user.name),
              subtitle: Text(user.email),
              onTap: () => close(context, user),
            );
          },
        );
      },
    );
  }
}
