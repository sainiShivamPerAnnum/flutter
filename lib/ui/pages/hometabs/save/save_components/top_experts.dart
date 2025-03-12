import 'package:felloapp/ui/pages/static/app_widget.dart';
import 'package:felloapp/util/assets.dart';
import 'package:felloapp/util/styles/bordered_text.dart';
import 'package:felloapp/util/styles/styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

class CardComponent extends StatelessWidget {
  final String name;
  final String experience;
  final String expertise;
  final String certification;
  final double rating;
  final String imageUrl;
  final String index;
  final VoidCallback onTap;

  const CardComponent({
    required this.name,
    required this.experience,
    required this.expertise,
    required this.certification,
    required this.rating,
    required this.imageUrl,
    required this.index,
    required this.onTap,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: SizedBox(
        width: 195.w,
        child: Stack(
          alignment: Alignment.bottomRight,
          children: [
            Positioned(
              left: 0,
              bottom: -45.h,
              child: BorderedText(
                strokeWidth: 1.5,
                strokeColor: Colors.transparent,
                gradient: LinearGradient(
                  colors: [
                    const Color(0xFF01656B),
                    const Color(0xFF14A085).withOpacity(.3),
                  ],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
                child: Text(
                  index,
                  style: GoogleFonts.sourceSans3(
                    fontSize: 125.sp,
                    fontWeight: FontWeight.w600,
                    color: Colors.transparent,
                  ),
                ),
              ),
            ),
            SizedBox(
              width: 168.w,
              child: Card(
                elevation: 1,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(6.r),
                ),
                color: UiConstants.greyVarient,
                child: Padding(
                  padding: EdgeInsets.all(10.r),
                  child: Column(
                    children: [
                      Stack(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.all(
                              Radius.circular(6.r),
                            ),
                            child: Image.network(
                              imageUrl,
                              height: 152.h,
                              width: 148.w,
                              fit: BoxFit.cover,
                            ),
                          ),
                          Positioned(
                            bottom: 8.h,
                            child: SizedBox(
                              width: 140.w,
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Container(
                                    padding: EdgeInsets.all(
                                      4.r,
                                    ),
                                    margin: EdgeInsets.only(
                                      left: 10.w,
                                    ),
                                    decoration: BoxDecoration(
                                      color: UiConstants.kTextColor4
                                          .withOpacity(0.3),
                                      borderRadius: BorderRadius.circular(
                                        5.r,
                                      ),
                                    ),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        AppImage(
                                          Assets.experience,
                                          height: 10.h,
                                        ),
                                        SizedBox(
                                          width: 2.w,
                                        ),
                                        Text(
                                          " $experience Years",
                                          style: TextStyles.sourceSans.body6,
                                        ),
                                      ],
                                    ),
                                  ),
                                  Container(
                                    padding: EdgeInsets.all(
                                      4.r,
                                    ),
                                    decoration: BoxDecoration(
                                      color: UiConstants.kTextColor4
                                          .withOpacity(0.3),
                                      borderRadius: BorderRadius.circular(
                                        5.r,
                                      ),
                                    ),
                                    margin: EdgeInsets.only(right: 10.w),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Icon(
                                          Icons.star,
                                          color: UiConstants.kamber,
                                          size: 10.r,
                                        ),
                                        SizedBox(
                                          width: 2.w,
                                        ),
                                        Text(
                                          '$rating',
                                          style: TextStyles.sourceSans.body6,
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 18.h),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            name,
                            style: GoogleFonts.sourceSans3(
                              fontSize: 16.sp,
                              fontWeight: FontWeight.w600,
                              color: UiConstants.kTextColor,
                            ),
                          ),
                          SizedBox(height: 10.h),
                          Row(
                            children: [
                              AppImage(
                                Assets.expertise,
                                height: 12.h,
                              ),
                              SizedBox(width: 4.w),
                              Expanded(
                                child: Text(
                                  expertise,
                                  style: GoogleFonts.sourceSans3(
                                    fontSize: 12.sp,
                                    fontWeight: FontWeight.w600,
                                    color: UiConstants.kTextColor,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 5.h),
                          Row(
                            children: [
                              AppImage(
                                Assets.qualifications,
                                height: 12.h,
                              ),
                              SizedBox(width: 4.w),
                              Expanded(
                                child: Text(
                                  certification.toString(),
                                  style: GoogleFonts.sourceSans3(
                                    fontSize: 12.sp,
                                    fontWeight: FontWeight.w600,
                                    color: UiConstants.kTextColor,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
