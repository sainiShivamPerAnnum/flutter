import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:felloapp/base_util.dart';
import 'package:felloapp/core/model/advisor/advisor_events.dart';
import 'package:felloapp/core/model/advisor/advisor_upcoming_call.dart';
import 'package:felloapp/core/repository/advisor_repo.dart';
part 'advisor_event.dart';
part 'advisor_state.dart';

class AdvisorBloc extends Bloc<AdvisorEvent, AdvisorState> {
  final AdvisorRepo _advisorRepo;
  AdvisorBloc(
    this._advisorRepo,
  ) : super(const LoadingAdvisorData()) {
    on<LoadAdvisorData>(_onLoadHomeData);
  }
  FutureOr<void> _onLoadHomeData(
    LoadAdvisorData event,
    Emitter<AdvisorState> emitter,
  ) async {
    emitter(const LoadingAdvisorData());

    List<AdvisorEvents> advisorEvents = [];
    List<AdvisorCall> advisorUpcomingCalls = [];
    List<AdvisorCall> advisorPastCalls = [];

    try {
      final response2 = await _advisorRepo.getUpcomingCalls();
      if (response2.isSuccess()) {
        advisorUpcomingCalls = response2.model ?? [];
      } else {
        BaseUtil.showNegativeAlert(
          'Error',
          response2.errorMessage ?? 'Failed to load upcoming calls.',
        );
      }
    } catch (e) {
      BaseUtil.showNegativeAlert(
        'Error',
        'An error occurred while loading upcoming calls.',
      );
    }

    try {
      final response3 = await _advisorRepo.getPastCalls();
      if (response3.isSuccess()) {
        advisorPastCalls = response3.model ?? [];
      } else {
        BaseUtil.showNegativeAlert(
          'Error',
          response3.errorMessage ?? 'Failed to load past calls.',
        );
      }
    } catch (e) {
      BaseUtil.showNegativeAlert(
        'Error',
        'An error occurred while loading past calls.',
      );
    }
    try {
      final response = await _advisorRepo.getEvents();
      if (response.isSuccess()) {
        advisorEvents = response.model ?? [];
      } else {
        BaseUtil.showNegativeAlert(
          'Error',
          response.errorMessage ?? 'Failed to load advisor events.',
        );
      }
    } catch (e) {
      BaseUtil.showNegativeAlert(
        'Error',
        'An error occurred while loading advisor events.',
      );
    }

    if (state is AdvisorData) {
      final currentState = state as AdvisorData;
      emitter(
        currentState.copyWith(
          advisorEvents: advisorEvents.toList(),
          advisorUpcomingCalls: advisorUpcomingCalls.toList(),
          advisorPastCalls: advisorPastCalls.toList(),
        ),
      );
    } else {
      emitter(
        AdvisorData(
          advisorEvents: advisorEvents.toList(),
          advisorUpcomingCalls: advisorUpcomingCalls.toList(),
          advisorPastCalls: advisorPastCalls.toList(),
        ),
      );
    }
  }
}
