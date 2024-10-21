part of 'rating_bloc.dart';

sealed class RatingState extends Equatable {
  const RatingState();
}

class LoadingRatingDetails extends RatingState {
  const LoadingRatingDetails();

  @override
  List<Object?> get props => const [];
}
class UploadingRatingDetails extends RatingState {
  const UploadingRatingDetails();

  @override
  List<Object?> get props => const [];
}

final class RatingDetailsLoaded extends RatingState {
  final List<UserRating>? userRatings;
  final bool viewMore;
  const RatingDetailsLoaded({
    required this.userRatings,
     this.viewMore=false,
  });
  RatingState copyWith({
    List<UserRating>? userRatings,
    bool? viewMore,
  }) {
    return RatingDetailsLoaded(
      userRatings: userRatings ?? this.userRatings,
      viewMore: viewMore?? this.viewMore,
    );
  }

  @override
  List<Object?> get props => [
        userRatings,
        viewMore,
      ];
}
