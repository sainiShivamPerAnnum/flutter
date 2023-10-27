import 'package:cached_network_image/cached_network_image.dart';
import 'package:felloapp/core/repository/user_stats_repo.dart';
import 'package:felloapp/ui/architecture/base_view.dart';
import 'package:felloapp/ui/pages/games/web/web_home/web_home_vm.dart';
import 'package:felloapp/ui/pages/static/app_widget.dart';
import 'package:felloapp/ui/pages/static/loader_widget.dart';
import 'package:felloapp/ui/service_elements/user_service/profile_image.dart';
import 'package:felloapp/util/assets.dart';
import 'package:felloapp/util/locator.dart';
import 'package:felloapp/util/styles/size_config.dart';
import 'package:felloapp/util/styles/textStyles.dart';
import 'package:felloapp/util/styles/ui_constants.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class WebGameModalSheet extends StatelessWidget {
  const WebGameModalSheet({required this.game, Key? key}) : super(key: key);
  final String game;

  @override
  Widget build(BuildContext context) {
    final gameInfo = locator<UserStatsRepo>().getGameInfo(game);
    return BaseView<WebHomeViewModel>(onModelReady: (model) {
      model.init(game);
    }, onModelDispose: (model) {
      model.clear();
    }, builder: (context, model, child) {
      if (model.isLoading) {
        return const FullScreenLoader();
      }
      return Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: SizeConfig.screenWidth! * 0.3,
            height: SizeConfig.padding4,
            color: Colors.grey,
            margin: EdgeInsets.only(top: SizeConfig.padding16),
          ),
          SizedBox(
            height: SizeConfig.screenHeight! * 0.01,
          ),
          SvgPicture.network(
            model.currentGameModel!.icon!,
            height: SizeConfig.screenHeight! * 0.13,
          ),
          StreamView(model: model, game: game),
          SizedBox(
            height: SizeConfig.padding12,
          ),
          Text(
            model.currentGameModel!.gameName!,
            style: TextStyles.sourceSansSB.title5.colour(Colors.white),
          ),
          const SizedBox(
            height: 2,
          ),
          SizedBox(
            width: SizeConfig.screenWidth! * 0.8,
            child: Text(
              model.currentGameModel!.description!,
              textAlign: TextAlign.center,
              style:
                  TextStyles.sourceSans.body3.colour(const Color(0xffBDBDBE)),
            ),
          ),
          if (model.currentGameModel?.rewardCriteria?.isNotEmpty ?? false)
            Padding(
              padding: const EdgeInsets.only(
                  top: 24, left: 14, right: 14, bottom: 0),
              child: RewardCriteria(
                data: model.currentGameModel?.rewardCriteria ?? "",
              ),
            ),
          SizedBox(
            height: SizeConfig.padding24,
          ),
          Text(
            "Your Scorecard",
            style: TextStyles.sourceSansSB.body1.colour(Colors.white),
          ),
          SizedBox(
            height: SizeConfig.padding10,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14),
            child: SizedBox(
              height: SizeConfig.screenHeight! * 0.15,
              child: Row(
                children: [
                  Expanded(
                    child: SizedBox(
                      child: Container(
                        decoration: BoxDecoration(
                          color: const Color(0xff050505).withOpacity(0.2),
                          border: Border.all(
                            color: const Color(0xff919193),
                          ),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 22, vertical: 8),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            const ProfileImageSE(),
                            const SizedBox(
                              height: 8,
                            ),
                            Text(
                              "Your best",
                              style: TextStyles.sourceSans.body3.colour(
                                const Color(0xffFFD979),
                              ),
                            ),
                            Text(
                              "${gameInfo?.topScore ?? "0"}",
                              style: TextStyles.rajdhaniSB.title5,
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 8,
                  ),
                  Expanded(
                    child: Column(
                      children: [
                        Expanded(
                          child: SizedBox(
                            child: Container(
                              decoration: BoxDecoration(
                                color: const Color(0xff050505).withOpacity(0.2),
                                border: Border.all(
                                  color: UiConstants.kTextColor2,
                                ),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              padding: const EdgeInsets.all(8),
                              child: Row(
                                mainAxisSize: MainAxisSize.max,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  Text(
                                    "Last Score",
                                    style: TextStyles.sourceSans.body3.colour(
                                        UiConstants.kTextFieldTextColor),
                                  ),
                                  Text(
                                    "${gameInfo?.lastScore ?? "0"}",
                                    style: TextStyles.rajdhaniSB.body1.colour(
                                      UiConstants.kTextFieldTextColor,
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: SizeConfig.padding4,
                        ),
                        Expanded(
                          child: SizedBox(
                            child: Container(
                              decoration: BoxDecoration(
                                color: const Color(0xff050505).withOpacity(0.2),
                                border: Border.all(
                                  color: const Color(0xff919193),
                                ),
                                borderRadius:
                                    BorderRadius.circular(SizeConfig.padding8),
                              ),
                              padding: EdgeInsets.all(SizeConfig.padding8),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  Text(
                                    "Total won\nfrom Game",
                                    style: TextStyles.sourceSans.body3
                                        .colour(const Color(0xffBDBDBE)),
                                  ),
                                  Text(
                                    "₹ ${gameInfo?.rewards?.amt ?? " 0"}",
                                    style: TextStyles.rajdhaniSB.body1.colour(
                                      const Color(0xffBDBDBE),
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
          SizedBox(
            height: SizeConfig.padding24,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14),
            child: AppPositiveBtn(
                btnText: "Play",
                widget: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "PLAY WITH ",
                      style: TextStyles.rajdhaniB.body1,
                    ),
                    ClipOval(
                      child: Container(
                        color: Colors.black,
                        child: SvgPicture.asset(
                          Assets.token,
                          height: SizeConfig.padding20,
                          width: SizeConfig.padding20,
                        ),
                      ),
                    ),
                    Text(" " + model.currentGameModel!.playCost.toString(),
                        style: TextStyles.rajdhaniB.body1)
                  ],
                ),
                onPressed: () async {
                  if (await model.setupGame()) {
                    model.launchGame(
                        gameInfo?.lastScore ?? 0, gameInfo?.topScore ?? 0);
                  }
                }),
          ),
          const SizedBox(
            height: 28,
          )
        ],
      );
    });
  }
}

class RewardCriteria extends StatefulWidget {
  const RewardCriteria({required this.data, Key? key}) : super(key: key);
  final String data;

  @override
  State<RewardCriteria> createState() => _RewardCriteriaState();
}

class _RewardCriteriaState extends State<RewardCriteria> {
  bool isError = false;

  @override
  Widget build(BuildContext context) {
    return isError
        ? const SizedBox()
        : CachedNetworkImage(
            imageUrl: widget.data,
            errorWidget: (_, __, ___) => const SizedBox(),
          );
  }
}

class StreamView extends StatelessWidget {
  const StreamView({required this.model, required this.game, Key? key})
      : super(key: key);

  final WebHomeViewModel model;
  final String game;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      initialData: null,
      stream: model.getRealTimePlayingStream(game),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              CircleAvatar(
                  backgroundColor: UiConstants.primaryColor,
                  radius: SizeConfig.padding4),
              SizedBox(
                width: SizeConfig.padding8,
              ),
              Text(
                "_",
                style: TextStyles.sourceSans.body2.colour(
                  const Color(0xffE0E0E0),
                ),
              )
            ],
          );
        }

        if ((snapshot.data as DatabaseEvent).snapshot.value != null) {
          Map fetchedData = Map<dynamic, dynamic>.from(
              (snapshot.data as DatabaseEvent).snapshot.value
                  as Map<dynamic, dynamic>);
          String? fieldToFetch = fetchedData['field'] as String?;

          Map<Object, Object> requiredTimeData =
              Map<Object, Object>.from(fetchedData[fieldToFetch!]);
          return AnimatedSwitcher(
            duration: const Duration(milliseconds: 500),
            transitionBuilder: (Widget child, Animation<double> animation) {
              return ScaleTransition(scale: animation, child: child);
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                CircleAvatar(
                    backgroundColor: UiConstants.primaryColor,
                    radius: SizeConfig.padding4),
                SizedBox(
                  width: SizeConfig.padding8,
                ),
                Text(
                  "${model.sortPlayerNumbers(requiredTimeData['value'].toString())}+ Playing",
                  style: TextStyles.sourceSans.body2.colour(
                    const Color(0xffE0E0E0),
                  ),
                )
              ],
            ),
          );
        } else {
          return Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              CircleAvatar(
                  backgroundColor: UiConstants.primaryColor,
                  radius: SizeConfig.padding4),
              SizedBox(
                width: SizeConfig.padding8,
              ),
              Text(
                "50+ Playing",
                style: TextStyles.sourceSans.body2.colour(
                  const Color(0xffE0E0E0),
                ),
              ),
            ],
          );
        }
      },
    );
  }
}
