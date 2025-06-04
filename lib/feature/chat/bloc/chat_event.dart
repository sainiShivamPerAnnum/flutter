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
  final String? sessionId;

  const InitializeChat({required this.advisorId, required this.sessionId});

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
    required this.messageType,
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

/// Load chat history for different user session
class LoadAllMessages extends ChatEvent {
  final String sessionId;

  const LoadAllMessages({required this.sessionId});

  @override
  List<Object?> get props => [sessionId];
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

// Socket connection status events
class SocketConnected extends ChatEvent {}

class SocketDisconnected extends ChatEvent {}

class MarkAllAsRead extends ChatEvent {}

class SocketError extends ChatEvent {
  final String error;

  const SocketError({required this.error});

  @override
  List<Object?> get props => [error];
}

/// Session created/retrieved event
class SessionReady extends ChatEvent {
  final ChatSessionWithMessages sessionWithMessages;

  const SessionReady({required this.sessionWithMessages});

  @override
  List<Object?> get props => [sessionWithMessages];
}
