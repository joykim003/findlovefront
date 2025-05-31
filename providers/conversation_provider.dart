import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/data/models/conversation.dart';
import 'package:frontend/data/services/conversation_service.dart';
import 'package:frontend/data/services/api_service.dart';

final apiServiceProvider = Provider<ApiService>((ref) => ApiService());

final conversationServiceProvider = Provider<ConversationService>((ref) {
  final apiService = ref.watch(apiServiceProvider);
  return ConversationService(apiService);
});

final conversationsProvider = FutureProvider<List<Conversation>>((ref) async {
  final service = ref.watch(conversationServiceProvider);
  return service.getConversations();
});

final conversationMessagesProvider =
    FutureProvider.family<List<Message>, int>((ref, conversationId) async {
  final service = ref.watch(conversationServiceProvider);
  return service.getMessages(conversationId);
});

class ConversationNotifier
    extends StateNotifier<AsyncValue<List<Conversation>>> {
  final ConversationService _service;

  ConversationNotifier(this._service) : super(const AsyncValue.loading()) {
    _loadConversations();
  }

  Future<void> _loadConversations() async {
    try {
      final conversations = await _service.getConversations();
      state = AsyncValue.data(conversations);
    } catch (e, stack) {
      state = AsyncValue.error(e.toString(), stack);
    }
  }

  Future<void> createConversation(int profileId) async {
    try {
      final conversation = await _service.createConversation(profileId);
      state.whenData((conversations) {
        state = AsyncValue.data([conversation, ...conversations]);
      });
    } catch (e, stack) {
      state = AsyncValue.error(e.toString(), stack);
      rethrow;
    }
  }

  Future<void> sendMessage(int conversationId, String content) async {
    try {
      final message = await _service.sendMessage(conversationId, content);
      state.whenData((conversations) {
        final updatedConversations = conversations.map((conv) {
          if (conv.id == conversationId) {
            return Conversation(
              id: conv.id,
              participants: conv.participants,
              lastMessage: message,
              unreadCount: conv.unreadCount,
              updatedAt: DateTime.now(),
            );
          }
          return conv;
        }).toList();
        state = AsyncValue.data(updatedConversations);
      });
    } catch (e, stack) {
      state = AsyncValue.error(e.toString(), stack);
      rethrow;
    }
  }

  Future<void> markMessagesAsRead(int conversationId) async {
    try {
      await _service.markMessagesAsRead(conversationId);
      state.whenData((conversations) {
        final updatedConversations = conversations.map((conv) {
          if (conv.id == conversationId) {
            return Conversation(
              id: conv.id,
              participants: conv.participants,
              lastMessage: conv.lastMessage,
              unreadCount: 0,
              updatedAt: conv.updatedAt,
            );
          }
          return conv;
        }).toList();
        state = AsyncValue.data(updatedConversations);
      });
    } catch (e, stack) {
      state = AsyncValue.error(e.toString(), stack);
      rethrow;
    }
  }
}

final conversationNotifierProvider =
    StateNotifierProvider<ConversationNotifier, AsyncValue<List<Conversation>>>(
        (ref) {
  final service = ref.watch(conversationServiceProvider);
  return ConversationNotifier(service);
});
