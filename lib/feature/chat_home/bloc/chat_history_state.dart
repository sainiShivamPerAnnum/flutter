part of 'chat_history_bloc.dart';

sealed class ChatHistoryState extends Equatable {
  const ChatHistoryState();
}

class LoadingChatHistory extends ChatHistoryState {
  const LoadingChatHistory();

  @override
  List<Object?> get props => const [];
}

final class ChatHistoryData extends ChatHistoryState {
  final List<ChatHistory> chatHistory;

  const ChatHistoryData({
    required this.chatHistory,
  });
  @override
  List<Object?> get props => [
        chatHistory,
      ];
}

class ErrorChatHistory extends ChatHistoryState {
  const ErrorChatHistory({
    required this.message,
  });

  final String message;

  @override
  List<Object?> get props => [
        message,
      ];
}
