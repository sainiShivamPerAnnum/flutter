import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shimmer/shimmer.dart';

class ShimmerReelsButtons extends StatelessWidget {
  const ShimmerReelsButtons({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 1.sh,
      child: Shimmer.fromColors(
        baseColor: Colors.black.withOpacity(0.2),
        highlightColor: Colors.black.withOpacity(0.4),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 12.w),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              const Spacer(),
              _shimmerCircle(50.r),
              SizedBox(height: 10.h),
              _shimmerCircle(50.r),
              SizedBox(height: 10.h),
              _shimmerCircle(50.r),
              SizedBox(height: 10.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _shimmerRectangle(
                    40.h,
                    0.75.sw,
                  ),
                  _shimmerCircle(50.r),
                ],
              ),
              SizedBox(
                height: 20.h,
              ),
              _shimmerRectangle(
                5.h,
                0.95.sw,
              ),
              SizedBox(
                height: 5.h,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _shimmerCircle(double size) {
    return Container(
      width: size,
      height: size,
      decoration: const BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.white,
      ),
    );
  }

  Widget _shimmerRectangle(double height, double width) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        shape: BoxShape.rectangle,
        color: Colors.white,
        borderRadius: BorderRadius.all(
          Radius.circular(4.r),
        ),
      ),
    );
  }
}
