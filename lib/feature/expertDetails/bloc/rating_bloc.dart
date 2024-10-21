import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:felloapp/base_util.dart';
import 'package:felloapp/core/model/experts/experts_details.dart';
import 'package:felloapp/core/repository/experts_repo.dart';
import 'package:felloapp/navigator/app_state.dart';

part 'rating_event.dart';
part 'rating_state.dart';

class RatingBloc extends Bloc<RatingEvent, RatingState> {
  final ExpertsRepository _expertsRepository;
  RatingBloc(
    this._expertsRepository,
  ) : super(const LoadingRatingDetails()) {
    on<LoadRatings>(_onLoadExpertsData);
    on<PostRating>(_postRating);
    on<ViewMoreClicked>(_viewMoreClicked);
  }
  FutureOr<void> _onLoadExpertsData(
    LoadRatings event,
    Emitter<RatingState> emitter,
  ) async {
    emitter(const LoadingRatingDetails());
    final data = await _expertsRepository.getRatingByExpert(
      advisorId: event.advisorId,
    );
    emitter(RatingDetailsLoaded(userRatings: data.model));
  }

  FutureOr<void> _postRating(
    PostRating event,
    Emitter<RatingState> emitter,
  ) async {
    emitter(const UploadingRatingDetails());
    final data = await _expertsRepository.postRatingDetails(
      advisorId: event.advisorId,
      comments: event.comments,
      rating: event.rating,
    );
    if (data.isSuccess()) {
      add(LoadRatings(event.advisorId));
      await AppState.backButtonDispatcher!.didPopRoute();
    } else {
      add(LoadRatings(event.advisorId));
      BaseUtil.showNegativeAlert('Failed to upload rating!', data.errorMessage);
      await AppState.backButtonDispatcher!.didPopRoute();
    }
  }

  FutureOr<void> _viewMoreClicked(
    ViewMoreClicked event,
    Emitter<RatingState> emitter,
  ) async {
    if (state is RatingDetailsLoaded) {
      emitter(
        (state as RatingDetailsLoaded).copyWith(viewMore: event.viewMore),
      );
    }
  }
}
