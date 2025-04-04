import 'package:felloapp/util/styles/ui_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shimmer/shimmer.dart';

class ExpertCardV2Shimmer extends StatelessWidget {
  final bool isLoading;

  const ExpertCardV2Shimmer({
    this.isLoading = true,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: EdgeInsets.all(18.r),
          decoration: BoxDecoration(
            color: UiConstants.greyVarient,
            borderRadius: BorderRadius.all(Radius.circular(10.r)),
          ),
          child: Column(
            children: [
              Row(
                children: [
                  _buildShimmerImage(),
                  SizedBox(width: 8.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        isLoading
                            ? _buildShimmerText(width: 150.w)
                            : Text(
                                'Expert Name',
                                style: GoogleFonts.sourceSans3(
                                  color: UiConstants.kTextColor,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 14.sp,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                        SizedBox(height: 4.h),
                        isLoading
                            ? _buildShimmerText(width: 100.w)
                            : Text(
                                'Expert description goes here',
                                style: GoogleFonts.sourceSans3(
                                  color:
                                      UiConstants.kTextColor.withOpacity(0.6),
                                  fontWeight: FontWeight.w400,
                                  fontSize: 12.sp,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                      ],
                    ),
                  ),
                ],
              ),
              const Divider(color: UiConstants.grey6),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 12.h),
                child: Row(
                  children: [
                    isLoading
                        ? _buildShimmerText(width: 120.w)
                        : _buildShimmerColumn(),
                    SizedBox(width: 40.w),
                    isLoading
                        ? _buildShimmerText(width: 120.w)
                        : _buildShimmerColumn(),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 12.h),
                child: Row(
                  children: [
                    isLoading
                        ? _buildShimmerText(width: 120.w)
                        : _buildShimmerColumn(),
                    SizedBox(width: 40.w),
                    isLoading
                        ? _buildShimmerText(width: 120.w)
                        : _buildShimmerColumn(),
                  ],
                ),
              ),
              const Divider(color: UiConstants.grey6),
              Padding(
                padding: EdgeInsets.only(top: 6.h),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        isLoading
                            ? _buildShimmerText(width: 50.w)
                            : Text(
                                'Original Price',
                                style: GoogleFonts.sourceSans3(
                                  fontSize: 12.sp,
                                  fontWeight: FontWeight.w500,
                                  color:
                                      UiConstants.kTextColor.withOpacity(0.6),
                                ),
                              ),
                        SizedBox(width: 4.w),
                        isLoading
                            ? _buildShimmerText(width: 50.w)
                            : const Text(
                                'Discounted Price',
                                style: TextStyle(
                                  color: UiConstants.teal3,
                                ),
                              ),
                      ],
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 12.w,
                        vertical: 8.h,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.grey[800]!,
                        borderRadius: BorderRadius.circular(8.r),
                      ),
                      child: isLoading
                          ? _buildShimmerText(width: 100.w)
                          : Text(
                              'Book a Call',
                              style: GoogleFonts.sourceSans3(
                                fontSize: 14.sp,
                                fontWeight: FontWeight.w600,
                                color: UiConstants.kTextColor4,
                              ),
                            ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildShimmerImage() {
    return Shimmer.fromColors(
      baseColor: Colors.grey[800]!,
      highlightColor: Colors.grey[600]!,
      child: Container(
        width: 50.w,
        height: 50.h,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(25.r),
        ),
      ),
    );
  }

  Widget _buildShimmerText({required double width}) {
    return Shimmer.fromColors(
      baseColor: Colors.grey[800]!,
      highlightColor: Colors.grey[600]!,
      child: Container(
        width: width,
        height: 12.h,
        color: Colors.grey[100]!,
      ),
    );
  }

  Widget _buildShimmerColumn() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildShimmerText(width: 80.w),
        SizedBox(height: 12.h),
        _buildShimmerText(width: 60.w),
      ],
    );
  }
}
