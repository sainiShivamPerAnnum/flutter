part of 'rating_bloc.dart';

sealed class RatingEvent {
  const RatingEvent();
}

class InitialRatingState extends RatingEvent {
  const InitialRatingState();
}

class LoadRatings extends RatingEvent {
  final String advisorId;
  const LoadRatings(this.advisorId);
}

class ViewMoreClicked extends RatingEvent {
  final bool viewMore;
  const ViewMoreClicked(this.viewMore);
}

class PostRating extends RatingEvent {
  final num rating;
  final String comments;
  final String advisorId;
  const PostRating({
    required this.rating,
    required this.comments,
    required this.advisorId,
  });
}
