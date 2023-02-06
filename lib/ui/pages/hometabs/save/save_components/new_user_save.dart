import 'package:felloapp/core/enums/investment_type.dart';
import 'package:felloapp/ui/elements/custom_card/save_container.dart';
import 'package:felloapp/ui/pages/hometabs/save/save_components/campaings.dart';
import 'package:felloapp/ui/pages/hometabs/save/save_viewModel.dart';
import 'package:felloapp/ui/pages/static/save_assets_footer.dart';
import 'package:felloapp/util/assets.dart';
import 'package:felloapp/util/dynamic_ui_utils.dart';
import 'package:felloapp/util/styles/size_config.dart';
import 'package:felloapp/util/styles/textStyles.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class NewUserSaveView extends StatelessWidget {
  const NewUserSaveView({Key? key, required this.model}) : super(key: key);
  final SaveViewModel model;
  @override
  Widget build(BuildContext context) {
    return Container(
      height: SizeConfig.screenHeight,

      //Horizontal Padding for each widget is 24px
      child: Column(
        children: [
          SizedBox(height: SizeConfig.fToolBarHeight),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    decoration: BoxDecoration(
                        color: Color(0xff232326),
                        borderRadius: BorderRadius.vertical(
                            bottom: Radius.circular(SizeConfig.padding24))),
                    child: Column(
                      children: [
                        SizedBox(
                          height: SizeConfig.padding4,
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: SizeConfig.padding16),
                          child: Text(
                            "Take your first step towards healthy Savings",
                            textAlign: TextAlign.center,
                            style: TextStyles.rajdhaniSB.title4
                                .colour(Colors.white),
                          ),
                        ),
                        SizedBox(
                          height: SizeConfig.padding14,
                        ),
                        ...getAssetWidget(),
                        SizedBox(
                          height: SizeConfig.padding8,
                        ),
                        // Center(
                        //   child: Text(
                        //     "100% SAFE & SECURE",
                        //     style: TextStyles.sourceSans.body3
                        //         .colour(
                        //           Colors.white.withOpacity(0.6),
                        //         )
                        //         .copyWith(letterSpacing: 1.12),
                        //   ),
                        // ),
                        SizedBox(
                          height: SizeConfig.padding10,
                        ),
                        SaveAssetsFooter(),
                        SizedBox(
                          height: SizeConfig.padding10,
                        ),
                      ],
                    ),
                  ),
                  Campaigns(model: model),
                  SizedBox(
                    height: SizeConfig.padding40,
                  ),
                  LottieBuilder.asset(Assets.inAppScrollAnimation),
                  SizedBox(height: SizeConfig.navBarHeight),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> getAssetWidget() {
    List<Widget> children = [];
    DynamicUiUtils.saveViewOrder[0].forEach(
      (element) {
        if (element == "LB") {
          children.add(
            SaveContainer(
              bottomStrip: [
                "750+ users deposited in Gold today!",
                "An average saver saves ₹500 in Gold every 2 days"
              ],
              investmentType: InvestmentType.LENDBOXP2P,
              isPopular: DynamicUiUtils.islbTrending,
            ),
          );
        } else if (element == "AG") {
          children.add(SaveContainer(
            bottomStrip: [
              "750+ users deposited in Gold today!",
              "An average saver saves ₹500 in Gold every 2 days"
            ],
            investmentType: InvestmentType.AUGGOLD99,
            isPopular: DynamicUiUtils.isGoldTrending,
          ));
        }
      },
    );

    return children;
  }
}

// class MarqueeWidget extends StatefulWidget {
//   const MarqueeWidget({Key? key}) : super(key: key);

//   @override
//   State<MarqueeWidget> createState() => _MarqueeWidgetState();
// }

// class _MarqueeWidgetState extends State<MarqueeWidget> {
//   final ScrollController scrollController = ScrollController();
//   late Timer timer;

//   @override
//   void initState() {
//     timer = Timer.periodic(Duration(milliseconds: 160), (timer) {
//       WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
//         if (scrollController.hasClients) {
//           scrollController.animateTo(10,
//               duration: Duration(milliseconds: 160), curve: Curves.linear);
//         }
//       });
//     });
//     super.initState();
//   }

//   @override
//   void dispose() {
//     scrollController.dispose();
//     timer.cancel();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return ListView.builder(
//         scrollDirection: Axis.horizontal,
//         controller: scrollController,
//         itemBuilder: (_, index) {
//           return Column(
//             children: [
//               Row(
//                 children: [
//                   Text("5 Lakh+ Users"),
//                 ],
//               ),
//               Row(
//                 children: [
//                   Text("")
//                 ],
//               )
//             ],
//           );
//         });
//   }
// }
