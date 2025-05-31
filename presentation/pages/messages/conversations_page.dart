import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:frontend/data/models/conversation.dart';
import 'package:frontend/data/models/user_profile.dart';
import 'package:frontend/providers/conversation_provider.dart';
import 'package:frontend/providers/auth_provider.dart';
import 'package:timeago/timeago.dart' as timeago;

class ConversationsPage extends ConsumerWidget {
  const ConversationsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final conversationsAsync = ref.watch(conversationNotifierProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Messages'),
        centerTitle: true,
      ),
      body: conversationsAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Erreur: $error'),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () => ref.refresh(conversationNotifierProvider),
                child: const Text('Réessayer'),
              ),
            ],
          ),
        ),
        data: (conversations) {
          if (conversations.isEmpty) {
            return const Center(
              child: Text(
                'Aucune conversation',
                style: TextStyle(fontSize: 16),
              ),
            );
          }

          return ListView.builder(
            itemCount: conversations.length,
            itemBuilder: (context, index) {
              final conversation = conversations[index];
              final otherParticipant = conversation.participants.firstWhere(
                (p) => p.id != ref.read(authStateProvider).value?.id,
              );

              return ConversationTile(
                conversation: conversation,
                otherParticipant: otherParticipant,
                onTap: () {
                  context.push('/messages/${conversation.id}');
                  ref.read(conversationNotifierProvider.notifier)
                      .markMessagesAsRead(conversation.id);
                },
              );
            },
          );
        },
      ),
    );
  }
}

class ConversationTile extends StatelessWidget {
  final Conversation conversation;
  final UserProfile otherParticipant;
  final VoidCallback onTap;

  const ConversationTile({
    super.key,
    required this.conversation,
    required this.otherParticipant,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onTap,
      leading: CircleAvatar(
        backgroundImage: otherParticipant.photos.isNotEmpty
            ? NetworkImage(otherParticipant.photos.first)
            : null,
        child: otherParticipant.photos.isEmpty
            ? Text(otherParticipant.name[0].toUpperCase())
            : null,
      ),
      title: Text(otherParticipant.name),
      subtitle: conversation.lastMessage != null
          ? Text(
              conversation.lastMessage!.content,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            )
          : null,
      trailing: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          if (conversation.lastMessage != null)
            Text(
              timeago.format(conversation.lastMessage!.createdAt, locale: 'fr'),
              style: Theme.of(context).textTheme.bodySmall,
            ),
          if (conversation.unreadCount > 0)
            Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primary,
                shape: BoxShape.circle,
              ),
              child: Text(
                conversation.unreadCount.toString(),
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                ),
              ),
            ),
        ],
      ),
    );
  }
} 