import 'package:felloapp/base_util.dart';
import 'package:felloapp/navigator/app_state.dart';
import 'package:felloapp/ui/architecture/base_view.dart';
import 'package:felloapp/ui/pages/buy_flow/buy_vm.dart';
import 'package:felloapp/ui/pages/static/gold_rate_card.dart';
import 'package:felloapp/util/constants.dart';
import 'package:felloapp/util/styles/size_config.dart';
import 'package:felloapp/util/styles/textStyles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_svg/flutter_svg.dart';

class AssetSelectionPage extends StatelessWidget {
  const AssetSelectionPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BaseView<BuyViewModel>(onModelReady: (model) {
      model.fetchGoldRates();
    }, builder: (ctx, model, child) {
      return Scaffold(
        backgroundColor: const Color(0xff232326),
        body: Padding(
          padding: EdgeInsets.symmetric(
              horizontal: SizeConfig.pageHorizontalMargins),
          child: Column(
            children: [
              SizedBox(height: SizeConfig.fToolBarHeight / 2),
              AppBar(
                elevation: 0,
                backgroundColor: Colors.transparent,
                leading: IconButton(
                  icon: const Icon(
                    Icons.arrow_back_ios,
                    color: Colors.white,
                  ),
                  onPressed: () {
                    AppState.backButtonDispatcher?.didPopRoute();
                  },
                ),
                title: Text(
                  'Select plan to save',
                  style: TextStyles.rajdhaniSB.title5,
                ),
              ),
              SizedBox(height: SizeConfig.padding24),
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: SizeConfig.padding16,
                  vertical: SizeConfig.padding16,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xff495DB2),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SvgPicture.asset(
                          'assets/svg/digitalgold.svg',
                          height: SizeConfig.padding44,
                          width: SizeConfig.padding44,
                          fit: BoxFit.cover,
                        ),
                        SizedBox(width: SizeConfig.padding12),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              'Save in Digital Gold',
                              style: TextStyles.rajdhaniSB.body0,
                            ),
                            SizedBox(height: SizeConfig.padding4),
                            Text(
                              '24K Gold • Withdraw anytime • 100% Secure',
                              style: TextStyles.sourceSans.body4
                                  .colour(Colors.white.withOpacity(0.8)),
                            ),
                          ],
                        ),
                        SvgPicture.asset(
                          'assets/svg/Arrow_dotted.svg',
                          height: SizeConfig.padding24,
                          width: SizeConfig.padding24,
                        ),
                      ],
                    ),
                    SizedBox(height: SizeConfig.padding34),
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: SizeConfig.padding16,
                        vertical: SizeConfig.padding16,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xffD9D9D9).withOpacity(0.1),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Market Rate',
                            style: TextStyles.sourceSans.body3,
                          ),
                          const Spacer(),
                          model.isGoldRateFetching
                              ? SpinKitThreeBounce(
                            size: SizeConfig.body2,
                            color: Colors.white,
                          )
                              : Text(
                            "₹ ${(model.goldRates != null ? model.goldRates!.goldBuyPrice : 0.0)?.toStringAsFixed(2)}/gm",
                            style: TextStyles.sourceSansSB.body1
                                .colour(Colors.white),
                          ),
                          NewCurrentGoldPriceWidget(
                            fetchGoldRates: model.fetchGoldRates,
                            goldprice: model.goldRates != null
                                ? model.goldRates!.goldBuyPrice
                                : 0.0,
                            isFetching: model.isGoldRateFetching,
                            mini: true,
                            textColor: Colors.white,
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
              SizedBox(height: SizeConfig.padding24),
              GestureDetector(
                onTap: () {
                  BaseUtil().openFloBuySheet(
                      floAssetType: Constants.ASSET_TYPE_FLO_FIXED_3);
                },
                child: Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: SizeConfig.padding16,
                    vertical: SizeConfig.padding16,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xff01656B),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SvgPicture.asset(
                            'assets/svg/fello_flo.svg',
                            height: SizeConfig.padding44,
                            width: SizeConfig.padding44,
                            fit: BoxFit.cover,
                          ),
                          SizedBox(width: SizeConfig.padding12),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                'Save in Fello Flo',
                                style: TextStyles.rajdhaniSB.body0,
                              ),
                              SizedBox(height: SizeConfig.padding4),
                              Text(
                                'P2P Asset • RBI Certified',
                                style: TextStyles.sourceSans.body4
                                    .colour(Colors.white.withOpacity(0.8)),
                              ),
                            ],
                          ),
                          const Spacer(),
                          SvgPicture.asset(
                            'assets/svg/Arrow_dotted.svg',
                            height: SizeConfig.padding24,
                            width: SizeConfig.padding24,
                          ),
                        ],
                      ),
                      SizedBox(height: SizeConfig.padding16),
                      Row(
                        children: [
                          const FelloFloPrograms(
                              title: '1 week lock-in',
                              percentage: '8%',
                              isRecommended: false),
                          SizedBox(width: SizeConfig.padding12),
                          const FelloFloPrograms(
                              title: '3 month lock-in',
                              percentage: '10%',
                              isRecommended: false),
                          SizedBox(width: SizeConfig.padding12),
                          const FelloFloPrograms(
                              title: '6 month lock-in',
                              percentage: '12%',
                              isRecommended: true),
                        ],
                      )
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      );
    });
  }
}

class FelloFloPrograms extends StatelessWidget {
  const FelloFloPrograms({Key? key,
    required this.title,
    required this.percentage,
    required this.isRecommended})
      : super(key: key);

  final String title;
  final String percentage;
  final bool isRecommended;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: SizeConfig.padding90 + SizeConfig.padding16,
      width: SizeConfig.padding90,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          if (isRecommended)
            Container(
              padding: EdgeInsets.symmetric(
                horizontal: SizeConfig.padding8,
                vertical: SizeConfig.padding2,
              ),
              decoration: const BoxDecoration(
                color: Color(0xff62E3C4),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(5),
                  topRight: Radius.circular(5),
                ),
              ),
              child: Text(
                'Recommended',
                style: TextStyles.sourceSans.body5.colour(Colors.black),
              ),
            ),
          if (!isRecommended) const Spacer(),
          GestureDetector(
            onTap: () {},
            child: Container(
              width: SizeConfig.padding90,
              padding: EdgeInsets.symmetric(
                vertical: SizeConfig.padding4,
                horizontal: SizeConfig.padding6,
              ),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(SizeConfig.roundness5),
                color: const Color(0xffD9D9D9).withOpacity(0.2),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    title,
                    style: TextStyles.sourceSans.body4.colour(Colors.white),
                  ),
                  SizedBox(height: SizeConfig.padding8),
                  Text(
                    percentage,
                    style: TextStyles.rajdhaniSB.title2
                        .colour(Colors.white.withOpacity(0.8)),
                  ),
                  Text(
                    'Returns',
                    style: TextStyles.sourceSansSB.body3
                        .colour(Colors.white.withOpacity(0.8)),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
