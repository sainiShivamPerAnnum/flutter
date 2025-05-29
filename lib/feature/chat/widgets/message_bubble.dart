import 'dart:math';

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
  final String? advisorId;
  final String? price;
  final String? duration;
  final Function(ConsultationOffer)? onBookConsultation;

  const MessageBubble({
    required this.message,
    required this.userId,
    required this.advisorProfilePhoto,
    required this.price,
    required this.duration,
    required this.advisorId,
    required this.advisorName,
    super.key,
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
      radius: 10.r,
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
      child: Row(
        children: [
          Expanded(
            child: Transform.rotate(
              angle: pi,
              child: CustomPaint(
                size: Size(double.infinity, 3.h),
                painter: ShrinkingLinePainter(
                  startHeight: 4.h,
                  endHeight: 1.h,
                  startColor: const Color(0xFF01656B).withOpacity(0.3),
                  endColor: const Color(0xff232326),
                ),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 8.w),
            child: Container(
              constraints: BoxConstraints(
                maxWidth: 152.w,
              ),
              child: Text(
                message.content,
                textAlign: TextAlign.center,
                style: TextStyles.sourceSansM.body4.colour(UiConstants.teal3),
              ),
            ),
          ),
          Expanded(
            child: CustomPaint(
              size: Size(double.infinity, 3.h),
              painter: ShrinkingLinePainter(
                startHeight: 4.h,
                endHeight: 1.h,
                startColor: const Color(0xFF01656B).withOpacity(0.3),
                endColor: const Color(0xff232326),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildConsultationMessage(BuildContext context) {
    final offer = ConsultationOffer(
      id: advisorId ?? '',
      advisorName: advisorName ?? '',
      price: price ?? '',
      duration: duration ?? '',
      advisorProfileImage: advisorProfilePhoto ?? '',
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

class ShrinkingLinePainter extends CustomPainter {
  final double startHeight;
  final double endHeight;
  final Color startColor;
  final Color endColor;

  ShrinkingLinePainter({
    required this.startHeight,
    required this.endHeight,
    required this.startColor,
    required this.endColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..shader = LinearGradient(
        colors: [startColor, endColor],
        stops: const [0.0, 1.0],
      ).createShader(Rect.fromLTWH(0, 0, size.width, size.height));

    // Create a path that forms a trapezoid (shrinking line)
    final path = Path();

    // Start from top-left with full height
    path.moveTo(0, (size.height - startHeight) / 2);

    // Top line - full height at start, shrinking to endHeight at end
    path.lineTo(size.width, (size.height - endHeight) / 2);

    // Right edge - from top to bottom of end height
    path.lineTo(size.width, (size.height + endHeight) / 2);

    // Bottom line - from endHeight back to full startHeight
    path.lineTo(0, (size.height + startHeight) / 2);

    // Close the path
    path.close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
