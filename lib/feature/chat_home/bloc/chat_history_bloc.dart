import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:felloapp/core/model/chat/chat_history.dart';
import 'package:felloapp/core/repository/chat_repo.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'chat_history_event.dart';
part 'chat_history_state.dart';

class ChatHistoryBloc extends Bloc<ChatHistoryEvent, ChatHistoryState> {
  final ChatRepository _chatRepository;
  StreamSubscription<List<ChatHistory>>? _chatHistorySubscription;

  ChatHistoryBloc(
    this._chatRepository,
  ) : super(const LoadingChatHistory()) {
    on<LoadChatHistory>(_onLoadChatHistory);
    on<UpdateChatHistory>(_onUpdateChatHistory);
    on<StopChatHistoryStream>(_onStopChatHistoryStream);
  }

  FutureOr<void> _onLoadChatHistory(
    LoadChatHistory event,
    Emitter<ChatHistoryState> emitter,
  ) async {
    emitter(const LoadingChatHistory());

    try {
      await _chatHistorySubscription?.cancel();
      _chatHistorySubscription =
          _chatRepository.getUserChatHistoryStream().listen(
        (chatHistory) {
          add(UpdateChatHistory(chatHistory: chatHistory));
        },
        onError: (error) {
          emitter(
            ErrorChatHistory(
              message: error.toString(),
            ),
          );
        },
      );
    } catch (e) {
      emitter(
        ErrorChatHistory(
          message: e.toString(),
        ),
      );
    }
  }

  FutureOr<void> _onUpdateChatHistory(
    UpdateChatHistory event,
    Emitter<ChatHistoryState> emitter,
  ) async {
    emitter(ChatHistoryData(chatHistory: event.chatHistory));
  }

  FutureOr<void> _onStopChatHistoryStream(
    StopChatHistoryStream event,
    Emitter<ChatHistoryState> emitter,
  ) async {
    await _chatHistorySubscription?.cancel();
    _chatHistorySubscription = null;
  }

  @override
  Future<void> close() {
    _chatHistorySubscription?.cancel();
    return super.close();
  }
}
