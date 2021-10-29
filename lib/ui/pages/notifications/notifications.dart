import 'package:felloapp/base_util.dart';
import 'package:felloapp/core/model/alert_model.dart';
import 'package:felloapp/core/ops/db_ops.dart';
import 'package:felloapp/ui/pages/static/fello_appbar.dart';
import 'package:felloapp/ui/pages/static/home_background.dart';
import 'package:felloapp/util/assets.dart';
import 'package:felloapp/util/localization/generated/l10n.dart';
import 'package:felloapp/util/styles/size_config.dart';
import 'package:felloapp/util/styles/textStyles.dart';
import 'package:felloapp/util/time_ago.dart';
import 'package:felloapp/util/styles/ui_constants.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class NotficationsPage extends StatefulWidget {
  @override
  _NotficationsPageState createState() => _NotficationsPageState();
}

class _NotficationsPageState extends State<NotficationsPage> {
  @override
  Widget build(BuildContext context) {
    final baseProvider = Provider.of<BaseUtil>(context, listen: false);
    final dbProvider = Provider.of<DBModel>(context, listen: false);
    S locale = S.of(context);
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
                padding: EdgeInsets.all(SizeConfig.pageHorizontalMargins),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(SizeConfig.padding40),
                    topRight: Radius.circular(SizeConfig.padding40),
                  ),
                  color: Colors.white,
                ),
                child: FutureBuilder(
                  future: dbProvider
                      .getUserNotifications(baseProvider.firebaseUser.uid),
                  builder: (context, AsyncSnapshot<List<AlertModel>> snapshot) {
                    List<AlertModel> alerts = snapshot.data;

                    if (snapshot.connectionState == ConnectionState.done) {
                      if (snapshot.hasError) {
                        print(snapshot.error);
                        return Container();
                      }

                      if (alerts.isEmpty) {
                        return Center(
                          child: Text("No notifications"),
                        );
                      } else {
                        return ListView.builder(
                          padding: EdgeInsets.zero,
                          itemBuilder: (context, index) => Padding(
                            padding: EdgeInsets.symmetric(
                                vertical: SizeConfig.padding8),
                            child: Column(
                              children: [
                                Row(
                                  children: [
                                    CircleAvatar(
                                      backgroundColor: UiConstants.primaryColor
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
                                                  alerts[index]
                                                          .title
                                                          .toUpperCase() ??
                                                      "Title",
                                                  maxLines: 2,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  style: TextStyles.body2.bold,
                                                ),
                                              ),
                                              Text(
                                                TimeAgo.timeAgoSinceDate(
                                                  DateTime.fromMillisecondsSinceEpoch(
                                                          alerts[index]
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
                                          SizedBox(height: SizeConfig.padding6),
                                          Text(alerts[index].subtitle ??
                                              "Subtitle"),
                                        ],
                                      ),
                                    )
                                  ],
                                ),
                                Divider(),
                              ],
                            ),
                          ),
                          itemCount: alerts?.length ?? 0,
                        );
                      }
                    } else {
                      return Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
