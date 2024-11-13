part of 'support_bloc.dart';

sealed class SupportState extends Equatable {
  const SupportState();
}

class LoadingSupportData extends SupportState {
  const LoadingSupportData();

  @override
  List<Object?> get props => const [];
}

final class SupportData extends SupportState {
  final List<Widget> supportItems;
  final List<SocialItems> socialItems;
  final List<SocialVideo> introData;
  const SupportData({
    required this.supportItems,
    this.socialItems = const [],
    this.introData = const [],
  });
  @override
  List<Object?> get props => [
        supportItems,
        socialItems,
        introData,
      ];
}
