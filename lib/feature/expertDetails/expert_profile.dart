import 'package:felloapp/base_util.dart';
import 'package:felloapp/core/model/experts/experts_details.dart';
import 'package:felloapp/core/model/live/live_home.dart';
import 'package:felloapp/feature/expert/booking_sheet.dart';
import 'package:felloapp/feature/expertDetails/bloc/expert_bloc.dart';
import 'package:felloapp/feature/expertDetails/widgets/ratingSheet.dart';
import 'package:felloapp/feature/live/widgets/live_card.dart';
import 'package:felloapp/feature/p2p_home/ui/shared/error_state.dart';
import 'package:felloapp/ui/pages/static/app_widget.dart';
import 'package:felloapp/ui/pages/static/loader_widget.dart';
import 'package:felloapp/util/locator.dart';
import 'package:felloapp/util/styles/styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

class ExpertsDetailsView extends StatelessWidget {
  final String advisorID;
  const ExpertsDetailsView({
    required this.advisorID,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ExpertDetailsBloc(
        locator(),
      )..add(LoadExpertsDetails(advisorID)),
      child: _ExpertProfilePage(
        advisorID: advisorID,
      ),
    );
  }
}

class _ExpertProfilePage extends StatelessWidget {
  const _ExpertProfilePage({
    required this.advisorID,
  });
  final String advisorID;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ExpertDetailsBloc, ExpertDetailsState>(
      builder: (context, state) {
        if (state is LoadingExpertsDetails) {
          return const BaseScaffold(
            showBackgroundGrid: true,
            body: Center(child: FullScreenLoader()),
          );
        }
        if (state is ExpertDetailsLoaded) {
          final expertDetails = state.expertDetails;
          final tab = state.currentTab;
          final recentlive = state.recentLive;
          return DefaultTabController(
            length: 3,
            initialIndex: 0,
            child: BaseScaffold(
              showBackgroundGrid: true,
              floatingActionButton: GestureDetector(
                onTap: () {
                  BaseUtil.openBookAdvisorSheet(
                    advisorId: advisorID,
                  );
                },
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.all(
                      Radius.circular(
                        SizeConfig.roundness5,
                      ),
                    ),
                  ),
                  child: Padding(
                    padding: EdgeInsets.all(SizeConfig.padding12),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.calendar_month,
                          size: SizeConfig.body3,
                          color: UiConstants.kTextColor4,
                        ),
                        SizedBox(
                          width: SizeConfig.padding12,
                        ),
                        Text(
                          'Book a Slot',
                          style: TextStyles.sourceSansSB.body3.colour(
                            UiConstants.kTextColor4,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              appBar: AppBar(
                backgroundColor: Colors.transparent,
                centerTitle: true,
                title: Text('Profile', style: TextStyles.rajdhaniSB.body1),
                leading: const BackButton(
                  color: Colors.white,
                ),
              ),
              body: SingleChildScrollView(
                child: Padding(
                  padding:
                      EdgeInsets.symmetric(horizontal: SizeConfig.padding20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(
                        height: SizeConfig.padding25,
                      ),
                      CircleAvatar(
                        radius: SizeConfig.padding35,
                        backgroundImage: NetworkImage(
                          expertDetails!.image,
                        ),
                      ),
                      SizedBox(
                        height: SizeConfig.padding20,
                      ),
                      Text(
                        expertDetails.name,
                        style: TextStyles.sourceSansSB.body0.colour(
                          UiConstants.kTextColor,
                        ),
                      ),
                      SizedBox(
                        height: SizeConfig.padding6,
                      ),
                      Text(
                        expertDetails.description,
                        style: TextStyles.sourceSansSB.body4.colour(
                          UiConstants.kTextColor.withOpacity(.7),
                        ),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(
                        height: SizeConfig.padding12,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Column(
                            children: [
                              Text(
                                'Experience',
                                style: TextStyles.sourceSansSB.body6.colour(
                                  UiConstants.kTextColor,
                                ),
                              ),
                              Text(
                                expertDetails.experience, // Display experience
                                style: TextStyles.sourceSansSB.body2.colour(
                                  UiConstants.kTextColor,
                                ),
                              ),
                            ],
                          ),
                          Column(
                            children: [
                              Text(
                                'Sessions',
                                style: TextStyles.sourceSansSB.body6.colour(
                                  UiConstants.kTextColor,
                                ),
                              ),
                              Text(
                                expertDetails.sessionCount
                                    .toString(), // Display session count
                                style: TextStyles.sourceSansSB.body2.colour(
                                  UiConstants.kTextColor,
                                ),
                              ),
                            ],
                          ),
                          Column(
                            children: [
                              Text(
                                'Rating',
                                style: TextStyles.sourceSansSB.body6.colour(
                                  UiConstants.kTextColor,
                                ),
                              ),
                              Text(
                                expertDetails.rating
                                    .toString(), // Display rating
                                style: TextStyles.sourceSansSB.body2.colour(
                                  UiConstants.kTextColor,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      SizedBox(
                        height: SizeConfig.padding32,
                      ),
                      CustomCarousel(
                        quickActions: expertDetails.QuickActions,
                      ),
                      SizedBox(
                        height: SizeConfig.padding48,
                        child: TabBar(
                          indicatorPadding: EdgeInsets.zero,
                          indicatorSize: TabBarIndicatorSize.tab,
                          dividerColor: UiConstants.grey4,
                          indicatorWeight: 1.5,
                          indicatorColor: UiConstants.kTextColor,
                          labelColor: UiConstants.kTextColor,
                          tabAlignment: TabAlignment.start,
                          isScrollable: true,
                          unselectedLabelColor:
                              UiConstants.kTextColor.withOpacity(.6),
                          labelStyle: TextStyles.sourceSansSB.body3,
                          unselectedLabelStyle: TextStyles.sourceSansSB.body3,
                          tabs: const [
                            Tab(text: "About"),
                            Tab(text: "Shorts"),
                            Tab(text: "Popular Live"),
                          ],
                          onTap: (value) {
                            BlocProvider.of<ExpertDetailsBloc>(context)
                                .add(TabChanged(value, advisorID));
                          },
                        ),
                      ),
                      if (tab == 0)
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(
                              height: SizeConfig.padding18,
                            ),
                            Text(
                              "Licenses",
                              style: TextStyles.sourceSansSB.body2,
                            ),
                            SizedBox(
                              height: SizeConfig.padding18,
                            ),
                            for (final license in expertDetails.licenses)
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    width: SizeConfig.padding46,
                                    height: SizeConfig.padding46,
                                    margin: EdgeInsets.only(
                                      bottom: SizeConfig.padding4,
                                    ),
                                    decoration: BoxDecoration(
                                      color: UiConstants.greyVarient,
                                      borderRadius: BorderRadius.circular(
                                        SizeConfig.roundness8,
                                      ),
                                    ),
                                    child: const Center(
                                      child: Text(
                                        "SEBI",
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    width: SizeConfig.padding10,
                                  ),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          license.name,
                                          style: TextStyles.sourceSansSB.body3,
                                        ),
                                        SizedBox(
                                          height: SizeConfig.padding2,
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              "Issued on ${DateFormat('MMMM d, y').format(license.issueDate)}",
                                              style: TextStyles
                                                  .sourceSansSB.body3
                                                  .colour(
                                                UiConstants.kTextColor
                                                    .withOpacity(.7),
                                              ),
                                            ),
                                            GestureDetector(
                                              onTap: () {
                                                // Handle the 'View Credentials' tap
                                              },
                                              child: Row(
                                                children: [
                                                  Text(
                                                    "View Credentials",
                                                    style: TextStyles
                                                        .sourceSans.body4
                                                        .colour(Colors.white70)
                                                        .copyWith(
                                                          decoration:
                                                              TextDecoration
                                                                  .underline,
                                                        ),
                                                  ),
                                                  SizedBox(
                                                    width: SizeConfig.padding4,
                                                  ),
                                                  Icon(
                                                    Icons.open_in_new,
                                                    color: Colors.white70,
                                                    size: SizeConfig.body6,
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
                            SizedBox(
                              height: SizeConfig.padding24,
                            ),
                            Text(
                              "Social",
                              style: TextStyles.sourceSansSB.body2,
                            ),
                            SizedBox(
                              height: SizeConfig.padding18,
                            ),
                            Row(
                              children: expertDetails.social.map((social) {
                                return GestureDetector(
                                  onTap: () {
                                    // Handle social media tap
                                  },
                                  child: Container(
                                    padding:
                                        EdgeInsets.all(SizeConfig.padding14),
                                    margin: EdgeInsets.only(
                                      right: SizeConfig.padding4,
                                    ),
                                    decoration: BoxDecoration(
                                      color: UiConstants.greyVarient,
                                      borderRadius: BorderRadius.circular(
                                        SizeConfig.roundness8,
                                      ),
                                    ),
                                    child: Icon(
                                      Icons.safety_check,
                                      color: UiConstants.kTextColor5,
                                      size: SizeConfig.body2,
                                    ),
                                  ),
                                );
                              }).toList(),
                            ),
                            SizedBox(
                              height: SizeConfig.padding24,
                            ),
                            RatingReviewSection(
                              ratingInfo: expertDetails.ratingInfo,
                            ),
                          ],
                        )
                      else if (tab == 2) ...[
                        for (int i = 0; i < recentlive.length; i++)
                          LiveCardWidget(
                            status: 'recent',
                            title: recentlive[i].title,
                            subTitle: recentlive[i].subtitle,
                            author: recentlive[i].author,
                            category: recentlive[i].categories.join(', '),
                            bgImage: recentlive[i].thumbnail,
                            liveCount: recentlive[i].views,
                            duration: recentlive[i].duration.toString(),
                          ),
                      ] else
                        _buildTabOneData(recentlive),
                    ],
                  ),
                ),
              ),
            ),
          );
        }
        return const Center(child: Text('Failed to load expert details'));
      },
    );
  }
}

Widget _buildTabOneData(List<RecentStream> shortsData) {
  if (shortsData == null || shortsData.isEmpty) {
    return const Center(child: ErrorPage());
  }

  // Define the height for the GridView
  final double gridHeight = (shortsData.length / 2).ceil() * 250.0;

  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      SizedBox(height: 16),
      SizedBox(
        height: gridHeight,
        child: GridView.builder(
          physics:
              const NeverScrollableScrollPhysics(), // Disable scrolling inside GridView
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
            childAspectRatio: 0.7,
          ),
          itemCount: shortsData.length,
          itemBuilder: (context, index) {
            final video = shortsData[index];

            return Stack(
              children: [
                // Video Thumbnail
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    image: DecorationImage(
                      image: NetworkImage(
                        video.thumbnail,
                      ),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),

                // Overlay with view count at the bottom left
                Positioned(
                  bottom: 8,
                  left: 8,
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.5),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.play_arrow, color: Colors.white, size: 16),
                        SizedBox(width: 4),
                        Text(
                          '${video.views} views',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    ],
  );
}

class CustomCarousel extends StatefulWidget {
  const CustomCarousel({required this.quickActions, super.key});
  final List<QuickAction> quickActions;

  @override
  CustomCarouselState createState() => CustomCarouselState();
}

class CustomCarouselState extends State<CustomCarousel> {
  final PageController _pageController = PageController();
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: SizeConfig.padding60,
          child: PageView(
            controller: _pageController,
            onPageChanged: (index) {
              setState(() {
                _currentIndex = index;
              });
            },
            children: widget.quickActions.map((e) {
              return buildCarouselItem(
                e.heading,
                e.subheading,
                e.buttonText,
                onTap: () {
                  print("Chat tapped: ${e.buttonCTA}");
                },
              );
            }).toList(),
          ),
        ),
        SizedBox(
          height: SizeConfig.padding12,
        ),
        if (widget.quickActions.length > 1)
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(widget.quickActions.length, (index) {
              return Container(
                margin: EdgeInsets.symmetric(
                  horizontal: SizeConfig.padding4,
                  vertical: SizeConfig.padding8,
                ),
                width: SizeConfig.padding4,
                height: SizeConfig.padding4,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: _currentIndex == index ? Colors.white : Colors.grey,
                ),
              );
            }),
          ),
      ],
    );
  }

  Widget buildCarouselItem(
    String title,
    String description,
    String btnTxt, {
    required VoidCallback onTap,
  }) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: SizeConfig.padding18,
        vertical: SizeConfig.padding12,
      ),
      decoration: BoxDecoration(
        color: UiConstants.greyVarient,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                title,
                style: TextStyles.sourceSansSB.body6.colour(
                  UiConstants.kTabBorderColor,
                ),
              ),
              SizedBox(
                height: SizeConfig.padding4,
              ),
              Text(
                description,
                style: TextStyles.sourceSansSB.body4.colour(
                  UiConstants.kTextColor,
                ),
              ),
            ],
          ),
          ElevatedButton(
            onPressed: onTap,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
              padding: EdgeInsets.symmetric(
                horizontal: SizeConfig.padding8,
                vertical: SizeConfig.padding6,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(SizeConfig.roundness5),
              ),
            ),
            child: Text(
              btnTxt,
              style: TextStyles.sourceSansSB.body4.colour(
                UiConstants.kTextColor4,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class RatingReviewSection extends StatelessWidget {
  final RatingInfo ratingInfo;

  const RatingReviewSection({required this.ratingInfo, super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Ratings & Reviews',
          style: TextStyles.sourceSansSB.body2,
        ),
        SizedBox(
          height: SizeConfig.padding18,
        ),
        Row(
          children: [
            Text(
              ratingInfo.overallRating.toStringAsFixed(1),
              style: TextStyles.sourceSansSB.title2,
            ),
            SizedBox(
              width: SizeConfig.padding10,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: List.generate(5, (index) {
                    return Icon(
                      Icons.star_rounded,
                      color: index < ratingInfo.overallRating
                          ? Colors.amber
                          : Colors.grey,
                      size: SizeConfig.body6,
                    );
                  }),
                ),
                Text(
                  '${ratingInfo.ratingCount} ratings',
                  style: TextStyles.sourceSans.body4
                      .colour(UiConstants.kTextColor.withOpacity(.7)),
                ),
              ],
            ),
            const Spacer(),
            OutlinedButton(
              onPressed: () {
                BaseUtil.openModalBottomSheet(
                  isBarrierDismissible: true,
                  content: FeedbackBottomSheet(),
                );
              },
              style: OutlinedButton.styleFrom(
                padding: EdgeInsets.symmetric(
                  horizontal: SizeConfig.padding18,
                  vertical: SizeConfig.padding4,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(
                    Radius.circular(SizeConfig.roundness5),
                  ),
                ),
              ),
              child: Text(
                'Rate',
                style:
                    TextStyles.sourceSans.body4.colour(UiConstants.kTextColor),
              ),
            ),
          ],
        ),
        SizedBox(height: SizeConfig.padding32),

        // Render the list of user reviews
        Column(
          children: ratingInfo.userRatings.map((userRating) {
            return ReviewCard(
              name: userRating.name,
              date: userRating.date,
              rating: userRating.rating,
              review: userRating.review,
              image: userRating.image,
            );
          }).toList(),
        ),
      ],
    );
  }
}

class ReviewCard extends StatelessWidget {
  final String name;
  final String date;
  final int rating;
  final String review;
  final String image;

  const ReviewCard({
    required this.name,
    required this.date,
    required this.rating,
    required this.review,
    required this.image,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            CircleAvatar(
              backgroundImage:
                  NetworkImage(image), // Use the image from UserRating
              radius: SizeConfig.padding16,
            ),
            SizedBox(width: SizeConfig.padding8),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: TextStyles.sourceSansSB.body3.colour(
                    UiConstants.kTextColor,
                  ),
                ),
                Text(
                  date,
                  style: TextStyles.sourceSans.body4.colour(
                    UiConstants.kTextColor.withOpacity(.7),
                  ),
                ),
              ],
            ),
          ],
        ),
        SizedBox(
          height: SizeConfig.padding10,
        ),
        Row(
          children: List.generate(rating, (index) {
            return Icon(
              Icons.star_rounded,
              color: Colors.amber,
              size: SizeConfig.body6,
            );
          }),
        ),
        SizedBox(
          height: SizeConfig.padding10,
        ),
        Text(
          review,
          style: TextStyles.sourceSans.body4.colour(
            UiConstants.kTextColor.withOpacity(.7),
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(vertical: SizeConfig.padding16),
          child: Divider(
            color: UiConstants.kTextColor.withOpacity(.11),
          ),
        ),
      ],
    );
  }
}
