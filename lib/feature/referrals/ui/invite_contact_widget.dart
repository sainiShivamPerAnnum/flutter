import 'package:felloapp/base_util.dart';
import 'package:felloapp/core/constants/analytics_events_constants.dart';
import 'package:felloapp/core/enums/app_config_keys.dart';
import 'package:felloapp/core/model/app_config_model.dart';
import 'package:felloapp/core/service/analytics/analyticsProperties.dart';
import 'package:felloapp/core/service/analytics/analytics_service.dart';
import 'package:felloapp/core/service/referral_service.dart';
import 'package:felloapp/feature/referrals/bloc/referral_cubit.dart';
import 'package:felloapp/feature/referrals/ui/contact_list_widget.dart';
import 'package:felloapp/feature/tambola/src/ui/widgets/loader.dart';
import 'package:felloapp/navigator/app_state.dart';
import 'package:felloapp/ui/pages/finance/lendbox/detail_page/flo_premium_details_view.dart';
import 'package:felloapp/ui/pages/static/app_widget.dart';
import 'package:felloapp/ui/pages/userProfile/referrals/referral_details/referral_details_vm.dart';
import 'package:felloapp/util/locator.dart';
import 'package:felloapp/util/styles/styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';

class InviteContactWidget extends StatefulWidget {
  const InviteContactWidget({
    required this.model,
    required this.scrollController,
    Key? key,
  }) : super(key: key);

  final ReferralDetailsViewModel model;
  final ScrollController scrollController;

  @override
  State<InviteContactWidget> createState() => _InviteContactWidgetState();
}

class _InviteContactWidgetState extends State<InviteContactWidget>
    with AutomaticKeepAliveClientMixin<InviteContactWidget> {
  final ScrollController scrollController = ScrollController();
  bool _isBouncyScroll = false;

  @override
  void initState() {
    super.initState();
    context.read<ReferralCubit>().checkPermission();

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

  void showPermissionBottomSheet() {
    BaseUtil.openModalBottomSheet(
      addToScreenStack: true,
      enableDrag: false,
      hapticVibrate: true,
      isBarrierDismissible: true,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      content: PermissionModalSheet(
        widget: widget,
        context: context,
      ),
    );

    locator<AnalyticsService>().track(
      eventName: AnalyticsEvents.syncContactsTapped,
      properties: {
        'Earned So far': widget.model.totalReferralWon,
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      controller: scrollController,
      physics: _isBouncyScroll
          ? const ClampingScrollPhysics()
          : const NeverScrollableScrollPhysics(),
      child: BlocBuilder<ReferralCubit, ReferralState>(
        builder: (context, state) {
          if (state is NoPermissionState) {
            return Column(
              children: [
                SizedBox(height: SizeConfig.padding20),
                SvgPicture.asset(
                  'assets/svg/magnifying_glass.svg',
                  height: SizeConfig.padding148,
                ),
                Text(
                  'You haven’t added your contacts yet',
                  style: TextStyles.sourceSans.body3
                      .colour(Colors.white.withOpacity(0.8)),
                ),
                SizedBox(height: SizeConfig.padding12),
                SizedBox(
                  width: SizeConfig.padding200 + SizeConfig.padding54,
                  child: Text(
                    'Over 2000 users have given contact access to Fello',
                    textAlign: TextAlign.center,
                    style: TextStyles.rajdhaniSB.body0
                        .colour(Colors.white.withOpacity(0.8)),
                  ),
                ),
                SizedBox(height: SizeConfig.padding16),
                MaterialButton(
                  onPressed: showPermissionBottomSheet,
                  color: Colors.white,
                  minWidth: SizeConfig.padding100,
                  padding: EdgeInsets.symmetric(
                      horizontal: SizeConfig.padding60,
                      vertical: SizeConfig.padding12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(SizeConfig.roundness5),
                  ),
                  height: SizeConfig.padding34,
                  child: Text(
                    "SYNC CONTACTS",
                    style: TextStyles.rajdhaniB.body3.colour(Colors.black),
                  ),
                ),
                SizedBox(height: SizeConfig.padding148),
              ],
            );
          }

          if (state is ContactsLoaded) {
            return ContactListWidget(
              contacts: state.contacts,
              scrollController: scrollController,
              onStateChanged: (val) {
                if (_isBouncyScroll) {
                  setState(() {
                    _isBouncyScroll = false;
                  });
                }
              },
            );
          }

          if (state is ContactsError) {
            return SizedBox(
              height: SizeConfig.padding80,
              child: Center(
                child: Text(
                  'No Contacts Found',
                  style: TextStyles.sourceSans.body3
                      .colour(Colors.white.withOpacity(0.8)),
                ),
              ),
            );
          }

          return Container(
            width: SizeConfig.screenWidth,
            padding: EdgeInsets.symmetric(
                vertical: SizeConfig.pageHorizontalMargins),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const FullScreenCircularLoader(),
                SizedBox(height: SizeConfig.padding20),
                Text(
                  'Fetching your contacts. Please wait..',
                  style: TextStyles.sourceSans.body2.colour(Colors.white),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}

class PermissionModalSheet extends StatelessWidget {
  const PermissionModalSheet({
    required this.widget,
    required this.context,
    super.key,
  });

  final InviteContactWidget widget;
  final BuildContext context;

  String get referrersCount => AppConfig.getValue<Map<String, dynamic>>(
          AppConfigKey.revamped_referrals_config)['stats']['referrersCount']
      .toString();

  String get usersFromReferrals => AppConfig.getValue<Map<String, dynamic>>(
          AppConfigKey.revamped_referrals_config)['stats']['usersFromReferrals']
      .toString();

  String get rewardsFromReferrals => AppConfig.getValue<Map<String, dynamic>>(
              AppConfigKey.revamped_referrals_config)['stats']
          ['rewardsFromReferrals']
      .toString();

  @override
  Widget build(BuildContext _) {
    return WillPopScope(
      onWillPop: () async {
        AppState.removeOverlay();
        return true;
      },
      child: Container(
        width: SizeConfig.screenWidth,
        padding: EdgeInsets.symmetric(horizontal: SizeConfig.padding32),
        decoration: BoxDecoration(
          color: const Color(0xff39393C),
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(SizeConfig.padding16),
            topRight: Radius.circular(SizeConfig.padding16),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              height: SizeConfig.padding18,
            ),
            Container(
              width: SizeConfig.screenWidth! * 0.247,
              height: SizeConfig.padding4,
              decoration: BoxDecoration(
                color: const Color(0xffD9D9D9),
                borderRadius: BorderRadius.circular(SizeConfig.padding4),
              ),
            ),
            SizedBox(
              height: SizeConfig.padding24,
            ),
            Text(
              'Allow access to your contacts for a seamless referral',
              style: TextStyles.rajdhaniSB.title5.colour(Colors.white),
              textAlign: TextAlign.center,
            ),
            SizedBox(
              height: SizeConfig.padding14,
            ),
            Container(
              width: SizeConfig.screenWidth! * 0.55,
              padding: EdgeInsets.symmetric(
                  horizontal: SizeConfig.padding4,
                  vertical: SizeConfig.padding4),
              decoration: BoxDecoration(
                color: Colors.black,
                borderRadius: BorderRadius.circular(SizeConfig.roundness12),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.security,
                    color: const Color(0xff959596),
                    size: SizeConfig.padding14,
                  ),
                  SizedBox(
                    width: SizeConfig.padding4,
                  ),
                  Text(
                    'Your data is safe with Fello',
                    style: TextStyles.sourceSans.body3
                        .colour(Colors.white.withOpacity(0.5)),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: SizeConfig.padding32,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: SizeConfig.padding36,
                      height: SizeConfig.padding38,
                      child: SvgPicture.asset(
                        'assets/svg/avatar.svg',
                        // width: SizeConfig.padding32,
                        height: SizeConfig.padding48,
                      ),
                    ),
                    SizedBox(
                      height: SizeConfig.padding8,
                    ),
                    SizedBox(
                      width: SizeConfig.padding88,
                      child: Text(
                        '${usersFromReferrals.toString()} Users',
                        textAlign: TextAlign.center,
                        style: TextStyles.sourceSans.body3.colour(Colors.white),
                      ),
                    )
                  ],
                ),
                Column(
                  children: [
                    SvgPicture.asset(
                      'assets/svg/winScreen-referalAsset.svg',
                      width: SizeConfig.padding32,
                      height: SizeConfig.padding48,
                    ),
                    SizedBox(
                      width: SizeConfig.padding88,
                      child: Text(
                        "$referrersCount Referrals",
                        textAlign: TextAlign.center,
                        style: TextStyles.sourceSans.body3.colour(Colors.white),
                      ),
                    )
                  ],
                ),
                Column(
                  children: [
                    SvgPicture.asset(
                      'assets/svg/play_gift.svg',
                      width: SizeConfig.padding32,
                      height: SizeConfig.padding44,
                    ),
                    SizedBox(
                      // width: SizeConfig.padding88,
                      child: Text(
                        "₹$rewardsFromReferrals rewards",
                        textAlign: TextAlign.center,
                        style: TextStyles.sourceSans.body3.colour(Colors.white),
                      ),
                    )
                  ],
                )
              ],
            ),
            SizedBox(
              height: SizeConfig.padding38,
            ),
            Stack(
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SvgPicture.asset(
                      'assets/svg/people.svg',
                      height: SizeConfig.padding16,
                    ),
                    SizedBox(
                      width: SizeConfig.padding6,
                    ),
                    Text(
                      'Fello is even more fun with friends!',
                      style: TextStyles.sourceSans.body3.colour(
                        Colors.white.withOpacity(0.64),
                      ),
                    )
                  ],
                ),
                Positioned(
                  left: 35,
                  top: 5,
                  child: CustomPaint(
                    size: Size(SizeConfig.padding8,
                        (SizeConfig.padding8 * 1.09).toDouble()),
                    painter: StarCustomPainter(),
                  ),
                ),
                Positioned(
                  left: 41,
                  top: 0,
                  child: CustomPaint(
                    size: Size(SizeConfig.padding6,
                        (SizeConfig.padding6 * 1.09).toDouble()),
                    painter: StarCustomPainter(),
                  ),
                ),
                Positioned(
                  left: 60,
                  top: 3,
                  child: CustomPaint(
                    size: Size(SizeConfig.padding8,
                        (SizeConfig.padding8 * 1.09).toDouble()),
                    painter: StarCustomPainter(),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: SizeConfig.padding12,
            ),
            AppPositiveBtn(
              btnText: 'ALLOW ACCESS TO CONTACTS',
              onPressed: () async {
                await context.read<ReferralCubit>().requestPermission();

                locator<AnalyticsService>().track(
                  eventName: AnalyticsEvents.syncContactsTapped,
                  properties: {
                    'Earned So far': widget.model.totalReferralWon,
                    'Current referral count':
                        AnalyticsProperties.getTotalReferralCount(),
                    'Data point 1': '${usersFromReferrals.toString()} Users',
                    'Data point 2': '$referrersCount Referrals',
                    'Data point 3': '₹$rewardsFromReferrals rewards',
                  },
                );
              },
            ),
            SizedBox(
              height: SizeConfig.padding4,
            ),
            TextButton(
              onPressed: () {
                AppState.backButtonDispatcher?.didPopRoute();
                if (widget.model.isShareAlreadyClicked == false) {
                  locator<ReferralService>().shareLink();
                }
              },
              child: Text(
                'INVITE MANUALLY',
                textAlign: TextAlign.center,
                style: TextStyles.rajdhaniSB.body0.colour(
                  const Color(0xFF00F2C7),
                ),
              ),
            ),
            SizedBox(
              height: SizeConfig.padding22,
            )
          ],
        ),
      ),
    );
  }
}
