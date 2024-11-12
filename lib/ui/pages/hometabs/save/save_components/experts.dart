import 'package:felloapp/base_util.dart';
import 'package:felloapp/core/enums/page_state_enum.dart';
import 'package:felloapp/core/model/experts/experts_home.dart';
import 'package:felloapp/feature/expert/widgets/expert_card.dart';
import 'package:felloapp/feature/expertDetails/expert_profile.dart';
import 'package:felloapp/navigator/app_state.dart';
import 'package:felloapp/navigator/router/ui_pages.dart';
import 'package:felloapp/ui/elements/title_subtitle_container.dart';
import 'package:felloapp/ui/pages/hometabs/save/save_viewModel.dart';
import 'package:felloapp/util/styles/size_config.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tuple/tuple.dart';

class Experts extends StatelessWidget {
  const Experts({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Selector<SaveViewModel, Tuple2<List<Expert>, bool>>(
      selector: (_, model) => Tuple2(
        model.topExperts,
        model.freeCallAvailable,
      ),
      builder: (_, value, __) {
        return value.item1.isNotEmpty
            ? Column(
                children: [
                  SizedBox(height: SizeConfig.padding14),
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      TitleSubtitleContainer(
                        title: "Experts",
                      ),
                    ],
                  ),
                  TopExperts(
                    topExperts: value.item1,
                    isFree: value.item2,
                  ),
                ],
              )
            : const SizedBox.shrink();
      },
    );
  }
}

class TopExperts extends StatelessWidget {
  final List<Expert> topExperts;
  final bool isFree;
  const TopExperts({required this.topExperts, required this.isFree, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: SizeConfig.padding10),
      child: Column(
        children: [
          for (int i = 0; i < topExperts.length; i++)
            Padding(
              padding: EdgeInsets.symmetric(horizontal: SizeConfig.padding20)
                  .copyWith(bottom: SizeConfig.padding16),
              child: ExpertCard(
                isFree: isFree,
                expert: topExperts[i],
                onBookCall: () {
                  BaseUtil.openBookAdvisorSheet(
                    advisorId: topExperts[i].advisorId,
                    advisorName: topExperts[i].name,
                    isEdit: false,
                  );
                },
                onTap: () {
                  AppState.delegate!.appState.currentAction = PageAction(
                    page: ExpertDetailsPageConfig,
                    state: PageState.addWidget,
                    widget: ExpertsDetailsView(
                      advisorID: topExperts[i].advisorId,
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
