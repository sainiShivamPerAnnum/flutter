part of 'advisor_bloc.dart';

sealed class AdvisorState extends Equatable {
  const AdvisorState();
}

class LoadingAdvisorData extends AdvisorState {
  const LoadingAdvisorData();

  @override
  List<Object?> get props => const [];
}

class ErrorAdvisorData extends AdvisorState {
  const ErrorAdvisorData({
    required this.message,
  });
  final String message;

  @override
  List<Object?> get props => [message];
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
  AdvisorData copyWith({
    List<AdvisorEvents>? advisorEvents,
    List<AdvisorCall>? advisorUpcomingCalls,
    List<AdvisorCall>? advisorPastCalls,
  }) {
    return AdvisorData(
      advisorEvents: advisorEvents ?? this.advisorEvents,
      advisorUpcomingCalls: advisorUpcomingCalls ?? this.advisorUpcomingCalls,
      advisorPastCalls: advisorPastCalls ?? this.advisorPastCalls,
    );
  }
}
