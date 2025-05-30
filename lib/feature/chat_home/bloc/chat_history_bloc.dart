import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:felloapp/core/model/chat/chat_history.dart';
import 'package:felloapp/core/repository/chat_repo.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'chat_history_event.dart';
part 'chat_history_state.dart';

class ChatHistoryBloc extends Bloc<ChatHistoryEvent, ChatHistoryState>
    with WidgetsBindingObserver {
  final ChatRepository _chatRepository;
  StreamSubscription<List<ChatHistory>>? _chatHistorySubscription;
  Timer? _reconnectionTimer;

  // Reconnection configuration
  static const int _maxReconnectAttempts = 5;
  static const Duration _initialReconnectDelay = Duration(seconds: 2);
  static const Duration _maxReconnectDelay = Duration(seconds: 30);

  int _reconnectAttempts = 0;
  bool _isReconnecting = false;
  bool _shouldReconnect = true;
  bool _wasInBackground = false;
  bool _isConnecting = false; // Add connection lock
  List<ChatHistory>? _lastKnownChatHistory;

  ChatHistoryBloc(
    this._chatRepository,
  ) : super(const LoadingChatHistory()) {
    on<LoadChatHistory>(_onLoadChatHistory);
    on<UpdateChatHistory>(_onUpdateChatHistory);
    on<StopChatHistoryStream>(_onStopChatHistoryStream);
    on<_ReconnectChatHistory>(_onReconnectChatHistory);
    on<ResetReconnectionAttempts>(_onResetReconnectionAttempts);
    on<AppResumedFromBackground>(_onAppResumedFromBackground);

    // Register as lifecycle observer
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);

    switch (state) {
      case AppLifecycleState.paused:
      case AppLifecycleState.detached:
        _wasInBackground = true;
        break;
      case AppLifecycleState.resumed:
        if (_wasInBackground && !_isConnecting) {
          _wasInBackground = false;
          // Add small delay to avoid race conditions
          Future.delayed(const Duration(milliseconds: 500), () {
            if (!isClosed && !_isConnecting) {
              add(const AppResumedFromBackground());
            }
          });
        }
        break;
      case AppLifecycleState.inactive:
        break;
      case AppLifecycleState.hidden:
        break;
    }
  }

  FutureOr<void> _onAppResumedFromBackground(
    AppResumedFromBackground event,
    Emitter<ChatHistoryState> emitter,
  ) async {
    // Prevent multiple simultaneous connections
    if (_isConnecting) {
      print('Connection already in progress, skipping background resume');
      return;
    }

    // Show last known data immediately if available
    if (_lastKnownChatHistory != null) {
      emitter(ChatHistoryData(chatHistory: _lastKnownChatHistory!));
    }

    // Check if current connection is still active
    if (_chatHistorySubscription != null &&
        !_chatHistorySubscription!.isPaused) {
      print('Existing connection still active, not reconnecting');
      return;
    }

    print('App resumed from background, reconnecting...');

    // Reset reconnection attempts and force reconnect
    _reconnectAttempts = 0;
    _isReconnecting = false;

    // Force reconnection after returning from background
    await _connectToChatHistoryStream(emitter);
  }

  FutureOr<void> _onLoadChatHistory(
    LoadChatHistory event,
    Emitter<ChatHistoryState> emitter,
  ) async {
    _shouldReconnect = true;
    _reconnectAttempts = 0;
    await _connectToChatHistoryStream(emitter);
  }

  Future<void> _connectToChatHistoryStream(
    Emitter<ChatHistoryState> emitter,
  ) async {
    // Prevent multiple simultaneous connections
    if (_isConnecting) {
      print('Connection already in progress, skipping...');
      return;
    }

    _isConnecting = true;

    try {
      // Cancel existing subscription and timer
      await _chatHistorySubscription?.cancel();
      _reconnectionTimer?.cancel();

      print(
          'Connecting to chat history stream (attempt ${_reconnectAttempts + 1})');

      // Show appropriate loading state
      if (!_isReconnecting && _lastKnownChatHistory == null) {
        emitter(const LoadingChatHistory());
      } else if (_isReconnecting) {
        emitter(
          ReconnectingChatHistory(
            attempts: _reconnectAttempts,
            maxAttempts: _maxReconnectAttempts,
            lastKnownData: _lastKnownChatHistory,
          ),
        );
      }

      _chatHistorySubscription =
          _chatRepository.getUserChatHistoryStream().listen(
        (chatHistory) {
          print('Received chat history update: ${chatHistory.length} items');
          _reconnectAttempts = 0;
          _isReconnecting = false;
          _lastKnownChatHistory = chatHistory; // Cache the data
          add(UpdateChatHistory(chatHistory: chatHistory));
        },
        onError: (error) {
          print('Stream error: $error');

          if (_shouldReconnect && _reconnectAttempts < _maxReconnectAttempts) {
            _scheduleReconnection();
          } else {
            emitter(
              ErrorChatHistory(
                message: _getErrorMessage(error),
                canRetry: _reconnectAttempts < _maxReconnectAttempts,
                lastKnownData: _lastKnownChatHistory,
              ),
            );
          }
        },
        onDone: () {
          print('Stream completed');

          if (_shouldReconnect && _reconnectAttempts < _maxReconnectAttempts) {
            _scheduleReconnection();
          }
        },
      );
    } catch (e) {
      print('Connection error: $e');

      if (_shouldReconnect && _reconnectAttempts < _maxReconnectAttempts) {
        _scheduleReconnection();
      } else {
        emitter(
          ErrorChatHistory(
            message: _getErrorMessage(e),
            canRetry: _reconnectAttempts < _maxReconnectAttempts,
            lastKnownData: _lastKnownChatHistory,
          ),
        );
      }
    } finally {
      _isConnecting = false;
    }
  }

  String _getErrorMessage(dynamic error) {
    final errorString = error.toString().toLowerCase();

    if (errorString.contains('authentication') || errorString.contains('401')) {
      return 'Session expired. Please refresh to continue.';
    } else if (errorString.contains('network') ||
        errorString.contains('connection')) {
      return 'Connection lost. Tap to retry.';
    } else if (errorString.contains('timeout')) {
      return 'Connection timeout. Check your internet.';
    } else {
      return 'Something went wrong. Tap to retry.';
    }
  }

  void _scheduleReconnection() {
    if (!_shouldReconnect || _isConnecting) return;

    _reconnectAttempts++;
    _isReconnecting = true;

    final delay = Duration(
      milliseconds: (_initialReconnectDelay.inMilliseconds *
              (1 << (_reconnectAttempts - 1)))
          .clamp(
        _initialReconnectDelay.inMilliseconds,
        _maxReconnectDelay.inMilliseconds,
      ),
    );

    print(
        'Scheduling reconnection attempt $_reconnectAttempts in ${delay.inSeconds}s');

    _reconnectionTimer = Timer(delay, () {
      if (_shouldReconnect && !isClosed && !_isConnecting) {
        add(const _ReconnectChatHistory());
      }
    });
  }

  FutureOr<void> _onUpdateChatHistory(
    UpdateChatHistory event,
    Emitter<ChatHistoryState> emitter,
  ) async {
    _lastKnownChatHistory = event.chatHistory;
    emitter(ChatHistoryData(chatHistory: event.chatHistory));
  }

  FutureOr<void> _onStopChatHistoryStream(
    StopChatHistoryStream event,
    Emitter<ChatHistoryState> emitter,
  ) async {
    _shouldReconnect = false;
    _reconnectionTimer?.cancel();
    await _chatHistorySubscription?.cancel();
    _chatHistorySubscription = null;
    _isReconnecting = false;
  }

  FutureOr<void> _onReconnectChatHistory(
    _ReconnectChatHistory event,
    Emitter<ChatHistoryState> emitter,
  ) async {
    await _connectToChatHistoryStream(emitter);
  }

  FutureOr<void> _onResetReconnectionAttempts(
    ResetReconnectionAttempts event,
    Emitter<ChatHistoryState> emitter,
  ) async {
    if (_isConnecting) {
      print('Connection in progress, skipping reset');
      return;
    }

    _reconnectAttempts = 0;
    _isReconnecting = false;
    add(const LoadChatHistory());
  }

  @override
  Future<void> close() {
    _shouldReconnect = false;
    _isConnecting = false;
    _reconnectionTimer?.cancel();
    _chatHistorySubscription?.cancel();
    WidgetsBinding.instance.removeObserver(this);
    return super.close();
  }
}
