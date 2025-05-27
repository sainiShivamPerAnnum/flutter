import 'dart:async';
import 'dart:io';

import 'package:felloapp/core/model/chat/chat_models.dart';
import 'package:felloapp/core/repository/chat_repo.dart';
import 'package:firebase_auth/firebase_auth.dart';
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
    on<ReceiveUnreadMessages>(_onReceiveUnreadMessages);
    on<LoadChatHistory>(_onLoadChatHistory);
    on<HandoverToHuman>(_onHandoverToHuman);
    on<BookConsultation>(_onBookConsultation);
    on<MarkMessageAsRead>(_onMarkMessageAsRead);
    on<ClearChatState>(_onClearChatState);
    on<ResetChatForNewUser>(_onResetChatForNewUser);
    on<SocketConnected>(_onSocketConnected);
    on<SocketDisconnected>(_onSocketDisconnected);
    on<SocketError>(_onSocketError);
    on<HandoverComplete>(_onHandoverComplete);
    on<SessionReady>(_onSessionReady);
  }

  @override
  ChatState? fromJson(Map<String, dynamic> json) {
    try {
      final session = json['session'] != null
          ? ChatSession.fromJson(json['session'])
          : null;

      return ChatState(
        loadingState: ChatLoadingState.initial, // Always start fresh
        session: session,
        currentUserId: json['currentUserId'],
        advisorId: json['advisorId'],
        chatStatus: ChatStatus.values.firstWhere(
          (status) => status.toString() == json['chatStatus'],
          orElse: () => ChatStatus.ai,
        ),
        advisorName: json['advisorName'],
        isSocketConnected: false, // Always start disconnected
      );
    } catch (e) {
      return null;
    }
  }

  @override
  Map<String, dynamic>? toJson(ChatState state) {
    if (state.session == null) return null;

    return {
      'session': state.session!.toJson(),
      'currentUserId': state.currentUserId,
      'advisorId': state.advisorId,
      'chatStatus': state.chatStatus.toString(),
      'advisorName': state.advisorName,
    };
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
      // Check if we need to reset for different user
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

      // Session ready, now connect to WebSocket
      add(SessionReady(session: apiResponse.model!));
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
        session: event.session,
        loadingState: ChatLoadingState.joiningRoom,
      ),
    );

    // Connect to WebSocket and join chat room
    await _connectWebSocket();
    add(JoinChatRoom(sessionId: event.session.id));
  }

  /// Join chat room and get unread messages
  Future<void> _onJoinChatRoom(
    JoinChatRoom event,
    Emitter<ChatState> emit,
  ) async {
    if (_socket?.connected != true) {
      emit(
        state.copyWith(
          loadingState: ChatLoadingState.error,
          error: 'Socket not connected',
        ),
      );
      return;
    }

    try {
      // Emit join-chat event to WebSocket
      _socket!.emit('join-chat', {
        'sessionId': event.sessionId,
      });

      // The unread messages will be received via ReceiveUnreadMessages event
      // from WebSocket listener
    } catch (e) {
      emit(
        state.copyWith(
          loadingState: ChatLoadingState.error,
          error: 'Failed to join chat room: $e',
        ),
      );
    }
  }

  /// Connect to WebSocket
  Future<void> _connectWebSocket() async {
    if (_socket?.connected == true) return;

    try {
      final user = FirebaseAuth.instance.currentUser;
      final token = await user?.getIdToken();

      _socket = IO.io(_baseUrl, <String, dynamic>{
        'transports': ['websocket'],
        'autoConnect': false,
        'extraHeaders': {
          HttpHeaders.authorizationHeader: 'Bearer ${token ?? ''}',
        },
      });

      _socket!.connect();

      // Socket event listeners
      _socket!.on('connect', (_) {
        print('Socket connected');
        add(SocketConnected());
      });

      _socket!.on('disconnect', (_) {
        print('Socket disconnected');
        add(SocketDisconnected());
      });

      _socket!.on('error', (error) {
        print('Socket error: $error');
        add(SocketError(error: error.toString()));
      });

      // Message received
      _socket!.on('message', (data) {
        try {
          final message = ChatMessage.fromJson(data);
          add(ReceiveMessage(message: message));
        } catch (e) {
          print('Error parsing message: $e');
        }
      });

      // Unread messages received after joining room
      _socket!.on('unread-messages', (data) {
        try {
          final List<ChatMessage> messages =
              (data as List).map((json) => ChatMessage.fromJson(json)).toList();
          add(ReceiveUnreadMessages(messages: messages));
        } catch (e) {
          print('Error parsing unread messages: $e');
        }
      });

      // Chat history for different user (dummy implementation)
      _socket!.on('chat-history', (data) {
        try {
          final List<ChatMessage> messages =
              (data as List).map((json) => ChatMessage.fromJson(json)).toList();
          // This would be handled when user switches accounts
          // For now, we'll update the current session with history
          final updatedSession = state.session?.copyWith(messages: messages);
          if (updatedSession != null) {
            add(SessionReady(session: updatedSession));
          }
        } catch (e) {
          print('Error parsing chat history: $e');
        }
      });

      // Handover completed
      _socket!.on('handover-complete', (data) {
        try {
          add(HandoverComplete(advisorName: data['advisorName']));
        } catch (e) {
          print('Error handling handover: $e');
        }
      });
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
        handler: event.messageType.toString().split('.').last,
        timestamp: DateTime.now(),
        messageType: event.messageType,
      );

      // Optimistic update
      final updatedMessages = [...state.messages, message];
      final updatedSession = state.session!.copyWith(
        messages: updatedMessages,
        updatedAt: DateTime.now(),
      );

      emit(
        state.copyWith(
          session: updatedSession,
          isSendingMessage: false,
        ),
      );

      // Send through WebSocket
      if (_socket?.connected == true) {
        _socket!.emit('message', {
          'sessionId': state.sessionId,
          'content': event.content,
          'messageType': event.messageType.toString().split('.').last,
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
    final updatedSession = state.session!.copyWith(
      messages: updatedMessages,
      updatedAt: DateTime.now(),
    );

    emit(state.copyWith(session: updatedSession));
  }

  /// Receive multiple unread messages
  Future<void> _onReceiveUnreadMessages(
    ReceiveUnreadMessages event,
    Emitter<ChatState> emit,
  ) async {
    if (!state.hasSession) return;

    // Filter out duplicate messages
    final existingIds = state.messages.map((m) => m.id).toSet();
    final newMessages =
        event.messages.where((m) => !existingIds.contains(m.id)).toList();

    if (newMessages.isNotEmpty) {
      final updatedMessages = [...state.messages, ...newMessages];
      final updatedSession = state.session!.copyWith(
        messages: updatedMessages,
        updatedAt: DateTime.now(),
      );

      emit(state.copyWith(session: updatedSession));
    }
  }

  /// Load chat history for different user (dummy implementation)
  Future<void> _onLoadChatHistory(
    LoadChatHistory event,
    Emitter<ChatState> emit,
  ) async {
    emit(state.copyWith(loadingState: ChatLoadingState.loadingHistory));

    try {
      // In real implementation, you would:
      // 1. Request chat history from backend for this user
      // 2. Or emit a socket event to get user's chat history

      // For now, dummy implementation - emit socket event
      if (_socket?.connected == true) {
        _socket!.emit('get-chat-history', {
          'userId': event.userId,
        });
      }

      // The response will come through 'chat-history' socket event
      // which is handled in _connectWebSocket method
    } catch (e) {
      emit(
        state.copyWith(
          loadingState: ChatLoadingState.error,
          error: 'Failed to load chat history: $e',
        ),
      );
    }
  }

  /// Handover to human advisor
  Future<void> _onHandoverToHuman(
    HandoverToHuman event,
    Emitter<ChatState> emit,
  ) async {
    try {
      if (_socket?.connected == true) {
        _socket!.emit('request-handover', {
          'sessionId': state.sessionId,
        });
      }
    } catch (e) {
      emit(state.copyWith(error: 'Failed to request handover: $e'));
    }
  }

  /// Book consultation
  Future<void> _onBookConsultation(
    BookConsultation event,
    Emitter<ChatState> emit,
  ) async {
    try {
      // final apiResponse = await _chatRepository.bookConsultation(
      //   sessionId: state.sessionId!,
      //   consultationId: event.offer.id,
      // );

      // if (!apiResponse.isSuccess()) {
      //   emit(state.copyWith(error: apiResponse.errorMessage));
      //   return;
      // }

      emit(state.copyWith(pendingConsultation: event.offer));
    } catch (e) {
      emit(state.copyWith(error: 'Failed to book consultation: $e'));
    }
  }

  /// Mark message as read
  Future<void> _onMarkMessageAsRead(
    MarkMessageAsRead event,
    Emitter<ChatState> emit,
  ) async {
    if (!state.hasSession) return;

    final updatedMessages = state.messages.map((message) {
      if (message.id == event.messageId) {
        return message.copyWith(read: true);
      }
      return message;
    }).toList();

    final updatedSession = state.session!.copyWith(messages: updatedMessages);
    emit(state.copyWith(session: updatedSession));
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

    // Load chat history for new user (dummy implementation)
    add(LoadChatHistory(userId: event.newUserId));

    // Initialize new session
    add(InitializeChat(advisorId: event.advisorId));
  }

  /// Handover completed
  Future<void> _onHandoverComplete(
    HandoverComplete event,
    Emitter<ChatState> emit,
  ) async {
    final handoverMessage = ChatMessage(
      id: const Uuid().v4(),
      sessionId: state.sessionId ?? '',
      senderId: 'system',
      receiverId: state.currentUserId ?? '',
      message:
          'You are now connected with ${event.advisorName}. How can I help you today?',
      handler: 'system',
      timestamp: DateTime.now(),
      messageType: MessageType.handover,
    );

    if (state.hasSession) {
      final updatedMessages = [...state.messages, handoverMessage];
      final updatedSession = state.session!.copyWith(
        messages: updatedMessages,
        humanAdvisorName: event.advisorName,
        updatedAt: DateTime.now(),
      );

      emit(
        state.copyWith(
          session: updatedSession,
          chatStatus: ChatStatus.human,
          advisorName: event.advisorName,
        ),
      );
    }
  }

  @override
  Future<void> close() {
    add(DisconnectSocket());
    return super.close();
  }
}
