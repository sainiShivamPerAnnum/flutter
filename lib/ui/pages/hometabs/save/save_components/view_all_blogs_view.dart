import 'package:felloapp/ui/widgets/buttons/nav_buttons/nav_buttons.dart';
import 'package:felloapp/util/styles/textStyles.dart';
import 'package:felloapp/util/styles/ui_constants.dart';
import 'package:flutter/material.dart';

class ViewAllBlogsView extends StatelessWidget {
  const ViewAllBlogsView({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: UiConstants.kBackgroundColor,
      appBar: AppBar(
        leading: FelloAppBarBackButton(),
        elevation: 0,
        backgroundColor: UiConstants.kBackgroundColor,
        title: Text('Blogs', style: TextStyles.rajdhaniSB.title5),
        centerTitle: false,
      ),
      body: Column(
        children: [],
      ),
    );
  }
}
