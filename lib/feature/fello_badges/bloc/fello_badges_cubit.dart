import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:collection/collection.dart';
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
        super(const FelloBadgesInitial());

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
    emit(const FelloBadgesLoading());

    try {
      await _repo.getFelloBadges().then((res) async {
        if (res.isSuccess()) {
          emit(
            FelloBadgesSuccess(
              res.model!.data,
              currentBadge: updateLevel(1),
            ),
          );

          unawaited(callLeaderBoardApi());

          await _postBadgeFetchHook(
            res.model!.data,
            onBadgeLevelChanged: _showBadgeAchievedPopup,
          );
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
      await locator<CampaignRepo>().getBadgesLeaderBoard().then(
        (res) async {
          if (res.isSuccess()) {
            emit(
              (state as FelloBadgesSuccess).copyWith(
                badgesLeaderBoardModel: res.model,
              ),
            );
          }
        },
      );
    } catch (e) {
      log(e.toString(), name: "BadgesLeaderBoardModel");
    }
  }

  Future<void> _postBadgeFetchHook(
    FelloBadgesData currentBadgeInfo, {
    ValueChanged<BadgeLevelInformation>? onBadgeLevelChanged,
  }) async {
    final cachedBadgeInfo = await _getCachedDetails();

    if (cachedBadgeInfo != null) {
      final badgeInformation = await _checkForBadgeUpdate(
        currentBadgeInfo: currentBadgeInfo,
        cachedBadgeInfo: cachedBadgeInfo,
      );

      if (badgeInformation != null) {
        onBadgeLevelChanged?.call(badgeInformation);
      }
    }

    await _cacheDetails(currentBadgeInfo);
  }

  Future<FelloBadgesData?> _getCachedDetails() async {
    final cache = PreferenceHelper.getString(
      PreferenceHelper.badgeLevelData,
    );

    if (cache.isEmpty) {
      return null;
    }

    final cachedMap = jsonDecode(cache);
    final cachedBadgeInfo = FelloBadgesData.fromJson(cachedMap);
    return cachedBadgeInfo;
  }

  /// Checks for badges updates for any level.
  ///
  /// If there is any badge which has been not completed according to previous
  /// status and has been completed in [currentBadgeInfo] then it captures that
  /// and provides the last badge out of which has status change.
  ///
  /// The current logic doesn't handles this cases:
  /// - If there is addition of the new level, in that if there is
  /// addition and that particular is being received as complete from backend.
  /// - If there is addition of the new badge level inside any particular level
  /// and that badge level is received as completed.
  Future<BadgeLevelInformation?> _checkForBadgeUpdate({
    required FelloBadgesData currentBadgeInfo,
    required FelloBadgesData cachedBadgeInfo,
  }) async {
    final currentLevels = currentBadgeInfo.levels;
    if (currentLevels.isEmpty) {
      return null;
    }

    final cachedLevels = cachedBadgeInfo.levels;

    BadgeLevelInformation? badgeToBeDisplayed;

    for (var i = 0; i < cachedLevels.length; i++) {
      final cachedLevel = cachedLevels[i];
      final currentLevel = currentLevels.firstWhereOrNull(
        (e) => e.level == cachedLevel.level,
      );

      if (currentLevel == null) {
        continue;
      }

      final cachedLevelData = cachedLevel.lvlData;
      final currentLevelData = currentLevel.lvlData;

      for (var j = 0; j < cachedLevelData.length; j++) {
        final cachedBadgeLevel = cachedLevelData[j];
        final currentBadgeLevel = currentLevelData.firstWhereOrNull(
          (e) => e.id == cachedBadgeLevel.id,
        );

        if (currentBadgeLevel == null) {
          continue;
        }

        if (!cachedBadgeLevel.isBadgeAchieved &&
            currentBadgeLevel.isBadgeAchieved) {
          badgeToBeDisplayed = currentBadgeLevel;
        }
      }
    }

    return badgeToBeDisplayed;
  }

  Future<void> _cacheDetails(FelloBadgesData levelDetails) async {
    final json = levelDetails.toJson();
    final encoded = jsonEncode(json);
    await PreferenceHelper.setString(
      PreferenceHelper.badgeLevelData,
      encoded,
    );
  }

  void _showBadgeAchievedPopup(BadgeLevelInformation badgeInformation) {
    BaseUtil.openDialog(
      isBarrierDismissible: true,
      addToScreenStack: true,
      hapticVibrate: true,
      content: BadgeUnlockDialog(
        badgeInformation: badgeInformation,
      ),
    );
  }
}
