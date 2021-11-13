import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:felloapp/base_util.dart';
import 'package:felloapp/core/model/referral_details_model.dart';
import 'package:felloapp/core/ops/db_ops.dart';
import 'package:felloapp/core/service/mixpanel_service.dart';
import 'package:felloapp/ui/pages/static/fello_appbar.dart';
import 'package:felloapp/ui/pages/static/home_background.dart';
import 'package:felloapp/util/assets.dart';
import 'package:felloapp/util/constants.dart';
import 'package:felloapp/util/locator.dart';
import 'package:felloapp/util/styles/size_config.dart';
import 'package:felloapp/util/styles/textStyles.dart';
import 'package:felloapp/util/styles/ui_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class ReferralHistoryView extends StatefulWidget {
  ReferralHistoryView();

  @override
  State createState() => _ReferralHistoryViewState();
}

class _ReferralHistoryViewState extends State<ReferralHistoryView> {
  BaseUtil baseProvider;
  DBModel dbProvider;
  final _mixpanelService = locator<MixpanelService>();

  @override
  Widget build(BuildContext context) {
    baseProvider = Provider.of<BaseUtil>(context, listen: false);
    dbProvider = Provider.of<DBModel>(context, listen: false);

    if (!baseProvider.referralsFetched) {
      dbProvider.getUserReferrals(baseProvider.myUser.uid).then((refList) {
        baseProvider.referralsFetched = true;
        baseProvider.userReferralsList = refList ?? [];

        ///check if user referral count is correct in the user object
        ///if not, update it
        if (baseProvider.userReferralsList != null &&
            baseProvider.userReferralsList.length > 0) {
          int _n = baseProvider.userReferralsList.length;
          int _t = 0;
          if (baseProvider.myReferralInfo != null &&
              baseProvider.myReferralInfo.refCount != null &&
              baseProvider.myReferralInfo.refCount > 0) {
            _t = baseProvider.myReferralInfo.refCount;
          }
          if (baseProvider.myReferralInfo != null && _t < _n) {
            baseProvider.myReferralInfo.refCount = _n;
            if (_n != null && _n > 0)
              _mixpanelService.mixpanel.track("No of referrals $_n");
            dbProvider.updateUserReferralCount(baseProvider.myUser.uid,
                baseProvider.myReferralInfo); //await not required
          }
        }
        setState(() {});
      });
    }
    return Scaffold(
        body: HomeBackground(
      child: Column(
        children: [
          FelloAppBar(
            leading: FelloAppBarBackButton(),
            title: "Referrals",
          ),
          Expanded(
            child: Container(
              padding: EdgeInsets.all(SizeConfig.pageHorizontalMargins),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(40),
                  topRight: Radius.circular(40),
                ),
                color: Colors.white,
              ),
              child: (baseProvider.referralsFetched)
                  ? SingleChildScrollView(
                      physics: BouncingScrollPhysics(),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Container(
                            // height: SizeConfig.screenHeight*0.8,
                            // width: SizeConfig.screenWidth*0.9,
                            child: ListView.builder(
                              shrinkWrap: true,
                              padding: const EdgeInsets.all(6.0),
                              itemBuilder: (context, i) {
                                return _buildRefItem(
                                    baseProvider.userReferralsList[i]);
                              },
                              itemCount: baseProvider.userReferralsList.length,
                            ),
                          ),
                          baseProvider.isOldCustomer()
                              ? Padding(
                                  padding: EdgeInsets.all(10),
                                  child: Text(
                                    'Referrals before April 2021 are not mentioned here',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        color: Colors.grey[500],
                                        fontSize: SizeConfig.mediumTextSize),
                                  ),
                                )
                              : Container()
                        ],
                      ),
                    )
                  : Center(
                      child: Padding(
                        padding: EdgeInsets.all(30),
                        child: SpinKitWave(
                          color: UiConstants.primaryColor,
                        ),
                      ),
                    ),
            ),
          )
        ],
      ),
    ));
  }

  Widget _buildRefItem(ReferralDetail rDetail) {
    if (rDetail.timestamp == null ||
        rDetail.timestamp.toDate().isBefore(Constants.VERSION_2_RELEASE_DATE))
      return Container();
    bool _isBonusUnlocked = (rDetail.isRefereeBonusUnlocked == null ||
        rDetail.isRefereeBonusUnlocked ||
        rDetail.isUserBonusUnlocked == null ||
        rDetail.isUserBonusUnlocked);
    return Container(
        margin: EdgeInsets.symmetric(vertical: SizeConfig.padding12),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(SizeConfig.roundness24),
            color: _isBonusUnlocked
                ? UiConstants.primaryColor.withOpacity(0.1)
                : UiConstants.tertiarySolid.withOpacity(0.1)),
        padding: EdgeInsets.symmetric(
            horizontal: SizeConfig.padding24, vertical: SizeConfig.padding16),
        width: SizeConfig.screenWidth,
        height: SizeConfig.screenWidth * 0.195,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            CircleAvatar(
              radius: SizeConfig.tileAvatarRadius,
              backgroundImage: AssetImage(
                Assets.profilePic,
              ),
              foregroundColor: UiConstants.tertiarySolid.withOpacity(0.4),
            ),
            SizedBox(width: SizeConfig.padding8),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(rDetail.userName ?? '',
                            maxLines: 2,
                            overflow: TextOverflow.clip,
                            style: TextStyles.body2.bold),
                      ),
                      Text(
                        _getBonusText(rDetail),
                        style: TextStyles.body4.bold.colour(_isBonusUnlocked
                            ? UiConstants.primaryColor
                            : UiConstants.tertiarySolid),
                      ),
                    ],
                  ),
                  SizedBox(height: SizeConfig.padding2),
                  Text('${_getUserMembershipDate(rDetail.timestamp)}',
                      maxLines: 2, style: TextStyles.body3.colour(Colors.grey)),
                ],
              ),
            ),
          ],
        ));
  }

  String _getBonusText(ReferralDetail rDetail) {
    bool _isBonusUnlocked = (rDetail.isRefereeBonusUnlocked == null ||
        rDetail.isRefereeBonusUnlocked ||
        rDetail.isUserBonusUnlocked == null ||
        rDetail.isUserBonusUnlocked);
    if (!_isBonusUnlocked)
      return 'Not yet invested 🔒';
    else {
      if (rDetail.bonusMap != null &&
          rDetail.bonusMap['uamt'] != null &&
          rDetail.bonusMap['uflc'] != null) {
        int _amt = BaseUtil.toInt(rDetail.bonusMap['uamt']);
        int _tck = BaseUtil.toInt(rDetail.bonusMap['uflc']);
        if (_amt != null && _tck != null)
          return 'You earned ₹$_amt and $_tck tokens 🥳';
      }
    }
    return 'Rewards unlocked 🥳';
  }

  String _getUserMembershipDate(Timestamp tmp) {
    if (tmp != null) {
      DateTime _dt = tmp.toDate();
      return DateFormat("dd MMM, yyyy").format(_dt);
    } else {
      return '\'Unavailable\'';
    }
  }
}
