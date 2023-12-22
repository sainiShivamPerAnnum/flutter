part of 'fello_badges_cubit.dart';

@immutable
sealed class FelloBadgesState {
  const FelloBadgesState();
}

class FelloBadgesInitial extends FelloBadgesState {
  const FelloBadgesInitial();
}

class FelloBadgesLoading extends FelloBadgesState {
  const FelloBadgesLoading();
}

class FelloBadgesSuccess extends FelloBadgesState {
  final FelloBadgesData felloBadgesModel;
  final SuperFelloLevel userLevel;
  final BadgesLeaderBoardModel? badgesLeaderBoardModel;

  const FelloBadgesSuccess(
    this.felloBadgesModel, {
    required this.userLevel,
    this.badgesLeaderBoardModel,
  });

  FelloBadgesSuccess copyWith({
    FelloBadgesData? felloBadgesModel,
    SuperFelloLevel? level,
    BadgesLeaderBoardModel? badgesLeaderBoardModel,
  }) {
    return FelloBadgesSuccess(
      userLevel: level ?? userLevel,
      felloBadgesModel ?? this.felloBadgesModel,
      badgesLeaderBoardModel:
          badgesLeaderBoardModel ?? this.badgesLeaderBoardModel,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is FelloBadgesSuccess &&
        other.felloBadgesModel == felloBadgesModel &&
        other.badgesLeaderBoardModel == badgesLeaderBoardModel &&
        other.userLevel == userLevel;
  }

  @override
  int get hashCode {
    return felloBadgesModel.hashCode ^ badgesLeaderBoardModel.hashCode;
  }

  @override
  String toString() {
    return 'FelloBadgesSuccess(felloBadgesModel: $felloBadgesModel, badgesLeaderBoardModel: $badgesLeaderBoardModel)';
  }
}

class FelloBadgesError extends FelloBadgesState {
  final String errorMsg;

  const FelloBadgesError(this.errorMsg);
}
