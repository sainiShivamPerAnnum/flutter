import 'package:felloapp/core/enums/view_state_enum.dart';
import 'package:felloapp/navigator/app_state.dart';
import 'package:felloapp/ui/architecture/base_view.dart';
import 'package:felloapp/ui/pages/notifications/notifications_vm.dart';
import 'package:felloapp/ui/pages/static/fello_appbar.dart';
import 'package:felloapp/ui/pages/static/home_background.dart';
import 'package:felloapp/util/assets.dart';
import 'package:felloapp/util/localization/generated/l10n.dart';
import 'package:felloapp/util/styles/size_config.dart';
import 'package:felloapp/util/styles/textStyles.dart';
import 'package:felloapp/util/styles/ui_constants.dart';
import 'package:felloapp/util/time_ago.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class NotficationsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    S locale = S.of(context);
    return BaseView<NotificationsViewModel>(onModelReady: (model) {
      model.init();
    }, builder: (ctx, model, child) {
      return Scaffold(
        body: HomeBackground(
          child: Column(
            children: [
              FelloAppBar(
                leading: FelloAppBarBackButton(),
                title: locale.abNotifications,
              ),
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(SizeConfig.padding40),
                      topRight: Radius.circular(SizeConfig.padding40),
                    ),
                  ),
                  child: model.state == ViewState.Busy
                      ? Center(
                          child: SpinKitWave(
                            color: UiConstants.primaryColor,
                            size: SizeConfig.padding32,
                          ),
                        )
                      : Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(SizeConfig.padding40),
                              topRight: Radius.circular(SizeConfig.padding40),
                            ),
                            color: Colors.white,
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(SizeConfig.padding40),
                              topRight: Radius.circular(SizeConfig.padding40),
                            ),
                            child: ListView.builder(
                              controller: model.scrollController,
                              padding: EdgeInsets.zero,
                              itemCount: model.notifications?.length ?? 0,
                              itemBuilder: (context, index) => InkWell(
                                onTap: () {
                                  model.updateHighlightStatus(index);
                                  if (model.notifications[index].actionUri !=
                                      null) {
                                    print(model.notifications[index].actionUri
                                        .toString());
                                    AppState.delegate.parseRoute(Uri.parse(
                                        model.notifications[index].actionUri));
                                  }
                                },
                                child: Container(
                                  color:
                                      model.notifications[index].isHighlighted
                                          ? UiConstants.primaryLight
                                              .withOpacity(0.3)
                                          : Colors.white,
                                  padding: EdgeInsets.symmetric(
                                      horizontal:
                                          SizeConfig.pageHorizontalMargins),
                                  child: Column(
                                    children: [
                                      SizedBox(height: SizeConfig.padding12),
                                      Row(
                                        children: [
                                          CircleAvatar(
                                            backgroundColor: UiConstants
                                                .primaryColor
                                                .withOpacity(0.1),
                                            radius: SizeConfig.tileAvatarRadius,
                                            child: Image.asset(
                                              Assets.logoShortform,
                                              color: UiConstants.primaryColor,
                                              height: SizeConfig.iconSize1,
                                            ),
                                          ),
                                          SizedBox(width: SizeConfig.padding12),
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Row(
                                                  children: [
                                                    Expanded(
                                                      child: Text(
                                                        model
                                                                .notifications[
                                                                    index]
                                                                .title
                                                                .toUpperCase() ??
                                                            "Title",
                                                        maxLines: 2,
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                        style: TextStyles
                                                            .body2.bold,
                                                      ),
                                                    ),
                                                    Text(
                                                      TimeAgo.timeAgoSinceDate(
                                                        DateTime.fromMillisecondsSinceEpoch(model
                                                                    .notifications[
                                                                        index]
                                                                    .createdTime
                                                                    .seconds *
                                                                1000)
                                                            .toString(),
                                                      ),
                                                      style: TextStyles.body3
                                                          .colour(Colors.grey)
                                                          .letterSpace(2),
                                                    ),
                                                  ],
                                                ),
                                                SizedBox(
                                                    height:
                                                        SizeConfig.padding6),
                                                Text(model.notifications[index]
                                                        .subtitle ??
                                                    "Subtitle"),
                                              ],
                                            ),
                                          )
                                        ],
                                      ),
                                      SizedBox(height: SizeConfig.padding12),
                                      Divider(
                                        height: 0,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                ),
              ),
              if (model.isMoreNotificationsLoading)
                Container(
                  width: SizeConfig.screenWidth,
                  padding: EdgeInsets.all(SizeConfig.padding12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SpinKitWave(
                        color: UiConstants.primaryColor,
                        size: SizeConfig.padding16,
                      ),
                      SizedBox(height: SizeConfig.padding4),
                      Text(
                        "Looking for more alerts, please wait ...",
                        style: TextStyles.body4.colour(Colors.grey),
                      )
                    ],
                  ),
                )
            ],
          ),
        ),
      );
    });
  }
}
