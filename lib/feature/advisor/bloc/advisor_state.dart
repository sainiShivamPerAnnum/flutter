part of 'advisor_bloc.dart';

sealed class AdvisorState extends Equatable {
  const AdvisorState();
}

class LoadingAdvisorData extends AdvisorState {
  const LoadingAdvisorData();

  @override
  List<Object?> get props => const [];
}

final class AdvisorData extends AdvisorState {
  final List<AdvisorEvents> advisorEvents;
  final List<AdvisorCall> advisorUpcomingCalls;
  final List<AdvisorCall> advisorPastCalls;
  const AdvisorData({
    this.advisorEvents = const [],
    this.advisorUpcomingCalls = const [],
    this.advisorPastCalls = const [],
  });
  @override
  List<Object?> get props => [
        advisorEvents,
        advisorUpcomingCalls,
        advisorPastCalls,
      ];
}
