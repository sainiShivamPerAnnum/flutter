import 'package:felloapp/navigator/app_state.dart';
import 'package:felloapp/util/styles/styles.dart';
import 'package:flutter/material.dart';

class CallDetailsSheet extends StatelessWidget {
  final List<Map<String, String>> details;
  const CallDetailsSheet({
    required this.details,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          padding: EdgeInsets.symmetric(
            vertical: SizeConfig.padding14,
            horizontal: SizeConfig.padding20,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'User Details',
                style: TextStyles.sourceSansSB.body1,
              ),
            ],
          ),
        ),
        const Divider(
          color: UiConstants.greyVarient,
        ),
        ...details.asMap().entries.map((detailEntry) {
          int index = detailEntry.key + 1;
          Map<String, String> detailMap = detailEntry.value;

          String question = detailMap['question'] ?? '';
          String answer = detailMap['answer'] ?? '';

          return Padding(
            padding: EdgeInsets.symmetric(horizontal: SizeConfig.padding18),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(vertical: SizeConfig.padding4),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '$index. ',
                        style: TextStyles.sourceSansSB.body3,
                      ),
                      Expanded(
                        child: Text(
                          question,
                          style: TextStyles.sourceSans.body3,
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(
                    left: SizeConfig.padding20,
                    top: SizeConfig.padding4,
                  ),
                  child: Text(
                    answer,
                    style: TextStyles.sourceSans.body3
                        .colour(UiConstants.kTextColor5),
                  ),
                ),
              ],
            ),
          );
        }).toList(),
        const Divider(
          color: UiConstants.greyVarient,
        ),
        Padding(
          padding: EdgeInsets.all(SizeConfig.padding18),
          child: SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                AppState.backButtonDispatcher!.didPopRoute();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: UiConstants.kTextColor,
                padding: EdgeInsets.symmetric(
                  vertical: SizeConfig.padding16,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(SizeConfig.roundness8),
                ),
              ),
              child: Text(
                'Got it!',
                style:
                    TextStyles.sourceSans.body3.colour(UiConstants.kTextColor4),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
