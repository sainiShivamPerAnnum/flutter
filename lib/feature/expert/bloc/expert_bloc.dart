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
    on<SearchExperts>(_searchExpert);
  }

  FutureOr<void> _onLoadExpertsData(
    ExpertEvent event,
    Emitter<ExpertState> emitter,
  ) async {
    try {
      emitter(const LoadingExpertsData());
      final data = await _expertsRepository.getExpertsHomeData();
      if (data.isSuccess() && data.model != null) {
        emitter(ExpertHomeLoaded(expertsHome: data.model!, query: ''));
      } else {
        emitter(
          LoadingExpertsFailed(
            errorMessage: data.errorMessage ?? 'Error loading expert data',
          ),
        );
      }
    } catch (e) {
      emitter(
        LoadingExpertsFailed(
          errorMessage: e.toString(),
        ),
      );
    }
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

  FutureOr<void> _searchExpert(
    SearchExperts event,
    Emitter<ExpertState> emitter,
  ) async {
    try {
      if (event.query.trim() != '') {
        final data = await _expertsRepository.applyQuery(query: event.query);
        if (data.isSuccess() && data.model != null) {
          if (state is ExpertHomeLoaded) {
            final currentState = state as ExpertHomeLoaded;
            final updatedState = currentState.copyWith(
              searchResults: data.model!,
              query: event.query,
            );
            emitter(updatedState);
          }
        } else {
          emitter(
            LoadingExpertsFailed(
              errorMessage: data.errorMessage ?? 'Error getting search results',
            ),
          );
        }
      }
    } catch (e) {
      emitter(
        LoadingExpertsFailed(
          errorMessage: e.toString(),
        ),
      );
    }
  }
}
