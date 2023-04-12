import 'package:felloapp/core/enums/faqTypes.dart';
import 'package:felloapp/core/enums/page_state_enum.dart';
import 'package:felloapp/core/repository/ticket_repo.dart';
import 'package:felloapp/navigator/app_state.dart';
import 'package:felloapp/navigator/router/ui_pages.dart';
import 'package:felloapp/ui/pages/games/tambola/tambola_home/view_model/tambola_home_vm.dart';
import 'package:felloapp/ui/pages/games/tambola/tambola_home/widgets/ticket_view.dart';
import 'package:felloapp/ui/pages/support/faq/faq_page.dart';
import 'package:felloapp/util/assets.dart';
import 'package:felloapp/util/constants.dart';
import 'package:felloapp/util/localization/generated/l10n.dart';
import 'package:felloapp/util/styles/size_config.dart';
import 'package:felloapp/util/styles/textStyles.dart';
import 'package:felloapp/util/styles/ui_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class TicketWidget extends StatelessWidget {
  const TicketWidget(
      {Key? key,
      required this.model,
      required this.animationController,
      required this.scrollController,
      required this.locale})
      : super(key: key);

  final TambolaHomeViewModel model;
  final AnimationController animationController;
  final ScrollController scrollController;
  final S locale;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TicketHeader(
            activeTambolaCardCount: model.activeTambolaCardCount ?? 0,
            scrollController: scrollController,
            animationController: animationController,
            locale: locale,
            buyTicketWidgetKey: model.itemKey),
        SizedBox(
          height: SizeConfig.padding6,
        ),
        TicketsView(model: model),
        SizedBox(
          height: SizeConfig.padding10,
        )
      ],
    );
  }
}

class TicketHeader extends StatelessWidget {
  const TicketHeader({
    super.key,
    required this.scrollController,
    required this.animationController,
    required this.locale,
    required this.activeTambolaCardCount,
    required this.buyTicketWidgetKey,
  });

  final int activeTambolaCardCount;
  final ScrollController scrollController;
  final AnimationController animationController;
  final S locale;
  final GlobalKey buyTicketWidgetKey;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: SizeConfig.padding26,
        vertical: SizeConfig.padding16,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                children: [
                  SvgPicture.asset(Assets.ticket_icon),
                  SizedBox(
                    width: SizeConfig.padding8,
                  ),
                  Text("Tickets ($activeTambolaCardCount)",
                      style: TextStyles.rajdhaniSB.body1),
                ],
              ),
              // if (TambolaRepo.expiringTicketCount != 0)
              if (TambolaRepo.expiringTicketCount > 1)
                SizedBox(
                  height: SizeConfig.padding4,
                ),
              if (TambolaRepo.expiringTicketCount > 1)
                Row(
                  children: [
                    Text(
                      "${TambolaRepo.expiringTicketCount} ticket${TambolaRepo.expiringTicketCount > 1 ? 's' : ''} expiring this Sunday. ",
                      style: TextStyles.sourceSansSB.body4
                          .colour(UiConstants.kBlogTitleColor),
                    ),
                    GestureDetector(
                      onTap: () {
                        AppState.delegate!.appState.currentAction = PageAction(
                          state: PageState.addWidget,
                          page: FaqPageConfig,
                          widget: const FAQPage(
                            type: FaqsType.play,
                          ),
                        );
                      },
                      child: Text(
                        "Know More",
                        style: TextStyles.sourceSansSB.body4
                            .colour(UiConstants.kBlogTitleColor)
                            .copyWith(
                                decorationStyle: TextDecorationStyle.solid,
                                decoration: TextDecoration.underline),
                      ),
                    ),
                  ],
                ),
            ],
          ),
          GestureDetector(
            onTap: () {
              final RenderBox renderBox = buyTicketWidgetKey.currentContext!
                  .findRenderObject() as RenderBox;
              final offset = renderBox.localToGlobal(Offset.zero);

              scrollController.animateTo(
                  offset.dy - SizeConfig.screenWidth! * 0.5,
                  duration: const Duration(milliseconds: 500),
                  curve: Curves.fastOutSlowIn);
              animationController
                  .forward()
                  .then((value) => animationController.reset());
            },
            child: Container(
              padding: EdgeInsets.symmetric(
                horizontal: SizeConfig.padding12,
                vertical: SizeConfig.padding6,
              ),
              decoration: BoxDecoration(
                color: Colors.transparent,
                border: Border.all(color: Colors.white),
                borderRadius: BorderRadius.circular(SizeConfig.roundness40),
              ),
              child: Text(
                locale.tGetTickets,
                style: TextStyles.rajdhaniSB.body4.colour(Colors.white),
                key: const ValueKey(Constants.GET_TAMBOLA_TICKETS),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
