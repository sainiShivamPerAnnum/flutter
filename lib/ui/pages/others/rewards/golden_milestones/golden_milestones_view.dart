import 'package:felloapp/core/enums/view_state_enum.dart';
import 'package:felloapp/ui/architecture/base_view.dart';
import 'package:felloapp/ui/pages/others/games/cricket/cricket_home/cricket_home_view.dart';
import 'package:felloapp/ui/pages/others/rewards/golden_milestones/golden_milestones_vm.dart';
import 'package:felloapp/ui/pages/static/fello_appbar.dart';
import 'package:felloapp/ui/pages/static/home_background.dart';
import 'package:felloapp/ui/service_elements/user_service/profile_image.dart';
import 'package:felloapp/util/styles/size_config.dart';
import 'package:felloapp/util/styles/textStyles.dart';
import 'package:felloapp/util/styles/ui_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:timelines/timelines.dart';

class GoldenMilestonesView extends StatelessWidget {
  const GoldenMilestonesView({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BaseView<GoldenMilestonesViewModel>(
      onModelReady: (model) {
        model.init();
      },
      builder: (ctx, model, child) {
        return Scaffold(
          backgroundColor: UiConstants.primaryColor,
          body: HomeBackground(
            child: Column(
              children: [
                FelloAppBar(
                  leading: FelloAppBarBackButton(),
                  title: "Milestones",
                ),
                Expanded(
                  child: Container(
                    width: SizeConfig.screenWidth,
                    padding: EdgeInsets.symmetric(
                        horizontal: SizeConfig.pageHorizontalMargins),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(SizeConfig.padding40),
                        topRight: Radius.circular(SizeConfig.padding40),
                      ),
                      color: Colors.white,
                    ),
                    child: model.state == ViewState.Busy
                        ? Center(
                            child: Center(
                              child: SpinKitWave(
                                color: UiConstants.primaryColor,
                                size: SizeConfig.padding32,
                              ),
                            ),
                          )
                        : ScrollConfiguration(
                            behavior: MyBehavior(),
                            child: SingleChildScrollView(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SizedBox(
                                      height: SizeConfig.pageHorizontalMargins),
                                  Text("Upcoming rewards",
                                      style: TextStyles.title4),
                                  SizedBox(height: SizeConfig.padding2),
                                  Text("Complete task, earn rewards!",
                                      style: TextStyles.body4),
                                  SizedBox(height: SizeConfig.padding12),
                                  Container(
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      shape: BoxShape.circle,
                                      border: Border.all(
                                          color: UiConstants.primaryColor,
                                          width: SizeConfig.padding2),
                                    ),
                                    padding:
                                        EdgeInsets.all(SizeConfig.padding4),
                                    child: ProfileImageSE(
                                        radius: SizeConfig.padding16),
                                  ),
                                  model.milestones == null
                                      ? Center(
                                          child: SpinKitWave(
                                          color: UiConstants.primaryColor,
                                          size: SizeConfig.padding32,
                                        ))
                                      : (model.milestones.isEmpty
                                          ? NoRecordDisplayWidget()
                                          : MilestonePath(
                                              data: model.milestones,
                                            )),
                                  Container(
                                    height: SizeConfig.screenHeight * 0.3,
                                    width: SizeConfig.screenWidth,
                                    padding: EdgeInsets.all(
                                        SizeConfig.pageHorizontalMargins),
                                    margin: EdgeInsets.symmetric(
                                        vertical:
                                            SizeConfig.pageHorizontalMargins),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(
                                          SizeConfig.roundness24),
                                      border: Border.all(
                                          color: UiConstants.primaryColor,
                                          width: 1),
                                    ),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text("How to earn",
                                            style: TextStyles.body1.bold),
                                        SizedBox(height: SizeConfig.padding2),
                                        Text(
                                            "Follow the simple steps to earn more..",
                                            style: TextStyles.body4),
                                        SizedBox(height: SizeConfig.padding12),
                                      ],
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class MilestonePath extends StatelessWidget {
  final List<MilestoneRecord> data;
  MilestonePath({this.data});
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
          right: SizeConfig.pageHorizontalMargins,
          left: SizeConfig.padding12 - SizeConfig.padding2),
      child: Timeline.tileBuilder(
        physics: NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        theme: TimelineThemeData(
          nodePosition: 0,
          color: Color(0xffc2c5c9),
          connectorTheme: ConnectorThemeData(
            thickness: 3.0,
          ),
        ),
        padding: EdgeInsets.zero,
        builder: TimelineTileBuilder.connected(
          indicatorBuilder: (context, index) {
            return Container(
              height: SizeConfig.padding24,
              width: SizeConfig.padding24,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(SizeConfig.padding2),
                  color: data[index].isCompleted
                      ? UiConstants.primaryColor
                      : Colors.grey[400]),
              alignment: Alignment.center,
              child: Text(
                index.toString(),
                style: TextStyles.body4.bold.colour(
                    data[index].isCompleted ? Colors.white : Colors.black),
              ),
            );
          },
          connectorBuilder: (_, index, connectorType) {
            var color;
            if (index + 1 < data.length - 1) {
              color = data[index].isCompleted && data[index + 1].isCompleted
                  ? UiConstants.primaryLight
                  : Colors.grey[300];
            }
            return DashedLineConnector(
              indent: connectorType == ConnectorType.start ? 5 : 2.0,
              endIndent: connectorType == ConnectorType.end ? 0 : 2.0,
              color: color,
              gap: 7,
              dash: 1,
              thickness: 3,
            );
          },
          contentsBuilder: (_, index) => ListTile(
            title: Text(data[index].title),
            subtitle: Text(data[index].subtilte),
          ),
          itemExtentBuilder: (_, __) {
            return 80;
          },
          itemCount: data.length,
        ),
      ),
    );
  }
}

class MyBehavior extends ScrollBehavior {
  @override
  Widget buildViewportChrome(
      BuildContext context, Widget child, AxisDirection axisDirection) {
    return child;
  }
}
