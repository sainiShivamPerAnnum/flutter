import 'package:felloapp/base_util.dart';
import 'package:felloapp/core/model/chat/chat_models.dart';
import 'package:felloapp/feature/chat/widgets/consultation_card.dart';
import 'package:felloapp/util/styles/textStyles.dart';
import 'package:felloapp/util/styles/ui_constants.dart';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class MessageBubble extends StatelessWidget {
  final String? userId;
  final String? advisorProfilePhoto;
  final ChatMessage message;
  final String? advisorName;
  final Function(ConsultationOffer)? onBookConsultation;

  const MessageBubble({
    required this.message,
    required this.userId,
    required this.advisorProfilePhoto,
    super.key,
    this.advisorName,
    this.onBookConsultation,
  });

  @override
  Widget build(BuildContext context) {
    final isUser = _isUserMessage();
    final isSystem = _isSystemMessage();

    final isAdvisor = _isAdvisor();

    if (message.messageType == MessageType.consultation) {
      return _buildConsultationMessage(context);
    }

    if (isSystem) {
      return _buildSystemMessage(context);
    }

    return Container(
      margin: EdgeInsets.symmetric(vertical: 4.h, horizontal: 16.w),
      child: Row(
        mainAxisAlignment:
            isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (!isUser) ...[
            isAdvisor ? _buildUserAvatar() : _buildAiAvatar(),
            SizedBox(width: 6.w),
          ],
          Flexible(
            child: Container(
              constraints: BoxConstraints(
                maxWidth: 248.w,
              ),
              padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 10.h),
              decoration: BoxDecoration(
                color: isUser
                    ? UiConstants.teal4.withOpacity(.5)
                    : UiConstants.greyVarient,
                borderRadius: BorderRadius.only(
                  topLeft:
                      isUser ? Radius.circular(10.r) : Radius.circular(2.r),
                  topRight:
                      isUser ? Radius.circular(2.r) : Radius.circular(10.r),
                  bottomLeft: Radius.circular(10.r),
                  bottomRight: Radius.circular(10.r),
                ),
              ),
              child: IntrinsicWidth(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        message.content,
                        style: TextStyles.sourceSans.body3,
                      ),
                    ),
                    SizedBox(height: 2.h),
                    Align(
                      alignment: Alignment.centerRight,
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            BaseUtil.formatTime(message.timestamp),
                            style: TextStyles.sourceSans.body4.colour(
                              const Color(0xffA6A6AC),
                            ),
                          ),
                          if (isUser) ...[
                            SizedBox(width: 4.w),
                            Icon(
                              message.isRead ? Icons.done_all : Icons.done,
                              size: 12.sp,
                              color: message.isRead
                                  ? const Color(0xFF48BCEE)
                                  : Colors.white.withOpacity(0.6),
                            ),
                          ],
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAiAvatar() {
    return Container(
      width: 20.w,
      height: 20.h,
      decoration: const BoxDecoration(
        shape: BoxShape.circle,
        color: UiConstants.greyVarient,
      ),
      child: Icon(
        Icons.smart_toy_rounded,
        size: 12.sp,
        color: Colors.white,
      ),
    );
  }

  Widget _buildUserAvatar() {
    return CircleAvatar(
      radius: 20.r,
      backgroundColor: Colors.grey[300],
      backgroundImage: NetworkImage(
        advisorProfilePhoto ?? '',
      ),
      onBackgroundImageError: (exception, stackTrace) {},
      child: advisorProfilePhoto == ''
          ? Icon(
              Icons.person,
              size: 12.r,
              color: Colors.grey[600],
            )
          : null,
    );
  }

  Widget _buildSystemMessage(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 8.h, horizontal: 16.w),
      child: Center(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
          decoration: BoxDecoration(
            color: const Color(0xFF4CAF50).withOpacity(0.1),
            borderRadius: BorderRadius.circular(12.r),
            border: Border.all(
              color: const Color(0xFF4CAF50).withOpacity(0.3),
              width: 0.5,
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                _getSystemIcon(),
                size: 12.sp,
                color: const Color(0xFF4CAF50),
              ),
              SizedBox(width: 6.w),
              Flexible(
                child: Text(
                  message.content,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: const Color(0xFF4CAF50),
                    fontSize: 11.sp,
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
    final offer = ConsultationOffer(
      id: message.id,
      advisorName: advisorName ?? 'Anil Singhvi',
      price: '₹499',
      duration: '30 mins',
      description: 'Get one-on-one financial advice tailored to your goals.',
    );

    return Container(
      margin: EdgeInsets.symmetric(vertical: 8.h, horizontal: 16.w),
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
    return message.senderId == userId;
  }

  bool _isSystemMessage() {
    return message.messageType == MessageType.handover;
  }

  bool _isAdvisor() {
    return message.messageType == MessageType.advisor ||
        message.handler == 'advisor';
  }
}
