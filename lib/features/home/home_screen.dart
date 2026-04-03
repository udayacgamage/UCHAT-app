import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_strings.dart';
import '../../providers/auth_provider.dart';
import '../../providers/chat_provider.dart';
import '../../shared/widgets/avatar_widget.dart';

/// Home screen (chat list)
class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    final currentUser = ref.watch(currentUserProvider);
    final chats = ref.watch(chatsStreamProvider);
    final currentUserId = currentUser.value?.uid;

    // Calculate total unread count for current tab
    int totalUnreadChats = 0;
    if (currentUserId != null && chats.asData != null) {
      final chatList = chats.asData!.value;
      totalUnreadChats = chatList.fold(
        0,
        (sum, chat) => sum + (chat.unreadCount[currentUserId] ?? 0),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Text(_currentIndex == 1 ? 'Groups' : AppStrings.homeTitle),
            if (totalUnreadChats > 0 && _currentIndex == 0)
              Container(
                margin: const EdgeInsets.only(left: 8),
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: AppColors.error,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  totalUnreadChats > 99 ? '99+' : '$totalUnreadChats',
                  style: Theme.of(context).textTheme.labelSmall?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
          ],
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: currentUser.whenData((user) {
              return GestureDetector(
                onTap: () => context.push('/profile'),
                child: AvatarWidget(
                  imageUrl: user?.photoUrl,
                  initials: (user?.name.split(' ').map((e) => e[0]).join() ?? '?'),
                  size: 40,
                ),
              );
            }).value ??
                const SizedBox.shrink(),
          ),
          const SizedBox(width: 8),
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              context.push('/search-users');
            },
          ),
        ],
      ),
      body: _currentIndex == 1 ? const _GroupList() : const _ChatList(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          if (_currentIndex == 1) {
            context.push('/create-group');
          } else {
            context.push('/search-users');
          }
        },
        child: Icon(_currentIndex == 1 ? Icons.group_add : Icons.message),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.chat),
            label: 'Chats',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.group),
            label: 'Groups',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
        onTap: (index) {
          if (index == 2) {
            context.push('/profile');
          } else {
            setState(() => _currentIndex = index);
          }
        },
      ),
    );
  }
}

class _ChatList extends ConsumerWidget {
  const _ChatList();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final chats = ref.watch(chatsStreamProvider);
    final currentUserAsync = ref.watch(currentUserProvider);
    final currentUserId = currentUserAsync.value?.uid;

    return chats.when(
        loading: () => const Center(
          child: CircularProgressIndicator(),
        ),
        error: (err, st) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.error_outline,
                size: 64,
                color: AppColors.error,
              ),
              const SizedBox(height: 16),
              Text('Error loading chats: $err'),
            ],
          ),
        ),
        data: (chatList) {
          if (chatList.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.chat_bubble_outline,
                    size: 64,
                    color: AppColors.primaryLight,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    AppStrings.noConversations,
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    AppStrings.startOne,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: AppColors.lightTextSecondary,
                    ),
                  ),
                ],
              ),
            );
          }

          return ListView.builder(
            itemCount: chatList.length,
            itemBuilder: (context, index) {
              final chat = chatList[index];
              
              // Resolve display info
              String title = 'Chat';
              String? photoUrl;
              
              if (currentUserId != null) {
                final otherId = chat.participants.firstWhere(
                  (id) => id != currentUserId,
                  orElse: () => '',
                );
                
                if (otherId.isNotEmpty) {
                  title = chat.participantNames[otherId] ?? 'Unknown User';
                  photoUrl = chat.participantPhotos[otherId];
                }
              }

              // Calculate unread count for current user
              final unreadCount = currentUserId != null 
                  ? (chat.unreadCount[currentUserId] ?? 0)
                  : 0;

              return ListTile(
                leading: Stack(
                  children: [
                    AvatarWidget(
                      imageUrl: photoUrl,
                      initials: title.isNotEmpty ? title[0] : '?',
                      size: 40,
                    ),
                    if (unreadCount > 0)
                      Positioned(
                        right: 0,
                        top: 0,
                        child: Container(
                          padding: const EdgeInsets.all(2),
                          decoration: const BoxDecoration(
                            color: AppColors.error,
                            shape: BoxShape.circle,
                          ),
                          constraints: const BoxConstraints(
                            minWidth: 20,
                            minHeight: 20,
                          ),
                          child: Center(
                            child: Text(
                              unreadCount > 99 ? '99+' : '$unreadCount',
                              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
                title: Text(title),
                subtitle: Text(
                  chat.lastMessage.isEmpty ? 'No messages' : chat.lastMessage,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                trailing: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      _formatTime(chat.lastMessageTime),
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                    if (unreadCount > 0)
                      Container(
                        width: 8,
                        height: 8,
                        margin: const EdgeInsets.only(top: 4),
                        decoration: const BoxDecoration(
                          color: AppColors.primary,
                          shape: BoxShape.circle,
                        ),
                      ),
                  ],
                ),
                onTap: () {
                  context.push('/chat/${chat.id}?isGroup=false');
                },
              );
            },
          );
        },
      );
  }

  String _formatTime(DateTime time) {
    return '${time.hour}:${time.minute.toString().padLeft(2, '0')}';
  }
}

class _GroupList extends ConsumerWidget {
  const _GroupList();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final groups = ref.watch(groupsStreamProvider);

    return groups.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (err, st) => Center(child: Text('Error: $err')),
      data: (groupList) {
        if (groupList.isEmpty) {
          return const Center(child: Text('No groups yet'));
        }

        return ListView.builder(
            itemCount: groupList.length,
            itemBuilder: (context, index) {
              final group = groupList[index];
              final memberCount = group.members.length;
              
              return ListTile(
                leading: Stack(
                  children: [
                    AvatarWidget(
                      imageUrl: group.photoUrl,
                      initials: group.name.isNotEmpty ? group.name[0] : 'G',
                      size: 40,
                    ),
                    Positioned(
                      right: 0,
                      bottom: 0,
                      child: Container(
                        padding: const EdgeInsets.all(2),
                        decoration: const BoxDecoration(
                          color: AppColors.primary,
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.group,
                          size: 12,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
                title: Text(group.name),
                subtitle: Text(
                  group.lastMessage.isEmpty 
                      ? '$memberCount members'
                      : '${group.lastMessage} • $memberCount members',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                trailing: Text(
                  _formatTime(group.lastMessageTime),
                  style: Theme.of(context).textTheme.bodySmall,
                ),
                onTap: () {
                  context.push('/chat/${group.id}?isGroup=true');
                },
              );
            },
          );
      },
    );
  }

  String _formatTime(DateTime time) {
    return '${time.hour}:${time.minute.toString().padLeft(2, '0')}';
  }
}
