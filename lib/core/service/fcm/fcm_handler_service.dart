import 'dart:developer';

import 'package:felloapp/core/constants/fcm_commands_constants.dart';
import 'package:felloapp/core/enums/transaction_state_enum.dart';
import 'package:felloapp/core/service/fcm/fcm_handler_datapayload.dart';
import 'package:felloapp/core/service/journey_service.dart';
import 'package:felloapp/core/service/notifier_services/user_service.dart';
import 'package:felloapp/core/service/payments/augmont_transaction_service.dart';
import 'package:felloapp/core/service/payments/paytm_service.dart';
import 'package:felloapp/navigator/app_state.dart';
import 'package:felloapp/ui/pages/others/finance/augmont/gold_sell/gold_sell_vm.dart';
import 'package:felloapp/ui/pages/others/finance/autopay/autopay_process/autopay_process_vm.dart';
import 'package:felloapp/ui/pages/others/games/web/web_game/web_game_vm.dart';
import 'package:felloapp/util/constants.dart';
import 'package:felloapp/util/custom_logger.dart';
import 'package:felloapp/util/locator.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

enum MsgSource { Foreground, Background, Terminated }

class FcmHandler extends ChangeNotifier {
  final CustomLogger? _logger = locator<CustomLogger>();
  final UserService? _userservice = locator<UserService>();

  // final _augmontGoldBuyViewModel = locator<AugmontGoldBuyViewModel>();
  final FcmHandlerDataPayloads? _fcmHandlerDataPayloads =
      locator<FcmHandlerDataPayloads>();
  final WebGameViewModel? _webGameViewModel = locator<WebGameViewModel>();
  final AutosaveProcessViewModel? _autosaveProcessViewModel =
      locator<AutosaveProcessViewModel>();
  final PaytmService? _paytmService = locator<PaytmService>();
  final AugmontTransactionService? _augTxnService =
      locator<AugmontTransactionService>();

  final JourneyService? _journeyService = locator<JourneyService>();
  final GoldSellViewModel? _augOps = locator<GoldSellViewModel>();
  ValueChanged<Map>? notifListener;
  // Timestamp latestFcmtimeStamp;
  String? latestFcmCommand;

  Map? lastFcmData;
  Future<bool> handleMessage(Map? data, MsgSource source) async {
    _logger!.d(
      "Fcm handler receives on ${DateFormat('yyyy-MM-dd - hh:mm a').format(DateTime.now())} - $data",
    );
    if (lastFcmData != null) {
      if (lastFcmData == data) {
        _logger!.d(
          "Duplicate Fcm Data, exiting method",
        );
        return false;
      }
    } else {
      lastFcmData = data;
    }
    bool showSnackbar = true;
    String? title = data!['dialog_title'];
    String? body = data['dialog_body'];
    String? command = data['command'];
    String? url = data['deep_uri'];

    // if (data["test_txn"] == "paytm") {
    // _augTxnService.isOngoingTxn = false;
    //   return true;
    // }

    // If notifications contains an url for navigation
    if (url != null && url.isNotEmpty) {
      if (_augTxnService!.isIOSTxnInProgress) {
        // TODO
        // ios transaction completed and app is in background
      } else if (source == MsgSource.Background ||
          source == MsgSource.Terminated) {
        showSnackbar = false;
        AppState.delegate!.parseRoute(Uri.parse(url));
        return true;
      }
    }

    // If message has a command payload
    if (data['command'] != null) {
      showSnackbar = false;

      if (command!.contains('end'))
        return _webGameViewModel!
            .handleGameRoundEnd(data as Map<String, dynamic>);
      switch (command) {
        case FcmCommands.COMMAND_JOURNEY_UPDATE:
          log("User journey stats update fcm response");
          _journeyService!
              .fcmHandleJourneyUpdateStats(data as Map<String, dynamic>);
          break;
        case FcmCommands.COMMAND_GOLDEN_TICKET_WIN:
          log("Golden Ticket win update fcm response");
          _journeyService!
              .fcmHandleJourneyUpdateStats(data as Map<String, dynamic>);
          break;
        case FcmCommands.COMMAND_WITHDRAWAL_RESPONSE:
          _augOps!.handleWithdrawalFcmResponse(data['payload']);
          break;
        case FcmCommands.COMMAND_LOW_BALANCE_ALERT:
          _webGameViewModel!.handleLowBalanceAlert();
          break;
        case FcmCommands.COMMAND_SHOW_DIALOG:
          _fcmHandlerDataPayloads!.showDialog(title, body);
          break;
        case FcmCommands.COMMAND_USER_PRIZE_WIN_2:
          await _fcmHandlerDataPayloads!.userPrizeWinPrompt();
          break;
        case FcmCommands.COMMAND_SUBSCRIPTION_RESPONSE:
          if (_paytmService!.isOnSubscriptionFlow)
            await _autosaveProcessViewModel!
                .handleSubscriptionPayload(data as Map<String, dynamic>);
          break;
        default:
      }
    }

    // If app is in foreground and needs to show a snackbar
    if (source == MsgSource.Foreground && showSnackbar == true) {
      handleNotification(title, body);
    }
    _userservice!.checkForNewNotifications();
    return true;
  }

  Future<bool> handleNotification(String? title, String? body) async {
    if (title != null && title.isNotEmpty && body != null && body.isNotEmpty) {
      Map<String, String> _map = {'title': title, 'body': body};
      if (this.notifListener != null) this.notifListener!(_map);
    }
    return true;
  }

  addIncomingMessageListener(ValueChanged<Map>? listener) {
    this.notifListener = listener;
  }
}
