import 'dart:async';
import 'dart:io';

import 'package:felloapp/core/model/chat/chat_models.dart';
import 'package:felloapp/core/repository/chat_repo.dart';
import 'package:felloapp/core/service/notifier_services/user_service.dart';
import 'package:felloapp/util/locator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:uuid/uuid.dart';

import 'chat_event.dart';
import 'chat_state.dart';

class ChatBloc extends HydratedBloc<ChatEvent, ChatState> {
  final ChatRepository _chatRepository;
  IO.Socket? _socket;

  static const String _baseUrl = 'https://advisors.fello-dev.net/chat';
  final userId = locator<UserService>().baseUser!.uid ?? '';
  final isAdvisor = locator<UserService>().baseUser!.isAdvisor ?? false;
  final advisorId = locator<UserService>().baseUser!.advisorId ?? '';

  ChatBloc({required ChatRepository chatRepository})
      : _chatRepository = chatRepository,
        super(const ChatState()) {
    // Event handlers
    on<InitializeChat>(_onInitializeChat);
    on<JoinChatRoom>(_onJoinChatRoom);
    on<DisconnectSocket>(_onDisconnectSocket);
    on<SendMessage>(_onSendMessage);
    on<ReceiveMessage>(_onReceiveMessage);
    on<LoadAllMessages>(_onLoadChatHistory);
    on<MarkMessageAsRead>(_onReadEvent);
    on<ClearChatState>(_onClearChatState);
    on<SocketConnected>(_onSocketConnected);
    on<SocketDisconnected>(_onSocketDisconnected);
    on<SocketError>(_onSocketError);
    on<SessionReady>(_onSessionReady);
  }

  @override
  ChatState? fromJson(Map<String, dynamic> json) {
    try {
      final sessionData = json['currentSession'];
      final currentSession = sessionData != null
          ? ChatSessionWithMessages.fromJson(sessionData)
          : null;
      final sessionMessagesData =
          json['sessionMessages'] as Map<String, dynamic>?;
      final sessionMessages = <String, List<ChatMessage>>{};

      if (sessionMessagesData != null) {
        sessionMessagesData.forEach((key, value) {
          if (value is List) {
            sessionMessages[key] = value
                .map(
                  (msgJson) =>
                      ChatMessage.fromJson(msgJson as Map<String, dynamic>),
                )
                .toList();
          }
        });
      }

      return ChatState(
        loadingState: ChatLoadingState.initial,
        currentSession: currentSession,
        sessionMessages: sessionMessages,
        currentUserId: json['currentUserId'],
        advisorId: json['advisorId'],
        chatStatus: ChatStatus.values.firstWhere(
          (status) => status.toString() == json['chatStatus'],
          orElse: () => ChatStatus.ai,
        ),
        advisorName: json['advisorName'],
        isSocketConnected: false,
      );
    } catch (e) {
      debugPrint('Error restoring chat state: $e');
      return null;
    }
  }

  @override
  Map<String, dynamic>? toJson(ChatState state) {
    try {
      return {
        'currentSession': state.currentSession?.toJson(),
        'sessionMessages': state.sessionMessages.map(
          (key, value) =>
              MapEntry(key, value.map((msg) => msg.toJson()).toList()),
        ),
        'currentUserId': state.currentUserId,
        'advisorId': state.advisorId,
        'chatStatus': state.chatStatus.toString(),
        'advisorName': state.advisorName,
      };
    } catch (e) {
      debugPrint('Error saving chat state: $e');
      return null;
    }
  }

  Future<void> _onInitializeChat(
    InitializeChat event,
    Emitter<ChatState> emit,
  ) async {
    emit(
      state.copyWith(
        loadingState: ChatLoadingState.creatingSession,
        advisorId: event.advisorId,
        currentUserId: userId,
      ),
    );

    try {
      if (event.sessionId == null) {
        final apiResponse =
            await _chatRepository.getOrCreateSession(event.advisorId);

        if (!apiResponse.isSuccess()) {
          emit(
            state.copyWith(
              loadingState: ChatLoadingState.error,
              error: apiResponse.errorMessage,
            ),
          );
          return;
        }

        final existingMessages =
            state.sessionMessages[apiResponse.model!.sessionId] ??
                <ChatMessage>[];

        final sessionWithMessages =
            ChatSessionWithMessages.fromSession(apiResponse.model!)
                .copyWith(messages: existingMessages);

        add(SessionReady(sessionWithMessages: sessionWithMessages));
      } else {
        final apiResponse = await _chatRepository.getSession(event.sessionId!);
        if (!apiResponse.isSuccess()) {
          emit(
            state.copyWith(
              loadingState: ChatLoadingState.error,
              error: apiResponse.errorMessage,
            ),
          );
          return;
        }
        final existingMessages =
            state.sessionMessages[apiResponse.model!.sessionId] ??
                <ChatMessage>[];

        final sessionWithMessages =
            ChatSessionWithMessages.fromSession(apiResponse.model!)
                .copyWith(messages: existingMessages);

        add(SessionReady(sessionWithMessages: sessionWithMessages));
      }
    } catch (e) {
      emit(
        state.copyWith(
          loadingState: ChatLoadingState.error,
          error: e.toString(),
        ),
      );
    }
  }

  Future<void> _onSessionReady(
    SessionReady event,
    Emitter<ChatState> emit,
  ) async {
    emit(
      state.copyWith(
        currentSession: event.sessionWithMessages,
        loadingState: ChatLoadingState.joiningRoom,
      ),
    );
    await _connectWebSocket(event.sessionWithMessages.sessionId);
    await Future.delayed(const Duration(milliseconds: 100));
    if (state.messages.isEmpty) {
      add(LoadAllMessages(sessionId: event.sessionWithMessages.sessionId));
    } else {
      add(JoinChatRoom(sessionId: event.sessionWithMessages.sessionId));
    }
  }

  Future<void> _onJoinChatRoom(
    JoinChatRoom event,
    Emitter<ChatState> emit,
  ) async {
    try {
      _socket!.emit('join-chat', {
        'sessionId': event.sessionId,
        'isAdvisor': isAdvisor,
        'advisorId': advisorId,
      });
    } catch (e) {
      emit(
        state.copyWith(
          loadingState: ChatLoadingState.error,
          error: 'Failed to join chat room: $e',
        ),
      );
    }
  }

  Future<void> _onReadEvent(
    MarkMessageAsRead event,
    Emitter<ChatState> emit,
  ) async {
    try {
      _socket!.emit('read-messages', {
        'sessionId': state.sessionId,
        'messageId': event.messageId,
        'isAdvisor': isAdvisor,
        'advisorId': advisorId,
      });
    } catch (e) {
      emit(
        state.copyWith(
          loadingState: ChatLoadingState.error,
          error: 'Failed to join chat room: $e',
        ),
      );
    }
  }

  Future<void> _connectWebSocket(String sessionId) async {
    if (_socket?.connected == true) return;

    try {
      final user = FirebaseAuth.instance.currentUser;
      final token = await user?.getIdToken();

      _socket = IO.io(_baseUrl, <String, dynamic>{
        'transports': ['websocket'],
        'autoConnect': false,
        'query': {'sessionId': sessionId},
        'extraHeaders': {
          HttpHeaders.authorizationHeader: 'Bearer ${token ?? ''}',
        },
      });

      _socket!.connect();

      // Socket event listeners
      _socket!.on('connect', (_) {
        debugPrint('Socket connected');
        add(SocketConnected());
      });

      _socket!.on('disconnect', (_) {
        debugPrint('Socket disconnected');
        // add(SocketDisconnected());
      });
      if (isAdvisor) {
        _socket!.on('message', (data) {
          try {
            final message = ChatMessage.fromJson(data);
            add(ReceiveMessage(message: message));
            add(MarkMessageAsRead(messageId: message.id ?? ''));
          } catch (e) {
            debugPrint('Error parsing message: $e');
          }
        });
      } else {
        _socket!.on('advisor-response', (data) {
          try {
            final message = ChatMessage.fromJson(data);
            add(ReceiveMessage(message: message));
            add(MarkMessageAsRead(messageId: message.id ?? ''));
          } catch (e) {
            debugPrint('Error parsing message: $e');
          }
        });
      }
    } catch (e) {
      add(SocketError(error: 'Failed to connect: $e'));
    }
  }

  Future<void> _onSocketConnected(
    SocketConnected event,
    Emitter<ChatState> emit,
  ) async {
    emit(
      state.copyWith(
        isSocketConnected: true,
        loadingState: ChatLoadingState.connected,
      ),
    );
  }

  Future<void> _onSocketDisconnected(
    SocketDisconnected event,
    Emitter<ChatState> emit,
  ) async {
    emit(
      state.copyWith(
        isSocketConnected: false,
        loadingState: ChatLoadingState.error,
      ),
    );
  }

  Future<void> _onSocketError(
    SocketError event,
    Emitter<ChatState> emit,
  ) async {
    emit(
      state.copyWith(
        error: event.error,
        loadingState: ChatLoadingState.error,
      ),
    );
  }

  Future<void> _onDisconnectSocket(
    DisconnectSocket event,
    Emitter<ChatState> emit,
  ) async {
    _socket?.disconnect();
    _socket?.dispose();
    _socket = null;
    emit(state.copyWith(isSocketConnected: false));
  }

  Future<void> _onSendMessage(
    SendMessage event,
    Emitter<ChatState> emit,
  ) async {
    if (!state.isReadyForMessaging) return;

    emit(state.copyWith(isSendingMessage: true));

    try {
      final user = FirebaseAuth.instance.currentUser;

      //need to change this for the advisor
      final message = ChatMessage(
        id: const Uuid().v4(),
        sessionId: state.sessionId!,
        senderId: user?.uid ?? '',
        receiverId: 'system',
        message: event.content,
        handler: 'user',
        timestamp: DateTime.now(),
        messageType: event.messageType,
      );

      final updatedMessages = [...state.messages, message];
      final updatedSessionMessages =
          Map<String, List<ChatMessage>>.from(state.sessionMessages);
      updatedSessionMessages[state.sessionId!] = updatedMessages;

      emit(
        state.copyWith(
          currentSession:
              state.currentSession!.copyWith(messages: updatedMessages),
          sessionMessages: updatedSessionMessages,
          isSendingMessage: false,
        ),
      );

      if (_socket?.connected == true) {
        if (isAdvisor) {
          _socket!.emit('advisor-response', {
            'sessionId': state.sessionId,
            'content': event.content,
            'message': event.content,
          });
        } else {
          _socket!.emit('message', {
            'sessionId': state.sessionId,
            'content': event.content,
            'message': event.content,
          });
        }
      }
    } catch (e) {
      emit(
        state.copyWith(
          isSendingMessage: false,
          error: 'Failed to send message: $e',
        ),
      );
    }
  }

  Future<void> _onReceiveMessage(
    ReceiveMessage event,
    Emitter<ChatState> emit,
  ) async {
    if (!state.hasSession) return;
    final messageExists = state.messages.any((m) => m.id == event.message.id);
    if (messageExists) return;

    final updatedMessages = [...state.messages, event.message];
    final updatedSessionMessages =
        Map<String, List<ChatMessage>>.from(state.sessionMessages);
    updatedSessionMessages[state.sessionId!] = updatedMessages;

    emit(
      state.copyWith(
        currentSession:
            state.currentSession!.copyWith(messages: updatedMessages),
        sessionMessages: updatedSessionMessages,
      ),
    );
  }

  Future<void> _onLoadChatHistory(
    LoadAllMessages event,
    Emitter<ChatState> emit,
  ) async {
    emit(state.copyWith(loadingState: ChatLoadingState.loadingHistory));

    try {
      // if (_socket?.connected == true) {
      _socket!.emit('get-chat-history', {
        'sessionId': event.sessionId,
        'isAdvisor': isAdvisor,
        'advisorId': advisorId,
      });
      // }
    } catch (e) {
      emit(
        state.copyWith(
          loadingState: ChatLoadingState.error,
          error: 'Failed to load chat history: $e',
        ),
      );
    }
  }

  Future<void> _onClearChatState(
    ClearChatState event,
    Emitter<ChatState> emit,
  ) async {
    add(DisconnectSocket());
    emit(state.cleared());
  }

  @override
  Future<void> close() {
    add(DisconnectSocket());
    return super.close();
  }
}
