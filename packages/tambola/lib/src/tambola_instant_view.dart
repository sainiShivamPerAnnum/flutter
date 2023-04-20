import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:tambola/src/utils/assets.dart';
import 'package:tambola/src/utils/styles/styles.dart';

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
          padding: const EdgeInsets.only(
            bottom: 14,
            left: 14,
          ),
          height: SizeConfig.screenHeight! * 0.48,
          width: SizeConfig.screenWidth! * 0.8,
          decoration: BoxDecoration(
            color: const Color(0xff39393C),
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
                      //TODO: REVERT WHEN PACAKGE IS SETUP

                      // AppState.backButtonDispatcher!.didPopRoute();
                    },
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      child: const Icon(
                        Icons.close,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
              ...[
                SvgPicture.asset(
                  Assets.tambolaInstantView,
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
                const SizedBox(
                  height: 8,
                ),
                Text(
                  "3 picks announced daily.\nMatching numbers are auto-crossed.\nWinners announced every Sunday.",
                  textAlign: TextAlign.center,
                  style: TextStyles.sourceSans.body3
                      .colour(Colors.white.withOpacity(0.6)),
                ),
                const Spacer(),
                //TODO: REVERT WHEN PACAKGE IS SETUP

                // Padding(
                //   padding: const EdgeInsets.only(right: 14),
                //   child: AppPositiveBtn(
                //     btnText: "GET STARTED",
                //     onPressed: () {
                //       AppState.backButtonDispatcher!.didPopRoute();
                //     },
                //   ),
                // )
              ]
            ],
          ),
        ),
      ),
    );
  }
}
