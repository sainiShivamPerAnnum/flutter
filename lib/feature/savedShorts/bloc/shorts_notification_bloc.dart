import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:felloapp/base_util.dart';
import 'package:felloapp/core/model/shorts/shorts_home.dart';
import 'package:felloapp/core/repository/shorts_repo.dart';

part 'shorts_notification_event.dart';
part 'shorts_notification_state.dart';

class ShortsNotificationBloc extends Bloc<SavedShortsEvents, SavedShortsState> {
  final ShortsRepository _shortsRepository;
  ShortsNotificationBloc(
    this._shortsRepository,
  ) : super(const LoadingSavedShortsDetails()) {
    on<LoadSavedData>(_onLoadShortsHomeData);
    on<ToogleNotification>(_toggleNotification);
  }
  FutureOr<void> _onLoadShortsHomeData(
    LoadSavedData event,
    Emitter<SavedShortsState> emitter,
  ) async {
    emitter(const LoadingSavedShortsDetails());

    final data = await _shortsRepository.getSaved();
    if (data.isSuccess()) {
      emitter(
        SavedShortsData(
          shortsHome: ShortsHome(allCategories: [], shorts: data.model!),
        ),
      );
    } else {
      emitter(LoadingSavedShortsFailed(errorMessage: data.errorMessage));
    }
  }

  FutureOr<void> _toggleNotification(
    ToogleNotification event,
    Emitter<SavedShortsState> emitter,
  ) async {
    final data = await _shortsRepository.toggleNotification(
      theme: event.theme,
      isFollowed: event.isFollowed,
    );
    if (data.isSuccess()) {
      final currentState = state as SavedShortsData;
      final updatedThemes = currentState.shortsHome.shorts.map((theme) {
        if (theme.theme == event.theme) {
          return theme.copyWith(isNotificationOn: !event.isFollowed);
        }
        return theme;
      }).toList();
      emitter(
        SavedShortsData(
          shortsHome: ShortsHome(
            allCategories: currentState.shortsHome.allCategories,
            shorts: updatedThemes,
          ),
        ),
      );
      if (event.isFollowed) {
        BaseUtil.showPositiveAlert(
          "Notifications turned off",
          "You won't be notified when a new short is uploaded.",
        );
      } else {
        BaseUtil.showPositiveAlert(
          "Notifications turned on",
          "You’ll be notified when a new short is uploaded!",
        );
      }
    } else {
      BaseUtil.showNegativeAlert(
        "Failed to turn on notifications",
        "Please try again later",
      );
    }
  }
}
