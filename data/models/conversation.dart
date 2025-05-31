import 'package:frontend/data/models/user_profile.dart';

class Message {
  final int id;
  final String content;
  final UserProfile sender;
  final bool isRead;
  final DateTime createdAt;

  Message({
    required this.id,
    required this.content,
    required this.sender,
    required this.isRead,
    required this.createdAt,
  });

  factory Message.fromJson(Map<String, dynamic> json) {
    return Message(
      id: json['id'],
      content: json['content'],
      sender: UserProfile.fromJson(json['sender']),
      isRead: json['is_read'],
      createdAt: DateTime.parse(json['created_at']),
    );
  }
}

class Conversation {
  final int id;
  final List<UserProfile> participants;
  final Message? lastMessage;
  final int unreadCount;
  final DateTime updatedAt;

  Conversation({
    required this.id,
    required this.participants,
    this.lastMessage,
    required this.unreadCount,
    required this.updatedAt,
  });

  factory Conversation.fromJson(Map<String, dynamic> json) {
    return Conversation(
      id: json['id'],
      participants: (json['participants'] as List)
          .map((p) => UserProfile.fromJson(p))
          .toList(),
      lastMessage: json['last_message'] != null
          ? Message.fromJson(json['last_message'])
          : null,
      unreadCount: json['unread_count'],
      updatedAt: DateTime.parse(json['updated_at']),
    );
  }
} 