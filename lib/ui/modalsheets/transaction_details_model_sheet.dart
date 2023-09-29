import 'dart:developer';

import 'package:felloapp/core/model/user_transaction_model.dart';
import 'package:felloapp/core/service/notifier_services/transaction_history_service.dart';
import 'package:felloapp/util/locator.dart';
import 'package:felloapp/util/styles/size_config.dart';
import 'package:felloapp/util/styles/textStyles.dart';
import 'package:felloapp/util/styles/ui_constants.dart';
import 'package:flutter/material.dart';

class TransactionSummary extends StatelessWidget {
  final List<TransactionStatusMapItemModel>? summary;
  final TxnHistoryService _txnHistoryService = locator<TxnHistoryService>();

  TransactionSummary({super.key, this.summary});

  bool isTBD = false;
  int naPoint = 0;

  @override
  Widget build(BuildContext context) {
    for (final sum in summary!) {
      log(sum.toString());
    }
    naPoint = summary!.length;
    for (int i = 0; i < summary!.length; i++) {
      if (summary![i].value != null && summary![i].value == 'NA') {
        naPoint = i;
      }
    }
    return ListView.builder(
        physics: const NeverScrollableScrollPhysics(),
        padding: EdgeInsets.zero,
        shrinkWrap: true,
        itemCount: naPoint,
        itemBuilder: (ctx, i) {
          return leadWidget(summary, i, naPoint);
        });
  }

  Widget leadWidget(List<TransactionStatusMapItemModel>? summary, int index, int length) {
    Widget mainWidget = const SizedBox();
    Color leadColor = Colors.white;
    bool showThread = true;
    String? subtitle;
    if (isTBD) {
      mainWidget = Container(
        height: SizeConfig.padding32,
        width: SizeConfig.padding32,
        padding: EdgeInsets.all(SizeConfig.padding8),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(width: 2, color: UiConstants.gameCardColor),
        ),
      );
      subtitle = '-';
      leadColor = UiConstants.gameCardColor;
    } else if (summary![index].timestamp != null) {
      mainWidget = Container(
        height: SizeConfig.padding32,
        width: SizeConfig.padding32,
        // padding: EdgeInsets.all(SizeConfig.padding8),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(width: 1, color: UiConstants.primaryColor),
        ),
        child: Icon(Icons.check_rounded,
            color: UiConstants.primaryColor, size: SizeConfig.padding20),
      );

      leadColor = UiConstants.primaryColor;
    } else if (summary[index].value == "NA") {
      mainWidget = const SizedBox();
      leadColor = Colors.transparent;
      showThread = false;
    } else if (summary[index].value == "TBD") {
      mainWidget = Container(
        height: SizeConfig.padding32,
        width: SizeConfig.padding32,
        padding: EdgeInsets.all(SizeConfig.padding4),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(width: 1, color: UiConstants.tertiarySolid),
        ),
        child: const CircularProgressIndicator(
            color: UiConstants.tertiarySolid, strokeWidth: 1),
      );
      leadColor = UiConstants.tertiarySolid;
      isTBD = true;
      subtitle = '-';
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: SizeConfig.padding44,
          height: SizeConfig.padding64,
          alignment: Alignment.topCenter,
          child: Column(mainAxisAlignment: MainAxisAlignment.start, children: [
            Expanded(
              child: VerticalDivider(
                color: index == 0 ? Colors.transparent : leadColor,
                thickness: 1,
              ),
            ),
            mainWidget,
            Expanded(
              child: VerticalDivider(
                color: index == length - 1 ? Colors.transparent : leadColor,
                thickness: 1,
              ),
            )
          ]),
        ),
        if (showThread)
          Expanded(
            child: Container(
              height: SizeConfig.padding54,
              alignment: Alignment.centerLeft,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    summary![index].title!,
                    style: TextStyles.sourceSans.body3
                        .colour(const Color(0XFFA9C6D6)),
                  ),
                  Text(
                    subtitle ??
                        (summary[index].timestamp != null
                            ? "${_txnHistoryService!.getFormattedDateAndTime(summary[index].timestamp!)}"
                            : summary[index].value!),
                    style: TextStyles.sourceSans.body4
                        .colour(const Color(0xffA0A0A0)),
                  ),
                ],
              ),
            ),
          )
      ],
    );
  }
}
