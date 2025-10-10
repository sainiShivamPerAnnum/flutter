import 'package:felloapp/util/styles/textStyles.dart';
import 'package:felloapp/util/styles/ui_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class BookConsultationWidget extends StatelessWidget {
  final String? title;
  final String? subtitle;
  final String? price;
  final String? duration;
  final VoidCallback? onBookCallTap;

  const BookConsultationWidget({
    super.key,
    this.title,
    this.subtitle,
    this.price,
    this.duration,
    this.onBookCallTap,
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
          Text(
            title ?? 'Book a Consultation',
            style: TextStyles.sourceSansSB.body2,
          ),
          SizedBox(height: 4.h),
          Text(
            subtitle ?? 'Master investment strategies in stocks',
            style: TextStyles.sourceSans.body3.colour(
              UiConstants.kTextColor.withOpacity(
                0.7,
              ),
            ),
          ),
          SizedBox(height: 12.h),
          const Divider(
            color: UiConstants.grey6,
          ),
          SizedBox(height: 12.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Price and duration
              Text(
                price ?? '',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w600,
                ),
              ),

              GestureDetector(
                onTap: onBookCallTap,
                child: Container(
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
                    'Book a call',
                    style: TextStyles.sourceSansSB.body4.colour(
                      UiConstants.kTextColor4,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
