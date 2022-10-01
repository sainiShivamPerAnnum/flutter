import 'dart:convert';
import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:felloapp/base_util.dart';
import 'package:felloapp/core/enums/faqTypes.dart';
import 'package:felloapp/core/enums/investment_type.dart';
import 'package:felloapp/core/enums/user_service_enum.dart';
import 'package:felloapp/core/model/event_model.dart';

import 'package:felloapp/core/service/notifier_services/user_service.dart';
import 'package:felloapp/navigator/app_state.dart';
import 'package:felloapp/ui/architecture/base_view.dart';
import 'package:felloapp/ui/pages/hometabs/save/save_viewModel.dart';
import 'package:felloapp/ui/pages/static/save_assets_footer.dart';
import 'package:felloapp/ui/service_elements/auto_save_card/subscription_card.dart';
import 'package:felloapp/ui/widgets/appbar/appbar.dart';
import 'package:felloapp/ui/widgets/buttons/nav_buttons/nav_buttons.dart';
import 'package:felloapp/ui/widgets/carousal_widget.dart';
import 'package:felloapp/ui/widgets/custom_card/custom_cards.dart';
import 'package:felloapp/ui/widgets/title_subtitle_container.dart';
import 'package:felloapp/util/assets.dart';
import 'package:felloapp/util/custom_logger.dart';
import 'package:felloapp/util/haptic.dart';
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
            appBar: FAppBar(
              type: FaqsType.savings,
              backgroundColor: UiConstants.kSecondaryBackgroundColor,
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
                    height: SizeConfig.padding10,
                  ),
                  // -- Break --
                  TitleSubtitleContainer(
                    title: 'Challenges',
                    subTitle: 'Exciting contests to save more',
                  ),
                  CampaignCardSection(saveVm: model),
                  // -- Break --
                  SizedBox(height: SizeConfig.padding24),
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

                  SaveBlogSection(),
                  //Extended the EOS to avoid overshadowing by navbar
                  SizedBox(
                      height: SizeConfig.navBarHeight + SizeConfig.padding24),
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
  final SaveViewModel saveViewModel;

  const SaveNetWorthSection({Key key, this.saveViewModel}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PropertyChangeConsumer<UserService, UserServiceProperties>(
      properties: [UserServiceProperties.myUserFund],
      builder: (context, model, property) => Container(
        // height: SizeConfig.screenWidth * 1.4,
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
              subtitle: "You own",
              cardBgColor: UiConstants.kSaveDigitalGoldCardBg,
              cardAssetName: Assets.digitalGoldBar,
              investmentType: InvestmentType.AUGGOLD99,
              onCardTap: () => saveViewModel.navigateToSaveAssetView(
                InvestmentType.AUGGOLD99,
              ),
              onTap: () {
                Haptic.vibrate();
                return BaseUtil().openRechargeModalSheet(
                  investmentType: InvestmentType.AUGGOLD99,
                );
              },
            ),
            SaveCustomCard(
              title: 'Fello Flo',
              subtitle: "Current Value",
              cardBgColor: UiConstants.kSaveStableFelloCardBg,
              cardAssetName: Assets.felloFlo,
              investmentType: InvestmentType.LENDBOXP2P,
              onCardTap: () => saveViewModel.navigateToSaveAssetView(
                InvestmentType.LENDBOXP2P,
              ),
              onTap: () {
                Haptic.vibrate();
                return BaseUtil().openRechargeModalSheet(
                  investmentType: InvestmentType.LENDBOXP2P,
                );
              },
            ),
            SaveAssetsFooter(),
          ],
        ),
      ),
    );
  }
}

class CampaignCardSection extends StatelessWidget {
  final SaveViewModel saveVm;

  const CampaignCardSection({Key key, @required this.saveVm}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        left: SizeConfig.padding24,
        top: SizeConfig.padding16,
        right: SizeConfig.padding16,
      ),
      child: Container(
        height: SizeConfig.screenWidth * 0.57,
        child: CarousalWidget(
          height: SizeConfig.screenWidth * 0.49,
          width: SizeConfig.screenWidth,
          widgets: List.generate(
            saveVm.isChallengesLoading ? 3 : saveVm.ongoingEvents.length,
            (index) {
              final event = saveVm.isChallengesLoading
                  ? null
                  : saveVm.ongoingEvents[index];

              return GestureDetector(
                onTap: () {
                  AppState.delegate.openTopSaverScreen(event.type);
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
                        width: SizeConfig.screenWidth * 0.4,
                        padding: EdgeInsets.only(
                          top: SizeConfig.padding8,
                        ),
                        child: Text(
                          event?.subtitle ?? '',
                          style: TextStyles.sourceSans.body4,
                        ),
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
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
      {@required this.event,
      @required this.subText,
      @required this.isLoading,
      @required this.topPadding,
      @required this.leftPadding});

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
                  height: SizeConfig.screenWidth * 0.18,
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
                    fit: BoxFit.contain,
                  ),
                ),
              ],
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
              : model.blogPosts == null || model.blogPosts.isEmpty
                  ? SizedBox()
                  : ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: model.blogPosts.length,
                      itemBuilder: (ctx, index) {
                        return Padding(
                          padding: EdgeInsets.only(right: SizeConfig.padding10),
                          child: SaveBlogTile(
                            onTap: () {
                              model.navigateToBlogWebView(
                                  model.blogPosts[index].slug,
                                  model.blogPosts[index].acf.categories);
                            },
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
  final String title;
  const BlogWebView({Key key, this.initialUrl, this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: UiConstants.kBackgroundColor3,
        leading: FelloAppBarBackButton(),
        centerTitle: true,
        title: Text(title ?? 'Title', style: TextStyles.rajdhaniSB.title5),
      ),
      backgroundColor: UiConstants.kBackgroundColor,
      body: WebView(
        initialUrl: initialUrl,
        backgroundColor: UiConstants.kBackgroundColor,
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

  const SaveBlogTile({
    Key key,
    this.onTap,
    this.title,
    this.description,
    this.imageUrl,
  }) : super(key: key);

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
                      svg ?? Assets.token,
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
