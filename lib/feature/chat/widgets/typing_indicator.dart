import 'dart:math';

import 'package:felloapp/util/styles/ui_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class TypingIndicator extends StatefulWidget {
  final String? advisorProfilePhoto;

  const TypingIndicator({
    super.key,
    this.advisorProfilePhoto,
  });

  @override
  State<TypingIndicator> createState() => _TypingIndicatorState();
}

class _TypingIndicatorState extends State<TypingIndicator>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );
    _animation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeInOut,
      ),
    );
    _animationController.repeat();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 4.h, horizontal: 16.w),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // AI Avatar
          Container(
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
          ),
          SizedBox(width: 6.w),
          // Typing bubble
          Container(
            constraints: BoxConstraints(
              maxWidth: 80.w,
            ),
            padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 12.h),
            decoration: BoxDecoration(
              color: UiConstants.greyVarient,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(2.r),
                topRight: Radius.circular(10.r),
                bottomLeft: Radius.circular(10.r),
                bottomRight: Radius.circular(10.r),
              ),
            ),
            child: AnimatedBuilder(
              animation: _animation,
              builder: (context, child) {
                return Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _buildDot(0),
                    SizedBox(width: 4.w),
                    _buildDot(1),
                    SizedBox(width: 4.w),
                    _buildDot(2),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDot(int index) {
    final delay = index * 0.3;
    final animationValue = (_animation.value - delay).clamp(0.0, 1.0);
    final opacity = (sin(animationValue * pi * 2) + 1) / 2;

    return Container(
      width: 6.w,
      height: 6.w,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.white.withOpacity(0.3 + (opacity * 0.7)),
      ),
    );
  }
}

// Alternative simpler version with just pulsing dots
class SimpleTypingIndicator extends StatefulWidget {
  const SimpleTypingIndicator({super.key});

  @override
  State<SimpleTypingIndicator> createState() => _SimpleTypingIndicatorState();
}

class _SimpleTypingIndicatorState extends State<SimpleTypingIndicator>
    with TickerProviderStateMixin {
  late List<AnimationController> _controllers;
  late List<Animation<double>> _animations;

  @override
  void initState() {
    super.initState();
    _controllers = List.generate(3, (index) {
      return AnimationController(
        duration: const Duration(milliseconds: 600),
        vsync: this,
      );
    });

    _animations = _controllers.map((controller) {
      return Tween<double>(begin: 0.4, end: 1.0).animate(
        CurvedAnimation(parent: controller, curve: Curves.easeInOut),
      );
    }).toList();

    // Start animations with delays
    for (int i = 0; i < _controllers.length; i++) {
      Future.delayed(Duration(milliseconds: i * 200), () {
        if (mounted) {
          _controllers[i].repeat(reverse: true);
        }
      });
    }
  }

  @override
  void dispose() {
    for (final controller in _controllers) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 4.h, horizontal: 16.w),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // AI Avatar
          Container(
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
          ),
          SizedBox(width: 6.w),
          // Typing bubble
          Container(
            padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 12.h),
            decoration: BoxDecoration(
              color: UiConstants.greyVarient,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(2.r),
                topRight: Radius.circular(10.r),
                bottomLeft: Radius.circular(10.r),
                bottomRight: Radius.circular(10.r),
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: List.generate(3, (index) {
                return AnimatedBuilder(
                  animation: _animations[index],
                  builder: (context, child) {
                    return Container(
                      margin: EdgeInsets.only(right: index < 2 ? 4.w : 0),
                      width: 6.w,
                      height: 6.w,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color:
                            Colors.white.withOpacity(_animations[index].value),
                      ),
                    );
                  },
                );
              }),
            ),
          ),
        ],
      ),
    );
  }
}
