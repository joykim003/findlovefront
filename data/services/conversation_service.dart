import 'package:frontend/data/models/conversation.dart';
import 'package:frontend/data/services/api_service.dart';

class ConversationService {
  final ApiService _apiService;

  ConversationService(this._apiService);

  Future<List<Conversation>> getConversations() async {
    final response = await _apiService.get('/conversations');
    return (response as List)
        .map((json) => Conversation.fromJson(json))
        .toList();
  }

  Future<Conversation> createConversation(int profileId) async {
    final response = await _apiService.post(
      '/conversations/$profileId',
      body: {},
    );
    return Conversation.fromJson(response);
  }

  Future<List<Message>> getMessages(int conversationId) async {
    final response = await _apiService.get('/conversations/$conversationId/messages');
    return (response as List)
        .map((json) => Message.fromJson(json))
        .toList();
  }

  Future<Message> sendMessage(int conversationId, String content) async {
    final response = await _apiService.post(
      '/conversations/$conversationId/messages',
      body: {'content': content},
    );
    return Message.fromJson(response);
  }

  Future<void> markMessagesAsRead(int conversationId) async {
    await _apiService.post(
      '/conversations/$conversationId/read',
      body: {},
    );
  }
} 