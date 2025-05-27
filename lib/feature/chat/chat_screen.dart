import 'package:felloapp/core/model/chat/chat_models.dart';
import 'package:felloapp/feature/chat/bloc/chat_bloc.dart';
import 'package:felloapp/feature/chat/bloc/chat_event.dart';
import 'package:felloapp/feature/chat/bloc/chat_state.dart';
import 'package:felloapp/feature/chat/widgets/chat_input.dart';
import 'package:felloapp/feature/chat/widgets/message_bubble.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ChatScreen extends StatefulWidget {
  final String advisorId;
  final String? advisorName;
  final String? advisorAvatar;

  const ChatScreen({
    required this.advisorId,
    this.advisorName,
    this.advisorAvatar,
    super.key,
  });

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final ScrollController _scrollController = ScrollController();
  bool _isNearBottom = true;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);

    // Initialize chat when screen opens
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ChatBloc>().add(InitializeChat(advisorId: widget.advisorId));
    });
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.hasClients) {
      final isNearBottom = _scrollController.offset >=
          _scrollController.position.maxScrollExtent - 100;

      if (_isNearBottom != isNearBottom) {
        setState(() {
          _isNearBottom = isNearBottom;
        });
      }
    }
  }

  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      });
    }
  }

  void _handleSendMessage(String content) {
    context.read<ChatBloc>().add(SendMessage(content: content));
    _scrollToBottom();
  }

  void _handleBookConsultation(ConsultationOffer offer) {
    context.read<ChatBloc>().add(BookConsultation(offer: offer));

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Consultation booked with ${offer.advisorName}'),
        backgroundColor: const Color(0xFF2D7D7D),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1A1A1A),
      appBar: _buildAppBar(context),
      body: BlocConsumer<ChatBloc, ChatState>(
        listener: (context, state) {
          if (state.error != null) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.error!),
                backgroundColor: Colors.red.shade600,
                behavior: SnackBarBehavior.floating,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8)),
              ),
            );
          }

          // Auto-scroll when new messages arrive
          if (state.messages.isNotEmpty && _isNearBottom) {
            _scrollToBottom();
          }
        },
        builder: (context, state) {
          return Column(
            children: [
              // Connection status banner
              if (!state.isSocketConnected &&
                  state.loadingState != ChatLoadingState.initial)
                Container(
                  width: double.infinity,
                  padding:
                      const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                  color: Colors.orange.withOpacity(0.15),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: 12,
                        height: 12,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation<Color>(
                              Colors.orange.shade600),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        _getConnectionStatusText(state.loadingState),
                        style: TextStyle(
                          color: Colors.orange.shade700,
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),

              // Chat content
              Expanded(
                child: Container(
                  decoration: const BoxDecoration(
                    color: Color(0xFF1A1A1A),
                  ),
                  child: Column(
                    children: [
                      // Loading state for initial setup
                      if (state.loadingState == ChatLoadingState.initial ||
                          state.loadingState ==
                              ChatLoadingState.creatingSession)
                        const Expanded(
                          child: Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                CircularProgressIndicator(
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                      Color(0xFF2D7D7D)),
                                ),
                                SizedBox(height: 16),
                                Text(
                                  'Setting up your chat...',
                                  style: TextStyle(
                                    color: Colors.white70,
                                    fontSize: 14,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        )
                      else
                        // Messages list
                        Expanded(
                          child: ListView.builder(
                            controller: _scrollController,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            itemCount: state.messages.length,
                            itemBuilder: (context, index) {
                              final message = state.messages[index];
                              return MessageBubble(
                                key: ValueKey(message.id),
                                message: message,
                                advisorName:
                                    state.advisorName ?? widget.advisorName,
                                onBookConsultation: _handleBookConsultation,
                              );
                            },
                          ),
                        ),

                      // Chat input
                      ChatInput(
                        onSendMessage: _handleSendMessage,
                        isEnabled:
                            state.isReadyForMessaging && !state.isChatEnded,
                        isLoading: state.isSendingMessage,
                        placeholder: state.isHumanMode
                            ? 'Message ${state.advisorName ?? widget.advisorName ?? 'advisor'}'
                            : 'Type a message...',
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  String _getConnectionStatusText(ChatLoadingState loadingState) {
    switch (loadingState) {
      case ChatLoadingState.creatingSession:
        return 'Creating session...';
      case ChatLoadingState.joiningRoom:
        return 'Joining chat...';
      case ChatLoadingState.loadingHistory:
        return 'Loading chat history...';
      case ChatLoadingState.error:
        return 'Reconnecting...';
      default:
        return 'Connecting...';
    }
  }

  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: const Color(0xFF1A1A1A),
      elevation: 0,
      leading: IconButton(
        onPressed: () => Navigator.of(context).pop(),
        icon: const Icon(
          Icons.arrow_back,
          color: Colors.white,
          size: 24,
        ),
      ),
      title: BlocBuilder<ChatBloc, ChatState>(
        builder: (context, state) {
          final displayName =
              state.advisorName ?? widget.advisorName ?? 'Anil Singhvi';

          return Row(
            children: [
              // Avatar
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: state.isSocketConnected
                        ? const Color(0xFF2D7D7D)
                        : Colors.grey.shade600,
                    width: 2,
                  ),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: widget.advisorAvatar != null
                      ? Image.network(
                          widget.advisorAvatar!,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return _buildDefaultAvatar();
                          },
                        )
                      : _buildDefaultAvatar(),
                ),
              ),
              const SizedBox(width: 12),

              // Name and status
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      displayName,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Row(
                      children: [
                        Container(
                          width: 8,
                          height: 8,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: state.isSocketConnected
                                ? const Color(0xFF4CAF50)
                                : Colors.grey.shade500,
                          ),
                        ),
                        const SizedBox(width: 6),
                        Text(
                          state.isSocketConnected
                              ? (state.isHumanMode ? 'Online' : 'AI Assistant')
                              : 'Connecting...',
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.7),
                            fontSize: 12,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
      actions: [
        IconButton(
          onPressed: () {
            // Handle call action
          },
          icon: const Icon(
            Icons.call_outlined,
            color: Colors.white,
            size: 24,
          ),
        ),
        const SizedBox(width: 8),
      ],
    );
  }

  Widget _buildDefaultAvatar() {
    return Container(
      decoration: const BoxDecoration(
        shape: BoxShape.circle,
        color: Color(0xFF2D7D7D),
      ),
      child: const Icon(
        Icons.person,
        color: Colors.white,
        size: 20,
      ),
    );
  }
}
