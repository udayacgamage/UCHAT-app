import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../core/constants/app_colors.dart';
import '../../models/user_model.dart';
import '../../providers/chat_provider.dart';
import '../../providers/user_provider.dart';
import '../../providers/auth_provider.dart';
import '../../shared/widgets/avatar_widget.dart';

class SearchUsersScreen extends ConsumerStatefulWidget {
  const SearchUsersScreen({super.key});

  @override
  ConsumerState<SearchUsersScreen> createState() => _SearchUsersScreenState();
}

class _SearchUsersScreenState extends ConsumerState<SearchUsersScreen> {
  final _searchController = TextEditingController();
  List<UserModel> _searchResults = [];
  bool _isLoading = false;

  void _onSearchChanged(String query) {
    // Debounce or just search on submit?
    // For simplicity, search on submit or minimal debounce
  }

  Future<void> _performSearch() async {
    final query = _searchController.text.trim();
    if (query.isEmpty) return;

    setState(() => _isLoading = true);
    
    try {
      // We use ref.read to get the future from provider or service directly
      // searchUsersProvider is a FutureProvider family
      final users = await ref.read(searchUsersProvider(query).future);
      setState(() {
        _searchResults = users;
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Search failed: $e')),
        );
      }
    }
  }

  Future<void> _startChat(UserModel otherUser) async {
    try {
      final currentUser = ref.read(currentUserProvider).value;
      if (currentUser == null) return;

      final chat = await ref.read(chatServiceProvider).createOrGetDirectChat(
        currentUser.uid,
        otherUser.uid,
        currentUser.name,
        otherUser.name,
        currentUser.photoUrl,
        otherUser.photoUrl,
      );

      if (mounted) {
        context.pushReplacement('/chat/${chat.id}?isGroup=false');
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to start chat: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDark ? Colors.white : AppColors.lightTextPrimary;
    final hintColor = isDark ? Colors.white70 : AppColors.lightTextSecondary;

    return Scaffold(
      appBar: AppBar(
        title: TextField(
          controller: _searchController,
          autofocus: true,
          decoration: InputDecoration(
            hintText: 'Search users...',
            border: InputBorder.none,
            hintStyle: TextStyle(color: hintColor),
          ),
          style: TextStyle(color: textColor),
          onSubmitted: (_) => _performSearch(),
          textInputAction: TextInputAction.search,
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: _performSearch,
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _searchResults.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.person_search,
                        size: 64,
                        color: isDark ? Colors.grey[500] : Colors.grey[300],
                      ),
                      const SizedBox(height: 16),
                      Text(
                        _searchController.text.isEmpty
                            ? 'Search by name or email'
                            : 'No users found',
                        style: TextStyle(
                          color: isDark ? Colors.grey[400] : Colors.grey,
                        ),
                      ),
                    ],
                  ),
                )
              : ListView.builder(
                  itemCount: _searchResults.length,
                  itemBuilder: (context, index) {
                    final user = _searchResults[index];
                    return ListTile(
                      leading: AvatarWidget(
                        imageUrl: user.photoUrl,
                        initials: user.name.isNotEmpty ? user.name[0] : '?',
                        size: 40,
                      ),
                      title: Text(user.name),
                      subtitle: Text(user.email),
                      onTap: () => _startChat(user),
                    );
                  },
                ),
    );
  }
}

