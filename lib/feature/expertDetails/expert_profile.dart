import 'package:felloapp/base_util.dart';
import 'package:felloapp/feature/expert/booking_sheet.dart';
import 'package:felloapp/feature/expertDetails/bloc/expert_bloc.dart';
import 'package:felloapp/feature/expertDetails/widgets/ratingSheet.dart';
import 'package:felloapp/util/locator.dart';
import 'package:felloapp/util/styles/styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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
      child: const _ExpertProfilePage(),
    );
  }
}

class _ExpertProfilePage extends StatelessWidget {
  const _ExpertProfilePage();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ExpertDetailsBloc, ExpertDetailsState>(
      builder: (context, state) {
        if (state is LoadingExpertsDetails) {
          return const Center(child: CircularProgressIndicator());
        }
        if (state is ExpertDetailsLoaded) {
          final expertDetails = state.expertDetails;

          return DefaultTabController(
            length: 3,
            child: Scaffold(
              floatingActionButton: GestureDetector(
                onTap: () {
                  BaseUtil.openModalBottomSheet(
                    isBarrierDismissible: true,
                    content: BookCallBottomSheet(),
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
              backgroundColor: UiConstants.bg,
              appBar: AppBar(
                backgroundColor: UiConstants.bg,
                centerTitle: true,
                title: Text('Profile', style: TextStyles.rajdhaniSB.body1),
                leading: Icon(
                  Icons.arrow_back,
                  color: Colors.white,
                  size: SizeConfig.body1,
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
                        ), // Load image from the model
                      ),
                      SizedBox(
                        height: SizeConfig.padding20,
                      ),
                      Text(
                        expertDetails.name, // Display expert's name
                        style: TextStyles.sourceSansSB.body0.colour(
                          UiConstants.kTextColor,
                        ),
                      ),
                      SizedBox(
                        height: SizeConfig.padding6,
                      ),
                      Text(
                        expertDetails
                            .description, // Display expert's description
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
                      const CustomCarousel(),
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
                            Tab(text: "Popular Live"),
                            Tab(text: "About"),
                          ],
                        ),
                      ),
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
                          for (final license
                              in expertDetails.licenses) // Display licenses
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  width: SizeConfig.padding46,
                                  height: SizeConfig.padding46,
                                  decoration: BoxDecoration(
                                    color: UiConstants.greyVarient,
                                    borderRadius: BorderRadius.circular(
                                      SizeConfig.roundness8,
                                    ),
                                  ),
                                  child: const Center(
                                    child: Text(
                                      "SEBI", // You can replace this with license name
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
                                        license.name, // Display license name
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
                                            "Issued on ${license.issueDate}", // Display issue date
                                            style: TextStyles.sourceSansSB.body3
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
                                  padding: EdgeInsets.all(SizeConfig.padding14),
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
                        ],
                      ),
                      SizedBox(
                        height: SizeConfig.padding24,
                      ),
                      const RatingReviewSection(),
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

class CustomCarousel extends StatefulWidget {
  const CustomCarousel({super.key});

  @override
  _CustomCarouselState createState() => _CustomCarouselState();
}

class _CustomCarouselState extends State<CustomCarousel> {
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
            children: [
              buildCarouselItem(
                "ASK VIBHOR!",
                "Is my mutual fund allocation right?",
                onTap: () {
                  print("Chat tapped!");
                },
              ),
              buildCarouselItem(
                "ASK VIBHOR!",
                "Should I increase my SIP amount?",
                onTap: () {
                  print("Chat tapped!");
                },
              ),
              // Add more carousel items here
            ],
          ),
        ),
        SizedBox(
          height: SizeConfig.padding12,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(2, (index) {
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
    String description, {
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
              'Ask on Chat',
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
  const RatingReviewSection({super.key});

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
              '5.0',
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
                      color: Colors.amber,
                      size: SizeConfig.body6,
                    );
                  }),
                ),
                Text(
                  '26 ratings',
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
        const ReviewCard(
          name: 'Devanshu Verma',
          date: 'March 3, 2023',
          rating: 5,
          review:
              'The call was great and super insightful. He always gives the best advice regarding financial planning.',
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

  const ReviewCard({
    required this.name,
    required this.date,
    required this.rating,
    required this.review,
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
              backgroundImage: const AssetImage(
                'assets/avatar.png',
              ), // Add a profile picture here
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
