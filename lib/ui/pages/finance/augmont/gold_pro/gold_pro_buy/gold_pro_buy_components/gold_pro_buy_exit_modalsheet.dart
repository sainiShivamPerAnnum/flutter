import 'package:felloapp/core/service/analytics/analytics_service.dart';
import 'package:felloapp/navigator/app_state.dart';
import 'package:felloapp/ui/elements/title_subtitle_container.dart';
import 'package:felloapp/util/locator.dart';
import 'package:felloapp/util/styles/styles.dart';
import 'package:flutter/material.dart';

class GoldProBuyExitModalSheet extends StatefulWidget {
  const GoldProBuyExitModalSheet({Key? key}) : super(key: key);

  @override
  State<GoldProBuyExitModalSheet> createState() =>
      _GoldProBuyExitModalSheetState();
}

class _GoldProBuyExitModalSheetState extends State<GoldProBuyExitModalSheet> {
  final List<String> _sellingReasons = [];

  @override
  void initState() {
    _sellingReasons.addAll([
      "Returns & value propositions are not clear",
      "Unsure about safety of investment",
      "Getting more returns elsewhere",
      "Just came here to explore",
    ]);
    super.initState();
  }

  String selectedReasonForSelling = '';
  int _selectedIndex = -1;

  int get selectedIndex => _selectedIndex;

  set selectedIndex(int value) {
    _selectedIndex = value;
    setState(() {});
  }

  final AnalyticsService _analyticsService = locator<AnalyticsService>();

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        AppState.removeOverlay();
        return Future.value(true);
      },
      child: Padding(
        padding: EdgeInsets.all(SizeConfig.padding10),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              height: SizeConfig.padding32,
            ),
            const TitleSubtitleContainer(
              title: "Why not earn 4.5% extra returns?",
              subTitle:
                  "Select any one option to help us improve your experience",
            ),
            ListView(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              padding: EdgeInsets.symmetric(
                  vertical: SizeConfig.pageHorizontalMargins),
              children: List.generate(
                  _sellingReasons.length,
                  (index) => RadioListTile(
                        toggleable: true,
                        activeColor: UiConstants.primaryColor,
                        selected: true,
                        value: index,
                        groupValue: _selectedIndex,
                        onChanged: (value) {
                          print(value);
                          selectedIndex = index;
                          selectedReasonForSelling = _sellingReasons[index];
                        },
                        title: Text(
                          _sellingReasons[index],
                          style: TextStyles.rajdhani.body2,
                        ),
                      )),
            ),
            MaterialButton(
              onPressed: () {},
              minWidth: SizeConfig.screenWidth! * 0.88,
              height: SizeConfig.padding44,
              color: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(SizeConfig.roundness12),
              ),
              child: Text(
                "CONTINUE TO GOLD PRO",
                style: TextStyles.rajdhaniB.body1.colour(Colors.black),
              ),
            ),
            TextButton(
              onPressed: () {
                AppState.backButtonDispatcher!.didPopRoute();
                AppState.backButtonDispatcher!.didPopRoute();
              },
              child: Text(
                "GO BACK",
                style: TextStyles.rajdhaniSB.body1.colour(Colors.grey),
              ),
            )
          ],
        ),
      ),
    );
  }
}
