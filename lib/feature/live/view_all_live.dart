import 'package:felloapp/ui/pages/static/app_widget.dart';
import 'package:felloapp/util/styles/textStyles.dart';
import 'package:flutter/material.dart';

class ViewAllLive extends StatelessWidget {
  const ViewAllLive({required this.appBarTitle, super.key});
  final String appBarTitle;

  @override
  Widget build(BuildContext context) {
    return BaseScaffold(
      showBackgroundGrid: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        surfaceTintColor: Colors.transparent,
        centerTitle: true,
        title: Text(appBarTitle, style: TextStyles.rajdhaniSB.body1),
        leading: const BackButton(
          color: Colors.white,
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [],
        ),
      ),
    );
  }
}