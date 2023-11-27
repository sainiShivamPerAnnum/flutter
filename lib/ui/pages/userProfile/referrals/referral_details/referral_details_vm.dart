import 'dart:async';
import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:felloapp/base_util.dart';
import 'package:felloapp/core/constants/analytics_events_constants.dart';
import 'package:felloapp/core/enums/app_config_keys.dart';
import 'package:felloapp/core/model/app_config_model.dart';
import 'package:felloapp/core/model/referral_details_model.dart';
import 'package:felloapp/core/model/referral_response_model.dart';
import 'package:felloapp/core/ops/db_ops.dart';
import 'package:felloapp/core/repository/referral_repo.dart';
import 'package:felloapp/core/service/analytics/analyticsProperties.dart';
import 'package:felloapp/core/service/analytics/analytics_service.dart';
import 'package:felloapp/core/service/analytics/appflyer_analytics.dart';
import 'package:felloapp/ui/architecture/base_vm.dart';
import 'package:felloapp/util/api_response.dart';
// import 'package:flutter_share_me/flutter_share_me.dart';
import 'package:felloapp/util/custom_logger.dart';
import 'package:felloapp/util/haptic.dart';
import 'package:felloapp/util/localization/generated/l10n.dart';
import 'package:felloapp/util/locator.dart';
import 'package:felloapp/util/styles/size_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';

import '../../../../../core/model/contact_model.dart';

class ReferralDetailsViewModel extends BaseViewModel {
  final CustomLogger _logger = locator<CustomLogger>();

  // final FcmListener _fcmListener = locator<FcmListener>();
  // final UserService _userService = locator<UserService>();
  final AnalyticsService _analyticsService = locator<AnalyticsService>();
  final AppFlyerAnalytics _appFlyer = locator<AppFlyerAnalytics>();

  // final UserRepository _userRepo = locator<UserRepository>();
  final ReferralRepo _refRepo = locator<ReferralRepo>();
  final DBModel _dbModel = locator<DBModel>();
  S locale = locator<S>();

  PageController? _pageController;
  int _tabNo = 0;

  final bool _isShareAlreadyClicked = false;

  bool get isShareAlreadyClicked => _isShareAlreadyClicked;

  int get tabNo => _tabNo;

  set tabNo(value) {
    _tabNo = value;
    notifyListeners();
  }

  double _tabPosWidthFactor = SizeConfig.pageHorizontalMargins;

  double get tabPosWidthFactor => _tabPosWidthFactor;

  set tabPosWidthFactor(value) {
    _tabPosWidthFactor = value;
    notifyListeners();
  }

  PageController? get pageController => _pageController;

  late BaseUtil baseProvider;
  DBModel? dbProvider;

  List<ReferralDetail>? _referalList;

  List<ReferralDetail>? get referalList => _referalList;

  bool noMoreReferrals = false;
  int _currentPage = 0;

  int get currentPage => _currentPage;

  set currentPage(int val) {
    _currentPage = val;
    notifyListeners();
  }

  set referalList(List<ReferralDetail>? value) {
    _referalList = value;
    notifyListeners();
  }

  String appShareMessage =
      AppConfig.getValue<String>(AppConfigKey.appShareMessage);
  String unlockReferralBonus =
      AppConfig.getValue(AppConfigKey.unlock_referral_amt).toString();

  final String _refUrl = "";
  String? _refCode = "";
  int? _totalReferralWon = -1;
  List<Contact>? contactsList = [];
  List<String> phoneNumbers = [];
  List<String> registeredUser = [];
  String? referralAmount;

  late String _shareMsg;
  bool shareWhatsappInProgress = false;
  bool shareLinkInProgress = false;
  bool loadingRefCode = true;
  bool hasPermission = false;

  final bool _isReferalsFetched = false;

  get refUrl => _refUrl;

  get refCode => _refCode;

  get isReferalsFetched => _isReferalsFetched;

  int? get totalReferralWon => _totalReferralWon;

  set totalReferralWon(int? value) {
    _totalReferralWon = value;
    notifyListeners();
  }

  void init(BuildContext context) {
    // generateLink().then((value) {
    //   _refUrl = value;
    // });
    _pageController = PageController(initialPage: 0);

    fetchReferralCode();
    fetchReferalsList(context);
    checkPermission();

    referralAmount = ((AppConfig.getValue(
                        AppConfigKey.revamped_referrals_config)?['rewardValues']
                    ?['invest1k'] ??
                50) +
            (AppConfig.getValue(AppConfigKey.revamped_referrals_config)?[
                    'rewardValues']?['invest10kflo12'] ??
                450))
        .toString();

    log("referralAmount: $referralAmount");
  }

  Future<void> checkPermission() async {
    PermissionStatus permission = await Permission.contacts.status;

    hasPermission = permission == PermissionStatus.granted;

    if (hasPermission) {
      await loadContacts();
    }
  }

  void copyReferCode() {
    Haptic.vibrate();
    _analyticsService
        .track(eventName: AnalyticsEvents.copyReferalCode, properties: {
      "Referrred Count Success": AnalyticsProperties.getSuccessReferralCount(),
      "Referred count (total)": AnalyticsProperties.getTotalReferralCount(),
      "code": _refCode,
    });
    Clipboard.setData(ClipboardData(text: _refCode!)).then((_) {
      BaseUtil.showPositiveAlert("Code: $_refCode", "Copied to Clipboard");
    });
  }

  Future<void> fetchReferralCode() async {
    final ApiResponse<ReferralResponse> res = await _refRepo.getReferralCode();
    if (res.code == 200) {
      _refCode = res.model?.referralData?.code ?? "";
      appShareMessage = res.model?.referralData?.referralMessage ?? "";
      totalReferralWon = res.model?.referralData?.referralRewardAmt ?? -1;
      _shareMsg = (appShareMessage.isNotEmpty)
          ? appShareMessage
          : 'Hey I am gifting you ₹${AppConfig.getValue(AppConfigKey.referralBonus)} and ${AppConfig.getValue(AppConfigKey.referralFlcBonus)} gaming tokens. Lets start saving and playing together! Share this code: $_refCode with your friends.\n';
    } else {
      _refCode = '';
      _shareMsg = '';
      BaseUtil.showNegativeAlert(res.errorMessage, '');
    }
    loadingRefCode = false;
    refresh();
  }

  switchTab(int tab) {
    if (tab == tabNo) return;
    tabNo = tab;
    tab == 0
        ? locator<AnalyticsService>().track(
            eventName: AnalyticsEvents.yourReferralsTapped,
            properties: {
              'Earned So far': totalReferralWon,
              "total referrals": AnalyticsProperties.getTotalReferralCount(),
            },
          )
        : locator<AnalyticsService>().track(
            eventName: AnalyticsEvents.inviteContactsTapped,
            properties: {
              'Earned So far': totalReferralWon,
              "contact access given": hasPermission,
              "Current referral count":
                  AnalyticsProperties.getTotalReferralCount(),
            },
          );
  }

  Future<void> fetchReferalsList(BuildContext context,
      {bool refresh = false}) async {
    print("Method to fetch");
    baseProvider = Provider.of<BaseUtil>(context, listen: false);
    dbProvider = Provider.of<DBModel>(context, listen: false);
    final ReferralRepo referralRepo = locator<ReferralRepo>();

    if (noMoreReferrals) {
      log("No more data to fetch");
      return;
    }

    // if (!(baseProvider.referralsFetched ?? false) || refresh) {
    unawaited(referralRepo
        .getReferralHistory(currentPage: currentPage)
        .then((refHisModel) {
      if (refHisModel.isSuccess()) {
        baseProvider.referralsFetched = true;

        if (currentPage == 0) {
          _referalList =
              baseProvider.userReferralsList = refHisModel.model ?? [];
        } else {
          _referalList?.addAll(refHisModel.model ?? []);
        }

        log("Referral List: ${_referalList!.length}");

        // If the fetched data count is less than 50, there's no more data to fetch
        if ((refHisModel.model?.length ?? 0) < 50) {
          noMoreReferrals = true; // Set the flag to true
        } else {
          // Increment the page number for the next fetch
          currentPage++;
        }
        notifyListeners();
      } else {
        BaseUtil.showNegativeAlert(refHisModel.errorMessage, '');
      }
      // });
    }));
    // else {
    //   _referalList = baseProvider.userReferralsList;
    //
    //   notifyListeners();
    // }
  }

  Future<String?> generateLink() async {
    if (_refUrl != "") return _refUrl;

    String? url;
    try {
      final link = await _appFlyer.inviteLink();
      if (link['status'] == 'success') {
        url = link['payload']['userInviteUrl'];
        url ??= link['payload']['userInviteURL'];
      }
      _logger.d('appflyer invite link as $url');
    } catch (e) {
      _logger.e(e);
    }
    return url;
  }

  Future getProfileDpWithUid(String uid) async {
    return _dbModel.getUserDP(uid);
  }

  String getUserMembershipDate(Timestamp? tmp) {
    if (tmp != null) {
      DateTime dt = tmp.toDate();
      return DateFormat("dd MMM, yyyy").format(dt);
    } else {
      return '\'Unavailable\'';
    }
  }

  bool bonusUnlockedReferalPresent(List<ReferralDetail> list) {
    // for (final ReferralDetail e in list) {
    //   if (e.isRefereeBonusUnlocked) {
    //     return true;
    //   }
    // }

    return true;
  }

  bool bonusLockedReferalPresent(List<ReferralDetail> list) {
    for (final ReferralDetail e in list) {
      if (e.isRefereeBonusUnlocked == false) {
        return true;
      }
    }

    return false;
  }

  Future<List<Contact>> loadContacts() async {
    const MethodChannel methodChannel = MethodChannel('methodChannel/contact');

    try {
      await Future.delayed(const Duration(milliseconds: 500));
      final List<dynamic>? contacts =
          await methodChannel.invokeMethod<List<dynamic>>('getContacts');
      if (contacts != null) {
        // Parse the contacts data
        final Set<String> uniquePhoneNumbers = {};
        final List<Contact> parsedContacts = [];

        for (final contactData in contacts) {
          final phoneNumber = contactData['phoneNumber'];
          if (phoneNumber == null) continue;

          final filteredPhoneNumber = _applyFilters(phoneNumber);

          if (filteredPhoneNumber == null) continue;

          if (!uniquePhoneNumbers.contains(filteredPhoneNumber)) {
            uniquePhoneNumbers.add(filteredPhoneNumber);
            phoneNumbers.add(filteredPhoneNumber);
            parsedContacts.add(Contact(
              displayName: contactData['displayName'],
              phoneNumber: filteredPhoneNumber,
            ));
          }
        }
        // Sort the contacts alphabetically by displayName
        parsedContacts.sort((a, b) => a.displayName.compareTo(b.displayName));

        log('Contacts loaded successfully!', name: 'ReferralDetailsScreen');
        contactsList = parsedContacts;
        return parsedContacts;

        //Print all contacts
        // for (final contact in _contacts) {
        //   log('${contact.displayName}, ${contact.phoneNumber}',
        //       name: 'ReferralDetailsScreen');
        // }
      }
      return [];
    } on PlatformException catch (e) {
      log('Error loading contacts: ${e.message}',
          name: 'ReferralDetailsScreen');
      return [];
    }
  }

  String? _applyFilters(String phoneNumber) {
    String filteredPhoneNumber = phoneNumber;

    // Remove spaces
    filteredPhoneNumber = filteredPhoneNumber.replaceAll(' ', '');

    // Remove "+91" prefix if present
    if (filteredPhoneNumber.startsWith('+91')) {
      filteredPhoneNumber = filteredPhoneNumber.substring(3);
    }

    // Filter out numbers less than 10 digits and not starting with 6, 7, 8, or 9
    if (filteredPhoneNumber.length < 10 ||
        !RegExp(r'^[6-9]').hasMatch(filteredPhoneNumber)) {
      return null;
    }

    return filteredPhoneNumber.isNotEmpty ? filteredPhoneNumber : null;
  }

// Future<void> shareWhatsApp() async {
//   if (await BaseUtil.showNoInternetAlert()) return;
//   _fcmListener!.addSubscription(FcmTopic.REFERRER);
//   BaseAnalytics.analytics!.logShare(
//     contentType: 'referral',
//     itemId: _userService!.baseUser!.uid!,
//     method: 'whatsapp',
//   );
//   shareWhatsappInProgress = true;
//   refresh();

//   String? url = await this.generateLink();
//   shareWhatsappInProgress = false;
//   refresh();

//   if (url == null) {
//     BaseUtil.showNegativeAlert(
//       locale.generatingLinkFailed,
//       locale.tryLater
//     );
//     return;
//   } else
//     _logger!.d(url);
//   try {
//     _analyticsService!.track(eventName: AnalyticsEvents.whatsappShare);
//     FlutterShareMe().shareToWhatsApp(msg: _shareMsg + url).then((flag) {
//       if (flag == "false") {
//         FlutterShareMe()
//             .shareToWhatsApp4Biz(msg: _shareMsg + url)
//             .then((flag) {
//           _logger!.d(flag);
//           if (flag == "false") {
//             BaseUtil.showNegativeAlert(
//                locale.whatsappNotDetected, locale.otherShareOption);
//           }
//         });
//       }
//     });
//   } catch (e) {
//     _logger!.d(e.toString());
//   }
// }
}
