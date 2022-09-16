import 'dart:convert';
import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:felloapp/base_util.dart';
import 'package:felloapp/core/enums/user_service_enum.dart';
import 'package:felloapp/core/model/event_model.dart';
import 'package:felloapp/core/model/journey_models/journey_background_model.dart';
import 'package:felloapp/core/service/notifier_services/user_service.dart';
import 'package:felloapp/navigator/app_state.dart';
import 'package:felloapp/ui/architecture/base_view.dart';
import 'package:felloapp/ui/modals_sheets/recharge_modal_sheet.dart';
import 'package:felloapp/ui/pages/hometabs/save/save_viewModel.dart';
import 'package:felloapp/ui/pages/others/finance/augmont/augmont_buy_screen/augmont_buy_vm.dart';
import 'package:felloapp/ui/pages/static/save_assets_footer.dart';
import 'package:felloapp/ui/pages/static/winnings_container.dart';
import 'package:felloapp/ui/service_elements/auto_save_card/subscription_card.dart';
import 'package:felloapp/ui/service_elements/user_service/profile_image.dart';
import 'package:felloapp/ui/service_elements/user_service/user_gold_quantity.dart';
import 'package:felloapp/ui/widgets/buttons/nav_buttons/nav_buttons.dart';
import 'package:felloapp/ui/widgets/coin_bar/coin_bar_view.dart';
import 'package:felloapp/ui/widgets/custom_card/custom_cards.dart';
import 'package:felloapp/ui/widgets/title_subtitle_container.dart';
import 'package:felloapp/util/assets.dart';
import 'package:felloapp/util/custom_logger.dart';
import 'package:felloapp/util/locator.dart';
import 'package:felloapp/util/styles/size_config.dart';
import 'package:felloapp/util/styles/textStyles.dart';
import 'package:felloapp/util/styles/ui_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:property_change_notifier/property_change_notifier.dart';
import 'package:shimmer/shimmer.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../../../../navigator/app_state.dart';

const HtmlEscape htmlEscape = HtmlEscape();

class Save extends StatelessWidget {
  final CustomLogger logger = locator<CustomLogger>();

  @override
  Widget build(BuildContext context) {
    log("ROOT: Save view build called");

    return BaseView<SaveViewModel>(
      onModelReady: (model) => model.init(),
      builder: (ctx, model, child) {
        log("ROOT: Save view baseview build called");
        return Scaffold(
            backgroundColor: Colors.transparent,
            appBar: AppBar(
              title: Text(
                'Save',
                style: TextStyles.rajdhaniSB.title1,
              ),
              elevation: 0,
              backgroundColor: UiConstants.kSecondaryBackgroundColor,
              actions: [
                FelloCoinBar(svgAsset: Assets.aFelloToken),
                SizedBox(width: SizeConfig.padding10),
                GestureDetector(
                  onTap: () {
                    model.openProfile();
                  },
                  child: ProfileImageSE(radius: SizeConfig.avatarRadius),
                ),
                SizedBox(width: SizeConfig.padding20)
              ],
            ),
            body: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              physics: ClampingScrollPhysics(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SaveNetWorthSection(
                    saveViewModel: model,
                  ),
                  SizedBox(
                    height: SizeConfig.padding24,
                  ),
                  // -- Break --
                  AutosaveCard(),
                  SizedBox(
                    height: SizeConfig.padding32,
                  ),
                  // -- Break --
                  TitleSubtitleContainer(
                    title: 'Challenges',
                    subTitle: 'Exciting contests to save more',
                  ),
                  CampaignCardSection(saveViewModel: model),
                  // -- Break --
                  SizedBox(height: SizeConfig.padding54),
                  GestureDetector(
                    onTap: () {
                      model.navigateToViewAllBlogs();
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        TitleSubtitleContainer(
                          title: 'Fin-gyan',
                          subTitle: 'Learn more about financial world',
                        ),
                        Padding(
                          padding: EdgeInsets.only(
                            right: SizeConfig.padding12,
                            bottom: SizeConfig.padding12,
                          ),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Padding(
                                padding:
                                    EdgeInsets.only(top: SizeConfig.padding2),
                                child: Text(
                                  'See All',
                                  style: TextStyles.rajdhaniSB.body2,
                                ),
                              ),
                              SvgPicture.asset(
                                Assets.chevRonRightArrow,
                                height: SizeConfig.padding24,
                                width: SizeConfig.padding24,
                              )
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                  SizedBox(
                    height: SizeConfig.padding8,
                  ),
                  SaveBlogSection(),
                  //Extended the EOS to avoid overshadowing by navbar
                  SizedBox(
                    height: SizeConfig.screenWidth * 0.6,
                  ),
                ],
              ),
            ));
      },
    );
  }
}

class SaveNetWorthSection extends StatelessWidget {
  final SaveViewModel saveViewModel;

  const SaveNetWorthSection({Key key, this.saveViewModel}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PropertyChangeConsumer<UserService, UserServiceProperties>(
      properties: [UserServiceProperties.myUserFund],
      builder: (context, model, property) => Container(
        height: SizeConfig.screenWidth * 1.4,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(SizeConfig.roundness16),
            bottomRight: Radius.circular(SizeConfig.roundness16),
          ),
          color: UiConstants.kSecondaryBackgroundColor,
        ),
        child: Column(
          children: [
            SizedBox(
              height: SizeConfig.padding10,
            ),
            SaveCustomCard(
              title: 'Digital Gold',
              cardBgColor: UiConstants.kSaveDigitalGoldCardBg,
              cardAssetName: Assets.digitalGoldBar,
              isGoldAssets: true,
              onCardTap: () => saveViewModel.navigateToSaveAssetView(),
              onTap: () {
                return BaseUtil.openModalBottomSheet(
                  addToScreenStack: true,
                  enableDrag: false,
                  hapticVibrate: true,
                  isBarrierDismissable: false,
                  backgroundColor: Colors.transparent,
                  isScrollControlled: true,
                  content: RechargeModalSheet(),
                );
              },
            ),
            SaveCustomCard(
              title: 'Fello Flo',
              cardBgColor: UiConstants.kSaveStableFelloCardBg,
              cardAssetName: Assets.stableFello,
              investedAmount: 0.0,
              onTap: () {
                return BaseUtil.openModalBottomSheet(
                  addToScreenStack: true,
                  enableDrag: false,
                  hapticVibrate: true,
                  isBarrierDismissable: false,
                  backgroundColor: Colors.transparent,
                  isScrollControlled: true,
                  content: RechargeModalSheet(),
                );
              },
            ),
            SizedBox(
              height: SizeConfig.padding38,
            ),
            SaveAssetsFooter(),
          ],
        ),
      ),
    );
  }
}

class CampaignCardSection extends StatelessWidget {
  final SaveViewModel saveViewModel;

  const CampaignCardSection({Key key, @required this.saveViewModel})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
          left: SizeConfig.padding24, top: SizeConfig.padding16),
      child: Container(
        height: SizeConfig.screenWidth * 0.51,
        child: ListView.builder(
          itemCount: saveViewModel.isChallengesLoading
              ? 2
              : saveViewModel.ongoingEvents.length,
          physics: BouncingScrollPhysics(),
          scrollDirection: Axis.horizontal,
          itemBuilder: (context, index) {
            return saveViewModel.isChallengesLoading
                ? Shimmer.fromColors(
                    child: Padding(
                      padding: EdgeInsets.only(right: SizeConfig.padding10),
                      child: Container(
                        width: SizeConfig.screenWidth * 0.5,
                        decoration: BoxDecoration(
                            borderRadius:
                                BorderRadius.circular(SizeConfig.roundness12),
                            color: UiConstants.kBackgroundColor),
                        child: Padding(
                          padding: EdgeInsets.all(SizeConfig.padding16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding:
                                    EdgeInsets.only(top: SizeConfig.padding28),
                                child: Center(
                                  child: Container(
                                    height: SizeConfig.screenWidth * 0.2,
                                    width: SizeConfig.screenWidth,
                                    decoration: BoxDecoration(
                                        color: UiConstants
                                            .kSecondaryBackgroundColor),
                                  ),
                                ),
                              ),
                              Spacer(),
                            ],
                          ),
                        ),
                      ),
                    ),
                    baseColor: UiConstants.kUserRankBackgroundColor,
                    highlightColor: UiConstants.kBackgroundColor,
                  )
                : CampiagnCard(
                    event: saveViewModel.ongoingEvents[index],
                  );
          },
        ),
      ),
    );
  }
}

class CampiagnCard extends StatelessWidget {
  final EventModel event;
  CampiagnCard({this.event});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        AppState.delegate.openTopSaverScreen(event.type);
      },
      child: Padding(
        padding: EdgeInsets.only(right: SizeConfig.padding10),
        child: Container(
          width: SizeConfig.screenWidth * 0.5,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(SizeConfig.roundness12),
              color: event.bgColor.toColor()),
          child: Padding(
            padding: EdgeInsets.all(SizeConfig.padding16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.only(top: SizeConfig.padding28),
                  child: Center(
                    child: SizedBox(
                      height: SizeConfig.screenWidth * 0.2,
                      width: SizeConfig.screenWidth,
                      child: Image.network(event.image),
                    ),
                  ),
                ),
                Spacer(),
                Text(
                  event.title,
                  style: TextStyles.rajdhaniSB.body0,
                ),
                FittedBox(
                  fit: BoxFit.contain,
                  child: Container(
                    width: SizeConfig.screenWidth * 0.5,
                    child: Text(
                      event.subtitle,
                      style: TextStyles.sourceSans.body4,
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class GoldBalanceContainer extends StatelessWidget {
  final AugmontGoldBuyViewModel model;
  final bool showNavIcon;
  final bool hapticReq;
  GoldBalanceContainer(
      {this.model, this.showNavIcon = false, this.hapticReq = true});

  @override
  Widget build(BuildContext context) {
    return WinningsContainer(
      onTap: model != null ? model.navigateToGoldBalanceDetailsScreen : () {},
      hapticRequired: hapticReq,
      borderRadius: SizeConfig.roundness16,
      shadow: true,
      color: UiConstants.tertiarySolid,
      height: SizeConfig.screenWidth * 0.16,
      child: Container(
        width: SizeConfig.screenWidth,
        alignment: Alignment.center,
        padding: EdgeInsets.only(
          top: SizeConfig.padding8,
          bottom: SizeConfig.padding8,
          left: SizeConfig.padding24,
          right: showNavIcon ? SizeConfig.padding12 : SizeConfig.padding24,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            FittedBox(
              fit: BoxFit.scaleDown,
              child: Text(
                "My Gold Balance:",
                style: TextStyles.title5.colour(Colors.white.withOpacity(0.8)),
              ),
            ),
            Row(
              children: [
                UserGoldQuantitySE(
                  style: TextStyles.title2
                      .colour(Colors.white)
                      .weight(FontWeight.w900),
                ),
                if (showNavIcon)
                  Icon(
                    Icons.navigate_next_rounded,
                    color: Colors.white.withOpacity(0.5),
                    size: SizeConfig.padding40,
                  )
              ],
            )
          ],
        ),
      ),
    );
  }
}

class SaveBlogSection extends StatelessWidget {
  const SaveBlogSection({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
          left: SizeConfig.padding24, top: SizeConfig.padding10),
      child: BaseView<SaveViewModel>(
        onModelReady: (model) => model.getSaveViewBlogs(),
        builder: (ctx, model, child) => Container(
          height: SizeConfig.screenWidth * 0.4,
          child: model.isLoading
              ? ListView.builder(
                  itemCount: 2,
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (ctx, index) {
                    return Padding(
                      padding: EdgeInsets.only(right: SizeConfig.padding10),
                      child: Container(
                        width: SizeConfig.screenWidth - 80,
                        decoration: BoxDecoration(
                            borderRadius:
                                BorderRadius.circular(SizeConfig.roundness12),
                            color: UiConstants.kSecondaryBackgroundColor),
                        child: Padding(
                          padding: EdgeInsets.all(SizeConfig.padding6),
                          child: Row(
                            children: [
                              Shimmer.fromColors(
                                baseColor: UiConstants.kUserRankBackgroundColor,
                                highlightColor: UiConstants.kBackgroundColor,
                                child: Container(
                                  height: SizeConfig.screenWidth * 0.23,
                                  width: SizeConfig.screenWidth * 0.25,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(
                                          SizeConfig.roundness12),
                                      color: UiConstants.kBackgroundColor),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                )
              : ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: model.blogPosts.length,
                  itemBuilder: (ctx, index) {
                    return Padding(
                      padding: EdgeInsets.only(right: SizeConfig.padding10),
                      child: SaveBlogTile(
                        onTap: () {
                          model.navigateToBlogWebView(
                              model.blogPosts[index].slug);
                        },
                        blogSideFlagColor: model.getRandomColor(),
                        title: model.blogPosts[index].acf.categories,
                        description: model.blogPosts[index].title.rendered,
                        imageUrl: model.blogPosts[index].yoastHeadJson,
                      ),
                    );
                  },
                ),
        ),
      ),
    );
  }
}

class BlogWebView extends StatelessWidget {
  final String initialUrl;

  const BlogWebView({Key key, this.initialUrl}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: FelloAppBarBackButton(),
      ),
      body: WebView(
        initialUrl: initialUrl,
        javascriptMode: JavascriptMode.unrestricted,
      ),
    );
  }
}

class SaveBlogTile extends StatelessWidget {
  final Function() onTap;
  final String title;
  final String description;
  final String imageUrl;
  final Color blogSideFlagColor;

  const SaveBlogTile(
      {Key key,
      this.onTap,
      this.title,
      this.description,
      this.imageUrl,
      this.blogSideFlagColor = Colors.red})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    // final document = parse(description);
    // final String parsedDesc = parse(document.body.text).documentElement.text;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: SizeConfig.screenWidth - 50,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(SizeConfig.roundness12),
          child: CachedNetworkImage(
            imageUrl: imageUrl,
            height: SizeConfig.screenWidth * 0.4,
            width: SizeConfig.screenWidth,
            fit: BoxFit.cover,
            alignment: Alignment.centerLeft,
          ),
        ),
      ),
    );
  }
}

class SaveInfoTile extends StatelessWidget {
  final String svg, png;
  final String title;
  final Function onPressed;

  SaveInfoTile({this.svg, this.png, this.onPressed, this.title});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed ?? () {},
      splashColor: UiConstants.primaryColor,
      focusColor: UiConstants.primaryColor,
      highlightColor: UiConstants.primaryColor,
      hoverColor: UiConstants.primaryColor,
      child: Container(
        width: SizeConfig.screenWidth * 0.603,
        height: SizeConfig.screenWidth * 0.24,
        margin: EdgeInsets.only(
            left: SizeConfig.pageHorizontalMargins,
            right: SizeConfig.padding16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(SizeConfig.roundness32),
        ),
        alignment: Alignment.center,
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: SizeConfig.padding20,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              png != null
                  ? Image.asset(png ?? Assets.moneyIcon,
                      width: SizeConfig.padding40)
                  : SvgPicture.asset(
                      svg ?? Assets.tokens,
                      width: SizeConfig.padding40,
                    ),
              SizedBox(width: SizeConfig.padding16),
              Expanded(
                child: Text(
                  title ?? "title",
                  maxLines: 3,
                  style: TextStyles.title5.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class SaveInfoSection extends StatelessWidget {
  final String title;
  final String imageAsset;
  final double imageHeight;
  final double imageWidth;

  const SaveInfoSection(
      {Key key, this.title, this.imageAsset, this.imageHeight, this.imageWidth})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          title,
          style: TextStyles.sourceSans.body4.colour(UiConstants.kTextColor2),
        ),
        SizedBox(
          height: SizeConfig.padding20,
        ),
        SizedBox(
            height: imageHeight,
            width: imageWidth,
            child: Image.asset(imageAsset)),
      ],
    );
  }
}
