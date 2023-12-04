import 'dart:developer';

import 'package:felloapp/core/constants/analytics_events_constants.dart';
import 'package:felloapp/core/model/referral_details_model.dart';
import 'package:felloapp/core/service/analytics/analytics_service.dart';
import 'package:felloapp/core/service/referral_service.dart';
import 'package:felloapp/feature/referrals/ui/referral_home.dart';
import 'package:felloapp/feature/referrals/ui/reward_track.dart';
import 'package:felloapp/feature/tambola/src/ui/widgets/loader.dart';
import 'package:felloapp/ui/pages/userProfile/referrals/referral_details/referral_details_vm.dart';
import 'package:felloapp/util/assets.dart';
import 'package:felloapp/util/debouncer.dart';
import 'package:felloapp/util/extensions/rich_text_extension.dart';
import 'package:felloapp/util/locator.dart';
import 'package:felloapp/util/styles/styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_svg/flutter_svg.dart';

class ReferralList extends StatefulWidget {
  const ReferralList({
    required this.model,
    required this.scrollController,
    Key? key,
  }) : super(key: key);

  final ReferralDetailsViewModel model;
  final ScrollController scrollController;

  @override
  State<ReferralList> createState() => _ReferralListState();
}

class _ReferralListState extends State<ReferralList> {
  final ScrollController scrollController = ScrollController();
  bool _isBouncyScroll = false;

  @override
  void initState() {
    super.initState();

    widget.scrollController.addListener(() {
      if (widget.scrollController.offset ==
          widget.scrollController.position.maxScrollExtent) {
        setState(() {
          _isBouncyScroll = true;
        });
      } else {
        if (_isBouncyScroll) {
          setState(() {
            _isBouncyScroll = false;
          });
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      controller: scrollController,
      physics: _isBouncyScroll
          ? const ClampingScrollPhysics()
          : const NeverScrollableScrollPhysics(),
      child: Container(
        color: const Color(0xFF454545).withOpacity(0.3),
        child: widget.model.referalList == null
            ? Container(
                width: SizeConfig.screenWidth,
                padding: EdgeInsets.symmetric(
                    vertical: SizeConfig.pageHorizontalMargins),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const FullScreenCircularLoader(),
                    SizedBox(height: SizeConfig.padding20),
                    Text(
                      'Fetching your referrals. Please wait..',
                      style: TextStyles.sourceSans.body2.colour(Colors.white),
                    ),
                  ],
                ),
              )
            : widget.model.referalList!.isEmpty
                ? Column(
                    children: [
                      SizedBox(height: SizeConfig.padding46),
                      SvgPicture.asset(
                        'assets/svg/winScreen-referalAsset.svg',
                        // width: SizeConfig.padding32,
                        height: SizeConfig.padding104,
                      ),
                      SizedBox(height: SizeConfig.padding16),
                      Text(
                        'You haven’t made any referrals yet',
                        style: TextStyles.sourceSans.body3
                            .colour(Colors.white.withOpacity(0.8)),
                      ),
                      SizedBox(height: SizeConfig.padding12),
                      Text('Earn over ₹1Lakh',
                          textAlign: TextAlign.center,
                          style: TextStyles.rajdhaniSB.body0
                              .colour(Colors.white.withOpacity(0.8))),
                      SizedBox(
                        height: SizeConfig.padding16,
                      ),
                      MaterialButton(
                        onPressed: () {
                          if (widget.model.isShareAlreadyClicked == false) {
                            locator<ReferralService>().shareLink();

                            locator<AnalyticsService>().track(
                              eventName: AnalyticsEvents
                                  .inviteFriendsReferralSectionTapped,
                              properties: {
                                'location': 'null screen',
                              },
                            );
                          }
                        },
                        color: Colors.white,
                        minWidth: SizeConfig.padding100,
                        padding: EdgeInsets.symmetric(
                            horizontal: SizeConfig.padding60,
                            vertical: SizeConfig.padding12),
                        shape: RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.circular(SizeConfig.roundness5),
                        ),
                        height: SizeConfig.padding34,
                        child: Text(
                          "REFER NOW",
                          style:
                              TextStyles.rajdhaniB.body3.colour(Colors.black),
                        ),
                      ),
                      SizedBox(
                        height: SizeConfig.padding54,
                      ),
                    ],
                  )
                : widget.model
                        .bonusUnlockedReferalPresent(widget.model.referalList!)
                    ? ReferralListView(
                        referalList: widget.model.referalList!,
                        onStateChanged: (val) {
                          // widget.model.refresh();
                          if (_isBouncyScroll) {
                            setState(() {
                              _isBouncyScroll = false;
                            });
                          }
                        },
                        model: widget.model,
                        scrollController: scrollController,
                      )
                    : Column(
                        children: [
                          SizedBox(height: SizeConfig.padding16),
                          SvgPicture.asset(Assets.noReferralAsset),
                          SizedBox(height: SizeConfig.padding16),
                          Text(
                            'No referrals yet',
                            style: TextStyles.sourceSans.body2
                                .colour(Colors.white),
                          ),
                          SizedBox(height: SizeConfig.padding16),
                        ],
                      ),
      ),
    );
  }
}

class ReferralListView extends StatefulWidget {
  const ReferralListView(
      {required this.referalList,
      required this.onStateChanged,
      required this.model,
      required this.scrollController,
      super.key});

  final List<ReferralDetail> referalList;
  final Function onStateChanged;
  final ReferralDetailsViewModel model;
  final ScrollController scrollController;

  @override
  State<ReferralListView> createState() => _ReferralListViewState();
}

class _ReferralListViewState extends State<ReferralListView> {
  TextEditingController controller = TextEditingController();
  List<ReferralDetail> filteredReferrals = [];
  late final Debouncer _debouncer;
  bool rebuild = false;
  bool isLoading = false;
  int _displayedReferralsCount = 0; // Number of contacts currently displayed

  @override
  void initState() {
    super.initState();
    filteredReferrals = widget.referalList;
    _displayedReferralsCount = widget.referalList.length;
    _debouncer = Debouncer(delay: const Duration(milliseconds: 700));

    widget.scrollController.addListener(() {
      // log('Scroll offset: ${widget.scrollController.offset}',
      //     name: 'ReferralDetailsScreen');
      if (widget.scrollController.offset ==
          widget.scrollController.position.maxScrollExtent) {
        loadMoreReferrals();
      }

      if (widget.scrollController.offset <= 0.0) {
        widget.onStateChanged(false);
      }
    });
  }

  void searchUser(String query) {
    log('searchUser query: $query', name: 'ReferralDetailsScreen');
    if (query.isEmpty || query.length < 3) {
      // If the query is empty, display all contacts
      setState(() {
        filteredReferrals = widget.referalList;
        _displayedReferralsCount = filteredReferrals.length;
      });
    } else {
      // Filter contacts based on the query
      setState(() {
        filteredReferrals = widget.referalList
            .where((contact) =>
                contact.userName.toLowerCase().contains(query.toLowerCase()))
            .toList();

        _displayedReferralsCount = filteredReferrals.length;
        // log('searchUser filteredReferrals: $filteredReferrals',
        //     name: 'ReferralDetailsScreen');
      });
    }

    // widget.onStateChanged();
  }

  Future<void> loadMoreReferrals() async {
    await widget.model.fetchReferalsList(context);
    setState(() {
      isLoading = false;
      _displayedReferralsCount = filteredReferrals.length;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:
          EdgeInsets.symmetric(horizontal: SizeConfig.pageHorizontalMargins),
      child: Column(
        children: [
          SizedBox(height: SizeConfig.padding24),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SvgPicture.network(
                Assets.referralReward,
                height: SizeConfig.padding16,
              ),
              SizedBox(
                width: SizeConfig.padding6,
              ),
              'Remind your friends. Don’t miss out on ₹1Lakh!'.beautify(
                boldStyle: TextStyles.sourceSansB.body3.colour(
                  Colors.white.withOpacity(0.5),
                ),
                style: TextStyles.sourceSans.body3.colour(
                  Colors.white.withOpacity(0.5),
                ),
              ),
            ],
          ),
          SizedBox(
            height: SizeConfig.padding16,
          ),
          Container(
            height: SizeConfig.padding40,
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            decoration: BoxDecoration(
              color: const Color(0xFF454545).withOpacity(0.3),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Stack(
              alignment: Alignment.centerLeft,
              children: [
                const Icon(
                  Icons.search,
                  color: Colors.grey,
                ),
                Padding(
                  padding: EdgeInsets.only(left: SizeConfig.padding36),
                  child: TextFormField(
                    controller: controller,
                    style: TextStyles.sourceSans.body3.colour(Colors.white),
                    onChanged: (query) {
                      log('Text changed: $query');
                      _debouncer.call(() => searchUser(query));
                    },
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'name should be greater than 3 characters';
                      }
                      return null;
                    },
                    decoration: InputDecoration(
                      contentPadding: const EdgeInsets.symmetric(vertical: 13),
                      hintText: "Search by name",
                      hintStyle: TextStyles.sourceSans.body3
                          .colour(Colors.white.withOpacity(0.3)),
                      errorStyle:
                          TextStyles.sourceSans.body3.colour(Colors.red),
                      border: InputBorder.none,
                      focusedBorder: InputBorder.none,
                      enabledBorder: InputBorder.none,
                      errorBorder: InputBorder.none,
                      disabledBorder: InputBorder.none,
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            height: SizeConfig.padding20,
          ),
          if (filteredReferrals.isEmpty)
            Column(
              children: [
                SizedBox(height: SizeConfig.padding16),
                SvgPicture.asset(Assets.noReferralAsset),
                SizedBox(height: SizeConfig.padding16),
                Text(
                  'No referrals found',
                  style: TextStyles.sourceSans.body2.colour(Colors.white),
                ),
                SizedBox(height: SizeConfig.padding16),
              ],
            ),
          ListView.builder(
            shrinkWrap: true,
            padding: EdgeInsets.zero,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: _displayedReferralsCount,
            itemBuilder: (context, i) {
              if (i < filteredReferrals.length) {
                if (filteredReferrals[i].revampedInfo?.isFullyComplete ??
                    false) {
                  return buildCompleteReferrals(i);
                }
                return buildIncompleteReferrals(i);
              }

              return const SizedBox.shrink();
            },
          ),
          if (filteredReferrals.length > _displayedReferralsCount)
            SpinKitThreeBounce(
              size: SizeConfig.title5,
              color: Colors.white,
            ),
          SizedBox(
            height: SizeConfig.padding44,
          ),
        ],
      ),
    );
  }

  Column buildIncompleteReferrals(int i) {
    return Column(
      children: [
        Container(
          padding: EdgeInsets.symmetric(
            horizontal: SizeConfig.padding24,
            vertical: SizeConfig.padding18,
          ),
          decoration: BoxDecoration(
            color: const Color(0xFF141414),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            children: [
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      filteredReferrals[i].userName,
                      style: TextStyles.sourceSansSB.body2.colour(Colors.white),
                    ),
                    Text(
                      filteredReferrals[i].revampedInfo!.subtitle!,
                      style: TextStyles.sourceSans.body3.colour(
                        Colors.white.withOpacity(0.44),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  width: SizeConfig.padding76,
                  child: MaterialButton(
                    onPressed: () {
                      navigateToWhatsApp(filteredReferrals[i].mobile!,
                          filteredReferrals[i].shareMsg);

                      locator<AnalyticsService>().track(
                        eventName: AnalyticsEvents.remindOnReferralCardTapped,
                        properties: {
                          'Status': (filteredReferrals[i]
                                      .revampedInfo
                                      ?.stages?[1]
                                      .isComplete ??
                                  false)
                              ? 'Made First investment'
                              : 'Signed up',
                        },
                      );
                    },
                    color: Colors.white,
                    minWidth: SizeConfig.padding76,
                    padding: EdgeInsets.symmetric(
                        horizontal: SizeConfig.padding14,
                        vertical: SizeConfig.padding8),
                    shape: RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.circular(SizeConfig.roundness5),
                    ),
                    height: SizeConfig.padding30,
                    child: Text(
                      "REMIND",
                      style: TextStyles.rajdhaniB.body3.colour(Colors.black),
                    ),
                  ),
                ),
              ]),
              SizedBox(
                height: SizeConfig.padding14,
              ),
              RewardTrack(
                revampedInfo: filteredReferrals[i].revampedInfo!,
              )
            ],
          ),
        ),
        SizedBox(
          height: SizeConfig.padding24,
        )
      ],
    );
  }

  Widget buildCompleteReferrals(int i) {
    return Column(
      children: [
        Container(
          padding: EdgeInsets.symmetric(
            horizontal: SizeConfig.padding24,
            vertical: SizeConfig.padding18,
          ),
          decoration: BoxDecoration(
            color: const Color(0xFF125459),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            children: [
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                Text(
                  filteredReferrals[i].userName,
                  style: TextStyles.sourceSansSB.body2.colour(Colors.white),
                ),
                Row(
                  children: [
                    CustomPaint(
                      size: Size(SizeConfig.padding8,
                          (SizeConfig.padding8 * 1.125).toDouble()),
                      painter: ReferralStarCustomPainter(),
                    ),
                    SizedBox(
                      width: SizeConfig.padding6,
                    ),
                    Text(
                      filteredReferrals[i].revampedInfo?.subtitle ??
                          'You earned ₹500',
                      style: TextStyles.sourceSans.body3.colour(Colors.white),
                    )
                  ],
                )
              ]),
              SizedBox(
                height: SizeConfig.padding14,
              ),
              RewardTrack(
                revampedInfo: filteredReferrals[i].revampedInfo!,
              )
            ],
          ),
        ),
        SizedBox(
          height: SizeConfig.padding24,
        )
      ],
    );
  }

  @override
  void dispose() {
    widget.scrollController.dispose();
    _debouncer.cancel();
    super.dispose();
  }
}

class ReferralStarCustomPainter extends CustomPainter {
  final Color? color;

  ReferralStarCustomPainter([this.color]);

  @override
  void paint(Canvas canvas, Size size) {
    Path path_0 = Path();
    path_0.moveTo(size.width * 0.4614612, size.height * 0.09050922);
    path_0.cubicTo(
        size.width * 0.4002150,
        size.height * 0.2402967,
        size.width * 0.2972562,
        size.height * 0.3871678,
        size.width * 0.01808200,
        size.height * 0.4862100);
    path_0.cubicTo(
        size.width * -0.008581438,
        size.height * 0.4956589,
        size.width * -0.004753475,
        size.height * 0.5385889,
        size.width * 0.02296600,
        size.height * 0.5450044);
    path_0.cubicTo(
        size.width * 0.2728375,
        size.height * 0.6033333,
        size.width * 0.3808112,
        size.height * 0.7530044,
        size.width * 0.4659500,
        size.height * 0.9352222);
    path_0.cubicTo(
        size.width * 0.4747938,
        size.height * 0.9541211,
        size.width * 0.5054163,
        size.height * 0.9550544,
        size.width * 0.5159763,
        size.height * 0.9367389);
    path_0.cubicTo(
        size.width * 0.6182750,
        size.height * 0.7587200,
        size.width * 0.7628113,
        size.height * 0.6159322,
        size.width * 0.9800800,
        size.height * 0.5483878);
    path_0.cubicTo(
        size.width * 1.005555,
        size.height * 0.5404556,
        size.width * 1.007008,
        size.height * 0.5035911,
        size.width * 0.9820600,
        size.height * 0.4947256);
    path_0.cubicTo(
        size.width * 0.7327162,
        size.height * 0.4054833,
        size.width * 0.5921388,
        size.height * 0.2572122,
        size.width * 0.5175600,
        size.height * 0.09015933);
    path_0.cubicTo(
        size.width * 0.5080562,
        size.height * 0.06881111,
        size.width * 0.4704375,
        size.height * 0.06881111,
        size.width * 0.4615938,
        size.height * 0.09050922);
    path_0.lineTo(size.width * 0.4614612, size.height * 0.09050922);
    path_0.close();

    Paint paint0Fill = Paint()..style = PaintingStyle.fill;
    paint0Fill.color = color ?? const Color(0xffFFD979).withOpacity(1.0);
    canvas.drawPath(path_0, paint0Fill);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
