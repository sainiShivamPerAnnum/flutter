import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tambola/src/tambola_home/view/tambola_home_details_view.dart';
import 'package:tambola/src/tambola_home/view/tambola_home_tickets_view.dart';
import 'package:tambola/src/utils/styles/ui_constants.dart';

class Service extends ChangeNotifier {
  int activeTambolaCardCount = 0;

  void refreshTambolaTickets() async {}
}

class TambolaHomeView extends StatelessWidget {
  const TambolaHomeView(
      {Key? key, required this.service, this.standAloneScreen = true})
      : super(key: key);
  final bool standAloneScreen;
  final dynamic service;
  @override
  Widget build(BuildContext context) {
    return Consumer<Service>(
        // onModelReady: (model) {
        //   model.init();
        // },
        builder: (ctx, model, child) {
      // if (model.state == ViewState.Busy) {
      //   return const Scaffold(
      //     body: Center(child: FullScreenLoader()),
      //     backgroundColor: UiConstants.kBackgroundColor,
      //   );
      // }
      return standAloneScreen
          ? Scaffold(
              backgroundColor: UiConstants.kBackgroundColor,
              appBar: AppBar(
                title: Text("New Screen"),
                // appBar: FAppBar(
                //   showAvatar: false,
                //   showCoinBar: false,
                //   showHelpButton: false,
                //   action: Row(
                //     children: [
                //       TextButton(
                //         style: TextButton.styleFrom(
                //           side: const BorderSide(color: Colors.white, width: 1),
                //           shape: const RoundedRectangleBorder(
                //               borderRadius:
                //                   BorderRadius.all(Radius.circular(25))),
                //         ),
                //         onPressed: () {
                //           AppState.delegate!.appState.currentAction =
                //               PageAction(
                //             state: PageState.addWidget,
                //             page: TambolaNewUser,
                //             widget: TambolaHomeDetailsView(
                //               model: model,
                //               showPrizeSection: true,
                //             ),
                //           );
                //         },
                //         child: Padding(
                //           padding:
                //               const EdgeInsets.only(left: 10.0, right: 10.0),
                //           child: Text(
                //             "Prizes",
                //             style: TextStyle(
                //               color: Colors.white,
                //               fontSize: SizeConfig.body2,
                //             ),
                //           ),
                //         ),
                //       ),
                //       SizedBox(
                //         width: SizeConfig.padding12,
                //       ),
                //       InkWell(
                //         onTap: () => AppState.delegate!.appState.currentAction =
                //             PageAction(
                //           state: PageState.addWidget,
                //           page: TambolaNewUser,
                //           widget: TambolaHomeDetailsView(
                //             model: model,
                //           ),
                //         ),
                //         child: Container(
                //           decoration: BoxDecoration(
                //               shape: BoxShape.circle,
                //               color: UiConstants.kArrowButtonBackgroundColor,
                //               border: Border.all(color: Colors.white)),
                //           padding: const EdgeInsets.all(6),
                //           child: Icon(
                //             Icons.question_mark,
                //             color: Colors.white,
                //             size: SizeConfig.padding20,
                //           ),
                //         ),
                //       )
                //     ],
                //   ),
                //   title: "Tambola",
                //   backgroundColor: UiConstants.kBackgroundColor,
                // ),
              ),
              body: RefreshIndicator(
                color: UiConstants.primaryColor,
                backgroundColor: Colors.black,
                onRefresh: () async => model.refreshTambolaTickets(),
                child: (model.activeTambolaCardCount ?? 0) > 0
                    ? TambolaHomeTicketsView()
                    : TambolaHomeDetailsView(),
              ),
            )
          : RefreshIndicator(
              color: UiConstants.primaryColor,
              backgroundColor: Colors.black,
              onRefresh: () async => model.refreshTambolaTickets(),
              child: (model.activeTambolaCardCount ?? 0) < 0
                  ? TambolaHomeTicketsView()
                  : TambolaHomeDetailsView(),
            );
    });
  }
}
