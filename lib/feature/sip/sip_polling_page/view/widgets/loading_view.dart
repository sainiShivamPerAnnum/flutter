import 'package:felloapp/core/model/quote_model.dart';
import 'package:felloapp/ui/pages/finance/quotes.dart';
import 'package:felloapp/ui/pages/static/app_widget.dart';
import 'package:felloapp/util/styles/styles.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

import '../../constants/asset_type.dart';

class SipPolling extends StatelessWidget {
  const SipPolling({
    required this.assetType,
    super.key,
  });

  final AssetType assetType;

  @override
  Widget build(BuildContext context) {
    final label = switch (assetType) {
      AssetType.aug => 'Digital Gold',
      AssetType.flo => 'Fello P2P'
    };

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor:
            UiConstants.kRechargeModalSheetAmountSectionBackgroundColor,
        centerTitle: true,
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox.square(
              dimension: SizeConfig.padding44,
              child: AppImage(assetType.icon),
            ),
            Text(
              label,
              style: TextStyles.rajdhaniSB.title5,
            ),
          ],
        ),
      ),
      backgroundColor:
          UiConstants.kRechargeModalSheetAmountSectionBackgroundColor,
      body: Column(
        children: [
          SizedBox(
            height: SizeConfig.padding32,
          ),
          Expanded(
            child: Lottie.network(
              assetType.loadingLottie,
              height: SizeConfig.screenHeight! * 0.7,
            ),
          ),
          QuotesComponent(
            quotesType: switch (assetType) {
              AssetType.flo => QuotesType.flo,
              AssetType.aug => QuotesType.aug,
            },
          ),
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: SizeConfig.padding32,
            ),
            child: const LinearProgressIndicator(
              color: UiConstants.primaryColor,
              backgroundColor: UiConstants.kDarkBackgroundColor,
            ),
          ),
          SizedBox(
            height: SizeConfig.padding32,
          ),
        ],
      ),
    );
  }
}
