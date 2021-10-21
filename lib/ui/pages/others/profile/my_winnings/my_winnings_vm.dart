import 'package:felloapp/base_util.dart';
import 'package:felloapp/navigator/app_state.dart';
import 'package:felloapp/ui/architecture/base_vm.dart';
import 'package:felloapp/ui/widgets/fello_dialog/fello_confirm_dialog.dart';
import 'package:felloapp/util/assets.dart';
import 'package:felloapp/util/locator.dart';
import 'package:felloapp/util/styles/ui_constants.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';

class MyWinningsViewModel extends BaseModel {
  final _logger = locator<Logger>();
  showConfirmDialog() {
    BaseUtil.openDialog(
      addToScreenStack: true,
      isBarrierDismissable: false,
      hapticVibrate: true,
      content: FelloConfirmationDialog(
        result: (res) async {
          if (res) await buyAmazonGiftCard();
          showSuccessPrizeWithdrawalDialog();
        },
        showCrossIcon: true,
        asset: Assets.prizeClaimConfirm,
        title: "Confirmation",
        subtitle: "Are you sure you want to invest Rs 200 in gold?",
        accept: "Yes",
        reject: "No",
        acceptColor: UiConstants.primaryColor,
        rejectColor: Colors.grey.withOpacity(0.3),
        //onAccept: buyAmazonGiftCard,
        onReject: AppState.backButtonDispatcher.didPopRoute,
      ),
    );
  }

  showSuccessPrizeWithdrawalDialog() {
    BaseUtil.openDialog(
      addToScreenStack: true,
      isBarrierDismissable: false,
      hapticVibrate: true,
      content: FelloConfirmationDialog(
        title: "Congratulations",
        subtitle: "Your winnnigs Rs 200 in invested in gold",
        acceptColor: UiConstants.primaryColor,
        rejectColor: UiConstants.tertiarySolid,
        accept: "Share on WhatsApp",
        reject: "OK",
        asset: Assets.goldenTicket,
        onReject: AppState.backButtonDispatcher.didPopRoute,
        result: (res) {
          if (res) shareOnWhatsapp();
        },
      ),
    );
  }

  shareOnWhatsapp() {
    _logger.i("Whatsapp share trigerred");
    AppState.backButtonDispatcher.didPopRoute();
  }

  buyAmazonGiftCard() async {
    await Future.delayed(Duration(seconds: 5));
    AppState.backButtonDispatcher.didPopRoute();
  }

  showSuccessDialog() {}
}
