part of 'chat_history_bloc.dart';

sealed class ChatHistoryEvent {
  const ChatHistoryEvent();
}

class LoadChatHistory extends ChatHistoryEvent {
  const LoadChatHistory();
}
