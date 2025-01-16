import 'package:felloapp/core/model/app_config_serialized_model.dart';
import 'package:felloapp/navigator/app_state.dart';
import 'package:felloapp/ui/pages/static/app_widget.dart';
import 'package:felloapp/util/styles/styles.dart';
import 'package:flutter/material.dart';

class LearmMoreOnRPS extends StatelessWidget {
  const LearmMoreOnRPS({super.key});

  @override
  Widget build(BuildContext context) {
    List<Map<String, String>> rpsQNA = AppConfigV2.instance.rpsLearnMore;
    return BaseScaffold(
      appBar: AppBar(
        backgroundColor: UiConstants.kTambolaMidTextColor,
        surfaceTintColor: UiConstants.kTambolaMidTextColor,
        centerTitle: false,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                GestureDetector(
                  onTap: () {
                    AppState.backButtonDispatcher!.didPopRoute();
                  },
                  child: Icon(
                    Icons.arrow_back,
                    color: Colors.white,
                    size: SizeConfig.padding20,
                  ),
                ),
                SizedBox(
                  width: SizeConfig.padding18,
                ),
                Column(
                  children: [
                    Text(
                      'Learn More',
                      style: TextStyles.sourceSansSB.body1,
                    ),
                  ],
                ),
              ],
            ),
            Row(
              children: [
                SizedBox(
                  width: SizeConfig.padding35,
                ),
                Text(
                  'Understand how repayment schedule works',
                  style: TextStyles.sourceSans.body3,
                ),
              ],
            ),
          ],
        ),
        leading: const SizedBox.shrink(),
        leadingWidth: 0,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding:
              EdgeInsets.symmetric(horizontal: SizeConfig.padding16).copyWith(
            top: SizeConfig.padding32,
          ),
          child: Column(
            children: [
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: rpsQNA.length,
                itemBuilder: (context, index) {
                  final item = rpsQNA[index];
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${index + 1}. ${item['qa'] ?? ''}',
                        style: TextStyles.sourceSansSB.body3,
                      ),
                      SizedBox(
                        height: SizeConfig.padding6,
                      ),
                      Text(
                        item['ans'] ?? '',
                        style: TextStyles.sourceSans.body3.colour(
                          UiConstants.kTextColor6,
                        ),
                      ),
                      SizedBox(
                        height: SizeConfig.padding24,
                      ),
                    ],
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
