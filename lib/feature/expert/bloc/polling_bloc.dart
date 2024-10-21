import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:felloapp/core/model/bookings/payment_polling.dart';
import 'package:felloapp/core/repository/experts_repo.dart';

part 'polling_event.dart';
part 'polling_state.dart';

class PollingBloc extends Bloc<PollingEvent, PollingState> {
  final ExpertsRepository _expertsRepository;
  PollingBloc(
    this._expertsRepository,
  ) : super(const InitialPollingState()) {
    on<StartPolling>(_onStartPolling);
  }
  FutureOr<void> _onStartPolling(
    StartPolling event,
    Emitter<PollingState> emitter,
  ) async {
    emitter(const Polling());
    final response = await _expertsRepository.pollForPayemtStatus(
      event.paymentId,
    );
    final data = response.model;
    if (response.isSuccess() &&
        data != null &&
        data.data.paymentDetails!.status == BookingPaymentStatus.complete) {
      emitter(
        CompletedPollingWithSuccess(data),
      );
    }
    else if (response.isSuccess() &&
        data != null &&
        data.data.paymentDetails!.status == BookingPaymentStatus.pending) {
      emitter(
        CompletedPollingWithPending(data),
      );
    } else {
      emitter(
        CompletedPollingWithFailure(
          response.errorMessage ?? 'Failed to check status',
        ),
      );
    }
  }
}
