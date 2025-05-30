part of 'chat_history_bloc.dart';

sealed class ChatHistoryState extends Equatable {
  const ChatHistoryState();
}

class LoadingChatHistory extends ChatHistoryState {
  const LoadingChatHistory();

  @override
  List<Object?> get props => const [];
}

class ReconnectingChatHistory extends ChatHistoryState {
  final int attempts;
  final int maxAttempts;
  final List<ChatHistory>? lastKnownData;

  const ReconnectingChatHistory({
    required this.attempts,
    required this.maxAttempts,
    this.lastKnownData,
  });

  @override
  List<Object?> get props => [attempts, maxAttempts, lastKnownData];
}

final class ChatHistoryData extends ChatHistoryState {
  final List<ChatHistory> chatHistory;

  const ChatHistoryData({
    required this.chatHistory,
  });

  @override
  List<Object?> get props => [chatHistory];
}

class ErrorChatHistory extends ChatHistoryState {
  final String message;
  final bool canRetry;
  final List<ChatHistory>? lastKnownData;

  const ErrorChatHistory({
    required this.message,
    this.canRetry = false,
    this.lastKnownData,
  });

  @override
  List<Object?> get props => [message, canRetry, lastKnownData];
}
