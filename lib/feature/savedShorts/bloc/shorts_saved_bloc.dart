import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:felloapp/base_util.dart';
import 'package:felloapp/core/model/shorts/shorts_home.dart';
import 'package:felloapp/core/repository/shorts_repo.dart';

part 'shorts_saved_event.dart';
part 'shorts_saved_state.dart';

class ShortsSavedBloc extends Bloc<SavedShortsEvents, SavedShortsState> {
  final ShortsRepository _shortsRepository;
  ShortsSavedBloc(
    this._shortsRepository,
  ) : super(const LoadingSavedShortsDetails()) {
    on<LoadSavedData>(_onLoadShortsHomeData);
    on<ToogleNotification>(_toggleNotification);
    on<RemoveSaved>(_onRemoveShort);
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
          shortsHome: data.model!,
        ),
      );
    } else {
      emitter(LoadingSavedShortsFailed(errorMessage: data.errorMessage));
    }
  }

  FutureOr _onRemoveShort(
    RemoveSaved event,
    Emitter emitter,
  ) async {
    if (state is SavedShortsData) {
      final currentState = state as SavedShortsData;
      final updatedShortsHome = currentState.shortsHome
          .where((short) => short.videos.every((video) => video.id != event.id))
          .toList();

      emitter(
        SavedShortsData(
          shortsHome: updatedShortsHome,
        ),
      );
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
      final updatedThemes = currentState.shortsHome.map((theme) {
        if (theme.theme == event.theme) {
          return theme.copyWith(isNotificationOn: !event.isFollowed);
        }
        return theme;
      }).toList();
      emitter(
        SavedShortsData(
          shortsHome: updatedThemes,
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
