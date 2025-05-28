import 'package:equatable/equatable.dart';
import 'package:felloapp/core/model/chat/chat_models.dart';

abstract class ChatEvent extends Equatable {
  const ChatEvent();

  @override
  List<Object?> get props => [];
}

/// Initialize chat session and connect to WebSocket
class InitializeChat extends ChatEvent {
  final String advisorId;

  const InitializeChat({required this.advisorId});

  @override
  List<Object?> get props => [advisorId];
}

/// Join chat room via WebSocket and get unread messages
class JoinChatRoom extends ChatEvent {
  final String sessionId;

  const JoinChatRoom({required this.sessionId});

  @override
  List<Object?> get props => [sessionId];
}

/// Disconnect from WebSocket
class DisconnectSocket extends ChatEvent {}

/// Send message through WebSocket
class SendMessage extends ChatEvent {
  final String content;
  final MessageType messageType;

  const SendMessage({
    required this.content,
    this.messageType = MessageType.ai, // Default to ai since it's in your enum
  });

  @override
  List<Object?> get props => [content, messageType];
}

/// Receive message from WebSocket
class ReceiveMessage extends ChatEvent {
  final ChatMessage message;

  const ReceiveMessage({required this.message});

  @override
  List<Object?> get props => [message];
}

/// Receive multiple unread messages from WebSocket
class ReceiveUnreadMessages extends ChatEvent {
  final List<ChatMessage> messages;

  const ReceiveUnreadMessages({required this.messages});

  @override
  List<Object?> get props => [messages];
}

/// Load chat history for different user session
class LoadChatHistory extends ChatEvent {
  final String userId;

  const LoadChatHistory({required this.userId});

  @override
  List<Object?> get props => [userId];
}

/// Mark message as read
class MarkMessageAsRead extends ChatEvent {
  final String messageId;

  const MarkMessageAsRead({required this.messageId});

  @override
  List<Object?> get props => [messageId];
}

/// Clear chat state (for logout)
class ClearChatState extends ChatEvent {}

/// Reset chat for new user session
class ResetChatForNewUser extends ChatEvent {
  final String newUserId;
  final String advisorId;

  const ResetChatForNewUser({
    required this.newUserId,
    required this.advisorId,
  });

  @override
  List<Object?> get props => [newUserId, advisorId];
}

// Socket connection status events
class SocketConnected extends ChatEvent {}

class SocketDisconnected extends ChatEvent {}

class SocketError extends ChatEvent {
  final String error;

  const SocketError({required this.error});

  @override
  List<Object?> get props => [error];
}

/// Handover completed event
class HandoverComplete extends ChatEvent {
  final String advisorName;

  const HandoverComplete({required this.advisorName});

  @override
  List<Object?> get props => [advisorName];
}

/// Session created/retrieved event
class SessionReady extends ChatEvent {
  final ChatSessionWithMessages sessionWithMessages;

  const SessionReady({required this.sessionWithMessages});

  @override
  List<Object?> get props => [sessionWithMessages];
}
