import 'package:felloapp/core/model/top_saver_model.dart';
import 'package:felloapp/ui/pages/static/fello_appbar.dart';
import 'package:felloapp/ui/pages/static/home_background.dart';
import 'package:felloapp/util/styles/size_config.dart';
import 'package:felloapp/util/styles/textStyles.dart';
import 'package:felloapp/util/styles/ui_constants.dart';
import 'package:flutter/material.dart';

class AllParticipantsView extends StatelessWidget {
  final List<TopSavers> participants;
  AllParticipantsView({this.participants});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: UiConstants.primaryColor,
        body: HomeBackground(
          child: Column(
            children: [
              FelloAppBar(
                leading: FelloAppBarBackButton(),
                title: "All Participants",
              ),
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(SizeConfig.padding40),
                      topRight: Radius.circular(SizeConfig.padding40),
                    ),
                    color: Colors.white,
                  ),
                  width: SizeConfig.screenWidth,
                  child: ClipRRect(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(SizeConfig.padding40),
                      topRight: Radius.circular(SizeConfig.padding40),
                    ),
                    child: ListView.builder(
                      padding: EdgeInsets.all(SizeConfig.pageHorizontalMargins),
                      itemCount: participants.length,
                      itemBuilder: (ctx, i) => Container(
                        margin: EdgeInsets.only(bottom: SizeConfig.padding12),
                        decoration: BoxDecoration(
                          borderRadius:
                              BorderRadius.circular(SizeConfig.padding12),
                          color: Colors.grey.withOpacity(0.1),
                        ),
                        child: ListTile(
                          contentPadding: EdgeInsets.symmetric(
                              vertical: SizeConfig.padding4,
                              horizontal: SizeConfig.pageHorizontalMargins / 2),
                          leading: CircleAvatar(
                            backgroundColor: UiConstants.primaryColor,
                            child: Text(
                              "${i + 1}",
                              style: TextStyles.body2.colour(Colors.white),
                            ),
                          ),
                          title: Text(
                            participants[i].username,
                            style: TextStyles.body3.bold.colour(Colors.black54),
                          ),
                          // subtitle: Text("This Week"),
                          trailing: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                participants[i].score.toString(),
                                style: TextStyles.body2.bold
                                    .colour(UiConstants.primaryColor),
                              ),
                              Text(
                                "score",
                                style:
                                    TextStyles.body4.light.colour(Colors.grey),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ));
  }
}
