import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:felloapp/core/constants/analytics_events_constants.dart';
import 'package:felloapp/core/model/bookings/payment_polling.dart';
import 'package:felloapp/core/repository/experts_repo.dart';
import 'package:felloapp/core/service/analytics/analytics_service.dart';
import 'package:felloapp/core/service/notifier_services/user_service.dart';
import 'package:felloapp/feature/expert/bloc/cart_bloc.dart';
import 'package:felloapp/navigator/app_state.dart';
import 'package:felloapp/ui/pages/hometabs/save/save_viewModel.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'polling_event.dart';
part 'polling_state.dart';

class PollingBloc extends Bloc<PollingEvent, PollingState> {
  final ExpertsRepository _expertsRepository;
  final SaveViewModel _saveViewModel;
  final UserService _userService;
  final AnalyticsService _analyticsService;
  PollingBloc(
    this._expertsRepository,
    this._saveViewModel,
    this._userService,
    this._analyticsService,
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
      unawaited(_saveViewModel.getUpcomingBooking());
      unawaited(_userService.getUserFundWalletData());
      _analyticsService.track(
        eventName: AnalyticsEvents.paymentStatus,
        properties: {
          "status": "Success",
        },
      );
      AppState.delegate!.navigatorKey.currentContext!.read<CartBloc>().add(
            ClearCart(),
          );
    } else if (response.isSuccess() &&
        data != null &&
        data.data.paymentDetails!.status == BookingPaymentStatus.pending) {
      emitter(
        CompletedPollingWithPending(data),
      );
      unawaited(_saveViewModel.getUpcomingBooking());
      unawaited(_userService.getUserFundWalletData());
      _analyticsService.track(
        eventName: AnalyticsEvents.paymentStatus,
        properties: {
          "status": "Pending",
        },
      );
    } else {
      emitter(
        CompletedPollingWithFailure(
          response.errorMessage ?? 'Failed to check status',
        ),
      );
      _analyticsService.track(
        eventName: AnalyticsEvents.paymentStatus,
        properties: {
          "status": "Failure",
        },
      );
    }
  }
}
