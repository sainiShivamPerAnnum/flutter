import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shimmer/shimmer.dart';

class ChatShimmerLoader extends StatelessWidget {
  const ChatShimmerLoader({super.key});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
        child: Column(
          children: [
            // // App bar shimmer
            // _buildAppBarShimmer(),

            // SizedBox(height: 16.h),

            // Chat messages shimmer
            Expanded(
              child: ListView.builder(
                reverse: true,
                itemCount: 10, // Show 10 shimmer messages
                itemBuilder: (context, index) {
                  // Alternate between incoming and outgoing message styles
                  final isOutgoing = index % 3 == 0;
                  return _buildMessageShimmer(isOutgoing: isOutgoing);
                },
              ),
            ),

            // SizedBox(height: 16.h),

            // // Chat input shimmer
            // _buildChatInputShimmer(),
          ],
        ),
      ),
    );
  }

  Widget _buildAppBarShimmer() {
    return Shimmer.fromColors(
      baseColor: Colors.grey[800]!,
      highlightColor: Colors.grey[600]!,
      child: Row(
        children: [
          // Back button
          Container(
            width: 24.w,
            height: 24.h,
            decoration: BoxDecoration(
              color: Colors.grey[100]!,
              borderRadius: BorderRadius.circular(4.r),
            ),
          ),

          SizedBox(width: 12.w),

          // Avatar
          Container(
            width: 32.w,
            height: 32.h,
            decoration: BoxDecoration(
              color: Colors.grey[100]!,
              shape: BoxShape.circle,
            ),
          ),

          SizedBox(width: 12.w),

          // Name and status
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 120.w,
                  height: 16.h,
                  decoration: BoxDecoration(
                    color: Colors.grey[100]!,
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                ),
                SizedBox(height: 4.h),
                Container(
                  width: 80.w,
                  height: 12.h,
                  decoration: BoxDecoration(
                    color: Colors.grey[100]!,
                    borderRadius: BorderRadius.circular(6.r),
                  ),
                ),
              ],
            ),
          ),

          // Call button
          Container(
            width: 24.w,
            height: 24.h,
            decoration: BoxDecoration(
              color: Colors.grey[100]!,
              borderRadius: BorderRadius.circular(4.r),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMessageShimmer({required bool isOutgoing}) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4.h),
      child: Row(
        mainAxisAlignment:
            isOutgoing ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          if (!isOutgoing) ...[
            // Incoming message avatar
            Shimmer.fromColors(
              baseColor: Colors.grey[800]!,
              highlightColor: Colors.grey[600]!,
              child: Container(
                width: 24.w,
                height: 24.h,
                decoration: BoxDecoration(
                  color: Colors.grey[100]!,
                  shape: BoxShape.circle,
                ),
              ),
            ),
            SizedBox(width: 8.w),
          ],

          // Message bubble
          Flexible(
            child: Container(
              constraints: BoxConstraints(maxWidth: 250.w),
              child: Shimmer.fromColors(
                baseColor: isOutgoing ? Colors.grey[800]! : Colors.grey[800]!,
                highlightColor:
                    isOutgoing ? Colors.grey[600]! : Colors.grey[600]!,
                child: Container(
                  padding:
                      EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
                  decoration: BoxDecoration(
                    color: Colors.grey[100]!,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(16.r),
                      topRight: Radius.circular(16.r),
                      bottomLeft: Radius.circular(isOutgoing ? 16.r : 4.r),
                      bottomRight: Radius.circular(isOutgoing ? 4.r : 16.r),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Message text lines
                      Container(
                        width: double.infinity,
                        height: 14.h,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(7.r),
                        ),
                      ),

                      // Random second line (not all messages have it)
                      if ((isOutgoing && DateTime.now().millisecond % 2 == 0) ||
                          (!isOutgoing &&
                              DateTime.now().millisecond % 3 == 0)) ...[
                        SizedBox(height: 4.h),
                        Container(
                          width: 80.w + (DateTime.now().millisecond % 100),
                          height: 14.h,
                          decoration: BoxDecoration(
                            color: Colors.grey[100]!,
                            borderRadius: BorderRadius.circular(7.r),
                          ),
                        ),
                      ],

                      SizedBox(height: 8.h),

                      // Timestamp
                      Container(
                        width: 40.w,
                        height: 10.h,
                        decoration: BoxDecoration(
                          color: Colors.grey[100]!,
                          borderRadius: BorderRadius.circular(5.r),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),

          if (isOutgoing) SizedBox(width: 8.w),
        ],
      ),
    );
  }

  Widget _buildChatInputShimmer() {
    return Shimmer.fromColors(
      baseColor: Colors.grey[800]!,
      highlightColor: Colors.grey[600]!,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
        decoration: BoxDecoration(
          color: Colors.grey[100]!,
          borderRadius: BorderRadius.circular(24.r),
          border: Border.all(color: Colors.grey[600]!),
        ),
        child: Row(
          children: [
            // Attachment icon
            Container(
              width: 20.w,
              height: 20.h,
              decoration: BoxDecoration(
                color: Colors.grey[100]!,
                borderRadius: BorderRadius.circular(4.r),
              ),
            ),

            SizedBox(width: 12.w),

            // Text input area
            Expanded(
              child: Container(
                height: 16.h,
                decoration: BoxDecoration(
                  color: Colors.grey[100]!,
                  borderRadius: BorderRadius.circular(8.r),
                ),
              ),
            ),

            SizedBox(width: 12.w),

            // Send button
            Container(
              width: 20.w,
              height: 20.h,
              decoration: BoxDecoration(
                color: Colors.grey[100]!,
                shape: BoxShape.circle,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
