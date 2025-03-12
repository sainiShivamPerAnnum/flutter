import 'dart:math';

import 'package:felloapp/core/constants/analytics_events_constants.dart';
import 'package:felloapp/core/enums/page_state_enum.dart';
import 'package:felloapp/core/model/experts/experts_home.dart';
import 'package:felloapp/core/service/analytics/analytics_service.dart';
import 'package:felloapp/feature/expertDetails/expert_profile.dart';
import 'package:felloapp/navigator/app_state.dart';
import 'package:felloapp/navigator/router/ui_pages.dart';
import 'package:felloapp/ui/elements/title_subtitle_container.dart';
import 'package:felloapp/ui/pages/hometabs/save/save_components/top_experts.dart';
import 'package:felloapp/ui/pages/hometabs/save/save_viewModel.dart';
import 'package:felloapp/util/locator.dart';
import 'package:felloapp/util/styles/styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';
import 'package:tuple/tuple.dart';

class Experts extends StatefulWidget {
  const Experts({Key? key}) : super(key: key);

  @override
  ExpertsState createState() => ExpertsState();
}

class ExpertsState extends State<Experts> {
  String? selectedCategory;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 20.h, bottom: 24.h),
      child: Selector<SaveViewModel, Tuple3<ExpertsHome?, bool, bool>>(
        selector: (_, model) => Tuple3(
          model.topExperts,
          model.freeCallAvailable,
          model.isTopAdvisorLoading,
        ),
        builder: (_, value, __) {
          if (selectedCategory == null &&
              value.item1?.list.isNotEmpty == true) {
            selectedCategory = value.item1!.list[0];
          }
          return Column(
            children: [
              const Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  TitleSubtitleContainer(
                    title: "Our top advisors",
                  ),
                ],
              ),
              Padding(
                padding: EdgeInsets.only(top: 24.h, bottom: 20.h, left: 20.w),
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: value.item1?.list.map((category) {
                          return Padding(
                            padding: EdgeInsets.only(right: 8.w),
                            child: GestureDetector(
                              onTap: () {
                                setState(() {
                                  selectedCategory = category;
                                });
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                  color: selectedCategory == category
                                      ? const Color(0xff62E3C4).withOpacity(.1)
                                      : const Color(0xffD9D9D9).withOpacity(.1),
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(6.r),
                                  ),
                                  border: Border.all(
                                    color: selectedCategory == category
                                        ? const Color(0xff62E3C4)
                                            .withOpacity(.5)
                                        : const Color(0xffCACBCC)
                                            .withOpacity(.07),
                                  ),
                                ),
                                padding: EdgeInsets.symmetric(
                                  horizontal: 16.w,
                                  vertical: 8.h,
                                ),
                                child: Text(
                                  category,
                                  style: TextStyles.sourceSansM.body4.colour(
                                    selectedCategory == category
                                        ? const Color(0xff62E3C4)
                                        : UiConstants.kTextColor,
                                  ),
                                ),
                              ),
                            ),
                          );
                        }).toList() ??
                        [],
                  ),
                ),
              ),
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 500),
                child: value.item3
                    ? Padding(
                        padding: EdgeInsets.only(left: 20.w),
                        child: SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            children: [
                              for (int i = 0; i < 3; i++)
                                const ShimmerCardComponent(),
                            ],
                          ),
                        ),
                      )
                    : value.item1 != null
                        ? TopExperts(
                            topExperts:
                                value.item1!.values[selectedCategory] ?? [],
                            isFree: value.item2,
                            key: ValueKey(selectedCategory),
                          )
                        : const SizedBox.shrink(),
              ),
            ],
          );
        },
      ),
    );
  }
}

class TopExperts extends StatelessWidget {
  final List<Expert> topExperts;
  final bool isFree;
  const TopExperts({required this.topExperts, required this.isFree, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: 20.w),
      child: SizedBox(
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              for (int i = 0; i < min(topExperts.length, 3); i++)
                Padding(
                  padding: EdgeInsets.only(right: 8.w),
                  child: CardComponent(
                    name: topExperts[i].name,
                    experience: topExperts[i].experience.toString(),
                    expertise: topExperts[i].expertise,
                    certification: topExperts[i].licenses.first.name,
                    rating: topExperts[i].rating.toDouble(),
                    imageUrl: topExperts[i].image,
                    index: (i + 1).toString(),
                    onTap: () {
                      AppState.delegate!.appState.currentAction = PageAction(
                        page: ExpertDetailsPageConfig,
                        state: PageState.addWidget,
                        widget: ExpertsDetailsView(
                          advisorID: topExperts[i].advisorId,
                        ),
                      );
                      locator<AnalyticsService>().track(
                        eventName: AnalyticsEvents.expertsHome,
                        properties: {
                          "Expert sequence": topExperts[i].advisorId,
                        },
                      );
                    },
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class ShimmerCardComponent extends StatelessWidget {
  const ShimmerCardComponent({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 195.w,
      child: SizedBox(
        width: 168.w,
        child: Card(
          elevation: 1,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(6.r),
          ),
          color: Colors.transparent,
          child: Padding(
            padding: EdgeInsets.all(10.r),
            child: Column(
              children: [
                Stack(
                  children: [
                    Shimmer.fromColors(
                      baseColor: Colors.grey[800]!,
                      highlightColor: Colors.grey[600]!,
                      child: ClipRRect(
                        borderRadius: BorderRadius.all(
                          Radius.circular(6.r),
                        ),
                        child: Container(
                          height: 152.h,
                          width: 148.w,
                          color: Colors.black,
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: 8.h,
                      child: SizedBox(
                        width: 148.w,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Shimmer.fromColors(
                              baseColor: Colors.grey[800]!,
                              highlightColor: Colors.grey[600]!,
                              child: Container(
                                padding: EdgeInsets.all(4.r),
                                margin: EdgeInsets.only(
                                  left: 10.w,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.grey.withOpacity(0.3),
                                  borderRadius: BorderRadius.circular(
                                    5.r,
                                  ),
                                ),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Container(
                                      width: 10.w,
                                      height: 10.h,
                                      color: Colors.black,
                                    ),
                                    SizedBox(
                                      width: 2.w,
                                    ),
                                    Shimmer.fromColors(
                                      baseColor: Colors.grey[800]!,
                                      highlightColor: Colors.grey[600]!,
                                      child: Container(
                                        width: 30.w,
                                        height: 12.h,
                                        color: Colors.black,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Shimmer.fromColors(
                              baseColor: Colors.grey[800]!,
                              highlightColor: Colors.grey[600]!,
                              child: Container(
                                padding: EdgeInsets.all(4.r),
                                decoration: BoxDecoration(
                                  color: Colors.grey.withOpacity(0.3),
                                  borderRadius: BorderRadius.circular(
                                    5.r,
                                  ),
                                ),
                                margin: EdgeInsets.only(right: 10.w),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Container(
                                      width: 10.w,
                                      height: 10.h,
                                      color: Colors.black,
                                    ),
                                    SizedBox(
                                      width: 2.w,
                                    ),
                                    Shimmer.fromColors(
                                      baseColor: Colors.grey[800]!,
                                      highlightColor: Colors.grey[600]!,
                                      child: Container(
                                        width: 20.w,
                                        height: 12.h,
                                        color: Colors.black,
                                      ),
                                    ),
                                  ],
                                ),
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
                    Shimmer.fromColors(
                      baseColor: Colors.grey[800]!,
                      highlightColor: Colors.grey[600]!,
                      child: Container(
                        width: 100.w,
                        height: 12.h,
                        color: Colors.black,
                      ),
                    ),
                    SizedBox(height: 10.h),
                    Row(
                      children: [
                        Container(
                          width: 12.w,
                          height: 12.h,
                          color: Colors.black,
                        ),
                        SizedBox(width: 4.w),
                        Shimmer.fromColors(
                          baseColor: Colors.grey[800]!,
                          highlightColor: Colors.grey[600]!,
                          child: Container(
                            width: 50.w,
                            height: 12.h,
                            color: Colors.black,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 5.h),
                    Row(
                      children: [
                        Container(
                          width: 12.w,
                          height: 12.h,
                          color: Colors.black,
                        ),
                        SizedBox(width: 4.w),
                        Shimmer.fromColors(
                          baseColor: Colors.grey[800]!,
                          highlightColor: Colors.grey[600]!,
                          child: Container(
                            width: 20.w,
                            height: 12.h,
                            color: Colors.black,
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
    );
  }
}
