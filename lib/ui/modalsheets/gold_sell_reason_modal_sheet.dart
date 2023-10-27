import 'package:felloapp/base_util.dart';
import 'package:felloapp/core/constants/analytics_events_constants.dart';
import 'package:felloapp/core/enums/investment_type.dart';
import 'package:felloapp/core/service/analytics/analytics_service.dart';
import 'package:felloapp/navigator/app_state.dart';
import 'package:felloapp/util/localization/generated/l10n.dart';
import 'package:felloapp/util/locator.dart';
import 'package:felloapp/util/styles/size_config.dart';
import 'package:felloapp/util/styles/textStyles.dart';
import 'package:flutter/material.dart';

class SellingReasonBottomSheet extends StatefulWidget {
  final InvestmentType investmentType;

  const SellingReasonBottomSheet({required this.investmentType, Key? key})
      : super(key: key);

  @override
  State<SellingReasonBottomSheet> createState() =>
      _SellingReasonBottomSheetState();
}

class _SellingReasonBottomSheetState extends State<SellingReasonBottomSheet> {
  S locale = locator<S>();

  final List<String> _sellingReasons = [];

  @override
  void initState() {
    _sellingReasons.addAll([
      locale.sellingReasons1,
      locale.sellingReasons2,
      locale.sellingReasons3,
      locale.sellingReasons4,
    ]);
    super.initState();
  }

  String selectedReasonForSelling = '';

  final AnalyticsService _analyticsService = locator<AnalyticsService>();

  @override
  Widget build(BuildContext context) {
    S locale = S.of(context);
    return WillPopScope(
      onWillPop: () async {
        AppState.screenStack.removeLast();
        return Future.value(true);
      },
      child: Padding(
        padding: EdgeInsets.all(SizeConfig.padding10),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              height: SizeConfig.padding40,
            ),
            Text(
              locale.goldSellReason,
              style: TextStyles.rajdhaniSB.body1,
            ),
            SizedBox(
              height: SizeConfig.padding10,
            ),
            ListView(
              shrinkWrap: true,
              children: _sellingReasons
                  .map(
                    (x) => RadioListTile(
                      toggleable: true,
                      selected: true,
                      value: x,
                      groupValue: selectedReasonForSelling,
                      onChanged: (dynamic value) {
                        selectedReasonForSelling = x;
                        _analyticsService.track(
                            eventName: AnalyticsEvents.sellReason,
                            properties: {"Reason": selectedReasonForSelling});
                        AppState.backButtonDispatcher!.didPopRoute();
                        BaseUtil().openSellModalSheet(
                            investmentType: widget.investmentType);
                      },
                      title: Text(
                        x,
                        style: TextStyles.rajdhani.body2,
                      ),
                    ),
                  )
                  .toList(),
            ),
          ],
        ),
      ),
    );
  }
}
