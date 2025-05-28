import 'package:equatable/equatable.dart';
import 'package:felloapp/core/model/chat/chat_models.dart';

enum ChatLoadingState {
  initial,
  creatingSession,
  joiningRoom,
  connected,
  error,
  loadingHistory
}

enum ChatStatus { ai, human, ended }

class ChatState extends Equatable {
  final ChatLoadingState loadingState;
  final ChatSessionWithMessages? currentSession;
  final Map<String, List<ChatMessage>> sessionMessages;
  final bool isSocketConnected;
  final bool isSendingMessage;
  final String? error;
  final ConsultationOffer? pendingConsultation;
  final String? currentUserId;
  final String? advisorId;
  final ChatStatus chatStatus;
  final String? advisorName;

  const ChatState({
    this.loadingState = ChatLoadingState.initial,
    this.currentSession,
    this.sessionMessages = const {},
    this.isSocketConnected = false,
    this.isSendingMessage = false,
    this.error,
    this.pendingConsultation,
    this.currentUserId,
    this.advisorId,
    this.chatStatus = ChatStatus.ai,
    this.advisorName,
  });

  ChatState copyWith({
    ChatLoadingState? loadingState,
    ChatSessionWithMessages? currentSession,
    Map<String, List<ChatMessage>>? sessionMessages,
    bool? isSocketConnected,
    bool? isSendingMessage,
    String? error,
    ConsultationOffer? pendingConsultation,
    String? currentUserId,
    String? advisorId,
    ChatStatus? chatStatus,
    String? advisorName,
  }) {
    return ChatState(
      loadingState: loadingState ?? this.loadingState,
      currentSession: currentSession ?? this.currentSession,
      sessionMessages: sessionMessages ?? this.sessionMessages,
      isSocketConnected: isSocketConnected ?? this.isSocketConnected,
      isSendingMessage: isSendingMessage ?? this.isSendingMessage,
      error: error,
      pendingConsultation: pendingConsultation ?? this.pendingConsultation,
      currentUserId: currentUserId ?? this.currentUserId,
      advisorId: advisorId ?? this.advisorId,
      chatStatus: chatStatus ?? this.chatStatus,
      advisorName: advisorName ?? this.advisorName,
    );
  }

  /// Clear all state (for logout)
  ChatState cleared() {
    return const ChatState();
  }

  @override
  List<Object?> get props => [
        loadingState,
        currentSession,
        sessionMessages,
        isSocketConnected,
        isSendingMessage,
        error,
        pendingConsultation,
        currentUserId,
        advisorId,
        chatStatus,
        advisorName,
      ];

  // Convenience getters
  List<ChatMessage> get messages => currentSession?.messages ?? [];
  bool get isAiMode => chatStatus == ChatStatus.ai;
  bool get isHumanMode => chatStatus == ChatStatus.human;
  bool get isChatEnded => chatStatus == ChatStatus.ended;
  bool get hasSession => currentSession != null;
  String? get sessionId => currentSession?.sessionId;
  ChatSession? get session => currentSession?.session;

  /// Check if current session belongs to different user
  bool isDifferentUser(String userId) {
    return currentUserId != null && currentUserId != userId;
  }

  /// Check if chat is ready for messaging
  bool get isReadyForMessaging =>
      loadingState == ChatLoadingState.connected &&
      isSocketConnected &&
      hasSession;
}
