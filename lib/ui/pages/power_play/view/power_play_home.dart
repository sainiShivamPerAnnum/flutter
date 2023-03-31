import 'package:felloapp/ui/elements/appbar/appbar.dart';
import 'package:felloapp/util/styles/size_config.dart';
import 'package:felloapp/util/styles/textStyles.dart';
import 'package:flutter/material.dart';

class PowerPlayHome extends StatefulWidget {
  const PowerPlayHome({Key? key}) : super(key: key);

  @override
  State<PowerPlayHome> createState() => _PowerPlayHomeState();
}

class _PowerPlayHomeState extends State<PowerPlayHome> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color(0xff21284A),
                  Color(0xff3C2840),
                  Color(0xff772828),
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                stops: [0.3, 0.6, 1],
              ),
            ),
          ),
          SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                FAppBar(
                  // type: FaqsType.play,
                  showAvatar: false,
                  showCoinBar: false,
                  showHelpButton: false,
                  backgroundColor: Colors.transparent,
                  action: Row(
                    children: [
                      TextButton(
                        style: TextButton.styleFrom(
                          primary: Colors.white,
                          onSurface: Colors.white,
                          side: BorderSide(
                              color: Colors.white.withOpacity(0.5), width: 0.5),
                          shape: const RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(5))),
                        ),
                        onPressed: () {},
                        child: Padding(
                          padding: EdgeInsets.zero,
                          child: Text(
                            "Invite Friends",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: SizeConfig.body5,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        width: SizeConfig.padding12,
                      ),
                      InkWell(
                        onTap: () {},
                        child: Container(
                          decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              // color: UiConstants.kArrowButtonBackgroundColor,
                              border: Border.all(
                                  color: Colors.white.withOpacity(0.5))),
                          padding: const EdgeInsets.all(6),
                          child: Icon(
                            Icons.question_mark,
                            color: Colors.white,
                            size: SizeConfig.padding20,
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                Center(
                  child: Image.asset(
                    'assets/images/powerplay_logo.png',
                    height: 95,
                  ),
                ),
                const SizedBox(
                  height: 5,
                ),
                Center(
                    child: Text(
                  'Predict. Save. Win.',
                  style: TextStyles.sourceSansSB.body2,
                )),
                const SizedBox(
                  height: 10,
                ),
                Container(
                  height: 43,
                  margin: const EdgeInsets.symmetric(horizontal: 50),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                    color: Colors.black.withOpacity(0.7),
                  ),
                  child: Text(
                    'Total Won From PowerPlay : ₹100',
                    style: TextStyles.sourceSansSB.body2,
                  ),
                ),
                const SizedBox(
                  height: 14,
                ),
                SizedBox(
                  height: SizeConfig.screenWidth! * 0.25,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    children: [
                      Container(
                        margin: EdgeInsets.only(
                            left: SizeConfig.pageHorizontalMargins),
                        height: 85,
                        width: 275,
                        padding: const EdgeInsets.symmetric(
                            vertical: 11, horizontal: 18),
                        decoration: BoxDecoration(
                          color: const Color(0xffA5E4FF),
                          borderRadius: BorderRadius.circular(10),
                          // border: Border.all(color: Colors.white, width: 0.5),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'How it Works?',
                              style: TextStyles.sourceSansSB.body1
                                  .colour(Colors.black),
                            ),
                            Expanded(
                              child: Text(
                                'Predict the winning score of today’s match and get a chance to win digital gold equal to the Winning score!',
                                style: TextStyles.sourceSans.body4
                                    .colour(Colors.black),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.symmetric(
                            horizontal: SizeConfig.pageHorizontalMargins),
                        height: 85,
                        width: 275,
                        padding: const EdgeInsets.symmetric(
                            vertical: 11, horizontal: 18),
                        decoration: BoxDecoration(
                          color: const Color(0xffA5E4FF),
                          borderRadius: BorderRadius.circular(10),
                          // border: Border.all(color: Colors.white, width: 0.5),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'How it Works?',
                              style: TextStyles.sourceSansSB.body1
                                  .colour(Colors.black),
                            ),
                            Expanded(
                              child: Text(
                                'Predict the winning score of today’s match and get a chance to win digital gold equal to the Winning score!',
                                style: TextStyles.sourceSans.body4
                                    .colour(Colors.black),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                const PowerPlayMatch(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class PowerPlayMatch extends StatefulWidget {
  const PowerPlayMatch({Key? key}) : super(key: key);

  @override
  State<PowerPlayMatch> createState() => _PowerPlayMatchState();
}

class _PowerPlayMatchState extends State<PowerPlayMatch>
    with TickerProviderStateMixin {
  TabController? _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(vsync: this, length: 3);
    _tabController!.addListener(_handleTabSelection);
  }

  List<String> getTitle() {
    return ['Live', 'Upcoming', 'Completed'];
  }

  void _handleTabSelection() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin:
          EdgeInsets.symmetric(horizontal: SizeConfig.pageHorizontalMargins),
      child: DefaultTabController(
        length: 3,
        child: Column(
          children: [
            TabBar(
              controller: _tabController,
              labelPadding: EdgeInsets.zero,
              indicatorColor: Colors.transparent,
              physics: const BouncingScrollPhysics(),
              isScrollable: true,
              splashFactory: NoSplash.splashFactory,
              tabs: List.generate(
                3,
                (index) => Container(
                  width: 105,
                  padding: EdgeInsets.symmetric(
                    horizontal: SizeConfig.padding10,
                    vertical: SizeConfig.padding10,
                  ),
                  decoration: BoxDecoration(
                      borderRadius: const BorderRadius.all(Radius.circular(5)),
                      color: _tabController!.index == index
                          ? Colors.white
                          : Colors.transparent,
                      border: Border.all(color: Colors.white)),
                  child: Text(
                    getTitle()[index],
                    textAlign: TextAlign.center,
                    style: TextStyles.sourceSansSB.body4.colour(
                        _tabController!.index == index
                            ? Colors.black
                            : Colors.white),
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Builder(builder: (_) {
              if (_tabController!.index == 0) {
                return const LiveMatch();
              } else if (_tabController!.index == 1) {
                return const UpcomingMatch();
              } else {
                return const CompletedMatch();
              }
            }),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _tabController?.dispose();
    super.dispose();
  }
}

class CompletedMatch extends StatelessWidget {
  const CompletedMatch({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 10,
      color: Colors.green,
    );
  }
}

class LiveMatch extends StatelessWidget {
  const LiveMatch({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      // height: 100,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5),
        color: const Color(0xff3B4E6E).withOpacity(0.8),
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 8),
            decoration: const BoxDecoration(
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(5), topRight: Radius.circular(5)),
                color: Color(0xff273C60)),
            child: Row(
              children: [
                Text(
                  'IPL Match - 4',
                  style: TextStyles.sourceSansB.body2.colour(Colors.white),
                ),
                const Spacer(),
                Text(
                  'PREDICTION LEADERBOARD',
                  style: TextStyles.sourceSans
                      .colour(Colors.white.withOpacity(0.7))
                      .copyWith(fontSize: SizeConfig.screenWidth! * 0.030),
                ),
                const Icon(
                  Icons.arrow_forward_ios,
                  size: 10,
                  color: Colors.white,
                )
              ],
            ),
          ),
          const SizedBox(
            height: 18,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 17),
            child: Row(
              children: [
                Container(
                  height: 30,
                  width: 35,
                  decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white)),
                ),
                const SizedBox(
                  width: 5,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Bengaluru',
                      style: TextStyles.sourceSansB.body4,
                    ),
                    Text(
                      '140/2 (19)',
                      style: TextStyles.sourceSans
                          .copyWith(fontSize: SizeConfig.screenWidth! * 0.030),
                    ),
                  ],
                ),
                const Spacer(),
                Text(
                  'VS',
                  style: TextStyles.sourceSansB.body4,
                ),
                const Spacer(),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Chennai',
                      style: TextStyles.sourceSansB.body4,
                    ),
                    Text(
                      'YET TO BAT',
                      style: TextStyles.sourceSans
                          .copyWith(fontSize: SizeConfig.screenWidth! * 0.030),
                    ),
                  ],
                ),
                const SizedBox(
                  width: 5,
                ),
                Container(
                  height: 30,
                  width: 35,
                  decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white)),
                ),
              ],
            ),
          ),
          const SizedBox(
            height: 30,
          ),
          Center(
            child: Text(
              'PREDICTIONS END AFTER RCB PLAYS 19TH OVER',
              style: TextStyles.sourceSans
                  .copyWith(fontSize: SizeConfig.screenWidth! * 0.030),
            ),
          ),
          const SizedBox(
            height: 18,
          ),
          Container(
            margin: const EdgeInsets.symmetric(
              horizontal: 22,
            ),
            child: MaterialButton(
              padding: const EdgeInsets.symmetric(vertical: 10),
              color: Colors.white,
              onPressed: () {
              },
              child: Center(
                child: Text(
                  'PREDICT NOW',
                  style: TextStyles.rajdhaniB.body1.colour(Colors.black),
                ),
              ),
            ),
          ),
          const SizedBox(
            height: 15,
          ),
        ],
      ),
    );
  }
}

class UpcomingMatch extends StatelessWidget {
  const UpcomingMatch({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: 3,
      padding: EdgeInsets.zero,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemBuilder: (context, index) {
        return Column(
          children: [
            Container(
              // height: 50,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
                color: const Color(0xff3B4E6E).withOpacity(0.8),
              ),
              child: Column(
                children: [
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 22, vertical: 8),
                    decoration: const BoxDecoration(
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(5),
                            topRight: Radius.circular(5)),
                        color: Color(0xff273C60)),
                    child: Row(
                      children: [
                        Text(
                          'IPL Match - 4',
                          style:
                              TextStyles.sourceSansB.body2.colour(Colors.white),
                        ),
                        const Spacer(),
                        Text(
                          'PREDICTION LEADERBOARD',
                          style: TextStyles.sourceSans.body5
                              .colour(Colors.white.withOpacity(0.7))
                              .copyWith(
                                  fontSize: SizeConfig.screenWidth! * 0.030),
                        ),
                        const Icon(
                          Icons.arrow_forward_ios,
                          size: 10,
                          color: Colors.white,
                        )
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 14,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 17),
                    child: Row(
                      children: [
                        Container(
                          height: 30,
                          width: 35,
                          decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(color: Colors.white)),
                        ),
                        const SizedBox(
                          width: 5,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Bengaluru',
                              style: TextStyles.sourceSansB.body4,
                            ),
                            Text(
                              '140/2 (19)',
                              style: TextStyles.sourceSans.copyWith(
                                  fontSize: SizeConfig.screenWidth! * 0.030),
                            ),
                          ],
                        ),
                        const Spacer(),
                        Text(
                          'VS',
                          style: TextStyles.sourceSansB.body4,
                        ),
                        const Spacer(),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Chennai',
                              style: TextStyles.sourceSansB.body4,
                            ),
                            Text(
                              'YET TO BAT',
                              style: TextStyles.sourceSans.copyWith(
                                  fontSize: SizeConfig.screenWidth! * 0.030),
                            ),
                          ],
                        ),
                        const SizedBox(
                          width: 5,
                        ),
                        Container(
                          height: 30,
                          width: 35,
                          decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(color: Colors.white)),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 19,
                  ),
                  Center(
                    child: Text(
                      'Match starts at 7 PM',
                      style: TextStyles.sourceSans
                          .copyWith(fontSize: SizeConfig.screenWidth! * 0.030),
                    ),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(vertical: 5),
                    decoration: BoxDecoration(
                        color: const Color(0xff000000).withOpacity(0.3),
                        borderRadius: const BorderRadius.only(
                            bottomLeft: Radius.circular(5),
                            bottomRight: Radius.circular(5))),
                    child: Center(
                      child: Text(
                        'Predictions start in 05 : 02 Hrs',
                        style: TextStyles.sourceSans.copyWith(
                            fontSize: SizeConfig.screenWidth! * 0.030),
                      ),
                    ),
                  )
                ],
              ),
            ),
            const SizedBox(
              height: 10,
            ),
          ],
        );
      },
    );
  }
}