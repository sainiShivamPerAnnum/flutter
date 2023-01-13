import 'package:felloapp/navigator/app_state.dart';
import 'package:felloapp/ui/pages/static/app_widget.dart';
import 'package:felloapp/util/assets.dart';
import 'package:felloapp/util/styles/size_config.dart';
import 'package:felloapp/util/styles/textStyles.dart';
import 'package:felloapp/util/styles/ui_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_svg/svg.dart';

class TambolaInstantView extends StatelessWidget {
  const TambolaInstantView({Key? key, required this.ticketCount})
      : super(key: key);
  final int ticketCount;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black.withOpacity(0.5),
      body: Center(
        child: Container(
          padding: EdgeInsets.only(
            bottom: 14,
            left: 14,
          ),
          height: SizeConfig.screenHeight! * 0.48,
          width: SizeConfig.screenWidth! * 0.8,
          decoration: BoxDecoration(
            color: Color(0xff39393C),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Align(
                  alignment: Alignment.topRight,
                  child: GestureDetector(
                    onTap: () {
                      AppState.backButtonDispatcher!.didPopRoute();
                    },
                    child: Container(
                      padding: EdgeInsets.all(8),
                      child: Icon(
                        Icons.close,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
              ...[
                SvgPicture.asset(
                  Assets.tambola_instant_view,
                  height: SizeConfig.screenHeight! * 0.12,
                ),
                SizedBox(
                  height: SizeConfig.padding28,
                ),
                Text(
                  "Congratulations! \nyou got $ticketCount tambola tickets",
                  style: TextStyles.sourceSansSB.title5,
                  textAlign: TextAlign.center,
                ),
                SizedBox(
                  height: 8,
                ),
                Text(
                  "3 picks announced daily.\nMatching numbers are auto-crossed.\nWinners announced every Sunday.",
                  textAlign: TextAlign.center,
                  style: TextStyles.sourceSans.body3
                      .colour(Colors.white.withOpacity(0.6)),
                ),
                Spacer(),
                Padding(
                  padding: const EdgeInsets.only(right: 14),
                  child: AppPositiveBtn(
                    btnText: "GET STARTED",
                    onPressed: () {
                      AppState.backButtonDispatcher!.didPopRoute();
                    },
                  ),
                )
              ]
            ],
          ),
        ),
      ),
    );
  }
}
