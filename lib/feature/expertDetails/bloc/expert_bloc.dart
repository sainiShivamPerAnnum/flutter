import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:felloapp/core/model/experts/experts_details.dart';
import 'package:felloapp/core/repository/experts_repo.dart';

part 'expert_event.dart';
part 'expert_state.dart';

class ExpertDetailsBloc extends Bloc<ExpertDetailsEvent, ExpertDetailsState> {
  final ExpertsRepository _expertsRepository;
  ExpertDetailsBloc(
    this._expertsRepository,
  ) : super(const LoadingExpertsDetails()) {
    on<LoadExpertsDetails>(_onLoadExpertsData);
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
}
