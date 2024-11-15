import 'package:felloapp/navigator/app_state.dart';
import 'package:felloapp/ui/pages/hometabs/save/save_viewModel.dart';
import 'package:felloapp/util/styles/styles.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class FirstFreeCall extends StatelessWidget {
  const FirstFreeCall({super.key});

  @override
  Widget build(BuildContext context) {
    return Selector<SaveViewModel, bool>(
      selector: (_, model) => model.freeCallAvailable,
      builder: (_, freeCallAvailable, __) {
        return freeCallAvailable
            ? Container(
                margin: EdgeInsets.symmetric(
                  vertical: SizeConfig.padding4,
                  horizontal: SizeConfig.padding20,
                ).copyWith(top: SizeConfig.padding8,),
                padding: EdgeInsets.all(SizeConfig.padding16),
                width: double.maxFinite,
                decoration: BoxDecoration(
                  color: UiConstants.greyVarient,
                  borderRadius: BorderRadius.circular(SizeConfig.roundness8),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      'BOOK A CALL',
                      style: TextStyles.sourceSansB.body6.colour(
                        UiConstants.kTabBorderColor,
                      ),
                    ),
                    SizedBox(height: SizeConfig.padding4),
                    Text(
                      'First Call FREE',
                      style: TextStyles.sourceSansB.body1,
                    ),
                    SizedBox(height: SizeConfig.padding4),
                    Text(
                      'Connect with Our Trusted Advisors Now!',
                      style: TextStyles.sourceSans.body3,
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: SizeConfig.padding16),
                    ElevatedButton(
                      onPressed: () {
                        AppState.delegate!.parseRoute(Uri.parse("experts"));
                      },
                      style: ElevatedButton.styleFrom(
                        minimumSize: const Size(0, 0),
                        padding: EdgeInsets.symmetric(
                          vertical: SizeConfig.padding6,
                          horizontal: SizeConfig.padding12,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(
                            SizeConfig.roundness5,
                          ),
                        ),
                      ),
                      child: Text(
                        'Book Now!',
                        style: TextStyles.sourceSansSB.body4
                            .colour(UiConstants.textColor),
                      ),
                    ),
                  ],
                ),
              )
            : const SizedBox.shrink();
      },
    );
  }
}
