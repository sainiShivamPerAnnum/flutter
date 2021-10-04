import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:felloapp/base_util.dart';
import 'package:felloapp/core/model/referral_details_model.dart';
import 'package:felloapp/core/ops/db_ops.dart';
import 'package:felloapp/util/constants.dart';
import 'package:felloapp/util/size_config.dart';
import 'package:felloapp/util/ui_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class ReferralsPage extends StatefulWidget {
  ReferralsPage();

  @override
  State createState() => _ReferralsPageState();
}

class _ReferralsPageState extends State<ReferralsPage> {
  BaseUtil baseProvider;
  DBModel dbProvider;

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
            dbProvider.updateUserReferralCount(baseProvider.myUser.uid,
                baseProvider.myReferralInfo); //await not required
          }
        }
        setState(() {});
      });
    }
    return Scaffold(
        appBar: BaseUtil.getAppBar(context, "My Referrals"),
        body: Container(
            width: SizeConfig.screenWidth,
            height: SizeConfig.screenHeight * 0.9,
            padding: EdgeInsets.only(
                left: SizeConfig.blockSizeHorizontal * 2,
                right: SizeConfig.blockSizeHorizontal * 2),
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
                  ))));
  }

  Widget _buildRefItem(ReferralDetail rDetail) {
    if (rDetail.timestamp == null ||
        rDetail.timestamp.toDate().isBefore(Constants.VERSION_2_RELEASE_DATE))
      return Container();
    bool _isBonusUnlocked = (rDetail.isRefereeBonusUnlocked == null ||
        rDetail.isRefereeBonusUnlocked ||
        rDetail.isUserBonusUnlocked == null ||
        rDetail.isUserBonusUnlocked);
    return Padding(
      padding: EdgeInsets.only(top: 5, bottom: 5),
      child: Container(
        margin: EdgeInsets.symmetric(
            horizontal: SizeConfig.blockSizeHorizontal * 2),
        decoration: BoxDecoration(
          color: (_isBonusUnlocked)
              ? UiConstants.primaryColor
              : Colors.blueGrey[400],
          gradient: (_isBonusUnlocked)
              ? LinearGradient(
                  colors: [
                    UiConstants.primaryColor,
                    UiConstants.primaryColor.withGreen(220)
                  ],
                )
              : LinearGradient(
                  colors: [Colors.blueGrey[600], Colors.blueGrey[400]],
                ),
          shape: BoxShape.rectangle,
          borderRadius: BorderRadius.circular(UiConstants.padding),
          boxShadow: [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 10.0,
              offset: const Offset(0.0, 10.0),
            ),
          ],
        ),
        child: Container(
            padding: EdgeInsets.all(SizeConfig.blockSizeHorizontal * 3),
            width: double.infinity,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                ListTile(
                  title: Text(
                    rDetail.userName ?? '',
                    maxLines: 1,
                    overflow: TextOverflow.clip,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: SizeConfig.cardTitleTextSize,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  trailing: Text(
                    'Referred on ${_getUserMembershipDate(rDetail.timestamp)}',
                    maxLines: 2,
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: SizeConfig.smallTextSize * 1.3,
                    ),
                  ),
                ),
                Text(
                  _getBonusText(rDetail),
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
              ],
            )),
      ),
    );
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
          rDetail.bonusMap['utck'] != null) {
        int _amt = BaseUtil.toInt(rDetail.bonusMap['uamt']);
        int _tck = BaseUtil.toInt(rDetail.bonusMap['utck']);
        if (_amt != null && _tck != null)
          return 'You earned ₹$_amt and $_tck tickets 🥳';
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
