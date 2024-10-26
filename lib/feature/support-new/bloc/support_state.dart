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
  final List<Map<String, String>> socialItems;
  final List<Map<String, String>> introData;
  const SupportData({
    required this.supportItems,
    this.socialItems = const [
      {
        "name": "Whatsapp",
        "icon": "assets/vectors/whatsapp_find.svg",
        "link": "",
      },
      {
        "name": "Facebook",
        "icon": "assets/vectors/fb.svg",
        "link": "",
      },
      {
        "name": "Linkedin",
        "icon": "assets/vectors/linkedIn.svg",
        "link": "",
      },
      {
        "name": "Instagram",
        "icon": "assets/vectors/insta.svg",
        "link": "",
      },
    ],
    this.introData = const [
      {
        "title": "Introduction to Fello",
        "bgImage":
            "https://ik.imagekit.io/9xfwtu0xm/experts/live1.png?updatedAt=1727083174845",
        "duration": "2:30 MINS",
      },
      {
        "title": "How Fello works",
        "bgImage":
            "https://ik.imagekit.io/9xfwtu0xm/experts/live2.png?updatedAt=1727083175271",
        "duration": "2:30 MINS",
      },
      {
        "title": "Understanding Mutual Funds",
        "bgImage":
            "https://ik.imagekit.io/9xfwtu0xm/experts/live2.png?updatedAt=1727083175271",
        "duration": "2:30 MINS",
      }
    ],
  });
  @override
  List<Object?> get props => [
        supportItems,
        socialItems,
        introData,
      ];
}
