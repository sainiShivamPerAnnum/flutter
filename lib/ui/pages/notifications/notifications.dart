import 'package:felloapp/base_util.dart';
import 'package:felloapp/core/model/alert_model.dart';
import 'package:felloapp/core/ops/db_ops.dart';
import 'package:felloapp/util/size_config.dart';
import 'package:felloapp/util/ui_constants.dart';
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

    return Scaffold(
      appBar: BaseUtil.getAppBar(context, "Notifications"),
      body: FutureBuilder(
        future: dbProvider.getUserNotifications(baseProvider.firebaseUser.uid),
        builder: (context, AsyncSnapshot<List<AlertModel>> snapshot) {
          List<AlertModel> alerts = snapshot.data;
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.hasError) {
              print(snapshot.error);
              return Container();
            }

            return ListView.builder(
              itemBuilder: (context, index) => Column(
                children: [
                  ListTile(
                    title: Text(
                      alerts[index].title ?? "Title",
                      style: TextStyle(
                        color: UiConstants.textColor,
                        fontSize: SizeConfig.screenHeight * 0.02,
                      ),
                    ),
                    subtitle: Text(alerts[index].subtitile ?? "Subtitle"),
                    trailing: Text('4:00 PM'),
                  ),
                  Divider(),
                ],
              ),
              itemCount: alerts.length ?? 1,
            );
          } else {
            return CircularProgressIndicator();
          }
        },
      ),
    );
  }
}
