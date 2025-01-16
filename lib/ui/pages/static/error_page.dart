import 'package:felloapp/navigator/app_state.dart';
import 'package:felloapp/ui/pages/static/app_widget.dart';
import 'package:felloapp/util/assets.dart';
import 'package:felloapp/util/styles/styles.dart';
import 'package:flutter/material.dart';

class NewErrorPage extends StatelessWidget {
  final VoidCallback? onTryAgain;
  final VoidCallback? onPressed;

  const NewErrorPage({
    this.onTryAgain,
    this.onPressed,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          AppImage(
            Assets.error,
            height: SizeConfig.padding80,
            width: SizeConfig.padding80,
          ),
          Text(
            'Oops, Something went wrong',
            style: TextStyles.sourceSansSB.title4.colour(
              UiConstants.kTextColor,
            ),
          ),
          SizedBox(
            height: SizeConfig.padding12,
          ),
          Text(
            'Our team is trying to resolve it earliest possible. Please try again later.',
            style: TextStyles.sourceSans.body3.colour(
              UiConstants.textGray70,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(
            height: SizeConfig.padding40,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              MaterialButton(
                height: SizeConfig.padding44,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(SizeConfig.roundness5),
                ),
                materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                color: UiConstants.greyVarient,
                onPressed: onTryAgain ??
                    () => AppState.backButtonDispatcher!.didPopRoute(),
                child: Text(
                  'Try Again',
                  style: TextStyles.rajdhaniB.body1.colour(
                    Colors.white,
                  ),
                ),
              ),
              SizedBox(
                width: SizeConfig.padding20,
              ),
              MaterialButton(
                height: SizeConfig.padding44,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(SizeConfig.roundness5),
                ),
                materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                color: UiConstants.kTextColor,
                onPressed: onPressed ??
                    () => AppState.backButtonDispatcher!.didPopRoute(),
                child: Text(
                  'Close',
                  style: TextStyles.rajdhaniB.body1.colour(
                    Colors.black,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
