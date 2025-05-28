import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:felloapp/core/model/chat/chat_history.dart';
import 'package:felloapp/core/repository/chat_repo.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'chat_history_event.dart';
part 'chat_history_state.dart';

class ChatHistoryBloc extends Bloc<ChatHistoryEvent, ChatHistoryState> {
  final ChatRepository _chatRepository;
  ChatHistoryBloc(
    this._chatRepository,
  ) : super(const LoadingChatHistory()) {
    on<ChatHistoryEvent>(_onLoadHomeData);
  }
  FutureOr<void> _onLoadHomeData(
    ChatHistoryEvent event,
    Emitter<ChatHistoryState> emitter,
  ) async {
    emitter(const LoadingChatHistory());
    final data = await _chatRepository.getUserChatHistory();
    if (data.isSuccess()) {
      emitter(
        ChatHistoryData(chatHistory: data.model!),
      );
    } else {
      emitter(
        ErrorChatHistory(
          message: data.errorMessage ?? 'Error getting chat history',
        ),
      );
    }
  }
}
