import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:felloapp/core/model/experts/experts_home.dart';
import 'package:felloapp/core/repository/experts_repo.dart';

part 'expert_event.dart';
part 'expert_state.dart';

class ExpertBloc extends Bloc<ExpertEvent, ExpertState> {
  final ExpertsRepository _expertsRepository;
  ExpertBloc(
    this._expertsRepository,
  ) : super(const LoadingExpertsData()) {
    on<LoadExpertsData>(_onLoadExpertsData);
    on<SectionChanged>(_onSectionChanged);
  }
  FutureOr<void> _onLoadExpertsData(
    ExpertEvent event,
    Emitter<ExpertState> emitter,
  ) async {
    emitter(const LoadingExpertsData());
    final data = await _expertsRepository.getExpertsHomeData();
    emitter(ExpertHomeLoaded(expertsHome: data.model));
  }

  FutureOr<void> _onSectionChanged(
    SectionChanged event,
    Emitter<ExpertState> emitter,
  ) {
    if (state is ExpertHomeLoaded) {
      final currentState = state as ExpertHomeLoaded;
      final updatedState =
          currentState.copyWith(currentSection: event.newSection);
      emitter(updatedState);
    }
  }
}
