import 'package:felloapp/util/styles/textStyles.dart';
import 'package:felloapp/util/styles/ui_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AnimatedUnreadDivider extends StatelessWidget {
  final bool isVisible;

  const AnimatedUnreadDivider({
    required this.isVisible,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
      height: isVisible ? null : 0,
      margin: EdgeInsets.symmetric(vertical: isVisible ? 8.h : 0),
      child: AnimatedOpacity(
        duration: const Duration(milliseconds: 300),
        opacity: isVisible ? 1.0 : 0.0,
        child: AnimatedScale(
          duration: const Duration(milliseconds: 300),
          scale: isVisible ? 1.0 : 0.8,
          curve: Curves.easeInOut,
          child: Row(
            children: [
              Expanded(
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 400),
                  curve: Curves.easeInOut,
                  child: Divider(
                    color: const Color(0xFF01656B).withOpacity(0.6),
                    thickness: 1.h,
                  ),
                ),
              ),
              AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeInOut,
                padding: EdgeInsets.symmetric(
                  horizontal: isVisible ? 12.w : 0,
                  vertical: isVisible ? 4.h : 0,
                ),
                decoration: BoxDecoration(
                  color:
                      const Color(0xFF01656B).withOpacity(isVisible ? 0.3 : 0),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: AnimatedDefaultTextStyle(
                  duration: const Duration(milliseconds: 300),
                  style: TextStyles.sourceSans.body6.colour(
                    UiConstants.teal3.withOpacity(isVisible ? 1.0 : 0.0),
                  ),
                  child: const Text('UNREAD MESSAGES'),
                ),
              ),
              Expanded(
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 400),
                  curve: Curves.easeInOut,
                  child: Divider(
                    color: const Color(0xFF01656B).withOpacity(0.6),
                    thickness: 1.h,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
