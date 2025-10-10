part of 'chat_history_bloc.dart';

abstract class ChatHistoryEvent extends Equatable {
  const ChatHistoryEvent();

  @override
  List<Object> get props => [];
}

class LoadChatHistory extends ChatHistoryEvent {
  const LoadChatHistory();
}

class UpdateChatHistory extends ChatHistoryEvent {
  final List<ChatHistory> chatHistory;

  const UpdateChatHistory({required this.chatHistory});

  @override
  List<Object> get props => [chatHistory];
}

class StopChatHistoryStream extends ChatHistoryEvent {
  const StopChatHistoryStream();
}

// Internal event for reconnection
class _ReconnectChatHistory extends ChatHistoryEvent {
  const _ReconnectChatHistory();
}

// Public event to reset reconnection attempts
class ResetReconnectionAttempts extends ChatHistoryEvent {
  const ResetReconnectionAttempts();
}

// New event for app resume
class AppResumedFromBackground extends ChatHistoryEvent {
  const AppResumedFromBackground();
}
