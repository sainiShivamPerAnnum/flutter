part of 'fello_badges_cubit.dart';

@immutable
abstract class FelloBadgesState {}

class FelloBadgesInitial extends FelloBadgesState {}

class FelloBadgesLoading extends FelloBadgesState {}

class FelloBadgesSuccess extends FelloBadgesState {
  final FelloBadgesData felloBadgesModel;
  final FelloBadges currentBadge;
  final int currentLevel;
  final BadgesLeaderBoardModel? badgesLeaderBoardModel;

  FelloBadgesSuccess(this.felloBadgesModel,
      {required this.currentBadge, this.badgesLeaderBoardModel})
      : currentLevel = felloBadgesModel.currentLevel ?? 1;

  FelloBadgesSuccess copyWith({
    FelloBadgesData? felloBadgesModel,
    FelloBadges? currentBadge,
    int? currentLevel,
    BadgesLeaderBoardModel? badgesLeaderBoardModel,
  }) {
    return FelloBadgesSuccess(
      felloBadgesModel ?? this.felloBadgesModel,
      currentBadge: currentBadge ?? this.currentBadge,
      badgesLeaderBoardModel:
          badgesLeaderBoardModel ?? this.badgesLeaderBoardModel,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is FelloBadgesSuccess &&
        other.felloBadgesModel == felloBadgesModel &&
        other.currentBadge == currentBadge &&
        other.currentLevel == currentLevel &&
        other.badgesLeaderBoardModel == badgesLeaderBoardModel;
  }

  @override
  int get hashCode {
    return felloBadgesModel.hashCode ^
        currentBadge.hashCode ^
        currentLevel.hashCode ^
        badgesLeaderBoardModel.hashCode;
  }

  @override
  String toString() {
    return 'FelloBadgesSuccess(felloBadgesModel: $felloBadgesModel, currentBadge: $currentBadge, currentLevel: $currentLevel, badgesLeaderBoardModel: $badgesLeaderBoardModel)';
  }
}

class FelloBadgesError extends FelloBadgesState {
  final String? errorMsg;

  FelloBadgesError(this.errorMsg) : assert(errorMsg != null);
}
