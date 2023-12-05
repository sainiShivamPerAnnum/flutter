import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:felloapp/base_util.dart';
import 'package:felloapp/core/model/badges_leader_board_model.dart';
import 'package:felloapp/core/model/fello_badges_model.dart';
import 'package:felloapp/core/repository/campaigns_repo.dart';
import 'package:felloapp/core/service/notifier_services/user_service.dart';
import 'package:felloapp/feature/fello_badges/ui/widgets/badge_unlock_popup.dart';
import 'package:felloapp/util/constants.dart';
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
          emit(FelloBadgesSuccess(res.model!.data,
              currentBadge: updateLevel(1)));

          callLeaderBoardApi();
        } else {
          emit(FelloBadgesError(res.model?.message ??
              "Something went wrong!\nPlease Try Again later"));
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
              emit(currentState.copyWith(badgesLeaderBoardModel: res.model));

              checkBadgeUpdate(currentState.felloBadgesModel.levels);
            }
          },
        );
      }
    } catch (e) {
      log(e.toString(), name: "BadgesLeaderBoardModel");
    }
  }

// create a function that check & compare the CACHE_SUPERFELLO_BADGE_API_TIMESTAMP
// with the LevelDetails[i].updateAt
// if the CACHE_SUPERFELLO_BADGE_API_TIMESTAMP is less than the LevelDetails[i].updateAt, then update the badge
// else, do nothing

  Future<void> checkBadgeUpdate(List<Level> levelDetails) async {
    final currentTimeStamp = PreferenceHelper.getString(
        PreferenceHelper.CACHE_SUPERFELLO_BADGE_API_TIMESTAMP,
        def: DateTime.now().toString());

    var temp = DateTime.parse(currentTimeStamp);

    for (int i = 0; i < levelDetails.length; i++) {
      for (int j = 0; j < levelDetails[i].lvlData.length; j++) {
        if (temp.isBefore(levelDetails[i].lvlData[j].updatedAt) ||
            temp.isAtSameMomentAs(levelDetails[i].lvlData[j].updatedAt)) {
          showPopUp(
            title: levelDetails[i].lvlData[j].title,
            subtitle: levelDetails[i].lvlData[j].barHeading,
            imageUrl: levelDetails[i].lvlData[j].badgeurl,
            actionUri: '',
          );
          break;
        } else {
          log("Badge Not Updated");
        }
      }
    }
  }

  void showPopUp(
      {String? title, String? subtitle, String? imageUrl, String? actionUri}) {
    BaseUtil.openDialog(
      isBarrierDismissible: true,
      addToScreenStack: true,
      hapticVibrate: true,
      content: BadgeUnlockDialog(
        title: title,
        subtitle: subtitle,
        imageUrl: imageUrl,
        actionUri: actionUri,
      ),
    );

    /// Storing the timeStamp of the Api call
    PreferenceHelper.setString(
        PreferenceHelper.CACHE_SUPERFELLO_BADGE_API_TIMESTAMP,
        DateTime.now().toString());
  }
}
