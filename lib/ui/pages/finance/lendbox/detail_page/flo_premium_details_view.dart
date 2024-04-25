// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:felloapp/base_util.dart';
import 'package:felloapp/core/constants/analytics_events_constants.dart';
import 'package:felloapp/core/enums/faqTypes.dart';
import 'package:felloapp/core/enums/investment_type.dart';
import 'package:felloapp/core/model/app_config_serialized_model.dart';
import 'package:felloapp/core/model/portfolio_model.dart';
import 'package:felloapp/core/service/analytics/analytics_service.dart';
import 'package:felloapp/core/service/lendbox_maturity_service.dart';
import 'package:felloapp/core/service/notifier_services/user_service.dart';
import 'package:felloapp/ui/architecture/base_view.dart';
import 'package:felloapp/ui/pages/finance/lendbox/detail_page/flo_premium_details_vm.dart';
import 'package:felloapp/ui/pages/hometabs/save/save_components/asset_view_section.dart';
import 'package:felloapp/ui/pages/login/login_components/login_support.dart';
import 'package:felloapp/ui/pages/static/save_assets_footer.dart';
import 'package:felloapp/util/assets.dart';
import 'package:felloapp/util/constants.dart';
import 'package:felloapp/util/extensions/rich_text_extension.dart';
import 'package:felloapp/util/haptic.dart';
import 'package:felloapp/util/localization/generated/l10n.dart';
import 'package:felloapp/util/locator.dart';
import 'package:felloapp/util/styles/size_config.dart';
import 'package:felloapp/util/styles/textStyles.dart';
import 'package:felloapp/util/styles/ui_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

import 'widgets/widget.dart';

class FloPremiumDetailsView extends StatelessWidget {
  final String fundType;

  const FloPremiumDetailsView({
    required this.fundType,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final locale = locator<S>();
    return BaseView<FloPremiumDetailsViewModel>(
      onModelReady: (model) => model.init(fundType),
      builder: (context, model, _) {
        final value = context.watch<LendboxMaturityService>().callTxnApi;
        WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
          if (value) {
            model.getTransactions();
            context.read<LendboxMaturityService>().callTxnApi = false;
          }
        });

        return RefreshIndicator(
          color: UiConstants.primaryColor,
          backgroundColor: Colors.black,
          onRefresh: () async => await model.getTransactions(),
          child: Scaffold(
            body: ColoredBox(
              color: UiConstants.kBackgroundColor,
              child: Stack(
                children: [
                  Container(
                    height: SizeConfig.screenHeight! * 0.5,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          UiConstants.kFloContainerColor,
                          const Color(0xff297264).withOpacity(0),
                        ],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                      ),
                    ),
                  ),
                  SafeArea(
                    child: Column(
                      children: [
                        const SizedBox(height: kToolbarHeight * 0.8),
                        Expanded(
                          child: SingleChildScrollView(
                            child: Column(
                              children: [
                                _Header(
                                  model: model.config,
                                ),
                                SizedBox(
                                  height: SizeConfig.padding32,
                                ),
                                if (model.isInvested)
                                  Padding(
                                    padding: EdgeInsets.only(
                                      bottom: SizeConfig.pageHorizontalMargins,
                                    ),
                                    child: FlexiTransactionsSection(
                                      fundType: fundType,
                                      model: model,
                                    ),
                                  ),
                                CircularSlider(
                                  type: InvestmentType.LENDBOXP2P,
                                  isNewUser: false,
                                  interest: model.config.interest,
                                ),
                                SizedBox(
                                  height: SizeConfig.padding40,
                                ),
                                Text(
                                  "From our 12% Flo Savers",
                                  style: TextStyles.rajdhaniSB.title4
                                      .colour(Colors.white),
                                  textAlign: TextAlign.center,
                                ),
                                SizedBox(
                                  height: SizeConfig.padding24,
                                ),
                                const Testimonials(),
                                SizedBox(
                                  height: SizeConfig.padding20,
                                ),
                                const SaveAssetsFooter(
                                  isFlo: true,
                                ),
                                SizedBox(
                                  height: SizeConfig.pageHorizontalMargins,
                                ),
                                Faqs(
                                  faqs: model.faqs,
                                ),
                                CustomerSupportWidget(
                                  config: model.config,
                                ),
                                SizedBox(
                                  height: SizeConfig.navBarHeight * 2,
                                )
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: Container(
                      color: UiConstants.kBackgroundColor.withOpacity(0.96),
                      width: SizeConfig.screenWidth,
                      height: SizeConfig.screenWidth! * 0.26 +
                          MediaQuery.of(context).viewPadding.bottom / 2,
                      child: Stack(
                        children: [
                          if (model.config.fundType == 'UNI_FIXED_6')
                            SvgPicture.asset(
                              Assets.btnBg,
                              fit: BoxFit.cover,
                              width: SizeConfig.screenWidth! * 1.5,
                            ),
                          Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              SizedBox(height: SizeConfig.padding6),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  SvgPicture.asset(
                                    Assets.floAsset,
                                    height: SizeConfig.screenHeight! * 0.03,
                                    width: SizeConfig.screenHeight! * 0.03,
                                  ),
                                  SizedBox(
                                    height: SizeConfig.padding1,
                                  ),
                                  Padding(
                                    padding: EdgeInsets.symmetric(
                                      horizontal: SizeConfig.padding4,
                                    ),
                                    child: locale
                                        .floTicketEarningOnAsset(
                                          model.config.tambolaMultiplier,
                                          model.config.interest,
                                        )
                                        .beautify(
                                          boldStyle: TextStyles
                                              .sourceSansB.body4
                                              .colour(
                                            Colors.white,
                                          ),
                                          style: TextStyles.sourceSans.body4
                                              .colour(
                                            Colors.white,
                                          ),
                                        ),
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: SizeConfig.padding4,
                              ),
                              Container(
                                padding: EdgeInsets.symmetric(
                                  horizontal: SizeConfig.pageHorizontalMargins,
                                ),
                                width: SizeConfig.screenWidth!,
                                child: Row(
                                  children: [
                                    if (model.config.fundType !=
                                        'UNI_FIXED_6') ...[
                                      Expanded(
                                        child: SizedBox(
                                          height: SizeConfig.padding44,
                                          child: OutlinedButton(
                                            style: ButtonStyle(
                                              side: MaterialStateProperty.all(
                                                const BorderSide(
                                                  color: Colors.white,
                                                  width: 1.0,
                                                  style: BorderStyle.solid,
                                                ),
                                              ),
                                            ),
                                            child: Text(
                                              "UPGRADE TO 12%",
                                              style: TextStyles.rajdhaniSB.body2
                                                  .colour(Colors.white),
                                            ),
                                            onPressed: () {
                                              Haptic.vibrate();
                                              model.cleanTransactionsList();
                                              model.updateConfig(
                                                'UNI_FIXED_6',
                                              );
                                              model.getTransactions();
                                            },
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        width: SizeConfig.padding12,
                                      ),
                                    ],
                                    Expanded(
                                      child: MaterialButton(
                                        color: Colors.white,
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(
                                            SizeConfig.roundness5,
                                          ),
                                        ),
                                        height: SizeConfig.padding44,
                                        child: Text(
                                          "SAVE",
                                          style: TextStyles.rajdhaniB.body1
                                              .colour(Colors.black),
                                        ),
                                        onPressed: () {
                                          BaseUtil.openFloBuySheet(
                                            floAssetType: model.config.fundType,
                                          );
                                          _onTapSave(
                                            model.config,
                                            locator<UserService>()
                                                .userPortfolio,
                                          );
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(height: SizeConfig.padding12),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  SafeArea(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        BackButton(
                          color: Colors.white,
                          onPressed: () => Navigator.of(context).pop(),
                        ),
                        Padding(
                          padding: EdgeInsets.only(right: SizeConfig.padding8),
                          child: const FaqPill(
                            type: FaqsType.savings,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  void _onTapSave(LendboxAssetConfiguration config, Portfolio portfolio) {
    locator<AnalyticsService>().track(
      eventName: AnalyticsEvents.investNowInFloSlabTapped,
      properties: {
        "asset name": "${config.interest}% Flo",
        "new user":
            locator<UserService>().userSegments.contains(Constants.NEW_USER),
        "total invested amount": switch (config.fundType) {
          'UNI_FIXED_6' => portfolio.flo.fixed1.principle,
          'UNI_FIXED_3' => portfolio.flo.fixed2.principle,
          'UNI_FIXED_1' => portfolio.flo.fixed2.principle,
          'UNI_FLEXI' => portfolio.flo.flexi.principle,
          _ => 0, //todo @Hirdesh2101
        },
        "total current amount": switch (config.fundType) {
          'UNI_FIXED_6' => portfolio.flo.fixed1.balance,
          'UNI_FIXED_3' => portfolio.flo.fixed2.balance,
          'UNI_FIXED_1' => portfolio.flo.fixed2.balance,
          'UNI_FLEXI' => portfolio.flo.flexi.balance,
          _ => 0, //todo @Hirdesh2101
        },
      },
    );
  }
}

class _Header extends StatelessWidget {
  final LendboxAssetConfiguration model;

  const _Header({
    required this.model,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: SizeConfig.pageHorizontalMargins,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Container(
                          margin: EdgeInsets.only(top: SizeConfig.padding12),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                offset: const Offset(-10, 40),
                                color: UiConstants.primaryColor.withOpacity(
                                  0.95,
                                ),
                                blurRadius: 50,
                              )
                            ],
                          ),
                          child: Text(
                            "${model.interest}% Flo",
                            style: TextStyles.rajdhaniB.title0.colour(
                              model.fundType == 'UNI_FIXED_6'
                                  ? UiConstants.primaryColor
                                  : Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                    Text(
                      "${model.interest}% Returns p.a.",
                      style: TextStyles.rajdhaniSB.title4,
                    ),
                  ],
                ),
              ),
              SvgPicture.asset(
                Assets.floAsset,
                height: SizeConfig.screenHeight! * 0.1,
              ),
            ],
          ),
          SizedBox(
            height: SizeConfig.padding16,
          ),
          Text(
            model.highlights,
            style: TextStyles.sourceSans.body2.colour(UiConstants.primaryColor),
          ),
          SizedBox(
            height: SizeConfig.padding4,
          ),
          Text(
            model.description,
            style: TextStyles.sourceSans.body2.colour(Colors.white54),
          ),
        ],
      ),
    );
  }
}

class StarCustomPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    Path path_0 = Path();
    path_0.moveTo(size.width * 0.5184209, size.height);
    path_0.lineTo(size.width * 0.4815791, size.height);
    path_0.cubicTo(
      size.width * 0.4815791,
      size.height * 0.7342100,
      size.width * 0.2657891,
      size.height * 0.5184208,
      0,
      size.height * 0.5184208,
    );
    path_0.lineTo(0, size.height * 0.4815792);
    path_0.cubicTo(
      size.width * 0.2657891,
      size.height * 0.4815792,
      size.width * 0.4815791,
      size.height * 0.2657892,
      size.width * 0.4815791,
      0,
    );
    path_0.lineTo(size.width * 0.5184209, 0);
    path_0.cubicTo(
      size.width * 0.5184209,
      size.height * 0.2657892,
      size.width * 0.7342109,
      size.height * 0.4815792,
      size.width,
      size.height * 0.4815792,
    );
    path_0.lineTo(size.width, size.height * 0.5184208);
    path_0.cubicTo(
      size.width * 0.7342109,
      size.height * 0.5184208,
      size.width * 0.5184209,
      size.height * 0.7342100,
      size.width * 0.5184209,
      size.height,
    );
    path_0.close();

    Paint paint0Fill = Paint()..style = PaintingStyle.fill;
    paint0Fill.color = Colors.white.withOpacity(1.0);
    canvas.drawPath(path_0, paint0Fill);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
