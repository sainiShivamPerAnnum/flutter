import 'package:felloapp/util/assets.dart';
import 'package:felloapp/util/styles/styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../static/app_widget.dart';

class SaveViewFooter extends StatelessWidget {
  const SaveViewFooter({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 20.h),
      decoration: BoxDecoration(
        color: UiConstants.kGridLineColor.withOpacity(.2),
      ),
      child: Column(
        children: [
          SizedBox(
            height: 45.h,
          ),
          AppImage(
            Assets.logoWhite,
            width: 44.w,
          ),
          SizedBox(
            height: 8.h,
          ),
          RichText(
            text: TextSpan(
              style: GoogleFonts.sourceSans3(
                fontSize: 14.sp,
                color: UiConstants.kTextColor6,
                fontWeight: FontWeight.w500,
              ),
              children: const <TextSpan>[
                TextSpan(
                  text: 'Trusted by ',
                ),
                TextSpan(
                  text: '1 million+ ',
                  style: TextStyle(
                    color: UiConstants.teal3,
                  ),
                ),
                TextSpan(
                  text: 'users',
                ),
              ],
            ),
          ),
          SizedBox(
            height: 24.h,
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w),
            child: Divider(
              color: UiConstants.kGridLineColor.withOpacity(.4),
            ),
          ),
          SizedBox(
            height: 24.h,
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 20.w),
            width: 1.sw,
            height: 58.h,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    AppImage(
                      Assets.sebi_new,
                      width: 36.w,
                    ),
                    Text(
                      'SEBI Registered Experts',
                      style: TextStyles.sourceSans.body6,
                      maxLines: 2,
                    ),
                  ],
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    AppImage(
                      Assets.rbi,
                      width: 30.w,
                    ),
                    Text(
                      'RBI Regulated',
                      style: TextStyles.sourceSans.body6,
                    ),
                  ],
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    AppImage(
                      Assets.amfi,
                      width: 24.w,
                    ),
                    Text(
                      'AMFI Certified Experts',
                      style: TextStyles.sourceSans.body6,
                    ),
                  ],
                ),
              ],
            ),
          ),
          SizedBox(
            height: 45.h,
          ),
        ],
      ),
    );
  }
}
