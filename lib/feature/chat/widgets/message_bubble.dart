import 'package:felloapp/core/model/chat/chat_models.dart';
import 'package:felloapp/feature/chat/widgets/consultation_card.dart';
import 'package:flutter/material.dart';

class MessageBubble extends StatelessWidget {
  final ChatMessage message;
  final String? advisorName;
  final Function(ConsultationOffer)? onBookConsultation;

  const MessageBubble({
    required this.message,
    super.key,
    this.advisorName,
    this.onBookConsultation,
  });

  @override
  Widget build(BuildContext context) {
    final isUser = _isUserMessage();
    final isSystem = _isSystemMessage();

    if (message.messageType == MessageType.consultation) {
      return _buildConsultationMessage(context);
    }

    if (isSystem) {
      return _buildSystemMessage(context);
    }

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 16),
      child: Row(
        mainAxisAlignment:
            isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (!isUser) ...[
            _buildAiAvatar(),
            const SizedBox(width: 12),
          ],
          Flexible(
            child: Container(
              constraints: BoxConstraints(
                maxWidth: MediaQuery.of(context).size.width * 0.75,
              ),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color:
                    isUser ? const Color(0xFF2D7D7D) : const Color(0xFF2A2A2A),
                borderRadius: BorderRadius.only(
                  topLeft: const Radius.circular(20),
                  topRight: const Radius.circular(20),
                  bottomLeft: isUser
                      ? const Radius.circular(20)
                      : const Radius.circular(4),
                  bottomRight: isUser
                      ? const Radius.circular(4)
                      : const Radius.circular(20),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    message.content,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 15,
                      fontWeight: FontWeight.w400,
                      height: 1.4,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(
                        _formatTime(message.timestamp),
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.6),
                          fontSize: 11,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      if (isUser) ...[
                        const SizedBox(width: 6),
                        Icon(
                          message.isRead ? Icons.done_all : Icons.done,
                          size: 14,
                          color: message.isRead
                              ? const Color(0xFF4CAF50)
                              : Colors.white.withOpacity(0.6),
                        ),
                      ],
                    ],
                  ),
                ],
              ),
            ),
          ),
          if (isUser) ...[
            const SizedBox(width: 12),
            _buildUserAvatar(),
          ],
        ],
      ),
    );
  }

  Widget _buildAiAvatar() {
    return Container(
      width: 32,
      height: 32,
      decoration: const BoxDecoration(
        shape: BoxShape.circle,
        color: Color(0xFF2D7D7D),
      ),
      child: const Icon(
        Icons.smart_toy_rounded,
        size: 18,
        color: Colors.white,
      ),
    );
  }

  Widget _buildUserAvatar() {
    return Container(
      width: 32,
      height: 32,
      decoration: const BoxDecoration(
        shape: BoxShape.circle,
        color: Color(0xFF2D7D7D),
      ),
      child: const Icon(
        Icons.person,
        size: 18,
        color: Colors.white,
      ),
    );
  }

  Widget _buildSystemMessage(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: Center(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: const Color(0xFF2D7D7D).withOpacity(0.15),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: const Color(0xFF2D7D7D).withOpacity(0.3),
              width: 1,
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                _getSystemIcon(),
                size: 14,
                color: const Color(0xFF4CAF50),
              ),
              const SizedBox(width: 8),
              Flexible(
                child: Text(
                  message.content,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: Color(0xFF4CAF50),
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildConsultationMessage(BuildContext context) {
    // Create a consultation offer from message data
    // This would typically come from message.data or be parsed from content
    final offer = ConsultationOffer(
      id: message.id,
      advisorName: advisorName ?? 'Anil Singhvi',
      price: '₹499',
      duration: '30 mins',
      description: 'Get one-on-one financial advice tailored to your goals.',
    );

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: ConsultationCard(
        offer: offer,
        onBook: onBookConsultation,
      ),
    );
  }

  IconData _getSystemIcon() {
    switch (message.messageType) {
      case MessageType.handover:
        return Icons.support_agent_rounded;
      default:
        return Icons.info_outline_rounded;
    }
  }

  bool _isUserMessage() {
    // Check if message is from user based on sender type or handler
    return message.handler == 'user' ||
        message.senderId != 'ai' &&
            message.senderId != 'system' &&
            message.senderId.isNotEmpty &&
            message.senderId != 'advisor';
  }

  bool _isSystemMessage() {
    return message.messageType == MessageType.handover ||
        message.handler == 'system' ||
        message.senderId == 'system';
  }

  String _formatTime(DateTime timestamp) {
    final now = DateTime.now();
    final difference = now.difference(timestamp);

    if (difference.inMinutes < 1) {
      return 'Just now';
    } else if (difference.inHours < 1) {
      return '${difference.inMinutes}m';
    } else if (difference.inDays < 1) {
      return '${difference.inHours}h';
    } else {
      final hour = timestamp.hour;
      final minute = timestamp.minute.toString().padLeft(2, '0');
      final amPm = hour >= 12 ? 'PM' : 'AM';
      final displayHour = hour > 12 ? hour - 12 : (hour == 0 ? 12 : hour);
      return '$displayHour:$minute $amPm';
    }
  }
}
