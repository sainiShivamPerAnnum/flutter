import 'package:felloapp/base_util.dart';
import 'package:felloapp/core/enums/screen_item_enum.dart';
import 'package:felloapp/core/model/aug_gold_rates_model.dart';
import 'package:felloapp/core/service/payments/augmont_transaction_service.dart';
import 'package:felloapp/navigator/app_state.dart';
import 'package:felloapp/ui/pages/others/finance/augmont/augmont_buy_screen/augmont_buy_vm.dart';
import 'package:felloapp/util/assets.dart';
import 'package:felloapp/util/styles/size_config.dart';
import 'package:felloapp/util/styles/textStyles.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class UPIAppsBottomSheet extends StatelessWidget {
  final AugmontTransactionService txnServiceInstance;

  const UPIAppsBottomSheet({Key key, this.txnServiceInstance})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: SizeConfig.screenWidth * 0.5,
      width: SizeConfig.screenWidth,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(SizeConfig.roundness12),
            topRight: Radius.circular(SizeConfig.roundness12)),
      ),
      child: Padding(
          padding: EdgeInsets.all(SizeConfig.padding20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.only(
                    left: SizeConfig.pageHorizontalMargins,
                    right: SizeConfig.pageHorizontalMargins / 2),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      txnServiceInstance.appMetaList.length > 0
                          ? 'Please select a UPI App'
                          : "No UPI apps available",
                      style: TextStyles.title5.bold,
                    ),
                    GestureDetector(
                        onTap: () {
                          AppState.backButtonDispatcher.didPopRoute();
                        },
                        child: Icon(Icons.close))
                  ],
                ),
              ),
              SizedBox(height: 20),
              txnServiceInstance.appMetaList.length <= 0
                  ? Container(
                      width: SizeConfig.screenWidth,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          SvgPicture.asset(Assets.noTickets,
                              height: SizeConfig.screenWidth * 0.16),
                          SizedBox(height: SizeConfig.padding12),
                          Text('Could not find any installed UPI applications.',
                              style: TextStyles.body1.colour(Colors.grey)),
                        ],
                      ),
                    )
                  : Expanded(
                      child: GridView.builder(
                        scrollDirection: Axis.vertical,
                        itemCount: txnServiceInstance.appMetaList.length,
                        itemBuilder: (context, index) {
                          return GestureDetector(
                            onTap: () {
                              txnServiceInstance.upiApplication =
                                  txnServiceInstance
                                      .appMetaList[index].upiApplication;
                              txnServiceInstance.selectedUpiApplicationName =
                                  txnServiceInstance.appMetaList[index]
                                      .upiApplication.appName;
                              AppState.backButtonDispatcher.didPopRoute();
                              txnServiceInstance.processUpiTransaction();
                            },
                            child: Padding(
                              padding: const EdgeInsets.all(10),
                              child: Container(
                                child: Center(
                                  child: Column(
                                    children: [
                                      ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(5),
                                          child: txnServiceInstance
                                              .appMetaList[index]
                                              .iconImage(40)),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      Text(
                                        txnServiceInstance.appMetaList[index]
                                            .upiApplication.appName,
                                        style: TextStyles.body4,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 3),
                      ),
                    ),
            ],
          )),
    );
  }
}
