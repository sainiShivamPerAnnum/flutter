import 'package:felloapp/core/enums/view_state_enum.dart';
import 'package:felloapp/ui/architecture/base_view.dart';
import 'package:felloapp/ui/pages/power_play/power_play_home/view_model/power_play_view_model.dart';
import 'package:felloapp/ui/pages/power_play/power_play_home/widgets/completed_match.dart';
import 'package:felloapp/ui/pages/power_play/power_play_home/widgets/live_match.dart';
import 'package:felloapp/ui/pages/power_play/power_play_home/widgets/upcoming_match.dart';
import 'package:felloapp/util/styles/size_config.dart';
import 'package:felloapp/util/styles/textStyles.dart';
import 'package:flutter/material.dart';

class PowerPlayMatches extends StatefulWidget {
  const PowerPlayMatches({Key? key}) : super(key: key);

  @override
  State<PowerPlayMatches> createState() => _PowerPlayMatchesState();
}

class _PowerPlayMatchesState extends State<PowerPlayMatches>
    with TickerProviderStateMixin {
  TabController? _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(vsync: this, length: 3);
    _tabController!.addListener(_handleTabSelection);
  }

  List<String> getTitle() {
    return ['Live', 'Upcoming', 'Completed'];
  }

  void _handleTabSelection() {
    if (_tabController!.index == 0) {
      print("Live");
    } else if (_tabController!.index == 1) {
      print("Upcoming");
    } else if (_tabController!.index == 2) {
      print("Completed");
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return BaseView<PowerPlayHomeViewModel>(
      onModelReady: (model) {
        model.init();
      },
      builder: (context, model, child) {
        return Container(
          margin: EdgeInsets.symmetric(
              horizontal: SizeConfig.pageHorizontalMargins),
          child: DefaultTabController(
            length: 3,
            child: Column(
              children: [
                TabBar(
                  controller: _tabController,
                  labelPadding: EdgeInsets.zero,
                  indicatorColor: Colors.transparent,
                  physics: const BouncingScrollPhysics(),
                  isScrollable: true,
                  splashFactory: NoSplash.splashFactory,
                  tabs: List.generate(
                    3,
                    (index) => Container(
                      width: 105,
                      padding: EdgeInsets.symmetric(
                        horizontal: SizeConfig.padding10,
                        vertical: SizeConfig.padding10,
                      ),
                      decoration: BoxDecoration(
                          borderRadius:
                              const BorderRadius.all(Radius.circular(5)),
                          color: _tabController!.index == index
                              ? Colors.white
                              : Colors.transparent,
                          border: Border.all(color: Colors.white)),
                      child: Text(
                        getTitle()[index],
                        textAlign: TextAlign.center,
                        style: TextStyles.sourceSansSB.body4.colour(
                            _tabController!.index == index
                                ? Colors.black
                                : Colors.white),
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                Builder(builder: (_) {
                  if (_tabController!.index == 0) {
                    if (model.state == ViewState.Busy) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    return model.liveMatchData?.isEmpty ?? true
                        ? const Center(child: Text("No Live Match"))
                        : LiveMatch(
                            matchData: model.liveMatchData?[0],
                          );
                  } else if (_tabController!.index == 1) {
                    return UpcomingMatch(
                      model: model,
                    );
                  } else {
                    return const CompletedMatch();
                  }
                }),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    _tabController?.dispose();
    super.dispose();
  }
}
