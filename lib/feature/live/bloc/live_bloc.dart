import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:felloapp/base_util.dart';
import 'package:felloapp/core/model/live/live_home.dart';
import 'package:felloapp/core/repository/live_repository.dart';

part 'live_event.dart';
part 'live_state.dart';

class LiveBloc extends Bloc<LiveEvent, LiveState> {
  final LiveRepository _liveRepository;
  LiveBloc(
    this._liveRepository,
  ) : super(const LoadingHomeData()) {
    on<LoadHomeData>(_onLoadHomeData);
    on<TurnOnNotification>(_onNotificationTrigger);
  }
  FutureOr<void> _onLoadHomeData(
    LoadHomeData event,
    Emitter<LiveState> emitter,
  ) async {
    emitter(const LoadingHomeData());
    final data = await _liveRepository.getLiveHomeData();
    if (data.isSuccess()) {
      final res = data.model!.upcoming;
      final Map<String, bool> notificationStatus = {};
      for (final item in res) {
        notificationStatus[item.id] = item.addedToNotify;
      }
      emitter(
        LiveHomeData(
          homeData: data.model,
          notificationStatus: notificationStatus,
        ),
      );
    }
  }

  FutureOr<void> _onNotificationTrigger(
    TurnOnNotification event,
    Emitter<LiveState> emitter,
  ) async {
    final res = await _liveRepository.notifyEvent(id: event.id);
    if (res.isSuccess()) {
      final currentState = state as LiveHomeData;
      final updatedNotificationStatus =
          Map<String, bool>.from(currentState.notificationStatus)
            ..[event.id] = true;

      emitter(
        currentState.copyWith(notificationStatus: updatedNotificationStatus),
      );
      BaseUtil.showPositiveAlert(
        'Notification Enabled Successfully',
        'You will now receive updates for this event.',
      );
    } else {
      BaseUtil.showNegativeAlert(
        'Failed to enable notification',
        'Please try again later.',
      );
    }
  }
}
