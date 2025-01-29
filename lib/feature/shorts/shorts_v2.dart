import 'package:felloapp/base_util.dart';
import 'package:felloapp/feature/support-new/bloc/support_bloc.dart';
import 'package:felloapp/ui/elements/title_subtitle_container.dart';
import 'package:felloapp/ui/pages/static/loader_widget.dart';
import 'package:felloapp/util/styles/styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ShortsNewPage extends StatelessWidget {
  const ShortsNewPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => SupportBloc()..add(const LoadSupportData()),
      child: _ShortsScreen(),
    );
  }
}

class _ShortsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      triggerMode: RefreshIndicatorTriggerMode.onEdge,
      color: UiConstants.primaryColor,
      backgroundColor: Colors.black,
      onRefresh: () async {
        BlocProvider.of<SupportBloc>(
          context,
          listen: false,
        ).add(const LoadSupportData());
        return;
      },
      child: BlocBuilder<SupportBloc, SupportState>(
        builder: (context, state) {
          return switch (state) {
            LoadingSupportData() => const FullScreenLoader(),
            SupportData() => Padding(
                padding: EdgeInsets.symmetric(horizontal: SizeConfig.padding20),
                child: SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: SizeConfig.padding14),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const TitleSubtitleContainer(
                                title: "Shorts",
                                zeroPadding: true,
                                largeFont: true,
                              ),
                              Text(
                                'Learn investing with quick and insightful shorts',
                                style: TextStyles.sourceSans.body3.colour(
                                  UiConstants.kTextColor.withOpacity(.7),
                                ),
                              ),
                            ],
                          ),
                          GestureDetector(
                            onTap: () {},
                            child: Container(
                              decoration: BoxDecoration(
                                color: UiConstants.grey5,
                                borderRadius: BorderRadius.all(
                                  Radius.circular(
                                    SizeConfig.roundness12,
                                  ),
                                ),
                              ),
                              padding: EdgeInsets.all(SizeConfig.padding10),
                              child: const Icon(
                                Icons.notifications,
                                color: UiConstants.kTextColor,
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: SizeConfig.padding24,
                      ),
                      Container(
                        padding: EdgeInsets.symmetric(vertical: 8),
                        child: TextField(
                          style: TextStyle(color: Colors.white),
                          decoration: InputDecoration(
                            hintText: "Search",
                            hintStyle: TextStyle(
                              color: UiConstants.kTextColor.withOpacity(.7),
                            ),
                            filled: true,
                            fillColor: Colors.grey[800],
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: BorderSide.none,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 16),

                      // Category Chips
                      Row(
                        children: [
                          Expanded(
                            child: SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: Row(
                                children: [
                                  Chip(
                                    label: Text("Stocks"),
                                    backgroundColor: Colors.grey[800],
                                    labelStyle: TextStyle(color: Colors.white),
                                  ),
                                  SizedBox(width: 8),
                                  GestureDetector(
                                    onTap: () {
                                      BaseUtil.showPositiveAlert('Hello', 'hi');
                                    },
                                    child: Chip(
                                      label: Text("Mutual Funds"),
                                      backgroundColor: Colors.grey[800],
                                      labelStyle:
                                          TextStyle(color: Colors.white),
                                    ),
                                  ),
                                  SizedBox(width: 8),
                                  Chip(
                                    label: Text("Corporates Planning"),
                                    backgroundColor: Colors.grey[800],
                                    labelStyle: TextStyle(color: Colors.white),
                                  ),
                                  SizedBox(width: 8),
                                  Chip(
                                    label: Text("Tax Planning"),
                                    backgroundColor: Colors.grey[800],
                                    labelStyle: TextStyle(color: Colors.white),
                                  ),
                                  SizedBox(width: 8),
                                  Chip(
                                    label: Text("Financial Planning"),
                                    backgroundColor: Colors.grey[800],
                                    labelStyle: TextStyle(color: Colors.white),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          GestureDetector(
                            onTap: () {},
                            child: Container(
                              margin:
                                  EdgeInsets.only(left: SizeConfig.padding12),
                              decoration: BoxDecoration(
                                color: Colors.grey[800],
                                borderRadius: BorderRadius.all(
                                  Radius.circular(
                                    SizeConfig.roundness12,
                                  ),
                                ),
                              ),
                              padding: EdgeInsets.all(SizeConfig.padding10),
                              child: const Icon(
                                Icons.bookmark,
                                color: UiConstants.kTextColor,
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 16),

                      // Sections
                      buildSection("Advisors you follow"),
                      buildSection("Recently Added"),
                      buildSection("Weekly Updates"),
                      buildSection("Market News"),
                      buildSection("IPO"),
                    ],
                  ),
                ),
              ),
          };
        },
      ),
    );
  }

  Widget buildSection(String title) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Section Header
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Text(
            title,
            style: TextStyle(
                color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ),
        SizedBox(height: 8),

        // Horizontal Scrollable Cards
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: List.generate(3, (index) => buildCard()),
          ),
        ),
        SizedBox(height: 16),
      ],
    );
  }

  Widget buildPlayIcon() {
    return Align(
      alignment: Alignment.center,
      child: Container(
        padding: EdgeInsets.all(SizeConfig.padding8),
        decoration: BoxDecoration(
          color: UiConstants.kTextColor.withOpacity(0.5),
          shape: BoxShape.circle,
        ),
        child: Icon(
          Icons.play_arrow_rounded,
          color: Colors.white,
          size: SizeConfig.iconSize5,
        ),
      ),
    );
  }

  Widget buildViewIndicator() {
    return Positioned(
      bottom: SizeConfig.padding10,
      left: SizeConfig.padding10,
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: SizeConfig.padding8,
          vertical: SizeConfig.padding4,
        ),
        decoration: BoxDecoration(
          color: UiConstants.kTextColor4,
          borderRadius: BorderRadius.circular(SizeConfig.roundness5),
        ),
        child: Row(
          children: [
            Icon(
              Icons.remove_red_eye,
              color: UiConstants.titleTextColor,
              size: SizeConfig.iconSize4,
            ),
            SizedBox(
              width: SizeConfig.padding4,
            ),
            Text(
              '3k',
              style: TextStyles.sourceSansSB.body4.colour(
                UiConstants.titleTextColor,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildCard() {
    return Container(
      width: SizeConfig.padding152,
      height: SizeConfig.padding275,
      decoration: BoxDecoration(
        color: Colors.grey[800],
        borderRadius: BorderRadius.circular(8),
      ),
      margin: EdgeInsets.only(right: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Image Thumbnail
          Expanded(
            child: Stack(
              children: [
                Positioned.fill(
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      image: DecorationImage(
                        image: NetworkImage(
                            'https://ik.imagekit.io/9xfwtu0xm/experts/live2.png?updatedAt=1727083175271'),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
                buildPlayIcon(),
                buildViewIndicator()
              ],
            ),
          ),
          SizedBox(height: 8),

          Container(
            padding: EdgeInsets.symmetric(
              horizontal: SizeConfig.padding10,
              vertical: SizeConfig.padding14,
            ),
            decoration: BoxDecoration(
              color: Colors.grey[800],
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Title of the Video",
                  style: TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: 4),

                // Author
                Text(
                  "Author Name",
                  style: TextStyle(color: Colors.grey, fontSize: 12),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
