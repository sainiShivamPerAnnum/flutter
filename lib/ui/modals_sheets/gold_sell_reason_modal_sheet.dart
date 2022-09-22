import 'package:felloapp/base_util.dart';
import 'package:felloapp/navigator/app_state.dart';

import 'package:felloapp/ui/pages/others/finance/augmont/gold_sell/gold_sell_view.dart';
import 'package:felloapp/util/styles/size_config.dart';
import 'package:felloapp/util/styles/textStyles.dart';
import 'package:felloapp/util/styles/ui_constants.dart';
import 'package:flutter/material.dart';

class SellingReasonBottomSheet extends StatelessWidget {
  final List<String> _sellingReasons = [
    'Not interested anymore',
    'Not interested a little more',
    'Not anymore',
    'Others'
  ];

  String selectedReasonForSelling = '';

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        AppState.screenStack.removeLast();
        return Future.value(true);
      },
      child: Container(
        alignment: Alignment.bottomCenter,
        child: Container(
          height: SizeConfig.screenWidth * 0.85,
          width: SizeConfig.screenWidth,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(SizeConfig.roundness32),
                  topRight: Radius.circular(SizeConfig.roundness32)),
              color: UiConstants.kModalSheetBackgroundColor),
          child: Padding(
            padding: EdgeInsets.all(SizeConfig.padding10),
            child: Column(
              children: [
                SizedBox(
                  height: SizeConfig.padding40,
                ),
                Text(
                  'What makes you want to sell the asset?',
                  style: TextStyles.rajdhaniSB.body1,
                ),
                SizedBox(
                  height: SizeConfig.padding10,
                ),
                Expanded(
                    child: ListView(
                  children: _sellingReasons
                      .map((x) => RadioListTile(
                            toggleable: true,
                            selected: true,
                            value: x,
                            groupValue: selectedReasonForSelling,
                            onChanged: (value) {
                              selectedReasonForSelling = x;
                              AppState.backButtonDispatcher.didPopRoute();
                              BaseUtil.openModalBottomSheet(
                                  isScrollControlled: true,
                                  backgroundColor: Colors.transparent,
                                  borderRadius: BorderRadius.circular(
                                      SizeConfig.roundness8),
                                  enableDrag: false,
                                  addToScreenStack: true,
                                  isBarrierDismissable: false,
                                  content: GoldSellView());
                            },
                            title: Text(
                              x,
                              style: TextStyles.rajdhani.body2,
                            ),
                          ))
                      .toList(),
                )),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
