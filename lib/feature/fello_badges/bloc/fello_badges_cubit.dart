import 'package:bloc/bloc.dart';
import 'package:felloapp/core/model/fello_badges_model.dart';
import 'package:felloapp/core/repository/journey_repo.dart';
import 'package:felloapp/util/locator.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';

part 'fello_badges_state.dart';

enum FelloBadges {
  Beginner,
  Intermediate,
  SuperFello_InProgress,
  SuperFello_Complete,
}

class FelloBadgesCubit extends Cubit<FelloBadgesState> {
  FelloBadgesCubit()
      : _repo = locator<JourneyRepository>(),
        super(FelloBadgesInitial());

  final JourneyRepository _repo;

  FelloBadges updateLevel(int i) {
    switch (i) {
      case 1:
        return FelloBadges.Beginner;
      case 2:
        return FelloBadges.Intermediate;
      case 3:
        return FelloBadges.SuperFello_InProgress;
      case 4:
        return FelloBadges.SuperFello_Complete;
      default:
        return FelloBadges.Beginner;
    }
  }

  Future<void> getFelloBadges() async {
    emit(FelloBadgesLoading());

    try {
      await _repo.getFelloBadges().then((res) {
        if (res.isSuccess()) {
          emit(FelloBadgesSuccess(res.model!.data!,
              currentBadge: updateLevel(res.model!.data!.currentLevel ?? 1)));
        } else {
          emit(FelloBadgesError(res.model?.message ?? "Something went wrong!"));
        }
      });
    } catch (e) {
      emit(FelloBadgesError(e.toString()));
    }
  }
}
