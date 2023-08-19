import 'package:felloapp/feature/tambola/src/ui/animations/dotted_border_animation.dart';
import 'package:felloapp/feature/tambola/src/ui/onboarding/intro_view/tickets_intro_view.dart';
import 'package:felloapp/feature/tambola/src/ui/widgets/ticket/tambola_ticket.dart';
import 'package:felloapp/feature/tambola/src/ui/widgets/ticket/ticket_painter.dart';
import 'package:felloapp/util/assets.dart';
import 'package:felloapp/util/styles/styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:tuple/tuple.dart';

class TicketsTutorialsSlotMachineView extends StatefulWidget {
  const TicketsTutorialsSlotMachineView({super.key});

  @override
  State<TicketsTutorialsSlotMachineView> createState() =>
      _TicketsTutorialsSlotMachineViewState();
}

class _TicketsTutorialsSlotMachineViewState
    extends State<TicketsTutorialsSlotMachineView> {
  late PageController _controller1, _controller2, _controller3;

  @override
  void initState() {
    _controller1 = PageController(viewportFraction: 0.8);
    _controller2 = PageController(viewportFraction: 0.8);
    _controller3 = PageController(viewportFraction: 0.8);
    super.initState();
  }

  @override
  void dispose() {
    _controller1.dispose();
    _controller2.dispose();
    _controller3.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: UiConstants.kBackgroundColor,
      body: SizedBox(
        width: SizeConfig.screenWidth,
        height: SizeConfig.screenHeight,
        child: Stack(
          children: [
            Positioned(
              top: SizeConfig.screenHeight! * 0.1,
              left: -SizeConfig.screenWidth! / 3,
              child: const RotatingPolkaDotsWidget(),
            ),
            Positioned(
              top: SizeConfig.screenHeight! * 0.1,
              right: -SizeConfig.screenWidth! / 3,
              child: const RotatingPolkaDotsWidget(),
            ),
            SafeArea(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    const SizedBox(height: kToolbarHeight),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Hero(
                          tag: "mainAsset",
                          child: SvgPicture.asset(
                            Assets.tambolaCardAsset,
                            width: SizeConfig.padding70,
                          ),
                        ),
                        Hero(
                          tag: "mainTitle",
                          child: Material(
                            color: Colors.transparent,
                            child: Stack(
                              children: [
                                Text(
                                  "Tickets",
                                  style: TextStyles.rajdhaniB.title1
                                      .colour(Colors.white),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: SizeConfig.padding10),
                    Text(
                      "Spin to reveal numbers everyday",
                      style: TextStyles.sourceSansSB.body2.colour(Colors.white),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: SizeConfig.padding10),
                    Text(
                      "( Don’t worry, if you forget we will do it for you )",
                      style: TextStyles.sourceSansSB.body3
                          .colour(UiConstants.primaryColor),
                      textAlign: TextAlign.center,
                    ),
                    Container(
                      width: SizeConfig.screenWidth,
                      margin: EdgeInsets.all(SizeConfig.pageHorizontalMargins),
                      padding: EdgeInsets.all(SizeConfig.pageHorizontalMargins),
                      decoration: BoxDecoration(
                        borderRadius:
                            BorderRadius.circular(SizeConfig.roundness16),
                        color: UiConstants.darkPrimaryColor,
                      ),
                      child: Column(
                        children: [
                          Text(
                            "Reveal numbers to match with Tickets",
                            style: TextStyles.sourceSansB.body2
                                .colour(Colors.white),
                          ),
                          Padding(
                            padding: EdgeInsets.all(SizeConfig.padding16),
                            child: AnimatedDottedRectangle(
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(
                                      SizeConfig.roundness16),
                                  color: Colors.black,
                                ),
                                margin: EdgeInsets.all(SizeConfig.padding16),
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: PageView.builder(
                                        controller: _controller1,
                                        scrollDirection: Axis.vertical,
                                        itemCount: 10,
                                        physics: const BouncingScrollPhysics(),
                                        itemBuilder: (ctx, i) => Container(
                                          alignment: Alignment.center,
                                          height: SizeConfig.title50,
                                          child: Text(
                                            "${i + 10}",
                                            style: TextStyles.rajdhaniSB.title1
                                                .colour(Colors.white),
                                          ),
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      child: PageView.builder(
                                        controller: _controller2,
                                        scrollDirection: Axis.vertical,
                                        itemCount: 10,
                                        physics: const BouncingScrollPhysics(),
                                        itemBuilder: (ctx, i) => Container(
                                          alignment: Alignment.center,
                                          height: SizeConfig.title50,
                                          child: Text(
                                            "${i + 10}",
                                            style: TextStyles.rajdhaniSB.title1
                                                .colour(Colors.white),
                                          ),
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      child: PageView.builder(
                                        controller: _controller3,
                                        scrollDirection: Axis.vertical,
                                        itemCount: 10,
                                        physics: const BouncingScrollPhysics(),
                                        itemBuilder: (ctx, i) => Container(
                                          alignment: Alignment.center,
                                          height: SizeConfig.title50,
                                          child: Text(
                                            "${i + 10}",
                                            style: TextStyles.rajdhaniSB.title1
                                                .colour(Colors.white),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          Text(
                            "1/2 Spins Left",
                            style: TextStyles.body4.colour(Colors.white),
                          ),
                          SizedBox(height: SizeConfig.padding16),
                          MaterialButton(
                            height: SizeConfig.padding44,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(
                                    SizeConfig.roundness5)),
                            minWidth: SizeConfig.screenWidth! * 0.3,
                            color: Colors.white,
                            onPressed: () {},
                            child: Text(
                              "SPIN",
                              style: TextStyles.rajdhaniB.body0
                                  .colour(Colors.black),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width * 0.7,
                      height: MediaQuery.of(context).size.width * 0.6,
                      margin: EdgeInsets.all(SizeConfig.pageHorizontalMargins),
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          ClipPath(
                            clipper: const TicketPainter(),
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: SizeConfig.padding16,
                                vertical: SizeConfig.padding16,
                              ),
                              width: MediaQuery.of(context).size.width * 0.7,
                              decoration: BoxDecoration(
                                color: UiConstants.kBuyTicketBg,
                                borderRadius: BorderRadius.circular(10.0),
                                border: Border.all(
                                    color: UiConstants.kFAQDividerColor
                                        .withOpacity(0.2),
                                    width: 1.5),
                              ),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Row(
                                    children: [
                                      Text(
                                        '#1234567890',
                                        style: TextStyles.sourceSans.body4
                                            .colour(UiConstants.kGreyTextColor),
                                      ),
                                    ],
                                  ),
                                  Container(
                                    padding: EdgeInsets.symmetric(
                                        vertical: SizeConfig.padding20),
                                    alignment: Alignment.center,
                                    child: MySeparator(
                                      color: Colors.white.withOpacity(0.3),
                                    ),
                                  ),
                                  GridView.builder(
                                    padding: EdgeInsets.zero,
                                    shrinkWrap: true,
                                    itemCount: 15,
                                    physics:
                                        const NeverScrollableScrollPhysics(),
                                    gridDelegate:
                                        const SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: 5,
                                      mainAxisSpacing: 2,
                                      crossAxisSpacing: 1,
                                    ),
                                    itemBuilder: (ctx, i) {
                                      return Container(
                                        alignment: Alignment.center,
                                        decoration: BoxDecoration(
                                          color: Colors.transparent,
                                          borderRadius: BorderRadius.circular(
                                              SizeConfig.blockSizeHorizontal *
                                                  1),
                                          border: Border.all(
                                              color: Colors.white54,
                                              width: 0.7),
                                          shape: BoxShape.rectangle,
                                        ),
                                        child: Stack(
                                          children: [
                                            Align(
                                              alignment: Alignment.center,
                                              child: Text(
                                                i.toString(),
                                                style: TextStyles
                                                    .rajdhaniB.body2
                                                    .colour(Colors.white54),
                                              ),
                                            ),
                                            // markStatus(i)
                                          ],
                                        ),
                                      );
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const Align(
                              alignment: Alignment.topCenter,
                              child: TicketTag(tag: "New"))
                        ],
                      ),
                    ),
                    SizedBox(height: SizeConfig.padding16),
                    Text(
                      "Rewards are calculated every\nmonday with top 10 of your Tickets",
                      style: TextStyles.sourceSansB.body1.colour(Colors.white),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: SizeConfig.padding16),
                    const TicketsRewardCategoriesWidget(),
                    MaterialButton(
                      height: SizeConfig.padding44,
                      shape: RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.circular(SizeConfig.roundness5)),
                      minWidth: SizeConfig.screenWidth! -
                          SizeConfig.pageHorizontalMargins * 2,
                      color: Colors.white,
                      onPressed: () {},
                      child: Text(
                        "GET YOUR 1ST TICKET",
                        style: TextStyles.rajdhaniB.body0.colour(Colors.black),
                      ),
                    ),
                    SizedBox(height: SizeConfig.pageHorizontalMargins)
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

class TicketsRewardCategoriesWidget extends StatelessWidget {
  const TicketsRewardCategoriesWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final List<Tuple2<String, String>> categories = [
      Tuple2("5-7 Matches", "₹ 50,000"),
      Tuple2("8-9 Matches", "₹ 70,000"),
      Tuple2("10-13 Matches", "₹ 100,000"),
      Tuple2("14-15 Matches", "iPhone"),
    ];
    return Container(
      margin: EdgeInsets.symmetric(
        horizontal: SizeConfig.pageHorizontalMargins,
        vertical: SizeConfig.padding10,
      ),
      padding: EdgeInsets.all(SizeConfig.pageHorizontalMargins),
      decoration: BoxDecoration(
        color: UiConstants.kArrowButtonBackgroundColor,
        borderRadius: BorderRadius.circular(SizeConfig.roundness16),
      ),
      child: Column(
        children: [
          Row(
            children: [
              SvgPicture.asset(
                Assets.tambolaPrizeAsset,
                width: SizeConfig.padding36,
              ),
              SizedBox(width: SizeConfig.padding12),
              Text(
                "Reward Categories",
                style: TextStyles.sourceSansSB.title4.colour(Colors.white),
              ),
            ],
          ),
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            padding: EdgeInsets.symmetric(vertical: SizeConfig.padding14),
            itemCount: categories.length,
            itemBuilder: (ctx, index) => ListTile(
              contentPadding:
                  EdgeInsets.symmetric(horizontal: SizeConfig.padding10),
              title: Text(
                categories[index].item1,
                style: TextStyles.rajdhaniB.body1.colour(
                    index == 0 ? UiConstants.primaryColor : Colors.white),
              ),
              subtitle: Text(
                "Per Ticket every week",
                style: TextStyles.sourceSans.body3.colour(Colors.white38),
              ),
              trailing: Text(
                categories[index].item2,
                style: TextStyles.sourceSansB.body1.colour(
                    index == 0 ? UiConstants.primaryColor : Colors.white),
              ),
            ),
            separatorBuilder: (context, index) => index != categories.length - 1
                ? const Divider(
                    color: Colors.white10,
                  )
                : const SizedBox(),
          ),
          Text(
            "Rewards are distributed every monday among all  the Tickets winning in a catagory",
            style: TextStyles.body3.colour(Colors.white30),
            textAlign: TextAlign.center,
          )
        ],
      ),
    );
  }
}
