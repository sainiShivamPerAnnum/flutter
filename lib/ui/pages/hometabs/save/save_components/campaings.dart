import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:felloapp/core/model/event_model.dart';
import 'package:felloapp/navigator/app_state.dart';
import 'package:felloapp/ui/pages/hometabs/save/save_viewModel.dart';
import 'package:felloapp/util/locator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:tuple/tuple.dart';

class Campaigns extends StatefulWidget {
  const Campaigns({
    super.key,
  });

  @override
  State<Campaigns> createState() => _CampaignsState();
}

class _CampaignsState extends State<Campaigns> {
  final CarouselController _carouselController = CarouselController();
  int _currentPage = 0;

  @override
  Widget build(BuildContext context) {
    return Selector<SaveViewModel, Tuple2<List<EventModel>?, bool>>(
      selector: (_, model) => Tuple2(
        model.ongoingEvents,
        model.isChallengesLoading,
      ),
      builder: (_, model, __) {
        return AnimatedSwitcher(
          duration: const Duration(milliseconds: 500),
          child: model.item2
              ? Padding(
                  padding: EdgeInsets.only(top: 20.h, bottom: 24.h),
                  child: Shimmer.fromColors(
                    baseColor: Colors.grey[800]!,
                    highlightColor: Colors.grey[600]!,
                    child: Container(
                      margin: EdgeInsets.symmetric(horizontal: 20.w),
                      height: 330.h,
                      decoration: BoxDecoration(
                        color: Colors.black,
                        borderRadius: BorderRadius.circular(8.r),
                      ),
                    ),
                  ),
                )
              : Padding(
                  padding: EdgeInsets.only(top: 20.h, bottom: 24.h),
                  child: Column(
                    key: const ValueKey<String>('Campaings'),
                    children: [
                      SizedBox(
                        height: 307.h,
                        child: CarouselSlider.builder(
                          carouselController: _carouselController,
                          itemCount: model.item1!.length,
                          itemBuilder: (context, index, realIndex) {
                            final event = model.item1![index];
                            return Padding(
                              padding: EdgeInsets.symmetric(horizontal: 10.w),
                              child: GestureDetector(
                                onTap: () {
                                  locator<SaveViewModel>().trackChallengeTapped(
                                    event.bgImage,
                                    event.type,
                                    index,
                                  );
                                  AppState.delegate!
                                      .parseRoute(Uri.parse(event.type));
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(
                                      8.r,
                                    ),
                                    image: DecorationImage(
                                      image: CachedNetworkImageProvider(
                                        event.bgImage,
                                      ),
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                              ),
                            );
                          },
                          options: CarouselOptions(
                            height: 330.h,
                            aspectRatio: 1,
                            enlargeCenterPage: false,
                            enableInfiniteScroll: false,
                            pageSnapping: true,
                            viewportFraction: 0.9,
                            autoPlay: true,
                            autoPlayInterval: const Duration(seconds: 4),
                            autoPlayAnimationDuration:
                                const Duration(milliseconds: 800),
                            padEnds: true,
                            onPageChanged: (page, reason) {
                              setState(() {
                                _currentPage = page;
                              });
                            },
                          ),
                        ),
                      ),
                      if (model.item1!.length > 1)
                        Padding(
                          padding: EdgeInsets.only(top: 14.h),
                          child: SmoothPageIndicator(
                            controller:
                                PageController(initialPage: _currentPage),
                            count: model.item1!.length,
                            effect: ExpandingDotsEffect(
                              activeDotColor: Colors.white,
                              dotColor: Colors.grey,
                              dotHeight: 6.h,
                              dotWidth: 6.w,
                            ),
                            onDotClicked: _carouselController.animateToPage,
                          ),
                        ),
                    ],
                  ),
                ),
        );
      },
    );
  }
}
