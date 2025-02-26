import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:felloapp/base_util.dart';
import 'package:felloapp/core/model/shorts/shorts_home.dart';
import 'package:felloapp/core/repository/shorts_repo.dart';
// import 'package:felloapp/util/debouncer.dart';

part 'shorts_home_event.dart';
part 'shorts_home_state.dart';

class ShortsHomeBloc extends Bloc<ShortsHomeEvents, ShortsHomeState> {
  final ShortsRepository _shortsRepository;
  ShortsHomeBloc(
    this._shortsRepository,
  ) : super(const LoadingShortsDetails()) {
    on<LoadHomeData>(_onLoadShortsHomeData);
    on<SearchShorts>(_searchShorts);
    on<ApplyCategory>(_onCategoryApply);
    on<ToogleNotification>(_toggleNotification);
  }
  FutureOr<void> _onLoadShortsHomeData(
    LoadHomeData event,
    Emitter<ShortsHomeState> emitter,
  ) async {
    emitter(const LoadingShortsDetails());

    final data = await _shortsRepository.getShortsHomeData();
    if (data.isSuccess()) {
      emitter(ShortsHomeData(shortsHome: data.model!, query: ''));
    } else {
      emitter(LoadingShortsFailed(errorMessage: data.errorMessage));
    }
  }

  FutureOr<void> _toggleNotification(
    ToogleNotification event,
    Emitter<ShortsHomeState> emitter,
  ) async {
    final data = await _shortsRepository.toggleNotification(
      theme: event.theme,
      isFollowed: event.isFollowed,
    );
    if (data.isSuccess()) {
      final currentState = state as ShortsHomeData;
      final updatedThemes = currentState.shortsHome.shorts.map((theme) {
        if (theme.theme == event.theme) {
          return theme.copyWith(isNotificationOn: !event.isFollowed);
        }
        return theme;
      }).toList();
      emitter(
        ShortsHomeData(
          shortsHome: ShortsHome(
            allCategories: currentState.shortsHome.allCategories,
            shorts: updatedThemes,
          ),
          query: currentState.query,
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

  FutureOr<void> _searchShorts(
    SearchShorts event,
    Emitter<ShortsHomeState> emitter,
  ) async {
    if (event.query.trim() != '') {
      emitter(const LoadingShortsDetails());
      final data = await _shortsRepository.applyQuery(query: event.query);
      if (data.isSuccess()) {
        emitter(
          ShortsHomeData(
            shortsHome: ShortsHome(allCategories: [], shorts: data.model!),
            query: event.query.trim(),
          ),
        );
      } else {
        emitter(LoadingShortsFailed(errorMessage: data.errorMessage));
      }
    }
  }

  FutureOr<void> _onCategoryApply(
    ApplyCategory event,
    Emitter<ShortsHomeState> emitter,
  ) async {
    emitter(const LoadingShortsDetails());

    final data = await _shortsRepository.applyCategory(query: event.query);
    if (data.isSuccess()) {
      emitter(
        ShortsHomeData(
          shortsHome: ShortsHome(allCategories: [], shorts: data.model!),
          query: event.query.trim(),
        ),
      );
    } else {
      emitter(LoadingShortsFailed(errorMessage: data.errorMessage));
    }
  }
}
