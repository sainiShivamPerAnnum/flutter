import 'package:cached_network_image/cached_network_image.dart';
import 'package:felloapp/base_util.dart';
import 'package:felloapp/core/model/event_model.dart';
import 'package:felloapp/core/service/notifier_services/user_service.dart';
import 'package:felloapp/navigator/app_state.dart';
import 'package:felloapp/ui/elements/title_subtitle_container.dart';
import 'package:felloapp/ui/pages/hometabs/save/save_viewModel.dart';
import 'package:felloapp/util/assets.dart';
import 'package:felloapp/util/localization/generated/l10n.dart';
import 'package:felloapp/util/locator.dart';
import 'package:felloapp/util/styles/size_config.dart';
import 'package:felloapp/util/styles/textStyles.dart';
import 'package:felloapp/util/styles/ui_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:shimmer/shimmer.dart';

class Campaigns extends StatelessWidget {
  final SaveViewModel model;
  const Campaigns({Key? key, required this.model}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    S locale = S.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: SizeConfig.padding16),
        TitleSubtitleContainer(
          title: locale.offers,
          subTitle: locale.offersSubtitle,
        ),
        CampaignCardSection(saveVm: model),
      ],
    );
  }
}

class CampaignCardSection extends StatelessWidget {
  final SaveViewModel saveVm;
  final UserService _userService = locator<UserService>();
  CampaignCardSection({Key? key, required this.saveVm}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        // left: SizeConfig.padding16,
        top: SizeConfig.padding8,
        // right: SizeConfig.padding16,
      ),
      child: Container(
        height: SizeConfig.screenWidth! * 0.57,
        width: SizeConfig.screenWidth,
        child: saveVm.isChallengesLoading
            ? SizedBox()
            : PageView.builder(
                controller: saveVm.offersController,
                itemCount: saveVm.ongoingEvents!.length,
                itemBuilder: ((context, index) {
                  final event = saveVm.ongoingEvents![index];
                  return GestureDetector(
                    onTap: () {
                      if (_userService.baseUser!.username!.isEmpty)
                        return BaseUtil.showUsernameInputModalSheet();
                      saveVm.trackChallangeTapped(event.type, index);
                      AppState.delegate!.parseRoute(Uri.parse(event.type));
                    },
                    child: Padding(
                      padding: EdgeInsets.only(right: SizeConfig.padding10),
                      child: CampaignCard(
                        isLoading: saveVm.isChallengesLoading,
                        topPadding: SizeConfig.padding16,
                        leftPadding: SizeConfig.padding20,
                        event: event,
                        subText: FittedBox(
                          fit: BoxFit.contain,
                          child: Container(
                            width: SizeConfig.screenWidth! * 0.4,
                            padding: EdgeInsets.only(
                              top: SizeConfig.padding8,
                            ),
                            child: Text(
                              event.subtitle ?? '',
                              style: TextStyles.sourceSans.body4,
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                }),
              ),
      ),
    );
  }
}

class IOSCampaignCard extends StatelessWidget {
  final EventModel event;
  final Widget subText;
  final bool isLoading;
  final double topPadding;
  final double leftPadding;

  const IOSCampaignCard(
      {required this.event,
      required this.subText,
      required this.isLoading,
      required this.topPadding,
      required this.leftPadding});

  @override
  Widget build(BuildContext context) {
    final i = isLoading ? 0 : event.title.lastIndexOf(' ');
    final prefix = isLoading ? '' : event.title.substring(0, i);
    final suffix = isLoading ? '' : event.title.substring(i + 1);
    final asset = isLoading
        ? ''
        : event.type == 'SAVER_MONTHLY'
            ? Assets.monthlySaver
            : event.type == 'SAVER_DAILY'
                ? Assets.dailySaver
                : Assets.weeklySaver;

    return AnimatedContainer(
      duration: Duration(seconds: 1),
      curve: Curves.easeInCubic,
      child: this.isLoading
          ? Shimmer.fromColors(
              child: Container(
                width: SizeConfig.screenWidth,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(SizeConfig.roundness12),
                  color: UiConstants.kBackgroundColor,
                ),
                child: Padding(
                  padding: EdgeInsets.all(SizeConfig.padding16),
                  child: Container(
                    height: SizeConfig.screenWidth! * 0.18,
                    decoration: BoxDecoration(
                      color: UiConstants.kSecondaryBackgroundColor,
                    ),
                  ),
                ),
              ),
              baseColor: UiConstants.kUserRankBackgroundColor,
              highlightColor: UiConstants.kBackgroundColor,
            )
          : Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(SizeConfig.roundness12),
                color: UiConstants.kSecondaryBackgroundColor,
              ),
              margin: EdgeInsets.only(bottom: SizeConfig.padding16),
              padding: EdgeInsets.only(
                  left: this.leftPadding,
                  right: SizeConfig.padding24,
                  top: SizeConfig.viewInsets.top + kToolbarHeight / 2),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        prefix,
                        style: TextStyles.sourceSans.body1.bold,
                      ),
                      Text(
                        suffix.toUpperCase(),
                        style: TextStyles.sourceSansEB.title50
                            .letterSpace(0.6)
                            .colour(
                              event.textColor.toColor(),
                            )
                            .setHeight(1),
                      ),
                      this.subText,
                      SizedBox(height: SizeConfig.padding32)
                    ],
                  ),
                  Expanded(
                    child: SvgPicture.asset(
                      asset,
                      fit: BoxFit.fitHeight,
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}

class CampaignCard extends StatelessWidget {
  final EventModel event;
  final Widget subText;
  final bool isLoading;
  final double topPadding;
  final double leftPadding;

  const CampaignCard(
      {required this.event,
      required this.subText,
      required this.isLoading,
      required this.topPadding,
      required this.leftPadding});

  @override
  Widget build(BuildContext context) {
    final i = isLoading ? 0 : event.title.lastIndexOf(' ');
    final prefix = isLoading ? '' : event.title.substring(0, i);
    final suffix = isLoading ? '' : event.title.substring(i + 1);
    final asset = isLoading
        ? ''
        : event.type == 'SAVER_MONTHLY'
            ? Assets.monthlySaver
            : event.type == 'SAVER_DAILY'
                ? Assets.dailySaver
                : Assets.weeklySaver;

    return this.isLoading
        ? Shimmer.fromColors(
            child: Container(
              width: SizeConfig.screenWidth,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(SizeConfig.roundness12),
                color: UiConstants.kBackgroundColor,
              ),
              child: Padding(
                padding: EdgeInsets.all(SizeConfig.padding16),
                child: Container(
                  height: SizeConfig.screenWidth! * 0.18,
                  decoration: BoxDecoration(
                    color: UiConstants.kSecondaryBackgroundColor,
                  ),
                ),
              ),
            ),
            baseColor: UiConstants.kUserRankBackgroundColor,
            highlightColor: UiConstants.kBackgroundColor,
          )
        : event.bgImage.isNotEmpty
            ? Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(SizeConfig.roundness12),
                  color: UiConstants.kSecondaryBackgroundColor,
                  image: DecorationImage(
                    image: CachedNetworkImageProvider(event.thumbnail),
                    fit: BoxFit.cover,
                  ),
                ),
              )
            : Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(SizeConfig.roundness12),
                  color: UiConstants.kSecondaryBackgroundColor,
                ),
                padding: EdgeInsets.only(
                  left: this.leftPadding,
                  right: SizeConfig.padding24,
                  top: this.topPadding,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                          prefix,
                          style: TextStyles.sourceSans.body1.bold,
                        ),
                        Text(
                          suffix.toUpperCase(),
                          style: TextStyles.sourceSansEB.title50
                              .letterSpace(0.6)
                              .colour(
                                event.textColor.toColor(),
                              )
                              .setHeight(1),
                        ),
                        this.subText
                      ],
                    ),
                    Expanded(
                      child: SvgPicture.asset(
                        asset,
                        fit: BoxFit.fitHeight,
                      ),
                    ),
                  ],
                ),
              );
  }
}
