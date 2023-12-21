import 'dart:developer';

import 'package:felloapp/core/constants/analytics_events_constants.dart';
import 'package:felloapp/core/enums/page_state_enum.dart';
import 'package:felloapp/core/enums/view_state_enum.dart';
import 'package:felloapp/core/model/scratch_card_model.dart';
import 'package:felloapp/core/model/timestamp_model.dart';
import 'package:felloapp/core/service/analytics/analytics_service.dart';
import 'package:felloapp/core/service/notifier_services/scratch_card_service.dart';
import 'package:felloapp/core/service/notifier_services/user_service.dart';
import 'package:felloapp/navigator/app_state.dart';
import 'package:felloapp/navigator/router/ui_pages.dart';
import 'package:felloapp/ui/architecture/base_view.dart';
import 'package:felloapp/ui/pages/rewards/detailed_scratch_card/gt_detailed_vm.dart';
import 'package:felloapp/ui/pages/rewards/scratch_card_const.dart';
import 'package:felloapp/ui/pages/rewards/scratch_card_utils.dart';
import 'package:felloapp/util/assets.dart';
import 'package:felloapp/util/extensions/rich_text_extension.dart';
import 'package:felloapp/util/localization/generated/l10n.dart';
import 'package:felloapp/util/locator.dart';
import 'package:felloapp/util/styles/size_config.dart';
import 'package:felloapp/util/styles/textStyles.dart';
import 'package:felloapp/util/styles/ui_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:scratcher/scratcher.dart';

final scratchKey = GlobalKey<ScratcherState>();

class GTDetailedView extends StatelessWidget {
  final ScratchCard ticket;

  const GTDetailedView({required this.ticket, super.key});

  Future<void> _onTapViewAllBadges() async {
    await AppState.backButtonDispatcher!.didPopRoute();
    await Future.delayed(const Duration(milliseconds: 400)); // For animation.
    AppState.delegate!.appState.currentAction = PageAction(
      state: PageState.addPage,
      page: FelloBadgeHomeViewPageConfig,
    );

    locator<AnalyticsService>()
        .track(eventName: AnalyticsEvents.superFelloEntryPoint, properties: {
      'current_level': locator<UserService>().baseUser!.superFelloLevel.name,
      'location': 'scratch_card',
    });
  }

  @override
  Widget build(BuildContext context) {
    return BaseView<GTDetailedViewModel>(
      onModelReady: (model) {
        model.init(ticket);
        log(ticket.toString());
      },
      builder: (ctx, model, child) {
        return Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0.0,
            automaticallyImplyLeading: false,
            actions: [
              IconButton(
                onPressed: () {
                  AppState.backButtonDispatcher!.didPopRoute();
                },
                icon: const Icon(Icons.close),
              )
            ],
          ),
          backgroundColor: Colors.black.withOpacity(0.7),
          body: Column(
            children: [
              const Spacer(),
              (model.viewScratchedCard)
                  ? RepaintBoundary(
                      //Scratched card
                      key: ticketImageKey,
                      child: ScratchCardGridItemCard(
                        ticket: ticket,
                        titleStyle: TextStyles.title2,
                        titleStyle2: TextStyles.title4,
                        subtitleStyle: TextStyles.body1,
                        width: SizeConfig.screenWidth! * 0.75,
                      ),
                    )
                  : (model.viewScratcher
                      ? Hero(
                          key: Key(ticket.gtId.toString()),
                          tag: ticket.timestamp.toString(),
                          createRectTween: (begin, end) {
                            return CustomRectTween(begin: begin, end: end);
                          },
                          child: Scratcher(
                            color: Colors.transparent,
                            accuracy: ScratchAccuracy.low,
                            brushSize: 50,
                            threshold: 20,
                            key: scratchKey,
                            onThreshold: () => model.redeemCard(ticket),
                            image: Image.asset(
                              ticket.isLevelChange!
                                  ? Assets.levelUpUnredeemedScratchCardBGPNG
                                  : Assets.unredeemedScratchCardBG_png,
                              fit: BoxFit.fitWidth,
                            ),
                            child: RepaintBoundary(
                              key: ticketImageKey,
                              child: RedeemedGoldenScratchCard(
                                ticket: ticket,
                                width: SizeConfig.screenWidth! * 0.75,
                              ),
                            ),
                          ),
                        )
                      : ScratchCardGridItemCard(
                          ticket: ticket,
                          titleStyle: TextStyles.title2,
                          titleStyle2: TextStyles.title4,
                          subtitleStyle: TextStyles.body1,
                          width: SizeConfig.screenWidth! * 0.75,
                        )),
              AnimatedContainer(
                  decoration: const BoxDecoration(),
                  duration: const Duration(seconds: 1),
                  curve: Curves.easeIn,
                  width: SizeConfig.screenWidth,
                  child: setTicketHeader(model)),
              const Spacer(flex: 2),
              AnimatedContainer(
                decoration: const BoxDecoration(),
                duration: const Duration(seconds: 1),
                curve: Curves.easeIn,
                width: SizeConfig.screenWidth,
                child: setModalContent(model, context),
              )
            ],
          ),
        );
      },
    );
  }

  Widget setTicketHeader(
    GTDetailedViewModel model,
  ) {
    S locale = locator<S>();
    final tag = ticket.tag;
    if (ticket.redeemedTimestamp != null &&
        ticket.redeemedTimestamp !=
            TimestampModel(seconds: 0, nanoseconds: 0)) {
      //redeemed ticket -> just show the details
      return Column(
        children: [
          Text(locale.btnCongratulations,
              style: TextStyles.rajdhaniB.title2.colour(Colors.white)),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: SizeConfig.padding32),
            child: (ticket.note ?? locale.wonGT).beautify(
                style:
                    TextStyles.sourceSans.body4.colour(UiConstants.kTextColor3),
                alignment: TextAlign.center),
          ),
          SizedBox(
            height: SizeConfig.padding40,
          ),
          if (tag != null && tag.isNotEmpty)
            Container(
              padding: EdgeInsets.symmetric(vertical: SizeConfig.padding16),
              margin: EdgeInsets.symmetric(horizontal: SizeConfig.padding32),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(SizeConfig.padding12),
                color: Colors.black,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              ScratchCardConstants.getTitle(
                                  ticket.tag!)['title']!,
                              style: TextStyles.sourceSans.body3
                                  .colour(Colors.white),
                              textAlign: TextAlign.center,
                            ),
                            SizedBox(
                              height: SizeConfig.padding8,
                            ),
                            Text(
                              ScratchCardConstants.getTitle(
                                  ticket.tag!)['subtitle']!,
                              style: TextStyles.rajdhaniSB.title5
                                  .colour(Colors.white),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),
                      //vertical divider
                      Container(
                        height: SizeConfig.padding90,
                        width: 2,
                        color: Colors.white,
                        // child:
                      ),
                      Expanded(
                        child: Column(
                          children: [
                            Text(
                              'You earned a badge',
                              style: TextStyles.sourceSans.body3
                                  .colour(Colors.white.withOpacity(0.6)),
                              textAlign: TextAlign.center,
                            ),
                            SizedBox(
                              height: SizeConfig.padding8,
                            ),
                            SvgPicture.network(
                                ScratchCardConstants.getBadges(ticket.tag!),
                                // fit: BoxFit.fitHeight,
                                height: SizeConfig.padding60,
                                width: SizeConfig.padding60),
                            SizedBox(
                              height: SizeConfig.padding4,
                            ),
                            Text(
                              ticket.tag ?? 'Fello Badge',
                              // 'Tambola Titan',
                              style: TextStyles.sourceSansSB.body2
                                  .colour(Colors.white),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: SizeConfig.padding14,
                  ),
                  GestureDetector(
                    onTap: _onTapViewAllBadges,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'View All Badges',
                          style: TextStyles.sourceSans.body3.colour(
                            Colors.white.withOpacity(0.6),
                          ),
                        ),
                        SizedBox(
                          width: SizeConfig.padding4,
                        ),
                        Icon(
                          Icons.arrow_forward_ios,
                          size: SizeConfig.padding12,
                          color: Colors.white.withOpacity(0.6),
                        )
                      ],
                    ),
                  ),
                  SizedBox(
                    height: SizeConfig.padding4,
                  ),
                ],
              ),
            )
        ],
      );
    } else {
      if (model.isCardScratched) {
        if (!ticket.isRewarding! ||
            ticket.rewardArr == null ||
            ticket.rewardArr!.isEmpty) {
          return Column(
            children: [
              Text(locale.rewardsEmpty,
                  style: TextStyles.rajdhaniB.title2.colour(Colors.white)),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: SizeConfig.padding32),
                child: Text(
                  locale.keepInvestingText,
                  style: TextStyles.sourceSans.body4
                      .colour(UiConstants.kTextColor3),
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          );
        } else {
          if (model.state == ViewState.Busy) {
            return const SizedBox.shrink();
          } else {
            return Column(
              children: [
                Text(locale.btnCongratulations,
                    style: TextStyles.rajdhaniB.title2.colour(Colors.white)),
                Padding(
                  padding:
                      EdgeInsets.symmetric(horizontal: SizeConfig.padding32),
                  child: Text(
                    "${ticket.note}",
                    style: TextStyles.sourceSans.body4
                        .colour(UiConstants.kTextColor3),
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            );
          }
        }
      } else {
        return Column(
          children: [
            Text(locale.hurray,
                style: TextStyles.rajdhaniB.title2.colour(Colors.white)),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: SizeConfig.padding32),
              child: Text(
                locale.earnedGTText,
                style: TextStyles.sourceSans.body4.colour(Colors.white),
                textAlign: TextAlign.center,
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: SizeConfig.padding32),
              child: Text(
                locale.scratchAndWin,
                style:
                    TextStyles.sourceSans.body4.colour(UiConstants.kTextColor3),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        );
      }
    }
  }

  Widget setModalContent(GTDetailedViewModel model, BuildContext context) {
    S locale = S.of(context);
    if (ticket.redeemedTimestamp != null &&
        ticket.redeemedTimestamp !=
            TimestampModel(seconds: 0, nanoseconds: 0)) {
      //redeemed ticket -> just show the details
      return Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          color: UiConstants.gameCardColor,
        ),
        padding: EdgeInsets.all(SizeConfig.pageHorizontalMargins),
        child: Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
          bulletTiles(locale.rewardsCredited),
          (ticket.redeemedTimestamp != null &&
                  ticket.redeemedTimestamp !=
                      TimestampModel(seconds: 0, nanoseconds: 0))
              ? bulletTiles(
                  "${locale.redeemedOn}${DateFormat('dd MMM, yyyy').format(DateTime.fromMillisecondsSinceEpoch(ticket.redeemedTimestamp!.seconds * 1000))} | ${DateFormat('h:mm a').format(DateTime.fromMillisecondsSinceEpoch(ticket.redeemedTimestamp!.seconds * 1000))}")
              : bulletTiles(
                  "${locale.receivedOn}${DateFormat('dd MMM, yyyy').format(DateTime.fromMillisecondsSinceEpoch(ticket.timestamp!.seconds * 1000))} | ${DateFormat('h:mm a').format(DateTime.fromMillisecondsSinceEpoch(ticket.timestamp!.seconds * 1000))}")
        ]),
      );
    } else {
      if (model.isCardScratched) {
        if (!ticket.isRewarding! ||
            ticket.rewardArr == null ||
            ticket.rewardArr!.isEmpty) {
          return const Column(
            children: [],
          );
        } else {
          if (model.state == ViewState.Busy) {
            return Container(
              padding: EdgeInsets.all(SizeConfig.pageHorizontalMargins),
              width: double.infinity,
              decoration: const BoxDecoration(
                color: UiConstants.gameCardColor,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  SpinKitWave(
                    color: UiConstants.primaryColor,
                    size: SizeConfig.padding32,
                  ),
                  SizedBox(height: SizeConfig.padding12),
                  Text(
                    locale.addingPrize,
                    style: TextStyles.body2.bold.colour(Colors.white),
                  ),
                ],
              ),
            );
          } else {
            return Container(
              width: double.infinity,
              decoration: const BoxDecoration(
                color: UiConstants.gameCardColor,
              ),
              padding: EdgeInsets.all(SizeConfig.pageHorizontalMargins),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    bulletTiles(locale.rewardsCredited),
                    (ticket.redeemedTimestamp != null &&
                            ticket.redeemedTimestamp !=
                                TimestampModel(seconds: 0, nanoseconds: 0))
                        ? bulletTiles(
                            "${locale.redeemedOn}${DateFormat('dd MMM, yyyy').format(DateTime.fromMillisecondsSinceEpoch(ticket.redeemedTimestamp!.seconds * 1000))} | ${DateFormat('h:mm a').format(DateTime.fromMillisecondsSinceEpoch(ticket.redeemedTimestamp!.seconds * 1000))}")
                        : bulletTiles(
                            "${locale.receivedOn}${DateFormat('dd MMM, yyyy').format(DateTime.fromMillisecondsSinceEpoch(ticket.timestamp!.seconds * 1000))} | ${DateFormat('h:mm a').format(DateTime.fromMillisecondsSinceEpoch(ticket.timestamp!.seconds * 1000))}")
                  ]),
            );
          }
        }
      } else {
        return const SizedBox(height: 0);
      }
    }
  }

  Widget bulletTiles(String title) {
    return Padding(
      padding: EdgeInsets.only(bottom: SizeConfig.padding8),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          const Icon(
            Icons.brightness_1,
            size: 06,
            color: UiConstants.kTextColor2,
          ),
          const SizedBox(width: 10),
          title.beautify(
              style: TextStyles.body3.colour(UiConstants.kTextColor2),
              boldStyle:
                  TextStyles.sourceSansB.body3.colour(UiConstants.kTextColor),
              italicStyle:
                  TextStyles.body3.colour(UiConstants.kTextColor).italic),
        ],
      ),
    );
  }
}
