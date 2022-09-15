import 'package:felloapp/base_util.dart';
import 'package:felloapp/core/enums/screen_item_enum.dart';
import 'package:felloapp/navigator/app_state.dart';
import 'package:felloapp/ui/pages/others/finance/augmont/augmont_buy_screen/augmont_buy_vm.dart';
import 'package:felloapp/util/assets.dart';
import 'package:felloapp/util/styles/size_config.dart';
import 'package:felloapp/util/styles/textStyles.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class UPIAppsBottomSheet extends StatelessWidget {
  final AugmontGoldBuyViewModel model;

  const UPIAppsBottomSheet({Key key, this.model}) : super(key: key);

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
                      model.appMetaList.length > 0
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
              model.appMetaList.length <= 0
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
                        itemCount: model.appMetaList.length,
                        itemBuilder: (context, index) {
                          return GestureDetector(
                            onTap: () {
                              BaseUtil.openDialog(
                                  addToScreenStack: true,
                                  isBarrierDismissable: false,
                                  content: Padding(
                                    padding: EdgeInsets.all(10),
                                    child: Dialog(
                                      child: Container(
                                          height: SizeConfig.screenWidth * 0.2,
                                          width: SizeConfig.screenWidth,
                                          decoration: BoxDecoration(
                                              color: Colors.white,
                                              borderRadius:
                                                  BorderRadius.circular(10)),
                                          child: Padding(
                                            padding: EdgeInsets.symmetric(
                                                horizontal: 20),
                                            child: Row(children: [
                                              Text(
                                                'Processing',
                                                style: TextStyles.title5,
                                              ),
                                              Spacer(),
                                              CircularProgressIndicator()
                                            ]),
                                          )),
                                    ),
                                  ));
                              AppState.screenStack.add(ScreenItem.loader);
                              model.upiApplication =
                                  model.appMetaList[index].upiApplication;
                              model.processTransaction(model
                                  .appMetaList[index].upiApplication.appName);
                              // AppState.backButtonDispatcher.didPopRoute();
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
                                          child: model.appMetaList[index]
                                              .iconImage(40)),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      Text(
                                        model.appMetaList[index].upiApplication
                                            .appName,
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
