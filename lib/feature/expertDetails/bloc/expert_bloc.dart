import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:felloapp/base_util.dart';
import 'package:felloapp/core/model/experts/experts_details.dart';
import 'package:felloapp/core/repository/experts_repo.dart';
import 'package:felloapp/feature/shorts/src/service/video_data.dart';
import 'package:felloapp/util/local_actions_state.dart';

part 'expert_event.dart';
part 'expert_state.dart';

class ExpertDetailsBloc extends Bloc<ExpertDetailsEvent, ExpertDetailsState> {
  final ExpertsRepository _expertsRepository;
  ExpertDetailsBloc(
    this._expertsRepository,
  ) : super(const LoadingExpertsDetails()) {
    on<LoadExpertsDetails>(_onLoadExpertsData);
    on<TabChanged>(_tabChanged);
    on<GetCertificate>(_getCertificate);
    on<FollowAdvisor>(_onFollowAdvisor);
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

  FutureOr<void> _onFollowAdvisor(
    FollowAdvisor event,
    Emitter<ExpertDetailsState> emitter,
  ) async {
    try {
      if (state is ExpertDetailsLoaded) {
        final currentState = state as ExpertDetailsLoaded;
        final followed = LocalActionsState.getAdvisorFollowed(
          event.advisorId,
          event.isFollowed,
        );

        unawaited(
          _expertsRepository.followAdvisor(
            event.isFollowed,
            event.advisorId,
          ),
        );
        final updatedExpertDetails = currentState.expertDetails?.copyWith(
          isFollowed: !followed,
        );
        emitter(
          currentState.copyWith(
            expertDetails: updatedExpertDetails,
            isLoading: false,
          ),
        );
        unawaited(
          LocalActionsState.setAdvisorFollowed(
            event.advisorId,
            !event.isFollowed,
          ),
        );
      }
    } catch (e) {
      BaseUtil.showNegativeAlert(
        'Follow Error',
        'Something went wrong while trying to follow this expert. Please try again later.',
      );
    }
  }

  FutureOr<void> _tabChanged(
    TabChanged event,
    Emitter<ExpertDetailsState> emitter,
  ) async {
    if (state is ExpertDetailsLoaded) {
      final currentState = state as ExpertDetailsLoaded;
      if (currentState.currentTab == event.tab) {
        return;
      }
      if ((event.tab == 1 && currentState.shortsData.isNotEmpty) ||
          (event.tab == 2 && currentState.recentLive.isNotEmpty)) {
        emitter(
          currentState.copyWith(
            currentTab: event.tab,
          ),
        );
        return;
      }
      final updatedState = currentState.copyWith(
        currentTab: event.tab,
        isLoading: event.tab != 0,
      );
      emitter(updatedState);
      if (event.tab == 1) {
        final tabOneData = await _expertsRepository.getShortsByAdvisor(
          advisorId: event.advisorId,
        );
        emitter(
          currentState.copyWith(
            currentTab: event.tab,
            shortsData: tabOneData.model,
            isLoading: false,
          ),
        );
      } else if (event.tab == 2) {
        final tabTwoData = await _expertsRepository.getLiveByAdvisor(
          advisorId: event.advisorId,
        );
        emitter(
          currentState.copyWith(
            currentTab: event.tab,
            recentLive: tabTwoData.model,
            isLoading: false,
          ),
        );
      }
    }
  }

  FutureOr<void> _getCertificate(
    GetCertificate event,
    Emitter<ExpertDetailsState> emitter,
  ) async {
    final data = await _expertsRepository.getCertificateById(
      advisorId: event.advisorId,
      certificateId: event.credentialId,
    );
    if (data.isSuccess()) {
      await BaseUtil.launchUrl(data.model!);
    }
  }
}
