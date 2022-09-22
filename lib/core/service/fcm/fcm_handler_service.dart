import 'dart:developer';

import 'package:felloapp/core/constants/fcm_commands_constants.dart';
import 'package:felloapp/core/enums/transaction_state_enum.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:felloapp/core/constants/fcm_commands_constants.dart';
import 'package:felloapp/core/ops/augmont_ops.dart';
import 'package:felloapp/core/service/fcm/fcm_handler_datapayload.dart';
import 'package:felloapp/core/service/journey_service.dart';
import 'package:felloapp/core/service/notifier_services/golden_ticket_service.dart';
import 'package:felloapp/core/service/notifier_services/paytm_service.dart';
import 'package:felloapp/core/service/notifier_services/transaction_service.dart';
import 'package:felloapp/core/service/notifier_services/user_service.dart';
import 'package:felloapp/navigator/app_state.dart';
import 'package:felloapp/ui/pages/others/finance/autopay/autopay_process/autopay_process_vm.dart';
import 'package:felloapp/ui/pages/others/games/web/web_game/web_game_vm.dart';
import 'package:felloapp/util/constants.dart';
import 'package:felloapp/util/custom_logger.dart';
import 'package:felloapp/util/locator.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:felloapp/ui/pages/others/finance/augmont/augmont_gold_sell/gold_sell_vm.dart';

enum MsgSource { Foreground, Background, Terminated }

class FcmHandler extends ChangeNotifier {
  final _logger = locator<CustomLogger>();
  final _userservice = locator<UserService>();

  // final _augmontGoldBuyViewModel = locator<AugmontGoldBuyViewModel>();
  final _fcmHandlerDataPayloads = locator<FcmHandlerDataPayloads>();
  final _webGameViewModel = locator<WebGameViewModel>();
  final _autosaveProcessViewModel = locator<AutosaveProcessViewModel>();
  final _paytmService = locator<PaytmService>();
  final _augTxnService = locator<AugmontTransactionService>();
  final _journeyService = locator<JourneyService>();
  final _augOps = locator<GoldSellViewModel>();

  ValueChanged<Map> notifListener;
  // Timestamp latestFcmtimeStamp;
  String latestFcmCommand;

  Map lastFcmData;
  Future<bool> handleMessage(Map data, MsgSource source) async {
    _logger.d(
      "Fcm handler receives on ${DateFormat('yyyy-MM-dd - hh:mm a').format(DateTime.now())} - $data",
    );
    if (lastFcmData != null) {
      if (lastFcmData == data) {
        _logger.d(
          "Duplicate Fcm Data, exiting method",
        );
        return false;
      }
    } else {
      lastFcmData = data;
    }
    bool showSnackbar = true;
    String title = data['dialog_title'];
    String body = data['dialog_body'];
    String command = data['command'];
    String url = data['deep_uri'];

    // if (data["test_txn"] == "paytm") {
    // _augTxnService.isOngoingTxn = false;
    //   return true;
    // }

    // If notifications contains an url for navigation
    if (url != null && url.isNotEmpty) {
      if (AugmontTransactionService.isIOSTxnInProgress) {
        // TODO
        // ios transaction completed and app is in background
      } else if (source == MsgSource.Background ||
          source == MsgSource.Terminated) {
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
          if (_augTxnService.currentTransactionState ==
              TransactionState.idleTrasantion) showSnackbar = true;
          _augTxnService.fcmTransactionResponseUpdate(data['payload']);
          break;
        case FcmCommands.COMMAND_JOURNEY_UPDATE:
          log("User journey stats update fcm response");
          _journeyService.fcmHandleJourneyUpdateStats(data);
          break;
        case FcmCommands.COMMAND_GOLDEN_TICKET_WIN:
          log("Golden Ticket win update fcm response");
          _journeyService.fcmHandleJourneyUpdateStats(data);
          break;
        case FcmCommands.COMMAND_WITHDRAWAL_RESPONSE:
          _augOps.handleWithdrawalFcmResponse(data['payload']);
          break;

        case FcmCommands.COMMAND_CRICKET_HERO_GAME_END:
          _webGameViewModel.handleCricketHeroRoundEnd(
              data, Constants.GAME_TYPE_CRICKET);
          break;
        case FcmCommands.COMMAND_POOL_CLUB_GAME_END:
          _webGameViewModel.handlePoolClubRoundEnd(
              data, Constants.GAME_TYPE_POOLCLUB);
          break;
        case FcmCommands.COMMAND_FOOT_BALL_GAME_END:
          _webGameViewModel.handleFootBallRoundEnd(
              data, Constants.GAME_TYPE_FOOTBALL);
          break;
        case FcmCommands.COMMAND_CANDY_FIESTA_GAME_END:
          _webGameViewModel.handleCandyFiestaRoundEnd(
              data, Constants.GAME_TYPE_CANDYFIESTA);
          break;
        case FcmCommands.COMMAND_LOW_BALANCE_ALERT:
          _webGameViewModel.handleLowBalanceAlert();
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
