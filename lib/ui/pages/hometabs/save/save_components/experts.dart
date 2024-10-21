import 'package:felloapp/base_util.dart';
import 'package:felloapp/core/enums/page_state_enum.dart';
import 'package:felloapp/feature/expert/widgets/expert_card.dart';
import 'package:felloapp/feature/expertDetails/expert_profile.dart';
import 'package:felloapp/navigator/app_state.dart';
import 'package:felloapp/navigator/router/ui_pages.dart';
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
    return model.topExperts.isNotEmpty
        ? Column(
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
          )
        : const SizedBox.shrink();
  }
}

class TopExperts extends StatelessWidget {
  final SaveViewModel model;
  const TopExperts({required this.model, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: SizeConfig.padding10),
      child: Column(
        children: [
          for (int i = 0; i < model.topExperts.length; i++)
            Padding(
              padding: EdgeInsets.symmetric(horizontal: SizeConfig.padding18)
                  .copyWith(bottom: SizeConfig.padding16),
              child: ExpertCard(
                expert: model.topExperts[i],
                onBookCall: () {
                  BaseUtil.openBookAdvisorSheet(
                    advisorId: model.topExperts[i].advisorId,
                  );
                },
                onTap: () {
                  AppState.delegate!.appState.currentAction = PageAction(
                    page: ExpertDetailsPageConfig,
                    state: PageState.addWidget,
                    widget: ExpertsDetailsView(
                      advisorID: model.topExperts[i].advisorId,
                    ),
                  );
                },
              ),
            ),
        ],
      ),
    );
  }
}
