import 'dart:async';
import 'dart:io';

import 'package:felloapp/core/model/chat/chat_models.dart';
import 'package:felloapp/core/repository/chat_repo.dart';
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

  ChatBloc({required ChatRepository chatRepository})
      : _chatRepository = chatRepository,
        super(const ChatState()) {
    // Event handlers
    on<InitializeChat>(_onInitializeChat);
    on<JoinChatRoom>(_onJoinChatRoom);
    on<DisconnectSocket>(_onDisconnectSocket);
    on<SendMessage>(_onSendMessage);
    on<ReceiveMessage>(_onReceiveMessage);
    // on<ReceiveUnreadMessages>(_onReceiveUnreadMessages);
    on<LoadChatHistory>(_onLoadChatHistory);
    on<ClearChatState>(_onClearChatState);
    on<ResetChatForNewUser>(_onResetChatForNewUser);
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

  /// Initialize chat session and setup WebSocket connection
  Future<void> _onInitializeChat(
    InitializeChat event,
    Emitter<ChatState> emit,
  ) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      emit(
        state.copyWith(
          loadingState: ChatLoadingState.error,
          error: 'User not authenticated',
        ),
      );
      return;
    }

    emit(
      state.copyWith(
        loadingState: ChatLoadingState.creatingSession,
        advisorId: event.advisorId,
        currentUserId: user.uid,
      ),
    );

    try {
      if (state.isDifferentUser(user.uid)) {
        add(
          ResetChatForNewUser(
            newUserId: user.uid,
            advisorId: event.advisorId,
          ),
        );
        return;
      }

      // Create or get session
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

      // Get existing messages for this session from local storage
      final existingMessages =
          state.sessionMessages[apiResponse.model!.sessionId] ??
              <ChatMessage>[];

      final sessionWithMessages =
          ChatSessionWithMessages.fromSession(apiResponse.model!)
              .copyWith(messages: existingMessages);

      add(SessionReady(sessionWithMessages: sessionWithMessages));
    } catch (e) {
      emit(
        state.copyWith(
          loadingState: ChatLoadingState.error,
          error: e.toString(),
        ),
      );
    }
  }

  /// Handle session ready and connect to WebSocket
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
    add(JoinChatRoom(sessionId: event.sessionWithMessages.sessionId));
  }

  /// Join chat room and get unread messages
  Future<void> _onJoinChatRoom(
    JoinChatRoom event,
    Emitter<ChatState> emit,
  ) async {
    try {
      _socket!.emit('join-chat', {
        'sessionId': event.sessionId,
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
        add(SocketDisconnected());
      });
      // Message received
      _socket!.on('message', (data) {
        try {
          final message = ChatMessage.fromJson(data);
          add(ReceiveMessage(message: message));
        } catch (e) {
          debugPrint('Error parsing message: $e');
        }
      });

      // Unread messages received after joining room
      // _socket!.on('unread-messages', (data) {
      //   try {
      //     final List<ChatMessage> messages =
      //         (data as List).map((json) => ChatMessage.fromJson(json)).toList();
      //     add(ReceiveUnreadMessages(messages: messages));
      //   } catch (e) {
      //     debugPrint('Error parsing unread messages: $e');
      //   }
      // });

      // Chat history for different user
      // _socket!.on('chat-history', (data) {
      //   try {
      //     final List<ChatMessage> messages =
      //         (data as List).map((json) => ChatMessage.fromJson(json)).toList();

      //     // Update current session with history
      //     if (state.currentSession != null) {
      //       final updatedSession = state.currentSession!.copyWith(
      //         messages: messages,
      //       );
      //       add(SessionReady(sessionWithMessages: updatedSession));
      //     }
      //   } catch (e) {
      //     debugPrint('Error parsing chat history: $e');
      //   }
      // });
    } catch (e) {
      add(SocketError(error: 'Failed to connect: $e'));
    }
  }

  /// Socket connected successfully
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

  /// Socket disconnected
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

  /// Socket error occurred
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

  /// Disconnect from WebSocket
  Future<void> _onDisconnectSocket(
    DisconnectSocket event,
    Emitter<ChatState> emit,
  ) async {
    _socket?.disconnect();
    _socket?.dispose();
    _socket = null;
    emit(state.copyWith(isSocketConnected: false));
  }

  /// Send message through WebSocket
  Future<void> _onSendMessage(
    SendMessage event,
    Emitter<ChatState> emit,
  ) async {
    if (!state.isReadyForMessaging) return;

    emit(state.copyWith(isSendingMessage: true));

    try {
      final user = FirebaseAuth.instance.currentUser;
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

      // Optimistic update
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

      // Send through WebSocket
      if (_socket?.connected == true) {
        _socket!.emit('message', {
          'sessionId': state.sessionId,
          'content': event.content,
          'message': event.content,
        });
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

  /// Receive single message
  Future<void> _onReceiveMessage(
    ReceiveMessage event,
    Emitter<ChatState> emit,
  ) async {
    if (!state.hasSession) return;

    // Check if message already exists
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

  /// Load chat history for different user
  Future<void> _onLoadChatHistory(
    LoadChatHistory event,
    Emitter<ChatState> emit,
  ) async {
    emit(state.copyWith(loadingState: ChatLoadingState.loadingHistory));

    try {
      // Emit socket event to get user's chat history
      if (_socket?.connected == true) {
        _socket!.emit('get-chat-history', {
          'userId': event.userId,
        });
      }

      // The response will come through 'chat-history' socket event
    } catch (e) {
      emit(
        state.copyWith(
          loadingState: ChatLoadingState.error,
          error: 'Failed to load chat history: $e',
        ),
      );
    }
  }

  /// Clear chat state (for logout)
  Future<void> _onClearChatState(
    ClearChatState event,
    Emitter<ChatState> emit,
  ) async {
    add(DisconnectSocket());
    emit(state.cleared());
  }

  /// Reset chat for new user
  Future<void> _onResetChatForNewUser(
    ResetChatForNewUser event,
    Emitter<ChatState> emit,
  ) async {
    // Disconnect current socket
    add(DisconnectSocket());

    // Clear state
    emit(state.cleared());

    // Load chat history for new user
    add(LoadChatHistory(userId: event.newUserId));

    // Initialize new session
    add(InitializeChat(advisorId: event.advisorId));
  }

  @override
  Future<void> close() {
    add(DisconnectSocket());
    return super.close();
  }
}
