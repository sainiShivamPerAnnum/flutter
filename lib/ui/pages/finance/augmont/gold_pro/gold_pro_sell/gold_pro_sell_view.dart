import 'package:felloapp/navigator/app_state.dart';
import 'package:felloapp/ui/architecture/base_view.dart';
import 'package:felloapp/ui/pages/finance/augmont/gold_pro/gold_pro_sell/gold_pro_sell_components/gold_pro_sell_card.dart';
import 'package:felloapp/ui/pages/finance/augmont/gold_pro/gold_pro_sell/gold_pro_sell_vm.dart';
import 'package:felloapp/util/assets.dart';
import 'package:felloapp/util/styles/styles.dart';
import 'package:flutter/material.dart';

class GoldProSellView extends StatelessWidget {
  const GoldProSellView({super.key});

  @override
  Widget build(BuildContext context) {
    return BaseView<GoldProSellViewModel>(
      onModelReady: (model) => model.init(),
      onModelDispose: (model) => model.dump(),
      builder: (context, model, child) {
        return Scaffold(
          backgroundColor: UiConstants.kModalSheetBackgroundColor,
          body: SafeArea(
            child: Column(
              children: [
                SizedBox(
                  width: SizeConfig.screenWidth,
                  height: kToolbarHeight,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      SizedBox(width: SizeConfig.padding4),
                      IconButton(
                        icon: const Icon(
                          Icons.arrow_back_ios,
                          color: Colors.white,
                        ),
                        onPressed: () =>
                            AppState.backButtonDispatcher!.didPopRoute(),
                      ),

                      Image.asset(
                        Assets.digitalGoldBar,
                        width: SizeConfig.padding54,
                        height: SizeConfig.padding54,
                      ),
                      // SizedBox(width: SizeConfig.padding8),
                      Text(
                        'Un-Lease Digital Gold Pro',
                        style: TextStyles.rajdhaniSB.title5,
                      ),
                      const Spacer()
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(SizeConfig.pageHorizontalMargins),
                  child: Text(
                    "Select Lease to Un-Lease to Digital Gold",
                    style: TextStyles.rajdhaniM.body0.colour(Colors.white),
                  ),
                ),
                Expanded(
                    child: ListView.builder(
                  physics: const BouncingScrollPhysics(),
                  itemCount: model.leasedGoldList.length,
                  itemBuilder: (context, index) => GoldProSellCard(
                    data: model.leasedGoldList[index],
                  ),
                ))
              ],
            ),
          ),
        );
      },
    );
  }
}
