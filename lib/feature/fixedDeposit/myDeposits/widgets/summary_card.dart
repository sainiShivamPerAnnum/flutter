import 'package:felloapp/base_util.dart';
import 'package:felloapp/core/model/fixedDeposit/my_fds.dart';
import 'package:felloapp/util/styles/ui_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

class SummaryCard extends StatelessWidget {
  final SummaryModel summary;

  const SummaryCard({
    required this.summary,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20.w),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10.r),
        color: UiConstants.greyVarient,
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 18.w, vertical: 14.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Current',
                      style: GoogleFonts.sourceSans3(
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w500,
                        color: UiConstants.kTextColor.withOpacity(.5),
                      ),
                    ),
                    SizedBox(
                      height: 4.h,
                    ),
                    Text(
                      BaseUtil.formatIndianRupees(
                        summary.totalCurrentAmount ?? 0,
                      ),
                      style: GoogleFonts.sourceSans3(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w500,
                        color: UiConstants.kTextColor,
                      ),
                    ),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      'Avg. XIRR',
                      style: GoogleFonts.sourceSans3(
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w500,
                        color: UiConstants.kTextColor.withOpacity(.5),
                      ),
                    ),
                    SizedBox(
                      height: 4.h,
                    ),
                    Text(
                      '${summary.averageXIRR}%',
                      style: GoogleFonts.sourceSans3(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w500,
                        color: UiConstants.teal3,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            SizedBox(
              height: 10.h,
            ),
            Divider(
              color: UiConstants.kTextColor.withOpacity(0.08),
            ),
            SizedBox(
              height: 10.h,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Invested',
                      style: GoogleFonts.sourceSans3(
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w500,
                        color: UiConstants.kTextColor.withOpacity(.5),
                      ),
                    ),
                    SizedBox(
                      height: 4.h,
                    ),
                    Text(
                      BaseUtil.formatIndianRupees(
                        summary.totalInvestedAmount ?? 0,
                      ),
                      style: GoogleFonts.sourceSans3(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w500,
                        color: UiConstants.kTextColor,
                      ),
                    ),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      'Net returns',
                      style: GoogleFonts.sourceSans3(
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w500,
                        color: UiConstants.kTextColor.withOpacity(.5),
                      ),
                    ),
                    SizedBox(
                      height: 4.h,
                    ),
                    Text(
                      BaseUtil.formatIndianRupees(
                        summary.totalReturns ?? 0,
                      ),
                      style: GoogleFonts.sourceSans3(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w500,
                        color: UiConstants.kTextColor,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
