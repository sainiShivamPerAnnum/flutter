import 'dart:async';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:felloapp/base_util.dart';
import 'package:felloapp/core/model/subscription_models/subscription_status_response.dart';
import 'package:felloapp/core/repository/subscription_repo.dart';
import 'package:felloapp/core/service/subscription_service.dart';
import 'package:felloapp/util/custom_logger.dart';
import 'package:flutter/services.dart';
import 'package:upi_pay/upi_pay.dart';

part 'mandate_event.dart';
part 'mandate_state.dart';

class MandateBloc extends Bloc<MandateEvent, MandateState> {
  final SubService _subService;
  final SubscriptionRepo _repo;
  final CustomLogger _logger;

  MandateBloc(
    this._subService,
    this._repo,
    this._logger,
  ) : super(const MandateInitialState()) {
    on<LoadPSPApps>(_onLoadPSPApps);
    on<CrateSubscription>(_onRequestCreateSubscription);
  }

  // Loads the available psp apps.
  FutureOr<void> _onLoadPSPApps(
    LoadPSPApps event,
    Emitter<MandateState> emitter,
  ) async {
    emitter(const ListingPSPApps());
    final apps = await _subService.getUPIApps();
    emitter(ListedPSPApps(apps));
  }

  // creates the subscription and launches the psp app if required.
  FutureOr<void> _onRequestCreateSubscription(
    CrateSubscription event,
    Emitter<MandateState> emitter,
  ) async {
    final currentState = state;
    if (currentState is ListedPSPApps) {
      emitter(
        (state as ListedPSPApps).copyWith(
          status: const SubsTransactionStatus.creating(),
        ),
      );

      final res = await _repo.createSubscription(
        freq: event.freq,
        lbAmt: event.lbAmt,
        augAmt: event.augAmt,
        amount: event.amount,
        package: event.meta.packageName,
      );

      final data = res.model?.data;
      final subscriptionData = data?.subscription;
      final intentData = data?.intent;

      if (res.isSuccess() && intentData != null) {
        emitter(
          (state as ListedPSPApps).copyWith(
            status: SubsTransactionStatus.created(
              subsPrimaryKey: intentData.subId,
              redirectUrl: intentData.redirectUrl,
              mandateAlreadyExits: intentData.alreadyExist,
              subscriptionData: subscriptionData,
            ),
          ),
        );

        if (intentData.redirectUrl.isNotEmpty && !intentData.alreadyExist) {
          await _openPSPApp(intentData.redirectUrl, event.meta.packageName);
        }
      } else {
        emitter(
          (state as ListedPSPApps).copyWith(
            status: SubsTransactionStatus.failed(
              res.errorMessage ?? 'Failed to create subscription',
            ),
          ),
        );

        BaseUtil.showNegativeAlert(
          'Failed to create subscription',
          res.errorMessage,
        );
      }
    }
  }

  // Launches the psp app.
  Future<void> _openPSPApp(String intentUrl, String package) async {
    try {
      if (Platform.isIOS) {
        await BaseUtil.launchUrl(intentUrl);
        return;
      } else {
        const platform = MethodChannel("methodChannel/upiIntent");
        await platform.invokeMethod('initiatePsp', {
          'redirectUrl': intentUrl,
          'packageName': package,
        });
      }
    } catch (e) {
      _logger.d('Failed launch intent url');
    }
  }
}
