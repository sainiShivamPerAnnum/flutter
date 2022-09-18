import 'package:felloapp/core/enums/view_state_enum.dart';
import 'package:felloapp/navigator/app_state.dart';
import 'package:felloapp/ui/architecture/base_view.dart';
import 'package:felloapp/ui/pages/notifications/notifications_vm.dart';
import 'package:felloapp/ui/pages/static/fello_appbar.dart';
import 'package:felloapp/ui/pages/static/home_background.dart';
import 'package:felloapp/ui/pages/static/loader_widget.dart';
import 'package:felloapp/ui/widgets/buttons/nav_buttons/nav_buttons.dart';
import 'package:felloapp/util/assets.dart';
import 'package:felloapp/util/localization/generated/l10n.dart';
import 'package:felloapp/util/styles/size_config.dart';
import 'package:felloapp/util/styles/textStyles.dart';
import 'package:felloapp/util/styles/ui_constants.dart';
import 'package:felloapp/util/date_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_svg/flutter_svg.dart';

class NotficationsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    S locale = S.of(context);
    return BaseView<NotificationsViewModel>(onModelReady: (model) {
      model.init();
    }, builder: (ctx, model, child) {
      return Scaffold(
        backgroundColor: UiConstants.kBackgroundColor,
        appBar: AppBar(
          title: Text(
            'Notifications',
            maxLines: 1,
            overflow: TextOverflow.clip,
            style: TextStyles.title4.bold.colour(Colors.white),
          ),
          elevation: 0.0,
          backgroundColor: UiConstants.kBackgroundColor,
          leading: IconButton(
            onPressed: () {
              AppState.backButtonDispatcher.didPopRoute();
            },
            icon: Icon(
              Icons.arrow_back_ios,
              color: Colors.white,
            ),
          ),
        ),
        body: Column(
          children: [
            Expanded(
              child: Container(
                margin: EdgeInsets.only(top: SizeConfig.padding24),
                decoration: BoxDecoration(),
                child: model.state == ViewState.Busy
                    ? Center(child: FullScreenLoader())
                    : Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(SizeConfig.padding40),
                            topRight: Radius.circular(SizeConfig.padding40),
                          ),
                          color: UiConstants.kBackgroundColor,
                        ),
                        child: ListView.builder(
                          physics: BouncingScrollPhysics(),
                          controller: model.scrollController,
                          padding: EdgeInsets.zero,
                          itemCount: model.notifications?.length ?? 0,
                          itemBuilder: (context, index) => InkWell(
                            onTap: () {
                              model.updateHighlightStatus(index);
                              if (model.notifications[index].actionUri !=
                                      null &&
                                  model.notifications[index].actionUri
                                      .isNotEmpty) {
                                print(model.notifications[index].actionUri
                                    .toString());
                                AppState.delegate.parseRoute(Uri.parse(
                                    model.notifications[index].actionUri));
                              }
                            },
                            child: Container(
                              color: model.notifications[index].isHighlighted
                                  ? UiConstants.primaryLight.withOpacity(0.3)
                                  : UiConstants.kBackgroundColor,
                              padding: EdgeInsets.fromLTRB(
                                  SizeConfig.pageHorizontalMargins,
                                  SizeConfig.padding16,
                                  SizeConfig.pageHorizontalMargins,
                                  0),
                              child: Column(
                                children: [
                                  SizedBox(height: SizeConfig.padding12),
                                  Row(
                                    children: [
                                      CircleAvatar(
                                        backgroundColor: UiConstants
                                            .kFAQsAnswerColor
                                            .withOpacity(0.1),
                                        radius:
                                            SizeConfig.notificationAvatarRadius,
                                        child: model.getNotificationAsset(model
                                                    .notifications[index]
                                                    .title) ==
                                                Assets.logoShortform
                                            ? Image.asset(
                                                model.getNotificationAsset(model
                                                    .notifications[index]
                                                    .title),
                                                color: UiConstants.primaryColor,
                                                height: SizeConfig.iconSize1,
                                                fit: BoxFit.contain,
                                              )
                                            : SvgPicture.asset(
                                                model.getNotificationAsset(model
                                                    .notifications[index]
                                                    .title),
                                                color: UiConstants.primaryColor,
                                                height: SizeConfig.iconSize1,
                                                fit: BoxFit.contain,
                                              ),
                                      ),
                                      SizedBox(width: SizeConfig.padding24),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Row(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Expanded(
                                                  child: Text(
                                                    model.notifications[index]
                                                            .title ??
                                                        "Title",
                                                    maxLines: 2,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    style: TextStyles.body2.bold
                                                        .colour(Colors.white),
                                                  ),
                                                ),
                                                SizedBox(
                                                    width:
                                                        SizeConfig.padding16),
                                                Text(
                                                  DateHelper.timeAgoSinceDate(
                                                    DateTime.fromMillisecondsSinceEpoch(
                                                            model
                                                                    .notifications[
                                                                        index]
                                                                    .createdTime
                                                                    .seconds *
                                                                1000)
                                                        .toString(),
                                                  ),
                                                  style: TextStyles.body4
                                                      .colour(UiConstants
                                                          .kFAQsAnswerColor)
                                                      .letterSpace(2),
                                                ),
                                              ],
                                            ),
                                            SizedBox(
                                                height: SizeConfig.padding6),
                                            Padding(
                                              padding: EdgeInsets.only(
                                                  right: SizeConfig.padding28),
                                              child: Text(
                                                model.notifications[index]
                                                        .subtitle ??
                                                    "Subtitle",
                                                style: TextStyles.body4
                                                    .colour(Colors.white),
                                              ),
                                            ),
                                          ],
                                        ),
                                      )
                                    ],
                                  ),
                                  index != model.notifications.length
                                      ? Container(
                                          margin: EdgeInsets.only(
                                              top: SizeConfig.padding24),
                                          width: double.infinity,
                                          height: 0.2,
                                          color: Colors.white.withOpacity(0.7),
                                        )
                                      : SizedBox.shrink(),
                                ],
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
      );
    });
  }
}
