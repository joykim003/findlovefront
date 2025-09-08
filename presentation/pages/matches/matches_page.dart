import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../providers/match_provider.dart';
import '../../../providers/conversation_provider.dart';

class MatchesPage extends ConsumerWidget {
  const MatchesPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final matchesAsync = ref.watch(matchNotifierProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Mes Matches'),
        centerTitle: true,
      ),
      body: matchesAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Erreur: $error', style: const TextStyle(color: Colors.red)),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () => ref.refresh(matchNotifierProvider),
                child: const Text('Réessayer'),
              ),
            ],
          ),
        ),
        data: (matches) {
          if (matches.isEmpty) {
            return const Center(
              child: Text(
                'Aucun match pour le moment',
                style: TextStyle(fontSize: 18),
              ),
            );
          }

          return RefreshIndicator(
            onRefresh: () =>
                ref.read(matchNotifierProvider.notifier).refreshMatches(),
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: matches.length,
              itemBuilder: (context, index) {
                final match = matches[index];
                final profile = match.profile;
                return Card(
                  margin: const EdgeInsets.only(bottom: 16),
                  child: ListTile(
                    leading: CircleAvatar(
                      radius: 30,
                      backgroundImage: profile.photos.isNotEmpty &&
                              profile.photos.first.isNotEmpty
                          ? NetworkImage(profile.photos.first)
                          : null,
                      child:
                          profile.photos.isEmpty || profile.photos.first.isEmpty
                              ? const Icon(Icons.person)
                              : null,
                    ),
                    title: Text('${profile.name}, ${profile.age}'),
                    subtitle: Text(profile.location ?? ''),
                    trailing: IconButton(
                      icon: const Icon(Icons.chat_bubble_outline),
                      onPressed: () async {
                        try {
                          await ref
                              .read(conversationNotifierProvider.notifier)
                              .createConversation(profile.id);
                          if (context.mounted) {
                            context.push('/messages');
                          }
                        } catch (e) {
                          if (context.mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('Erreur: $e'),
                                backgroundColor: Colors.red,
                              ),
                            );
                          }
                        }
                      },
                    ),
                    onTap: () {
                      // TODO: Implémenter la navigation vers le profil détaillé
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Profil détaillé à venir !'),
                        ),
                      );
                    },
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
