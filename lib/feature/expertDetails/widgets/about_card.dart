import 'package:felloapp/base_util.dart';
import 'package:felloapp/core/model/experts/experts_details.dart';
import 'package:felloapp/feature/expertDetails/bloc/expert_bloc.dart';
import 'package:felloapp/util/styles/styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';

class AdvisorAboutWidget extends StatelessWidget {
  final String aboutText;
  final String advisorId;
  final List<License> licenses;

  const AdvisorAboutWidget({
    required this.licenses,
    required this.aboutText,
    required this.advisorId,
    super.key,
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
          if (aboutText != '')
            Text(
              'About',
              style: TextStyles.sourceSansSB.body2,
            ),
          if (aboutText != '') SizedBox(height: 12.h),
          if (aboutText != '')
            Text(
              aboutText,
              style: TextStyles.sourceSans.body3.colour(
                UiConstants.kTextColor.withOpacity(
                  0.7,
                ),
              ),
            ),
          if (aboutText != '') SizedBox(height: 24.h),

          // Licenses Section
          Text(
            'Licenses',
            style: TextStyles.sourceSansSB.body2,
          ),

          SizedBox(height: 16.h),
          ...(licenses.map((l) => _buildLicenseItem(l, context))),
        ],
      ),
    );
  }

  Widget _buildLicenseItem(License license, BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 8.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 46.w,
            height: 46.h,
            decoration: BoxDecoration(
              color: UiConstants.greyVarient,
              borderRadius: BorderRadius.circular(8.r),
            ),
            child: Center(
              child: Image.network(
                license.imageUrl,
                width: 46.w,
                height: 46.h,
                fit: BoxFit.cover,
              ),
            ),
          ),
          SizedBox(width: 10.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  license.name,
                  style: TextStyles.sourceSansSB.body3,
                ),
                SizedBox(height: 2.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Issued on ${DateFormat('MMMM y').format(license.issueDate)}",
                      style: TextStyles.sourceSans.body4.colour(
                        UiConstants.kTextColor.withOpacity(.7),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        BaseUtil.launchUrl(license.credentials);
                        BlocProvider.of<ExpertDetailsBloc>(context).add(
                          GetCertificate(license.id, advisorId),
                        );
                      },
                      child: Row(
                        children: [
                          Text(
                            "View Credentials",
                            style: TextStyles.sourceSans.body4
                                .colour(Colors.white70)
                                .copyWith(
                                  decoration: TextDecoration.underline,
                                  decorationColor: Colors.white70,
                                  decorationThickness: 1,
                                ),
                          ),
                          SizedBox(width: 4.w),
                          Icon(
                            Icons.open_in_new,
                            color: Colors.white70,
                            size: 12.r,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
