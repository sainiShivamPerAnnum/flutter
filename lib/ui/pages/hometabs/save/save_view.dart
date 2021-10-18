import 'package:felloapp/core/enums/page_state_enum.dart';
import 'package:felloapp/core/enums/user_service_enum.dart';
import 'package:felloapp/core/service/user_service.dart';
import 'package:felloapp/navigator/app_state.dart';
import 'package:felloapp/navigator/router/ui_pages.dart';
import 'package:felloapp/ui/architecture/base_view.dart';
import 'package:felloapp/ui/pages/hometabs/save/save_viewModel.dart';
import 'package:felloapp/ui/widgets/buttons/sell_gold_button/sellGoldBtn_view.dart';
import 'package:felloapp/ui/widgets/mini_trans_card/mini_trans_card_view.dart';
import 'package:felloapp/util/assets.dart';
import 'package:felloapp/util/localization/generated/l10n.dart';
import 'package:felloapp/util/styles/palette.dart';
import 'package:felloapp/util/styles/size_config.dart';
import 'package:felloapp/util/styles/textStyles.dart';
import 'package:felloapp/util/styles/ui_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:property_change_notifier/property_change_notifier.dart';

class Save extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    S locale = S.of(context);
    return BaseView<SaveViewModel>(
      onModelReady: (model) {},
      builder: (ctx, model, child) {
        return ListView(
          children: [
            Container(
              margin: EdgeInsets.all(SizeConfig.scaffoldMargin),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(32),
                color: Colors.white,
              ),
              child: Container(
                padding: EdgeInsets.all(SizeConfig.pageHorizontalMargins),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(locale.saveGoldBalancelabel,
                            style: TextStyles.title5.light),
                        PropertyChangeConsumer<UserService,
                            UserServiceProperties>(
                          builder: (ctx, model, child) => Text(
                            locale.saveGoldBalanceValue(
                                // model.userFundWallet.augGoldQuantity ??
                                0.0),
                            style: TextStyles.title5.bold.colour(
                                FelloColorPalette.augmontFundPalette()
                                    .primaryColor),
                          ),
                        ),
                      ],
                    ),
                    Container(
                      margin: EdgeInsets.symmetric(vertical: 24),
                      child: Row(
                        children: [
                          Expanded(
                              child: Center(
                            child: InkWell(
                              onTap: () {
                                AppState.delegate.appState.currentAction =
                                    PageAction(
                                        state: PageState.addPage,
                                        page: AugmontGoldBuyPageConfig);
                              },
                              child: Container(
                                width: SizeConfig.screenWidth * 0.367,
                                height: SizeConfig.screenWidth * 0.12,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(100),
                                    color: UiConstants.primaryColor),
                                alignment: Alignment.center,
                                child: Text(
                                  locale.saveBuyButton,
                                  style: TextStyles.title5.bold
                                      .colour(Colors.white),
                                ),
                              ),
                            ),
                          )
                              // BuyGoldBtn(
                              //   activeButtonUI: Container(
                              //     decoration: BoxDecoration(
                              //       color: UiConstants.primaryColor,
                              //       borderRadius: BorderRadius.circular(100),
                              //     ),
                              //     padding: EdgeInsets.symmetric(vertical: 16),
                              //     alignment: Alignment.center,
                              //     child: Text("BUY",
                              //         style: TextStyles.title3.bold
                              //             .colour(Colors.white)),
                              //   ),
                              //   loadingButtonUI: Container(
                              //     decoration: BoxDecoration(
                              //       color: UiConstants.primaryColor,
                              //       borderRadius: BorderRadius.circular(100),
                              //     ),
                              //     padding: EdgeInsets.symmetric(vertical: 16),
                              //     alignment: Alignment.center,
                              //     child: SpinKitThreeBounce(
                              //       color: Colors.white,
                              //     ),
                              //   ),
                              //   disabledButtonUI: Container(
                              //     decoration: BoxDecoration(
                              //       color: Colors.grey[400],
                              //       borderRadius: BorderRadius.circular(100),
                              //     ),
                              //     padding: EdgeInsets.symmetric(vertical: 16),
                              //     alignment: Alignment.center,
                              //     child: Text(
                              //       "Offline",
                              //       style: TextStyles.title3.bold
                              //           .colour(Colors.white),
                              //     ),
                              //   ),
                              // ),
                              ),
                          SizedBox(width: 24),
                          Expanded(
                              child: Center(
                            child: SellGoldBtn(
                              activeButtonUI: Container(
                                width: SizeConfig.screenWidth * 0.367,
                                height: SizeConfig.screenWidth * 0.12,
                                decoration: BoxDecoration(
                                  border: Border.all(
                                      color: UiConstants.tertiarySolid,
                                      width: 2),
                                  borderRadius: BorderRadius.circular(100),
                                ),
                                alignment: Alignment.center,
                                child: Text(
                                  locale.saveSellButton,
                                  style: TextStyles.title5.bold,
                                ),
                              ),
                              loadingButtonUI: Container(
                                width: SizeConfig.screenWidth * 0.367,
                                height: SizeConfig.screenWidth * 0.12,
                                decoration: BoxDecoration(
                                  border: Border.all(
                                      color: UiConstants.tertiarySolid,
                                      width: 2),
                                  borderRadius: BorderRadius.circular(100),
                                ),
                                alignment: Alignment.center,
                                child: SpinKitThreeBounce(
                                  size: SizeConfig.title5,
                                  color: UiConstants.tertiarySolid,
                                ),
                              ),
                              disabledButtonUI: Container(
                                width: SizeConfig.screenWidth * 0.367,
                                height: SizeConfig.screenWidth * 0.12,
                                decoration: BoxDecoration(
                                  border:
                                      Border.all(color: Colors.grey, width: 2),
                                  borderRadius: BorderRadius.circular(100),
                                ),
                                alignment: Alignment.center,
                                child: Text(
                                  locale.saveSellButton,
                                  style: TextStyles.title5.bold
                                      .colour(Colors.grey),
                                ),
                              ),
                            ),
                            // ),
                          )
                              // SellGoldBtn(
                              //   activeButtonUI: Container(
                              //     decoration: BoxDecoration(
                              //       border: Border.all(
                              //           color: UiConstants.tertiarySolid),
                              //       borderRadius: BorderRadius.circular(100),
                              //     ),
                              //     padding: EdgeInsets.symmetric(vertical: 16),
                              //     alignment: Alignment.center,
                              //     child:
                              //         Text("SELL", style: TextStyles.title3.bold),
                              //   ),
                              //   loadingButtonUI: Container(
                              //     decoration: BoxDecoration(
                              //       border: Border.all(
                              //           color: UiConstants.tertiarySolid),
                              //       borderRadius: BorderRadius.circular(100),
                              //     ),
                              //     padding: EdgeInsets.symmetric(vertical: 16),
                              //     alignment: Alignment.center,
                              //     child: SpinKitThreeBounce(
                              //       color: UiConstants.tertiarySolid,
                              //     ),
                              //   ),
                              //   disabledButtonUI: Container(
                              //     decoration: BoxDecoration(
                              //       color: Colors.grey[400],
                              //       borderRadius: BorderRadius.circular(100),
                              //     ),
                              //     padding: EdgeInsets.symmetric(vertical: 16),
                              //     alignment: Alignment.center,
                              //     child: Text(
                              //       "Offline",
                              //       style: TextStyles.title3.bold
                              //           .colour(Colors.white),
                              //     ),
                              //   ),
                              // ),
                              ),
                        ],
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Image.asset(
                          Assets.augLogo,
                          height: SizeConfig.padding24,
                        ),
                        Image.asset(
                          Assets.sebiGraphic,
                          color: Colors.blue,
                          height: SizeConfig.padding20,
                        ),
                        TextButton.icon(
                          icon: Icon(
                            Icons.lock,
                            color: Colors.grey,
                            size: SizeConfig.body3,
                          ),
                          onPressed: () {},
                          label: Text(
                            "100% secure",
                            style: TextStyles.body3.colour(Colors.grey),
                          ),
                        ),
                      ],
                    ),
                    // Divider(
                    //   height: 0,
                    // ),
                    // Text("You get 1 ticket for every \$100 invested",
                    //     style: TextStyles.body3)
                  ],
                ),
              ),
            ),
            Container(
              decoration: BoxDecoration(
                  color: UiConstants.primaryColor,
                  borderRadius: BorderRadius.circular(32),
                  boxShadow: [
                    BoxShadow(
                      blurRadius: 30,
                      color: UiConstants.primaryColor.withOpacity(0.5),
                      offset: Offset(
                        0,
                        SizeConfig.screenWidth * 0.1,
                      ),
                      spreadRadius: -30,
                    )
                  ]),
              height: SizeConfig.screenWidth * 0.3,
              margin: EdgeInsets.all(SizeConfig.scaffoldMargin),
              child: Stack(
                children: [
                  Opacity(
                    opacity: 0.1,
                    child: Image.asset(
                      Assets.whiteRays,
                      fit: BoxFit.cover,
                      width: SizeConfig.screenWidth,
                    ),
                  ),
                  Container(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset(
                            Assets.moneyIcon,
                            width: SizeConfig.screenWidth * 0.24,
                          ),
                          SizedBox(width: 24),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                locale.saveWinningsLabel,
                                style:
                                    TextStyles.body1.colour(Colors.white).light,
                              ),
                              SizedBox(height: 8),
                              Text(
                                locale.saveWinningsValue(
                                    model.getUnclaimedPrizeBalance()),
                                // "₹ ${model.getUnclaimedPrizeBalance()}",
                                style:
                                    TextStyles.title2.colour(Colors.white).bold,
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 24,
            ),
            Container(
              width: SizeConfig.screenWidth,
              height: SizeConfig.screenWidth * 0.3,
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: List.generate(
                    3,
                    (index) {
                      return Container(
                        width: SizeConfig.screenWidth * 0.5,
                        height: SizeConfig.screenWidth * 0.24,
                        margin: EdgeInsets.only(
                            left: SizeConfig.scaffoldMargin,
                            right: SizeConfig.scaffoldMargin / 2),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(32),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 24.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Image.asset("images/augmont-share.png",
                                  width: 50),
                              SizedBox(width: 16),
                              Expanded(
                                child: Text(
                                  "What is digital Gold",
                                  maxLines: 3,
                                  style: TextStyles.body1.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.all(SizeConfig.scaffoldMargin),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(32),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 16),
                  Container(
                      margin: EdgeInsets.symmetric(
                          horizontal: SizeConfig.scaffoldMargin, vertical: 16),
                      child: Text(locale.saveHistory,
                          style: TextStyles.title2.bold)),
                  MiniTransactionCard(),
                ],
              ),
            ),
            SizedBox(height: kBottomNavigationBarHeight * 4),
          ],
        );
      },
    );
  }
}

// FELLO BUTTON IMPLEMENTATION

// Row(
//   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//   children: [
//     FelloButton(
//         textStyle: TextStyle(color: Colors.white),
//         action: (val) {
//           if (val) print("I Changed");
//         },
//         offlineButtonUI: Container(
//           width: 300,
//           height: 50,
//           decoration: BoxDecoration(
//             borderRadius: BorderRadius.circular(100),
//             color: Colors.grey,
//           ),
//           alignment: Alignment.center,
//           child: Text("Fello Button"),
//         ),
//         activeButtonUI: Container(
//           width: 150,
//           height: 50,
//           decoration: BoxDecoration(
//             borderRadius: BorderRadius.circular(100),
//             color: UiConstants.primaryColor,
//           ),
//           alignment: Alignment.center,
//           child: Text("Fello Button"),
//         ),
//         onPressed: () {
//           showDialog(
//             context: context,
//             builder: (ctx) => FelloConfirmationDialog(
//               content: Padding(
//                 padding:
//                     EdgeInsets.all(SizeConfig.globalMargin * 3),
//                 child: SvgPicture.asset("images/svgs/offline.svg"),
//               ),
//               onAccept: () async {
//                 Navigator.pop(context);

//                 AppState.delegate.appState.currentAction =
//                     PageAction(
//                   page: TransactionPageConfig,
//                   state: PageState.addPage,
//                 );
//               },
//               onReject: () => Navigator.pop(context),
//               result: (res) {
//                 if (res) print("I Changed");
//               },
//             ),
//           );
//         }),
//     FelloButton(
//       onPressedAsync: () async {
//         await Future.delayed(Duration(seconds: 3));
//       },
//       onPressed: () {
//         AppState.delegate.appState.currentAction = PageAction(
//           state: PageState.addPage,
//           page: SplashPageConfig,
//         );
//       },
//       // onPressed: () => showDialog(
//       //   context: context,
//       //   builder: (ctx) => FelloInfoDialog(
//       //     title: "Info Dialog",
//       //     subtitle: "This is the subtitle",
//       //     body:
//       //         "What other ways do you use to minimize the app size ??with tooling and language features that allow developers to eliminate a whole class of errors, increase app performance and reduce package size.",
//       //   ),
//       // ),
//     )
//   ],
// ),
