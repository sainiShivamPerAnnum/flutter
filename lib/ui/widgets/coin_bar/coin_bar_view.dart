import 'dart:developer';

import 'package:felloapp/base_util.dart';
import 'package:felloapp/core/constants/analytics_events_constants.dart';
import 'package:felloapp/core/enums/view_state_enum.dart';
import 'package:felloapp/ui/architecture/base_view.dart';
import 'package:felloapp/ui/modals_sheets/want_more_tickets_modal_sheet.dart';
import 'package:felloapp/ui/service_elements/user_coin_service/coin_balance_text.dart';
import 'package:felloapp/ui/widgets/coin_bar/coin_bar_vm.dart';
import 'package:felloapp/util/assets.dart';
import 'package:felloapp/util/styles/size_config.dart';
import 'package:felloapp/util/styles/ui_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../../core/service/analytics/analytics_service.dart';
import '../../../util/locator.dart';

class FelloCoinBar extends StatelessWidget {
  final _analytics = locator<AnalyticsService>();

  final String svgAsset;
  final Color borderColor;
  final TextStyle style;
  final double size;

  FelloCoinBar({
    this.svgAsset,
    this.borderColor,
    this.style,
    this.size,
  });

  @override
  Widget build(BuildContext context) {
    log("FLC build called");
    return BaseView<FelloCoinBarViewModel>(
      onModelReady: (model) => model.getFlc(),
      builder: (ctx, model, child) => model.state == ViewState.Busy
          ? CircularProgressIndicator()
          : GestureDetector(
              onTap: () {
                _analytics.track(
                    eventName: AnalyticsEvents.addFLCTokensTopRight);
                BaseUtil.openModalBottomSheet(
                  addToScreenStack: true,
                  backgroundColor: Colors.transparent,
                  content: WantMoreTicketsModalSheet(),
                  hapticVibrate: true,
                  isBarrierDismissable: true,
                );
              },
              child: Container(
                margin: EdgeInsets.all(SizeConfig.padding8),
                padding: EdgeInsets.symmetric(
                    horizontal: SizeConfig.padding12,
                    vertical: SizeConfig.padding10),
                decoration: BoxDecoration(
                  color: UiConstants.kTextFieldColor.withOpacity(0.4),
                  border: Border.all(color: borderColor ?? Colors.white10),
                  borderRadius: BorderRadius.circular(SizeConfig.roundness12),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    SvgPicture.asset(
                      svgAsset ?? Assets.aFelloToken,
                      height: size ?? SizeConfig.padding20,
                      width: size ?? SizeConfig.padding20,
                    ),
                    SizedBox(width: SizeConfig.padding4),
                    CoinBalanceTextSE(),
                  ],
                ),
              ),
            ),
    );
  }
}
