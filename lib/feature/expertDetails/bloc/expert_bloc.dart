import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:felloapp/core/model/experts/experts_details.dart';
import 'package:felloapp/core/model/live/live_home.dart';
import 'package:felloapp/core/repository/experts_repo.dart';
import 'package:felloapp/feature/shorts/src/service/video_data.dart';

part 'expert_event.dart';
part 'expert_state.dart';

class ExpertDetailsBloc extends Bloc<ExpertDetailsEvent, ExpertDetailsState> {
  final ExpertsRepository _expertsRepository;
  ExpertDetailsBloc(
    this._expertsRepository,
  ) : super(const LoadingExpertsDetails()) {
    on<LoadExpertsDetails>(_onLoadExpertsData);
    on<TabChanged>(_tabChanged);
  }
  FutureOr<void> _onLoadExpertsData(
    LoadExpertsDetails event,
    Emitter<ExpertDetailsState> emitter,
  ) async {
    emitter(const LoadingExpertsDetails());
    final data = await _expertsRepository.getExperDetailsByID(
      advisorId: event.advisorId,
    );
    emitter(ExpertDetailsLoaded(expertDetails: data.model));
  }

  FutureOr<void> _tabChanged(
    TabChanged event,
    Emitter<ExpertDetailsState> emitter,
  ) async {
    if (state is ExpertDetailsLoaded) {
      final currentState = state as ExpertDetailsLoaded;
      if (currentState.currentTab != event.tab) {
        final updatedState = currentState.copyWith(currentTab: event.tab);
        emitter(updatedState);
      }
      if (event.tab == 1) {
          final tabOneData = await _expertsRepository.getShortsByAdvisor(
          advisorId: event.advisorId,
        );
        emitter(currentState.copyWith(
          currentTab: event.tab,
          shortsData: tabOneData.model,
        ),);
      } else if (event.tab == 2) {
        final tabTwoData = await _expertsRepository.getLiveByAdvisor(
          advisorId: event.advisorId,
        );
        emitter(currentState.copyWith(
          currentTab: event.tab,
          recentLive: tabTwoData.model,
        ),);
      }
    }
  }
}
