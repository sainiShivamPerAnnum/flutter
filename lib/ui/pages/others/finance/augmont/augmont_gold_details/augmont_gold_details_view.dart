import 'package:felloapp/ui/architecture/base_view.dart';
import 'package:felloapp/ui/elements/plots/fund_graph.dart';
import 'package:felloapp/ui/pages/others/finance/augmont/augmont_gold_details/augmont_gold_details_vm.dart';
import 'package:felloapp/ui/pages/static/fello_appbar.dart';
import 'package:felloapp/ui/pages/static/home_background.dart';
import 'package:felloapp/ui/widgets/faq_card/faq_card_view.dart';
import 'package:felloapp/ui/widgets/faq_card/faq_card_vm.dart';
import 'package:felloapp/util/assets.dart';
import 'package:felloapp/util/styles/size_config.dart';
import 'package:felloapp/util/styles/textStyles.dart';
import 'package:felloapp/util/styles/ui_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class AugmontGoldDetailsView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BaseView<AugmontGoldDetailsViewModel>(
      onModelReady: (model) {
        model.fetchGoldRates();
      },
      builder: (ctx, model, child) {
        return Scaffold(
          backgroundColor: UiConstants.primaryColor,
          body: HomeBackground(
            child: Column(
              children: [
                FelloAppBar(
                  leading: FelloAppBarBackButton(),
                  title: "About Digital Gold",
                ),
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(SizeConfig.roundness40),
                          topRight: Radius.circular(SizeConfig.roundness40)),
                    ),
                    child: ListView(
                      padding: EdgeInsets.zero,
                      children: [
                        Container(
                          margin: EdgeInsets.only(
                              top: SizeConfig.padding32,
                              right: SizeConfig.pageHorizontalMargins,
                              bottom: SizeConfig.pageHorizontalMargins),
                          width: SizeConfig.screenWidth,
                          child: LineChartWidget(),
                        ),
                        Row(
                          children: [
                            Expanded(
                              child: Center(
                                child: Container(
                                  width: SizeConfig.screenWidth * 0.422,
                                  height: SizeConfig.screenWidth * 0.202,
                                  decoration: BoxDecoration(
                                    color: UiConstants.tertiarySolid,
                                    borderRadius: BorderRadius.circular(
                                        SizeConfig.roundness24),
                                  ),
                                  alignment: Alignment.center,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        "Buy Price",
                                        style: TextStyles.body1
                                            .colour(Colors.white),
                                      ),
                                      SizedBox(height: SizeConfig.padding4),
                                      model.isGoldRateFetching
                                          ? SpinKitThreeBounce(
                                              size: SizeConfig.title5,
                                              color: Colors.white,
                                            )
                                          : Text(
                                              model.goldRates != null
                                                  ? "₹ ${model.goldRates.goldBuyPrice.toStringAsFixed(2)}"
                                                  : "-",
                                              style: TextStyles.title5
                                                  .colour(Colors.white)
                                                  .bold,
                                            ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            Expanded(
                              child: Center(
                                child: Container(
                                  width: SizeConfig.screenWidth * 0.422,
                                  height: SizeConfig.screenWidth * 0.202,
                                  decoration: BoxDecoration(
                                    color: UiConstants.primaryColor,
                                    borderRadius: BorderRadius.circular(
                                        SizeConfig.roundness24),
                                  ),
                                  alignment: Alignment.center,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        "Sell Price",
                                        style: TextStyles.body1
                                            .colour(Colors.white),
                                      ),
                                      SizedBox(height: SizeConfig.padding4),
                                      model.isGoldRateFetching
                                          ? SpinKitThreeBounce(
                                              size: SizeConfig.title5,
                                              color: Colors.white,
                                            )
                                          : Text(
                                              model.goldRates != null
                                                  ? "₹ ${model.goldRates.goldSellPrice.toStringAsFixed(2)}"
                                                  : "-",
                                              style: TextStyles.title5
                                                  .colour(Colors.white)
                                                  .bold,
                                            ),
                                    ],
                                  ),
                                ),
                              ),
                            )
                          ],
                        ),
                        SizedBox(height: SizeConfig.padding32),
                        FAQCardView(category: FAQCardViewModel.FAQ_CAT_AUGMONT)
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        );
      },
    );
  }
}
