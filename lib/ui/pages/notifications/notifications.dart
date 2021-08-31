import 'package:felloapp/base_util.dart';
import 'package:felloapp/util/size_config.dart';
import 'package:felloapp/util/ui_constants.dart';
import 'package:flutter/material.dart';

class NotficationsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: BaseUtil.getAppBar(context, "Notifications"),
      body: ListView.builder(
        itemBuilder: (context, index) => Column(
          children: [
            ListTile(
              title: Text(
                'Notification Title',
                style: TextStyle(
                  color: UiConstants.textColor,
                  fontSize: SizeConfig.screenHeight * 0.02,
                ),
              ),
              subtitle: Text('Notification Subtitle'),
              trailing: Text('4:00 PM'),
            ),
            Divider(),
          ],
        ),
        itemCount: 2,
      ),
    );
  }
}
