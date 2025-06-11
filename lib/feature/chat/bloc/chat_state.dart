import 'package:equatable/equatable.dart';
import 'package:felloapp/core/model/chat/chat_models.dart';

enum ChatLoadingState {
  initial,
  creatingSession,
  joiningRoom,
  reconnecting,
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
  final int unreadMessageCount;
  final String? firstUnreadMessageId;
  final bool showUnreadBanner;
  final bool showTypingIndicator;

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
    this.unreadMessageCount = 0,
    this.firstUnreadMessageId,
    this.showUnreadBanner = false,
    this.showTypingIndicator = false,
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
    int? unreadMessageCount,
    String? firstUnreadMessageId,
    bool? showUnreadBanner,
    bool? showTypingIndicator,
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
      unreadMessageCount: unreadMessageCount ?? this.unreadMessageCount,
      firstUnreadMessageId: firstUnreadMessageId ?? this.firstUnreadMessageId,
      showUnreadBanner: showUnreadBanner ?? this.showUnreadBanner,
      showTypingIndicator: showTypingIndicator ?? this.showTypingIndicator,
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
        unreadMessageCount,
        firstUnreadMessageId,
        showUnreadBanner,
        showTypingIndicator,
      ];

  List<ChatMessage> get messages => currentSession?.messages ?? [];
  bool get hasSession => currentSession != null;
  String? get sessionId => currentSession?.sessionId;
  ChatSession? get session => currentSession?.session;
  bool get hasUnreadMessages => unreadMessageCount > 0;
  bool get shouldShowTypingIndicator {
    if (messages.isEmpty) return false;
    if (isSendingMessage) return false; // Don't show while sending

    // Get last message from current user and last message from other person
    final userMessages =
        messages.where((msg) => msg.messageType == MessageType.user).toList();
    final otherMessages = messages
        .where(
          (msg) =>
              msg.messageType == MessageType.ai ||
              msg.messageType == MessageType.advisor ||
              msg.messageType == MessageType.handover,
        )
        .toList();

    if (userMessages.isEmpty) return false;
    final lastUserMessage = userMessages.last;
    final lastOverallMessage = messages.last;
    if (otherMessages.isEmpty) {
      return lastOverallMessage.id == lastUserMessage.id;
    }
    final lastOtherMessage = otherMessages.last;
    // Show typing if:
    // 1. Last overall message is from user
    // 2. Last other person's message was AI type
    // 3. User message is newer than other person's message
    return lastOverallMessage.id == lastUserMessage.id &&
        lastOtherMessage.messageType == MessageType.ai;
  }

  bool get isReadyForMessaging =>
      loadingState == ChatLoadingState.connected &&
      isSocketConnected &&
      hasSession;
}
