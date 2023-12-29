// ignore_for_file: lines_longer_than_80_chars, one_member_abstracts, constant_identifier_names

import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:felloapp/base_util.dart';
import 'package:felloapp/core/constants/fcm_commands_constants.dart';
import 'package:felloapp/core/enums/screen_item_enum.dart';
import 'package:felloapp/core/service/fcm/fcm_handler_datapayload.dart';
import 'package:felloapp/core/service/fcm/fcm_handler_v2/fcm_handler_v2.dart';
import 'package:felloapp/core/service/journey_service.dart';
import 'package:felloapp/core/service/notifier_services/user_service.dart';
import 'package:felloapp/core/service/payments/augmont_transaction_service.dart';
import 'package:felloapp/core/service/payments/lendbox_transaction_service.dart';
import 'package:felloapp/navigator/app_state.dart';
import 'package:felloapp/ui/elements/fello_dialog/apxor_dialog.dart';
import 'package:felloapp/ui/pages/finance/augmont/gold_sell/gold_sell_vm.dart';
import 'package:felloapp/ui/pages/games/web/web_game/web_game_vm.dart';
import 'package:felloapp/util/custom_logger.dart';
import 'package:felloapp/util/locator.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

enum MsgSource {
  Foreground,
  Background,
  Terminated;
}

class FcmHandler extends ChangeNotifier {
  final CustomLogger _logger = locator<CustomLogger>();
  final UserService _userService = locator<UserService>();

  // final _augmontGoldBuyViewModel = locator<AugmontGoldBuyViewModel>();
  final FcmHandlerDataPayloads _fcmHandlerDataPayloads =
      locator<FcmHandlerDataPayloads>();
  final WebGameViewModel _webGameViewModel = locator<WebGameViewModel>();

  // final PaytmService? _paytmService = locator<PaytmService>();
  final AugmontTransactionService _augTxnService =
      locator<AugmontTransactionService>();
  final LendboxTransactionService _floTxnService =
      locator<LendboxTransactionService>();

  final JourneyService _journeyService = locator<JourneyService>();
  final GoldSellViewModel _augOps = locator<GoldSellViewModel>();
  ValueChanged<Map>? notifListener;

  // Timestamp latestFcmtimeStamp;
  String? latestFcmCommand;

  Map? lastFcmData;

  Future<bool> handleMessage(Map? data, MsgSource source) async {
    _logger.d(
      "Fcm handler receives on ${DateFormat('yyyy-MM-dd - hh:mm a').format(DateTime.now())} - $data",
    );

    if (lastFcmData != null) {
      if (lastFcmData == data) {
        _logger.d(
          "Duplicate Fcm Data, exiting method",
        );
        lastFcmData = data;
        return false;
      }
    } else {
      lastFcmData = data;
    }

    var v2 = data?['v2'];
    final isTransactionInProgress = _augTxnService.currentTxnState.isGoingOn ||
        _floTxnService.currentTransactionState.isGoingOn;

    if (v2 != null &&
        !_augTxnService.isIOSTxnInProgress &&
        !isTransactionInProgress) {
      if (v2 is String) {
        v2 = jsonDecode(v2);
      }
      await FcmHandlerV2.instance.handle(v2);
      return true;
    }

    bool showSnackbar = true;
    String? title = data!['dialog_title'];
    String? body = data['dialog_body'];
    String? command = data['command'];
    String? url;
    if (data["source"] != null && data["source"] == "webengage") {
      final data0 = jsonDecode(data['message_data']);
      final listOfData = data0["custom"] as List;
      try {
        url = listOfData.firstWhere(
          (element) => element['key'] == 'route',
        )['value'];
      } catch (e) {
        log(e.toString());
      }
    } else {
      url = data['deep_uri'] ?? data['route'];
    }

    // If notifications contains an url for navigation
    if (url != null && url.isNotEmpty) {
      if (_augTxnService.isIOSTxnInProgress) {
        // TODO
        // ios transaction completed and app is in background
      } else if (source == MsgSource.Background ||
          source == MsgSource.Terminated) {
        showSnackbar = false;
        await Future.delayed(const Duration(milliseconds: 800), () {
          if (isTransactionInProgress) return true;
          AppState.delegate!.parseRoute(Uri.parse(url!));
        });

        return true;
      }
    }

    // If message has a command payload
    if (data['command'] != null) {
      log("Fcm command: $command");
      showSnackbar = false;

      if (command!.toLowerCase().contains('end')) {
        return _webGameViewModel
            .handleGameRoundEnd(data as Map<String, dynamic>);
      }
      switch (command) {
        case FcmCommands.COMMAND_JOURNEY_UPDATE:
          log("User journey stats update fcm response");
          _journeyService
              .fcmHandleJourneyUpdateStats(data as Map<String, dynamic>);
          break;
        case FcmCommands.COMMAND_TICKET_WIN:
          log("Scratch Card win update fcm response");
          _journeyService
              .fcmHandleJourneyUpdateStats(data as Map<String, dynamic>);
          break;
        case FcmCommands.COMMAND_WITHDRAWAL_RESPONSE:
          _augOps.handleWithdrawalFcmResponse(data['payload']);
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
        case FcmCommands.COMMAND_GOLDEN_TICKET_WIN:
          log("Golden Ticket win update fcm response - ${data['payload']}",
              name: "FcmHandler");
          showSnackbar = false;
          await _userService.checkForNewNotifications();
          break;
        case FcmCommands.COMMAND_APPXOR_DIALOG:
          debugPrint("fcm handler: appxor");
          if (AppState.isOnboardingInProgress ||
              AppState.isWebGamePInProgress ||
              AppState.isWebGameLInProgress ||
              AppState.isUpdateScreen ||
              AppState.isInstantGtViewInView ||
              AppState.showAutosaveBt ||
              AppState.screenStack.last == ScreenItem.loader) return true;
          if (data["payload"] != null && data["payload"].isNotEmpty) {
            unawaited(
              BaseUtil.openDialog(
                isBarrierDismissible: false,
                barrierColor: Colors.black12,
                addToScreenStack: true,
                hapticVibrate: true,
                content: ApxorDialog(
                  dialogContent:
                      json.decode(data["payload"]) as Map<String, dynamic>,
                ),
              ),
            );
          }
          return true;

        default:
      }
    }

    // If app is in foreground and needs to show a snackbar
    if (source == MsgSource.Foreground && showSnackbar == true) {
      await handleNotification(title, body, command);
    }
    return true;
  }

  Future<bool> handleNotification(
      String? title, String? body, String? command) async {
    if (title == null || body == null) return false;

    log("Foreground Fcm handler receives on ${DateFormat('yyyy-MM-dd - hh:mm a').format(DateTime.now())} - $title - $body - $command");
    if (command != null && command == FcmCommands.COMMAND_GOLDEN_TICKET_WIN) {
      await Future.delayed(const Duration(seconds: 2));
      await _userService.checkForNewNotifications();
      return true;
    }

    if (title.isNotEmpty && body.isNotEmpty) {
      Map<String, String> map = {'title': title, 'body': body};
      if (notifListener != null) notifListener!(map);
    }
    return true;
  }

  void addIncomingMessageListener(ValueChanged<Map>? listener) =>
      notifListener = listener;
}
