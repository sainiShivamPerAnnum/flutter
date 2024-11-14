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
  final String contactDetails;
  final String btnTxt;
  const SupportData({
    required this.supportItems,
    this.socialItems = const [],
    this.introData = const [],
    this.contactDetails = "support@fello.in",
    this.btnTxt = "Raise a Ticket",
  });
  @override
  List<Object?> get props => [
        supportItems,
        socialItems,
        introData,
        contactDetails,
        btnTxt,
      ];
}
