part of 'tell_us_bloc.dart';

sealed class TellUsState extends Equatable {
  const TellUsState();
}

class InitialTellUsState extends TellUsState {
  const InitialTellUsState();
  @override
  List<Object?> get props => const [];
}

class SubmittingAnswers extends TellUsState {
  const SubmittingAnswers();
  @override
  List<Object?> get props => [];
}


class SubmittingAnswersFailed extends TellUsState {
  const SubmittingAnswersFailed(this.message);
  final String message;
  @override
  List<Object?> get props => [message];
}


class SubmitedAnswers extends TellUsState {
  const SubmitedAnswers();
  @override
  List<Object?> get props => [];
}
