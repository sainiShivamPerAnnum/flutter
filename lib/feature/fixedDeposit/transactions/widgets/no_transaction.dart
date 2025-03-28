import 'package:felloapp/util/styles/styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

class NoFdTransactions extends StatelessWidget {
  const NoFdTransactions({
    required this.message,
    required this.onClick,
    super.key,
  });
  final String message;
  final VoidCallback onClick;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20.w),
      padding: EdgeInsets.symmetric(
        vertical: 14.h,
        horizontal: 18.w,
      ),
      decoration: BoxDecoration(
        color: UiConstants.greyVarient,
        borderRadius: BorderRadius.all(
          Radius.circular(10.r),
        ),
      ),
      child: Column(
        children: [
          Text(
            message,
            style: GoogleFonts.sourceSans3(
              fontWeight: FontWeight.w500,
              fontSize: 14.sp,
              color: UiConstants.kTextColor,
            ),
          ),
          SizedBox(
            height: 12.h,
          ),
          GestureDetector(
            onTap: onClick,
            child: Container(
              padding: EdgeInsets.symmetric(
                horizontal: SizeConfig.padding8,
                vertical: SizeConfig.padding6,
              ),
              decoration: BoxDecoration(
                color: UiConstants.kTextColor,
                borderRadius: BorderRadius.circular(
                  SizeConfig.roundness5,
                ),
              ),
              child: Text(
                'Invest now',
                style: TextStyles.sourceSansSB.body4.colour(
                  UiConstants.kTextColor4,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
