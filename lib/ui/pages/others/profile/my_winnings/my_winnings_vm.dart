import 'package:felloapp/base_util.dart';
import 'package:felloapp/navigator/app_state.dart';
import 'package:felloapp/ui/architecture/base_vm.dart';
import 'package:felloapp/ui/widgets/fello_dialog/fello_confirm_dialog.dart';
import 'package:felloapp/util/assets.dart';
import 'package:felloapp/util/styles/size_config.dart';
import 'package:felloapp/util/styles/textStyles.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class MyWinningsViewModel extends BaseModel {
  showConfirmDialog() {
    BaseUtil.openDialog(
      addToScreenStack: true,
      isBarrierDismissable: false,
      hapticVibrate: true,
      content: FelloConfirmationDialog(
        showCrossIcon: true,
        content: Column(
          children: [
            SizedBox(height: SizeConfig.screenWidth * 0.171),
            SvgPicture.asset(
              Assets.prizeClaimConfirm,
              height: SizeConfig.screenWidth * 0.398,
            ),
            SizedBox(
              height: SizeConfig.padding40,
            ),
            Text(
              "Confirmation",
              style: TextStyles.title2.bold,
            ),
            SizedBox(height: SizeConfig.padding16),
            Text(
              "Are you sure you want to invest Rs 200 in gold?",
              textAlign: TextAlign.center,
              style: TextStyles.body2.colour(Colors.grey),
            ),
            SizedBox(height: SizeConfig.padding54),
          ],
        ),
        onAccept: AppState.backButtonDispatcher.didPopRoute,
        onReject: AppState.backButtonDispatcher.didPopRoute,
      ),
    );
  }

  showSuccessDialog() {}
}
