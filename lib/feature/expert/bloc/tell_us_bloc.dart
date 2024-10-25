import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:felloapp/base_util.dart';
import 'package:felloapp/core/repository/experts_repo.dart';
import 'package:felloapp/navigator/app_state.dart';

part 'tell_us_event.dart';
part 'tell_us_state.dart';

class TellUsBloc extends Bloc<TellUsEvent, TellUsState> {
  final ExpertsRepository _expertsRepository;
  TellUsBloc(
    this._expertsRepository,
  ) : super(const InitialTellUsState()) {
    on<SubmitQNA>(_onSubmitAnswers);
  }
  FutureOr<void> _onSubmitAnswers(
    SubmitQNA event,
    Emitter<TellUsState> emitter,
  ) async {
    emitter(const SubmittingAnswers());
    final response = await _expertsRepository.submitQNA(
      detailsQA: event.detailsQA,
      bookingID: event.bookingID,
    );
    final data = response.model;
    if (response.isSuccess() && data != null) {
      emitter(
        const SubmitedAnswers(),
      );
      await AppState.backButtonDispatcher!.didPopRoute();
    } else {
      emitter(
        SubmittingAnswersFailed(
          response.errorMessage ?? 'Failed to post QNA!',
        ),
      );
      BaseUtil.showNegativeAlert(
        'Failed to post QNA!',
        response.errorMessage ?? 'Try Again!',
      );
    }
  }
}
