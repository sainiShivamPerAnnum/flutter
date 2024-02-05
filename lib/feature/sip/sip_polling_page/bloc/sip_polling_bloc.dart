import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:felloapp/core/model/subscription_models/subscription_status_response.dart';
import 'package:felloapp/core/service/subscription_service.dart';
import 'package:felloapp/util/custom_logger.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'sip_polling_event.dart';
part 'sip_polling_state.dart';

class SipPollingBloc extends Bloc<SipPollingEvent, SipPollingState> {
  final SubService _subscriptionService;
  final CustomLogger _logger;

  SipPollingBloc(this._subscriptionService, this._logger)
      : super(const InitialPollingState()) {
    on<StartPolling>(_onStartPolling);
  }

  FutureOr<void> _onStartPolling(
    StartPolling event,
    Emitter<SipPollingState> emitter,
  ) async {
    emitter(const Polling()); // for loading state.

    final response = await _subscriptionService.pollForSubscriptionStatus(
      event.subscriptionKey,
    );

    final data = response.model?.data;

    if (response.isSuccess() && data != null) {
      emitter(
        CompletedPollingWithSuccessOrPending(data),
      ); // either pending or success.
    } else {
      emitter(
        CompletedPollingWithFailure(
          response.errorMessage ?? 'Failed to subscription status check status',
        ), // failed to check status of subscription.
      );

      _logger.d(
        'Failed to check status of subscription with error: ${response.errorMessage}',
      );
    }
  }
}
