import 'package:felloapp/core/enums/page_state_enum.dart';
import 'package:felloapp/navigator/app_state.dart';
import 'package:felloapp/navigator/router/ui_pages.dart';
import 'package:felloapp/util/assets.dart';
import 'package:felloapp/util/styles/size_config.dart';
import 'package:felloapp/util/styles/textStyles.dart';
import 'package:felloapp/util/styles/ui_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class FelloAppBar extends StatelessWidget {
  final Widget leading;
  final List<Widget> actions;
  final String title;

  FelloAppBar({this.leading, this.actions, this.title});
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        width: SizeConfig.screenWidth,
        // height: SizeConfig.padding40,
        margin: EdgeInsets.symmetric(
          vertical: SizeConfig.padding8,
          horizontal: SizeConfig.pageHorizontalMargins,
        ),
        child: Row(
          children: [
            if (leading != null) leading,
            SizedBox(width: 16),
            if (title != null)
              FittedBox(
                child: Text(
                  title,
                  maxLines: 1,
                  overflow: TextOverflow.clip,
                  style: TextStyles.title4.bold.colour(Colors.white),
                ),
              ),
            Spacer(),
            if (actions != null)
              Row(
                children: actions,
              )
          ],
        ),
      ),
    );
  }
}

class NotificationButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        AppState.delegate.appState.currentAction =
            PageAction(state: PageState.addPage, page: NotificationsConfig);
      },
      child: CircleAvatar(
        backgroundColor: Colors.black,
        radius: SizeConfig.avatarRadius,
        child: Padding(
          padding: EdgeInsets.all(SizeConfig.padding12),
          child: SvgPicture.asset(
            Assets.alerts,
          ),
        ),
      ),
    );
  }
}

class FelloAppBarBackButton extends StatelessWidget {
  final Function onBackPress;
  FelloAppBarBackButton({this.onBackPress});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onBackPress ?? () => AppState.backButtonDispatcher.didPopRoute(),
      child: CircleAvatar(
        radius: SizeConfig.avatarRadius,
        backgroundColor: Colors.white.withOpacity(0.4),
        child: Padding(
          padding: EdgeInsets.all(SizeConfig.padding4),
          child:
              Icon(Icons.arrow_back_rounded, color: UiConstants.primaryColor),
        ),
      ),
    );
  }
}

class TextFieldLabel extends StatelessWidget {
  final String text;
  TextFieldLabel(this.text);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: SizeConfig.padding6,
        top: SizeConfig.padding16,
      ),
      child: Text(
        text,
        style: TextStyles.body3.colour(Colors.grey),
      ),
    );
  }
}
