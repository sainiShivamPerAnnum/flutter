import 'package:cached_network_image/cached_network_image.dart';
import 'package:felloapp/base_util.dart';
import 'package:felloapp/core/enums/page_state_enum.dart';
import 'package:felloapp/core/enums/user_service_enum.dart';
import 'package:felloapp/core/model/journey_models/journey_background_model.dart';
import 'package:felloapp/core/service/notifier_services/user_service.dart';
import 'package:felloapp/navigator/app_state.dart';
import 'package:felloapp/navigator/router/ui_pages.dart';
import 'package:felloapp/ui/architecture/base_view.dart';
import 'package:felloapp/ui/modals_sheets/recharge_modal_sheet.dart';
import 'package:felloapp/ui/pages/hometabs/save/save_viewModel.dart';
import 'package:felloapp/ui/pages/others/events/topSavers/top_savers_new.dart';
import 'package:felloapp/ui/pages/others/finance/augmont/augmont_buy_screen/augmont_buy_view.dart';
import 'package:felloapp/ui/pages/others/finance/augmont/augmont_buy_screen/augmont_buy_vm.dart';
import 'package:felloapp/ui/pages/static/winnings_container.dart';
import 'package:felloapp/ui/service_elements/auto_save_card/subscription_card_vm.dart';
import 'package:felloapp/ui/service_elements/user_service/user_gold_quantity.dart';
import 'package:felloapp/ui/widgets/coin_bar/coin_bar_view.dart';
import 'package:felloapp/ui/widgets/custom_card/custom_cards.dart';
import 'package:felloapp/util/assets.dart';
import 'package:felloapp/util/constants.dart';
import 'package:felloapp/util/custom_logger.dart';
import 'package:felloapp/util/localization/generated/l10n.dart';
import 'package:felloapp/util/locator.dart';
import 'package:felloapp/util/styles/size_config.dart';
import 'package:felloapp/util/styles/textStyles.dart';
import 'package:felloapp/util/styles/ui_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:property_change_notifier/property_change_notifier.dart';
import 'package:shimmer/shimmer.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../../../../core/enums/page_state_enum.dart';
import '../../../../navigator/app_state.dart';
import '../../../../navigator/router/ui_pages.dart';

class Save extends StatelessWidget {
  final CustomLogger logger = locator<CustomLogger>();

  @override
  Widget build(BuildContext context) {
    return BaseView<SaveViewModel>(
      onModelReady: (model) => model.init(),
      builder: (ctx, model, child) {
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
                FelloCoinBar(
                  svgAsset: Assets.aFelloToken,
                ),
                SizedBox(
                  width: SizeConfig.padding20,
                )
              ],
            ),
            body: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              physics: BouncingScrollPhysics(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SaveNetWorthSection(),
                  SizedBox(
                    height: SizeConfig.padding24,
                  ),
                  // -- Break --
                  SaveTitleContainer(title: 'Auto SIP'),
                  SizedBox(
                    height: SizeConfig.padding10,
                  ),
                  AutoSIPCard(),
                  // -- Break --
                  SizedBox(height: SizeConfig.padding54),
                  SaveTitleContainer(title: 'Challenges'),
                  CampaignCardSection(saveViewModel: model),
                  // -- Break --
                  SizedBox(height: SizeConfig.padding54),
                  SaveTitleContainer(title: 'Latest'),
                  SaveBlogSection(),
                  // -- Break --
                  //Extended the EOS to avoid overshadowing by navbar
                  SizedBox(
                    height: SizeConfig.screenWidth * 0.8,
                  ),
                ],
              ),
            ));
      },
    );
  }
}

class SaveTitleContainer extends StatelessWidget {
  final String title;

  const SaveTitleContainer({Key key, @required this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: SizeConfig.padding24),
      child: Text(title, style: TextStyles.rajdhaniSB.title3),
    );
  }
}

class SaveNetWorthSection extends StatelessWidget {
  const SaveNetWorthSection({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PropertyChangeConsumer<UserService, UserServiceProperties>(
        properties: [UserServiceProperties.myUserFund],
        builder: (context, model, property) => Container(
              height: SizeConfig.screenWidth * 1,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(SizeConfig.roundness16),
                      bottomRight: Radius.circular(SizeConfig.roundness16)),
                  color: UiConstants.kSecondaryBackgroundColor),
              child: Column(
                children: [
                  SizedBox(
                    height: SizeConfig.padding10,
                  ),
                  SaveCustomCard(
                    title: 'Digital Gold',
                    cardBgColor: UiConstants.kSaveDigitalGoldCardBg,
                    cardAssetName: Assets.digitalGoldBar,
                    investedAmount: model.userFundWallet?.augGoldBalance,
                    onTap: () {
                      return BaseUtil.openModalBottomSheet(
                        addToScreenStack: true,
                        enableDrag: false,
                        hapticVibrate: true,
                        isBarrierDismissable: true,
                        backgroundColor: Colors.transparent,
                        isScrollControlled: true,
                        content: RechargeModalSheet(),
                      );
                    },
                  ),
                  SaveCustomCard(
                    title: 'Stable Fello',
                    cardBgColor: UiConstants.kSaveStableFelloCardBg,
                    cardAssetName: Assets.digitalGoldBar,
                    onTap: () {
                      return BaseUtil.openModalBottomSheet(
                        addToScreenStack: true,
                        enableDrag: false,
                        hapticVibrate: true,
                        isBarrierDismissable: true,
                        backgroundColor: Colors.transparent,
                        isScrollControlled: true,
                        content: RechargeModalSheet(),
                      );
                    },
                  ),
                ],
              ),
            ));
  }
}

class AutoSIPCard extends StatelessWidget {
  const AutoSIPCard({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    S locale = S();
    return BaseView<SubscriptionCardViewModel>(
      builder: (ctx, model, builder) => Padding(
        padding: EdgeInsets.symmetric(horizontal: SizeConfig.padding24),
        child: GestureDetector(
          onTap: () {
            model.navigateToAutoSave();
          },
          child: Container(
            height: SizeConfig.screenWidth * 0.42,
            width: SizeConfig.screenWidth,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: UiConstants.kSecondaryBackgroundColor),
            child: Padding(
              padding: EdgeInsets.all(SizeConfig.padding6),
              child: Row(
                children: [
                  Expanded(child: SvgPicture.asset(Assets.autoSaveDefault)),
                  SizedBox(
                    width: SizeConfig.padding10,
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      FittedBox(
                        fit: BoxFit.cover,
                        child: Container(
                          width: SizeConfig.screenWidth * 0.48,
                          child: RichText(
                              text: TextSpan(
                                  text: '${locale.getStartedWithSIP}\n',
                                  style: TextStyles.rajdhaniSB.body1,
                                  children: <TextSpan>[
                                TextSpan(
                                    text: locale.investSafelyInGoldText,
                                    style: TextStyles.sourceSans.body4
                                        .colour(UiConstants.kTextColor2))
                              ])),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(right: SizeConfig.padding20),
                        child: SvgPicture.asset(Assets.saveChevronRight),
                      )
                    ],
                  ),
                ],
              ),
            ),
          ),
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
            itemCount: saveViewModel.ongoingEvents.length,
            physics: BouncingScrollPhysics(),
            scrollDirection: Axis.horizontal,
            itemBuilder: (context, index) {
              return CampiagnCard(
                title: saveViewModel.ongoingEvents[index].title,
                subTitle: saveViewModel.ongoingEvents[index].subtitle,
                containerColor:
                    saveViewModel.ongoingEvents[index].bgColor.toColor(),
                imageUrl: saveViewModel.ongoingEvents[index].image,
              );
            }),
      ),
    );
  }
}

class CampiagnCard extends StatelessWidget {
  final Color containerColor;
  final String title;
  final String subTitle;
  final String imageUrl;

  const CampiagnCard(
      {Key key, this.containerColor, this.title, this.subTitle, this.imageUrl})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        AppState.delegate.appState.currentAction = PageAction(
          page: CampaignViewPageConfig,
          state: PageState.addWidget,
          widget: CampaignView(eventType: Constants.HS_DAILY_SAVER),
        );
      },
      child: Padding(
        padding: EdgeInsets.only(right: SizeConfig.padding10),
        child: Container(
          width: SizeConfig.screenWidth * 0.5,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(SizeConfig.roundness12),
              color: containerColor),
          child: Padding(
            padding: EdgeInsets.all(SizeConfig.padding16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.only(top: SizeConfig.padding28),
                  child: Center(
                    child: SizedBox(
                      height: SizeConfig.screenWidth * 0.17,
                      width: SizeConfig.screenWidth,
                      child: Image.network(imageUrl),
                    ),
                  ),
                ),
                Spacer(),
                Text(
                  title,
                  style: TextStyles.rajdhaniSB.body0,
                ),
                FittedBox(
                  fit: BoxFit.contain,
                  child: Container(
                    width: SizeConfig.screenWidth * 0.5,
                    child: Text(
                      subTitle,
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
          onModelReady: (model) => model.getBlogs(),
          builder: (ctx, model, child) => Container(
            height: SizeConfig.screenWidth * 0.26,
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
                                  baseColor:
                                      UiConstants.kUserRankBackgroundColor,
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
                    })
                : ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: 5,
                    itemBuilder: (ctx, index) {
                      return SaveBlogTile(
                        onTap: () {
                          model.navigateToBlogWebView(
                              model.blogPosts[index].slug);
                        },
                        title: model.blogPosts[index].title.rendered,
                        description: model.blogPosts[index].acf.categories,
                        imageUrl: model.blogPosts[index].yoastHeadJson,
                      );
                    }),
          ),
        ));
  }
}

class BlogWebView extends StatelessWidget {
  final String initialUrl;

  const BlogWebView({Key key, this.initialUrl}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: WebView(
          initialUrl: initialUrl, javascriptMode: JavascriptMode.unrestricted),
    );
  }
}

class SaveBlogTile extends StatelessWidget {
  final Function() onTap;
  final String title;
  final String description;
  final String imageUrl;
  const SaveBlogTile(
      {Key key, this.onTap, this.title, this.description, this.imageUrl})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(right: SizeConfig.padding10),
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          width: SizeConfig.screenWidth - 80,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(SizeConfig.roundness12),
              color: UiConstants.kSecondaryBackgroundColor),
          child: Padding(
            padding: EdgeInsets.all(SizeConfig.padding6),
            child: Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(SizeConfig.roundness12),
                  child: CachedNetworkImage(
                      imageUrl: imageUrl,
                      height: SizeConfig.screenWidth * 0.23,
                      width: SizeConfig.screenWidth * 0.25,
                      fit: BoxFit.cover,
                      alignment: Alignment.centerLeft),
                ),
                SizedBox(
                  width: SizeConfig.padding10,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding:
                          EdgeInsets.symmetric(vertical: SizeConfig.padding4),
                      child: Text(
                        description,
                        style: TextStyles.rajdhaniM
                            .colour(UiConstants.kBlogTitleColor),
                      ),
                    ),
                    ConstrainedBox(
                        constraints: BoxConstraints(
                          maxWidth: SizeConfig.screenWidth * 0.4,
                        ),
                        child: Text(
                          title,
                          maxLines: 2,
                          overflow: TextOverflow.clip,
                          style:
                              TextStyles.sourceSans.body3.colour(Colors.white),
                        )),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ignore: must_be_immutable
class Goldlinks extends StatelessWidget {
  AugmontGoldBuyViewModel model;

  Goldlinks({this.model});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: SizeConfig.screenWidth,
      height: SizeConfig.screenWidth * 0.24,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: [
          SaveInfoTile(
            svg: 'images/svgs/gold.svg',
            title: "About digital Gold",
            onPressed: () {
              model.navigateToAboutGold();
            },
          ),
          SaveInfoTile(
            png: Assets.augmontShare,
            title: "Learn more about Augmont",
            onPressed: () {
              model.openAugmontWebUri();
            },
          ),
        ],
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
