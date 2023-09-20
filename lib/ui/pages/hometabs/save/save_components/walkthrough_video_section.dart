import 'package:cached_network_image/cached_network_image.dart';
import 'package:felloapp/base_util.dart';
import 'package:felloapp/core/constants/analytics_events_constants.dart';
import 'package:felloapp/core/enums/app_config_keys.dart';
import 'package:felloapp/core/model/app_config_model.dart';
import 'package:felloapp/core/model/home_screen_carousel_items.dart';
import 'package:felloapp/core/repository/getters_repo.dart';
import 'package:felloapp/core/service/analytics/analytics_service.dart';
import 'package:felloapp/navigator/app_state.dart';
import 'package:felloapp/ui/elements/title_subtitle_container.dart';
import 'package:felloapp/ui/pages/static/youtube_player_view.dart';
import 'package:felloapp/util/assets.dart';
import 'package:felloapp/util/locator.dart';
import 'package:felloapp/util/styles/styles.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class WalthroughVideosSection extends StatefulWidget {
  const WalthroughVideosSection({
    super.key,
  });

  @override
  State<WalthroughVideosSection> createState() =>
      _WalthroughVideosSectionState();
}

class _WalthroughVideosSectionState extends State<WalthroughVideosSection> {
  List<HomeScreenCarouselItemsModel>? listItems;
  @override
  void initState() {
    locator<GetterRepository>().getHomeScreenItems().then((value) {
      if (value.isSuccess()) {
        listItems = value.model;
        setState(() {});
      } else {}
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: SizeConfig.screenWidth! * 0.4 / 0.84,
      width: SizeConfig.screenWidth,
      child: listItems == null
          ? const HomeScreenShimmer()
          : listItems!.isNotEmpty
              ? ListView.builder(
                  physics: const BouncingScrollPhysics(),
                  padding:
                      EdgeInsets.symmetric(horizontal: SizeConfig.padding14),
                  scrollDirection: Axis.horizontal,
                  itemCount: listItems!.length,
                  itemBuilder: (ctx, i) => Card(
                    shape: RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.circular(SizeConfig.roundness12)),
                    color: Colors.black,
                    margin:
                        EdgeInsets.symmetric(horizontal: SizeConfig.padding8),
                    child: GestureDetector(
                      onTap: () {
                        decideAction(listItems![i]);

                        locator<AnalyticsService>().track(
                            eventName: AnalyticsEvents.carouselItemTapped,
                            properties: {
                              "order": i + 1,
                              "type": listItems![i].type,
                            });
                      },
                      child: Container(
                        width: SizeConfig.screenWidth! * 0.4,
                        decoration: BoxDecoration(
                          color: Colors.black,
                          image: DecorationImage(
                              image: CachedNetworkImageProvider(
                                  listItems![i].thumbnail),
                              fit: BoxFit.cover),
                          borderRadius:
                              BorderRadius.circular(SizeConfig.roundness12),
                        ),
                        alignment: Alignment.center,
                      ),
                    ),
                  ),
                )
              : const SizedBox(),
    );
  }

  void decideAction(HomeScreenCarouselItemsModel item) {
    if (item.type == "video") {
      BaseUtil.openDialog(
        isBarrierDismissible: true,
        addToScreenStack: true,
        hapticVibrate: true,
        barrierColor: Colors.black54,
        content: Dialog(
          child: YoutubePlayerView(url: item.action),
        ),
      );
    } else if (item.type == "image") {
      AppState.delegate!.parseRoute(Uri.parse(item.action));
    } else if (item.type == "appLink") {
      AppState.delegate!.parseRoute(Uri.parse(item.action));
    } else if (item.type == "webLinkExternal") {
      AppState.delegate!.parseRoute(Uri.parse(item.action), isExternal: true);
    } else if (item.type == "webLinkInternal") {
      AppState.delegate!.parseRoute(Uri.parse(item.action));
    }
  }
}

class HomeScreenShimmer extends StatelessWidget {
  const HomeScreenShimmer({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      physics: const BouncingScrollPhysics(),
      padding: EdgeInsets.symmetric(horizontal: SizeConfig.padding14),
      scrollDirection: Axis.horizontal,
      itemCount: 5,
      itemBuilder: (ctx, i) => Shimmer(
        gradient: const LinearGradient(
          colors: [Colors.white24, Colors.grey, Colors.black],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        child: Card(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(SizeConfig.roundness12)),
          color: Colors.black,
          margin: EdgeInsets.symmetric(horizontal: SizeConfig.padding8),
          child: Container(
            width: SizeConfig.screenWidth! * 0.4,
            decoration: BoxDecoration(
                color: Colors.black,
                borderRadius: BorderRadius.circular(SizeConfig.roundness12)),
          ),
        ),
      ),
    );
  }
}

class TambolaVideosSection extends StatelessWidget {
  const TambolaVideosSection({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final List videos =
        AppConfig.getValue(AppConfigKey.tickets_youtube_videos) ??
            [
              "https://www.youtube.com/watch?v=mzaIjBjUM1Y",
              "https://www.youtube.com/watch?v=CDokUdux0rc",
              "https://www.youtube.com/watch?v=zFhYJRqz_xk"
            ];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          height: SizeConfig.pageHorizontalMargins - SizeConfig.padding16,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const TitleSubtitleContainer(title: "How Tickets Work?"),
            Padding(
              padding: EdgeInsets.only(
                right: SizeConfig.pageHorizontalMargins,
              ),
              child: OutlinedButton(
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(width: 1.0, color: Colors.white),
                ),
                onPressed: () {
                  AppState.delegate!.parseRoute(Uri.parse('ticketsIntro'));
                },
                child: Text(
                  "Play Tutorial",
                  style: TextStyles.rajdhaniSB.body3.colour(Colors.white),
                ),
              ),
            )
          ],
        ),
        SizedBox(height: SizeConfig.padding12),
        SizedBox(
          height: SizeConfig.screenWidth! * 0.32,
          width: SizeConfig.screenWidth,
          child: ListView.builder(
            physics: const BouncingScrollPhysics(),
            padding: EdgeInsets.symmetric(horizontal: SizeConfig.padding14),
            scrollDirection: Axis.horizontal,
            itemCount: videos.length,
            itemBuilder: (ctx, i) => Card(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(SizeConfig.roundness12)),
              color: Colors.black,
              margin: EdgeInsets.symmetric(horizontal: SizeConfig.padding8),
              child: GestureDetector(
                onTap: () {
                  BaseUtil.openDialog(
                      isBarrierDismissible: true,
                      addToScreenStack: true,
                      hapticVibrate: true,
                      barrierColor: Colors.black54,
                      content:
                          Dialog(child: YoutubePlayerView(url: videos[i])));

                  locator<AnalyticsService>().track(
                      eventName: AnalyticsEvents.ticketsVideoItemTapped,
                      properties: {
                        "order": i + 1,
                        "video_url": videos[i],
                      });
                },
                child: Container(
                  width: SizeConfig.screenWidth! * 0.58,
                  height: SizeConfig.screenWidth! * 0.32,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(SizeConfig.roundness12),
                    image: DecorationImage(
                      image: NetworkImage(
                          'https://img.youtube.com/vi/${videos[i].substring(videos[i].length - 11)}/0.jpg'),
                      fit: BoxFit.cover,
                    ),
                  ),
                  alignment: Alignment.center,
                  child: Image.network(
                    Assets.youtubeLogo,
                    width: SizeConfig.padding54,
                  ),
                ),
              ),
            ),
          ),
        ),
        SizedBox(height: SizeConfig.padding12),
      ],
    );
  }
}
