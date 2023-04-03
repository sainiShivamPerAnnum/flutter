import 'package:felloapp/core/enums/view_state_enum.dart';
import 'package:felloapp/core/service/power_play_service.dart';
import 'package:felloapp/ui/architecture/base_view.dart';
import 'package:felloapp/ui/pages/power_play/power_play_home/view_model/power_play_view_model.dart';
import 'package:felloapp/ui/pages/power_play/shared_widgets/ipl_teams_score_widget.dart';
import 'package:felloapp/util/locator.dart';
import 'package:felloapp/util/styles/size_config.dart';
import 'package:felloapp/util/styles/textStyles.dart';
import 'package:flutter/material.dart';

class UpcomingMatch extends StatefulWidget {
  const UpcomingMatch({
    super.key,
  });

  @override
  State<UpcomingMatch> createState() => _UpcomingMatchState();
}

class _UpcomingMatchState extends State<UpcomingMatch> {
  final PowerPlayHomeViewModel _playHomeViewModel =
      locator<PowerPlayHomeViewModel>();

  @override
  void initState() {
    super.initState();
    _playHomeViewModel.getMatchesByStatus(MatchStatus.upcoming.getValue, 10, 0);
  }

  @override
  Widget build(BuildContext context) {
    return BaseView<PowerPlayHomeViewModel>(
      onModelReady: (model) {
        // model.getMatchesByStatus(MatchStatus.upcoming.getValue, 10, 0);
      },
      builder: (context, model, child) {
        return model.state == ViewState.Busy
            ? const Center(child: CircularProgressIndicator())
            : ListView.builder(
                itemCount: 3,
                padding: EdgeInsets.zero,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemBuilder: (context, index) {
                  return Column(
                    children: [
                      Container(
                        // height: 50,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          color: const Color(0xff3B4E6E).withOpacity(0.8),
                        ),
                        child: Column(
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 22, vertical: 8),
                              decoration: const BoxDecoration(
                                  borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(5),
                                      topRight: Radius.circular(5)),
                                  color: Color(0xff273C60)),
                              child: Row(
                                children: [
                                  Text(
                                    'IPL Match - 4',
                                    style: TextStyles.sourceSansB.body2
                                        .colour(Colors.white),
                                  ),
                                  const Spacer(),
                                  Text(
                                    '24th May 2023',
                                    style: TextStyles.sourceSans.body5
                                        .colour(Colors.white.withOpacity(0.7))
                                        .copyWith(
                                            fontSize: SizeConfig.screenWidth! *
                                                0.030),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(
                              height: 14,
                            ),
                            const Padding(
                                padding: EdgeInsets.symmetric(horizontal: 17),
                                child: IplTeamsScoreWidget(
                                  team1: 'RCB',
                                  team2: 'CSK',
                                )),
                            const SizedBox(
                              height: 19,
                            ),
                            Center(
                              child: Text(
                                'Match starts at 7 PM',
                                style: TextStyles.sourceSans.copyWith(
                                    fontSize: SizeConfig.screenWidth! * 0.030),
                              ),
                            ),
                            const SizedBox(
                              height: 15,
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(vertical: 5),
                              decoration: BoxDecoration(
                                  color:
                                      const Color(0xff000000).withOpacity(0.3),
                                  borderRadius: const BorderRadius.only(
                                      bottomLeft: Radius.circular(5),
                                      bottomRight: Radius.circular(5))),
                              child: Center(
                                child: Text(
                                  'Predictions start in 05 : 02 Hrs',
                                  style: TextStyles.sourceSans.copyWith(
                                      fontSize:
                                          SizeConfig.screenWidth! * 0.030),
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                    ],
                  );
                },
              );
      },
    );
  }
}
