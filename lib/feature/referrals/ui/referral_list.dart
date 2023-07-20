import 'dart:developer';

import 'package:felloapp/core/model/referral_details_model.dart';
import 'package:felloapp/core/service/referral_service.dart';
import 'package:felloapp/feature/referrals/ui/referral_home.dart';
import 'package:felloapp/feature/tambola/src/ui/widgets/loader.dart';
import 'package:felloapp/ui/pages/userProfile/referrals/referral_details/referral_details_vm.dart';
import 'package:felloapp/util/assets.dart';
import 'package:felloapp/util/debouncer.dart';
import 'package:felloapp/util/extensions/rich_text_extension.dart';
import 'package:felloapp/util/locator.dart';
import 'package:felloapp/util/styles/styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class ReferralList extends StatelessWidget {
  const ReferralList({
    required this.model,
    Key? key,
  }) : super(key: key);

  final ReferralDetailsViewModel model;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFF454545).withOpacity(0.3),
      child: model.referalList == null
          ? Container(
              width: SizeConfig.screenWidth,
              padding: EdgeInsets.symmetric(
                  vertical: SizeConfig.pageHorizontalMargins),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const FullScreenLoader(),
                  SizedBox(height: SizeConfig.padding20),
                  Text(
                    'Fetching your referrals. Please wait..',
                    style: TextStyles.sourceSans.body2.colour(Colors.white),
                  ),
                ],
              ),
            )
          : model.referalList!.isEmpty
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
                        if (model.isShareAlreadyClicked == false) {
                          locator<ReferralService>().shareLink();
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
                        style: TextStyles.rajdhaniB.body3.colour(Colors.black),
                      ),
                    ),
                    SizedBox(
                      height: SizeConfig.padding54,
                    ),
                  ],
                )
              : model.bonusUnlockedReferalPresent(model.referalList!)
                  ? ReferralListView(referalList: model.referalList!)
                  : Column(
                      children: [
                        SizedBox(height: SizeConfig.padding16),
                        SvgPicture.asset(Assets.noReferralAsset),
                        SizedBox(height: SizeConfig.padding16),
                        Text(
                          'No referrals yet',
                          style:
                              TextStyles.sourceSans.body2.colour(Colors.white),
                        ),
                        SizedBox(height: SizeConfig.padding16),
                      ],
                    ),
    );
  }
}

class ReferralListView extends StatefulWidget {
  const ReferralListView({
    required this.referalList,
    super.key,
  });

  final List<ReferralDetail> referalList;

  @override
  State<ReferralListView> createState() => _ReferralListViewState();
}

class _ReferralListViewState extends State<ReferralListView> {
  TextEditingController controller = TextEditingController();
  List<ReferralDetail> filteredReferrals = [];
  late final Debouncer _debouncer;

  @override
  void initState() {
    super.initState();
    filteredReferrals = widget.referalList;
    _debouncer = Debouncer(delay: const Duration(milliseconds: 700));
  }

  void searchUser(String query) {
    log('searchUser query: $query', name: 'ReferralDetailsScreen');
    if (query.isEmpty || query.length < 3) {
      // If the query is empty, display all contacts
      setState(() {
        filteredReferrals = widget.referalList;
      });
    } else {
      // Filter contacts based on the query
      setState(() {
        filteredReferrals = widget.referalList
            .where((contact) =>
                contact.userName.toLowerCase().contains(query.toLowerCase()))
            .toList();
        log('searchUser filteredReferrals: $filteredReferrals',
            name: 'ReferralDetailsScreen');
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(SizeConfig.pageHorizontalMargins),
      child: Column(
        children: [
          SizedBox(height: SizeConfig.padding10),
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
          ListView.builder(
            shrinkWrap: true,
            padding: EdgeInsets.zero,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: filteredReferrals.length,
            itemBuilder: (context, i) {
              if (filteredReferrals[i].isUserBonusUnlocked ?? false) {
                return buildIncompleteReferrals(i);
              } else {
                return const SizedBox.shrink();
              }
            },
          ),
        ],
      ),
    );
  }

  Container buildIncompleteReferrals(int i) {
    return Container(
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
                  'Remind to save & get ₹450 more!',
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
                  // navigateToWhatsApp(
                  //   filteredReferrals[i]
                  //         .userPhoneNumber,);
                },
                color: Colors.white,
                minWidth: SizeConfig.padding76,
                padding: EdgeInsets.symmetric(
                    horizontal: SizeConfig.padding14,
                    vertical: SizeConfig.padding8),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(SizeConfig.roundness5),
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
          const RewardTrack()
        ],
      ),
    );
  }

  Widget buildCompleteReferrals(int i) {
    return Container(
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
                  painter: RPSCustomPainter(),
                ),
                SizedBox(
                  width: SizeConfig.padding6,
                ),
                Text(
                  'You earned ₹500',
                  style: TextStyles.sourceSans.body3.colour(Colors.white),
                )
              ],
            )
          ]),
          SizedBox(
            height: SizeConfig.padding14,
          ),
          const RewardTrack()
        ],
      ),
    );
  }
}

class RewardTrack extends StatelessWidget {
  const RewardTrack({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: SizeConfig.padding72,
      child: Stack(
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: Container(
              margin: EdgeInsets.only(
                left: SizeConfig.padding38,
                right: SizeConfig.padding50,
                bottom: SizeConfig.padding6,
              ),
              height: 1.2,
              width: SizeConfig.padding82,
              color: const Color(0xFF61E3C4),
            ),
          ),
          Align(
            alignment: Alignment.centerRight,
            child: Container(
              margin: EdgeInsets.only(
                right: SizeConfig.padding50,
                bottom: SizeConfig.padding6,
              ),
              height: 1.2,
              width: SizeConfig.padding108,
              color: const Color(0xFF868686),
            ),
          ),
          const Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              RewardInfoBlock(
                title: 'Signed Up',
                isComplete: true,
                tooltipContent: null,
              ),
              RewardInfoBlock(
                title: 'Save ₹1000',
                isComplete: false,
                tooltipContent: '₹50',
              ),
              RewardInfoBlock(
                title: 'Save in 12% Flo',
                isComplete: false,
                tooltipContent: '₹450',
                isPreviousTaskCompleted: false,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class RewardInfoBlock extends StatelessWidget {
  const RewardInfoBlock(
      {required this.title,
      required this.isComplete,
      super.key,
      this.tooltipContent,
      this.isPreviousTaskCompleted = true});

  final String title;
  final bool isComplete;
  final String? tooltipContent;
  final bool isPreviousTaskCompleted;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
            width: SizeConfig.padding32,
            height: (tooltipContent?.isNotEmpty ?? false)
                ? null
                : SizeConfig.padding25,
            child: (tooltipContent?.isNotEmpty ?? false)
                ? Stack(
                    children: [
                      CustomPaint(
                        size: Size(SizeConfig.padding34,
                            (SizeConfig.padding34 * 0.7).toDouble()),
                        painter: ToolTipCustomPainter(isComplete
                            ? const Color(0xff62E3C4).withOpacity(1.0)
                            : const Color(0xffB9B9B9)),
                      ),
                      Align(
                        alignment: Alignment.center,
                        child: Text(
                          tooltipContent ?? '',
                          style: TextStyles.sourceSans.body4.colour(isComplete
                              ? const Color(0xFF00E6C3)
                              : const Color(0xFFB8B8B8)),
                        ),
                      ),
                    ],
                  )
                : const SizedBox()),
        Container(
          width: SizeConfig.padding16,
          height: SizeConfig.padding16,
          decoration: BoxDecoration(
              color: isComplete ? const Color(0xFF61E3C4) : null,
              shape: BoxShape.circle,
              border: Border.all(
                  width: 0.50,
                  color: isPreviousTaskCompleted
                      ? const Color(0xFF61E3C4)
                      : const Color(0xFF868686).withOpacity(0.8))),
          child: isComplete
              ? Icon(
                  Icons.check,
                  color: Colors.black,
                  size: SizeConfig.padding14,
                  weight: 700,
                  grade: 200,
                  opticalSize: 48,
                )
              : null,
        ),
        SizedBox(
          height: SizeConfig.padding6,
        ),
        Text(
          title,
          style: TextStyles.sourceSans.body4.colour(Colors.white),
        ),
      ],
    );
  }
}

class RPSCustomPainter extends CustomPainter {
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

    Paint paint_0_fill = Paint()..style = PaintingStyle.fill;
    paint_0_fill.color = const Color(0xffFFD979).withOpacity(1.0);
    canvas.drawPath(path_0, paint_0_fill);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
