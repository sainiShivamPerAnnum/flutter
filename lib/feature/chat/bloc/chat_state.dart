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

enum SenderType { user, ai, advisor, system }

class ChatState extends Equatable {
  final ChatLoadingState loadingState;
  final ChatSession? session;
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
    this.session,
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
    ChatSession? session,
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
      session: session ?? this.session,
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
        session,
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
  List<ChatMessage> get messages => session?.messages ?? [];
  bool get isAiMode => chatStatus == ChatStatus.ai;
  bool get isHumanMode => chatStatus == ChatStatus.human;
  bool get isChatEnded => chatStatus == ChatStatus.ended;
  bool get hasSession => session != null;
  String? get sessionId => session?.id;

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
