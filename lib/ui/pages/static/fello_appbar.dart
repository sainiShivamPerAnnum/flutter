import 'package:felloapp/core/enums/screen_item_enum.dart';
import 'package:felloapp/navigator/app_state.dart';
import 'package:felloapp/ui/modals_sheets/want_more_tickets_modal_sheet.dart';
import 'package:felloapp/util/styles/size_config.dart';
import 'package:felloapp/util/styles/textStyles.dart';
import 'package:felloapp/util/styles/ui_constants.dart';
import 'package:flutter/material.dart';

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
        child: Container(
          margin: EdgeInsets.symmetric(
            vertical: kToolbarHeight / 3,
            horizontal: SizeConfig.scaffoldMargin,
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
      ),
    );
  }
}

class FelloCurrency extends StatelessWidget {
  const FelloCurrency({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        AppState.screenStack.add(ScreenItem.dialog);
        showModalBottomSheet(
            backgroundColor: Colors.transparent,
            context: context,
            builder: (ctx) {
              return WantMoreTicketsModalSheet();
            });
      },
      child: Container(
        height: kToolbarHeight * 0.8,
        padding: EdgeInsets.symmetric(
          horizontal: SizeConfig.globalMargin,
        ),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(100),
          color: Colors.white.withOpacity(0.4),
        ),
        child: Row(
          children: [
            Icon(
              Icons.airplane_ticket,
              size: 30,
              color: UiConstants.tertiarySolid,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4.0),
              child: Text("200", style: TextStyles.body2.bold),
            ),
            Icon(
              Icons.add_circle,
              size: 30,
              color: UiConstants.primaryColor,
            ),
          ],
        ),
      ),
    );
  }
}

class NotificationButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      backgroundColor: Colors.black,
      radius: kToolbarHeight * 0.4,
      child: Icon(
        Icons.notifications,
        color: Colors.white,
        size: kToolbarHeight * 0.4,
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
        radius: kToolbarHeight * 0.5,
        backgroundColor: Colors.white.withOpacity(0.4),
        child: Icon(Icons.arrow_back_rounded, color: UiConstants.primaryColor),
      ),
    );
  }
}
