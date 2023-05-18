import 'package:felloapp/util/styles/styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class FelloInAppReview extends HookWidget {
  const FelloInAppReview({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final emojis = useState([
      "😞",
      "😒",
      "😐",
      "🙂",
      "😍",
    ]);
    final selected = useState(-1);

    return Container(
      decoration: BoxDecoration(
        color: const Color(0xff39393C),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(SizeConfig.padding16),
          topRight: Radius.circular(SizeConfig.padding16),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            height: SizeConfig.padding16,
          ),
          Container(
            width: SizeConfig.padding90 + SizeConfig.padding6,
            height: SizeConfig.padding4,
            decoration: BoxDecoration(
              color: const Color(0xffD9D9D9),
              borderRadius: BorderRadius.circular(SizeConfig.padding4),
            ),
          ),
          SizedBox(
            height: SizeConfig.padding24,
          ),
          Text(
            "How’s your experience so far?",
            textAlign: TextAlign.center,
            style: TextStyles.sourceSansSB.title5.colour(Colors.white),
          ),
          SizedBox(
            height: SizeConfig.padding24,
          ),
          Text(
            "We’d love to know!",
            textAlign: TextAlign.center,
            style: TextStyles.sourceSans.body2.colour(
              Colors.white.withOpacity(0.6),
            ),
          ),
          SizedBox(
            height: SizeConfig.padding24,
          ),
          SizedBox(
            height: SizeConfig.padding54,
            child: ListView.separated(
              itemCount: emojis.value.length,
              scrollDirection: Axis.horizontal,
              shrinkWrap: true,
              physics: const BouncingScrollPhysics(),
              itemBuilder: (context, index) {
                return Emoji(
                  emoji: emojis.value[index],
                  onTap: () {
                    selected.value = index;
                  },
                  selected: selected.value == index,
                );
              },
              separatorBuilder: (context, index) {
                return SizedBox(
                  width: SizeConfig.padding8,
                );
              },
            ),
          ),
          SizedBox(
            height: SizeConfig.padding54,
          ),
        ],
      ),
    );
  }
}

class Emoji extends StatelessWidget {
  const Emoji({
    super.key,
    required this.emoji,
    required this.onTap,
    required this.selected,
  });

  final String emoji;
  final VoidCallback onTap;
  final bool selected;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: SizeConfig.padding54 - SizeConfig.padding4,
        height: SizeConfig.padding54 - SizeConfig.padding4,
        decoration: BoxDecoration(
          color: selected ? const Color(0xff62E3C4) : const Color(0xff323232),
          shape: BoxShape.circle,
        ),
        child: Center(
          child: Text(
            emoji,
            style: TextStyles.sourceSansB.title4.colour(Colors.white),
          ),
        ),
      ),
    );
  }
}
