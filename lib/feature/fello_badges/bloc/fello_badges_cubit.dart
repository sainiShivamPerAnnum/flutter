import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:felloapp/core/model/badges_leader_board_model.dart';
import 'package:felloapp/core/model/fello_badges_model.dart';
import 'package:felloapp/core/repository/campaigns_repo.dart';
import 'package:felloapp/util/locator.dart';
import 'package:felloapp/util/preference_helper.dart';
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
      : _repo = locator<CampaignRepo>(),
        super(FelloBadgesInitial());

  final CampaignRepo _repo;

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
              currentBadge: updateLevel(1)));

          callLeaderBoardApi();

          /// Storing the timeStamp of the Api call
          PreferenceHelper.setInt(
              PreferenceHelper.CACHE_SUPERFELLO_BADGE_API_TIMESTAMP,
              DateTime.now().millisecondsSinceEpoch);
        } else {
          emit(FelloBadgesError(res.model?.message ?? "Something went wrong!"));
        }
      });
    } catch (e) {
      emit(FelloBadgesError(e.toString()));
    }
  }

  Future<void> callLeaderBoardApi() async {
    try {
      var currentState = state;

      if (currentState is FelloBadgesSuccess) {
        await locator<CampaignRepo>().getBadgesLeaderboard().then(
          (res) {
            if (res.isSuccess()) {
              log("BadgesLeaderBoardModel: ${res.model?.toJson()}");

              emit(currentState.copyWith(badgesLeaderBoardModel: res.model));
            }
          },
        );
      }
    } catch (e) {
      print(e.toString());
    }
  }

// create a function that check & compare the CACHE_SUPERFELLO_BADGE_API_TIMESTAMP
// with the LevelDetails[i].updateAt
// if the CACHE_SUPERFELLO_BADGE_API_TIMESTAMP is less than the LevelDetails[i].updateAt, then update the badge
// else, do nothing

  void checkBadgeUpdate(List<LvlDatum> levelDetails) {
    final currentTimeStamp = PreferenceHelper.getInt(
        PreferenceHelper.CACHE_SUPERFELLO_BADGE_API_TIMESTAMP,
        def: DateTime.now().millisecondsSinceEpoch);

    // for (int i = 0; i < levelDetails.length; i++) {
    //   if (currentTimeStamp < levelDetails[i].updatedAt && (levelDetails[i].achieve ?? 0) >= 100) {
    //     updateLevel(i);
    //   }
    // }
  }

  void showPopUp() {}
}
