import 'package:felloapp/util/styles/textStyles.dart';
import 'package:felloapp/util/styles/ui_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ChatNowWidget extends StatelessWidget {
  final String? advisorName;
  final String? advisorAvatar;
  final List<String>? iCanHelpIn;
  final VoidCallback? onChatNowTap;

  const ChatNowWidget({
    super.key,
    this.advisorName,
    this.advisorAvatar,
    this.onChatNowTap,
    this.iCanHelpIn,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(18.r),
      decoration: BoxDecoration(
        color: UiConstants.greyVarient,
        borderRadius: BorderRadius.circular(10.r),
        border: Border.all(
          color: UiConstants.kTextColor6.withOpacity(0.1),
          width: 0.5.w,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              SizedBox(
                width: 33.w,
                height: 33.h,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20.r),
                  child: advisorAvatar != null
                      ? Image.network(
                          advisorAvatar!,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return _buildDefaultAvatar();
                          },
                        )
                      : _buildDefaultAvatar(),
                ),
              ),
              SizedBox(width: 10.w),
              Text(
                'I can help with :',
                style: TextStyles.sourceSansSB.body2,
              ),
            ],
          ),
          SizedBox(height: 18.h),
          Container(
            padding: EdgeInsets.symmetric(vertical: 8.h, horizontal: 14.w),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12.r),
              border: Border.all(
                color: UiConstants.kTabBorderColor.withOpacity(0.05),
                width: 1.w,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ...(iCanHelpIn != null && iCanHelpIn!.isNotEmpty
                    ? iCanHelpIn!
                        .map(
                          (s) => [
                            _buildHelpItem(s),
                            SizedBox(height: 2.h),
                          ],
                        )
                        .expand((element) => element)
                        .toList()
                    : [
                        _buildHelpItem('Personal finance management'),
                        SizedBox(height: 2.h),
                        _buildHelpItem('Capital market investments'),
                        SizedBox(height: 2.h),
                        _buildHelpItem('Achieving financial growth'),
                        SizedBox(height: 2.h),
                        _buildHelpItem('Maximize growth, reduce stress'),
                      ]),
              ],
            ),
          ),
          SizedBox(height: 16.h),
          GestureDetector(
            onTap: onChatNowTap,
            child: Container(
              padding: EdgeInsets.symmetric(
                horizontal: 16.w,
                vertical: 12.h,
              ),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20.r),
                border: Border.all(
                  color: UiConstants.kTextColor6.withOpacity(0.3),
                  width: 1.w,
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Tap to start a chat',
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.6),
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 8.w,
                      vertical: 6.h,
                    ),
                    decoration: BoxDecoration(
                      color: UiConstants.kTextColor,
                      borderRadius: BorderRadius.circular(
                        5.r,
                      ),
                    ),
                    child: Text(
                      'Chat now',
                      style: TextStyles.sourceSansSB.body4.colour(
                        UiConstants.kTextColor4,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHelpItem(String text) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          margin: EdgeInsets.only(top: 6.h, right: 8.w),
          width: 4.w,
          height: 4.h,
          decoration: const BoxDecoration(
            color: Colors.white,
            shape: BoxShape.circle,
          ),
        ),
        Expanded(
          child: Text(
            text,
            style: TextStyles.sourceSans.body3,
          ),
        ),
      ],
    );
  }

  Widget _buildDefaultAvatar() {
    return Container(
      decoration: const BoxDecoration(
        shape: BoxShape.circle,
        color: Color(0xFF2D7D7D),
      ),
      child: Icon(
        Icons.person,
        color: Colors.white,
        size: 20.sp,
      ),
    );
  }
}
