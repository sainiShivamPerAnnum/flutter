import 'package:felloapp/feature/expert/expert_card.dart';
import 'package:felloapp/ui/elements/title_subtitle_container.dart';
import 'package:felloapp/ui/pages/hometabs/save/save_viewModel.dart';
// import 'package:felloapp/util/localization/generated/l10n.dart';
import 'package:felloapp/util/styles/size_config.dart';
import 'package:flutter/material.dart';

class Experts extends StatelessWidget {
  final SaveViewModel model;
  const Experts({required this.model, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // S locale = S.of(context);
    return Column(
      children: [
        SizedBox(height: SizeConfig.padding14),
        GestureDetector(
          onTap: () {},
          child: const Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              TitleSubtitleContainer(
                title: "Experts",
              ),
            ],
          ),
        ),
        TopExperts(model: model),
      ],
    );
  }
}

class TopExperts extends StatelessWidget {
  final SaveViewModel model;
  const TopExperts({required this.model, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: SizeConfig.padding10),
      child: SizedBox(
        child:  Column(
                children: [
                  for (int i = 0; i < model.topExperts!.length; i++)
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 18)
                          .copyWith(bottom: 8),
                      child: ExpertCard(
                        imageUrl: model.topExperts![i].bgImage,
                        name: model.topExperts![i].name,
                        experience: model.topExperts![i].exp.toString(),
                        expertise: model.topExperts![i].expertise.toString(),
                        qualifications:
                            model.topExperts![i].qualifications.toString(),
                        availableSlots: model.topExperts![i].availableSlot,
                        rating: model.topExperts![i].rating,
                        onBookCall: () {},
                      ),
                    ),
                ],
              ),
      ),
    );
  }
}
