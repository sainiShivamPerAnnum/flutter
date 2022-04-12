import 'package:felloapp/core/constants/fcm_commands_constants.dart';
import 'package:felloapp/core/service/fcm/fcm_handler_datapayload.dart';
import 'package:felloapp/core/service/notifier_services/paytm_service.dart';
import 'package:felloapp/core/service/notifier_services/user_service.dart';
import 'package:felloapp/navigator/app_state.dart';
import 'package:felloapp/ui/pages/others/finance/augmont/augmont_buy_screen/augmont_buy_vm.dart';
import 'package:felloapp/ui/pages/others/finance/autopay/autopay_process/autopay_process_vm.dart';
import 'package:felloapp/ui/pages/others/games/cricket/cricket_game/cricket_game_vm.dart';
import 'package:felloapp/util/custom_logger.dart';
import 'package:felloapp/util/locator.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

enum MsgSource { Foreground, Background, Terminated }

class FcmHandler extends ChangeNotifier {
  final _logger = locator<CustomLogger>();
  final _userservice = locator<UserService>();

  final _augmontGoldBuyViewModel = locator<AugmontGoldBuyViewModel>();
  final _fcmHandlerDataPayloads = locator<FcmHandlerDataPayloads>();
  final _cricketGameViewModel = locator<CricketGameViewModel>();
  final _autosaveProcessViewModel = locator<AutoSaveProcessViewModel>();
  final _paytmService = locator<PaytmService>();

  ValueChanged<Map> notifListener;

  Future<bool> handleMessage(Map data, MsgSource source) async {
    _logger.d(
        "Fcm handler receives on ${DateFormat('yyyy-MM-dd – hh:mm a').format(DateTime.now())} - $data");
    bool showSnackbar = true;
    String title = data['dialog_title'];
    String body = data['dialog_body'];
    String command = data['command'];
    String url = data['deep_uri'];

    // If notifications contains an url for navigation
    if (url != null && url.isNotEmpty) {
      if (source == MsgSource.Background || source == MsgSource.Terminated) {
        showSnackbar = false;
        AppState.delegate.parseRoute(Uri.parse(url));
        return true;
      }
    }

    // If message has a command payload
    if (data['command'] != null) {
      showSnackbar = false;
      switch (command) {
        case FcmCommands.DEPOSIT_TRANSACTION_RESPONSE:
          {
            _augmontGoldBuyViewModel
                .fcmTransactionResponseUpdate(data['payload']);
          }
          break;
        case FcmCommands.COMMAND_CRIC_GAME_END:
          _cricketGameViewModel.endCricketGame(data);
          break;
        case FcmCommands.COMMAND_SHOW_DIALOG:
          _fcmHandlerDataPayloads.showDialog(title, body);
          break;
        case FcmCommands.COMMAND_USER_PRIZE_WIN_2:
          await _fcmHandlerDataPayloads.userPrizeWinPrompt();
          break;
        case FcmCommands.COMMAND_SUBSCRIPTION_RESPONSE:
          if (_paytmService.isOnSubscriptionFlow)
            await _autosaveProcessViewModel.handleSubscriptionPayload(data);
          // else
          //   await _paytmService.handleFCMStatusUpdate(data);
          break;
        default:
      }
    }

    // If app is in foreground and needs to show a snackbar
    if (source == MsgSource.Foreground && showSnackbar == true) {
      handleNotification(title, body);
    }
    _userservice.checkForNewNotifications();
    return true;
  }

  Future<bool> handleNotification(String title, String body) async {
    if (title != null && title.isNotEmpty && body != null && body.isNotEmpty) {
      Map<String, String> _map = {'title': title, 'body': body};
      if (this.notifListener != null) this.notifListener(_map);
    }
    return true;
  }

  addIncomingMessageListener(ValueChanged<Map> listener) {
    this.notifListener = listener;
  }
}
