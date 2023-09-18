part of 'fello_badges_cubit.dart';

@immutable
abstract class FelloBadgesState {}

class FelloBadgesInitial extends FelloBadgesState {}

class FelloBadgesLoading extends FelloBadgesState {}

class FelloBadgesSuccess extends FelloBadgesState {
  final FelloBadgesData felloBadgesModel;
  final FelloBadges currentBadge;
  final int currentLevel;

  FelloBadgesSuccess(this.felloBadgesModel, {required this.currentBadge})
      : currentLevel = felloBadgesModel.currentLevel ?? 1;
}

class FelloBadgesError extends FelloBadgesState {
  final String? errorMsg;

  FelloBadgesError(this.errorMsg) : assert(errorMsg != null);
}
