import 'package:felloapp/base_util.dart';
import 'package:flutter/material.dart';

class NotficationsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: BaseUtil.getAppBar(context, "Notifications"),
    );
  }
}
