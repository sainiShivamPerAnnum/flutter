import 'package:cached_network_image/cached_network_image.dart';
import 'package:felloapp/core/model/testimonials_model.dart';
import 'package:felloapp/ui/pages/hometabs/save/save_viewModel.dart';
import 'package:felloapp/ui/pages/static/app_widget.dart';
import 'package:felloapp/util/assets.dart';
import 'package:felloapp/util/styles/textStyles.dart';
import 'package:felloapp/util/styles/ui_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:tuple/tuple.dart';

class Testimonials extends StatelessWidget {
  const Testimonials({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 20.h, bottom: 24.h),
      child: Selector<SaveViewModel, Tuple2<List<TestimonialsModel>?, bool>>(
        selector: (_, model) => Tuple2(
          model.testimonials,
          model.freeCallAvailable,
        ),
        builder: (_, value, __) {
          // First pass to determine the maximum height
          final List<TestimonialsModel>? testimonials = value.item1;

          // If no testimonials, return early
          if (testimonials == null || testimonials.isEmpty) {
            return const SizedBox.shrink();
          }

          return Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Padding(
                    padding: EdgeInsets.only(left: 20.w),
                    child: Text(
                      "What users say",
                      style: TextStyles.sourceSansSB.body2,
                    ),
                  ),
                ],
              ),
              Padding(
                padding: EdgeInsets.only(top: 24.h).copyWith(left: 20.w),
                child: SizedBox(
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: LayoutBuilder(
                      builder: (context, constraints) {
                        return IntrinsicHeight(
                          child: Row(
                            children: testimonials.map((testimonial) {
                              return Padding(
                                padding: EdgeInsets.only(right: 16.w),
                                child: Container(
                                  width: 0.8.sw,
                                  decoration: BoxDecoration(
                                    color: UiConstants.greyVarient,
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(10.r)),
                                  ),
                                  padding: EdgeInsets.all(18.r),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          CircleAvatar(
                                            radius: 20.r,
                                            backgroundColor: Colors.black,
                                            child: testimonial.avatarId != '' &&
                                                    testimonial.avatarId !=
                                                        'CUSTOM'
                                                ? ClipOval(
                                                    child: SizedBox(
                                                      width: 40.r,
                                                      height: 40.r,
                                                      child: AppImage(
                                                        "assets/vectors/userAvatars/${testimonial.avatarId}.svg",
                                                        fit: BoxFit.cover,
                                                      ),
                                                    ),
                                                  )
                                                : (testimonial.avatarId != '' &&
                                                        testimonial.avatarId ==
                                                            'CUSTOM' &&
                                                        testimonial.dpUrl != '')
                                                    ? ClipOval(
                                                        child: SizedBox(
                                                          width: 40.r,
                                                          height: 40.r,
                                                          child:
                                                              CachedNetworkImage(
                                                            imageUrl:
                                                                testimonial
                                                                    .dpUrl,
                                                            fit: BoxFit.cover,
                                                          ),
                                                        ),
                                                      )
                                                    : ClipOval(
                                                        child: SizedBox(
                                                          width: 40.r,
                                                          height: 40.r,
                                                          child: Image.asset(
                                                            Assets.profilePic,
                                                            fit: BoxFit.cover,
                                                          ),
                                                        ),
                                                      ),
                                          ),
                                          SizedBox(
                                            width: 14.w,
                                          ),
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                testimonial.userName,
                                                style: TextStyles
                                                    .sourceSansSB.body3,
                                                maxLines: 1,
                                              ),
                                              Row(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                children: [
                                                  Text(
                                                    '${testimonial.rating} ',
                                                    style: TextStyles
                                                        .sourceSansM.body4,
                                                  ),
                                                  Icon(
                                                    Icons.star_rounded,
                                                    color: Colors.amber,
                                                    size: 12.r,
                                                  ),
                                                  Padding(
                                                    padding:
                                                        EdgeInsets.symmetric(
                                                      horizontal: 4.w,
                                                    ),
                                                    child: Icon(
                                                      Icons.circle,
                                                      size: 4.r,
                                                      color: const Color(
                                                          0xffA6A6AC),
                                                    ),
                                                  ),
                                                  Text(
                                                    timeago.format(
                                                      DateTime.parse(
                                                        testimonial.createdAt,
                                                      ),
                                                    ),
                                                    style: TextStyles
                                                        .sourceSansM.body4
                                                        .colour(
                                                      const Color(0xffA6A6AC),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                      SizedBox(
                                        height: 18.h,
                                      ),
                                      Expanded(
                                        child: Text(
                                          testimonial.review,
                                          style: TextStyles.sourceSans.body3,
                                          maxLines: 5,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            }).toList(),
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
