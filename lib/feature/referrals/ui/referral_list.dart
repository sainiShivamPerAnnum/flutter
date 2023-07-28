import 'dart:developer';

import 'package:felloapp/core/model/referral_details_model.dart';
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
                  ? ReferralListView(
                      referalList: model.referalList!,
                      onStateChanged: () {
                        model.refresh();
                      },
                    )
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
    required this.onStateChanged,
  });

  final List<ReferralDetail> referalList;
  final Function onStateChanged;

  @override
  State<ReferralListView> createState() => _ReferralListViewState();
}

class _ReferralListViewState extends State<ReferralListView> {
  TextEditingController controller = TextEditingController();
  List<ReferralDetail> filteredReferrals = [];
  late final Debouncer _debouncer;
  bool rebuild = false;

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
        // log('searchUser filteredReferrals: $filteredReferrals',
        //     name: 'ReferralDetailsScreen');
      });
    }

    widget.onStateChanged();
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
          ListView.separated(
            shrinkWrap: true,
            padding: EdgeInsets.zero,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: filteredReferrals.length,
            itemBuilder: (context, i) {
              if (filteredReferrals[i].revampedInfo?.isFullyComplete ?? false) {
                return buildCompleteReferrals(i);
              }

              return buildIncompleteReferrals(i);
              // if (filteredReferrals[i].isUserBonusUnlocked ?? false) {
              //   return buildIncompleteReferrals(i);
              // } else {
              //   return const SizedBox.shrink();
              // }
            },
            separatorBuilder: (context, i) => SizedBox(
              height: SizeConfig.padding20,
            ),
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
                  navigateToWhatsApp(
                    filteredReferrals[i].mobile!,
                  );
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
          RewardTrack(
            revampedInfo: filteredReferrals[i].revampedInfo!,
          )
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
                  painter: ReferralStarCustomPainter(),
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
          RewardTrack(
            revampedInfo: filteredReferrals[i].revampedInfo!,
          )
        ],
      ),
    );
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

    Paint paint_0_fill = Paint()..style = PaintingStyle.fill;
    paint_0_fill.color = color ?? const Color(0xffFFD979).withOpacity(1.0);
    canvas.drawPath(path_0, paint_0_fill);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
