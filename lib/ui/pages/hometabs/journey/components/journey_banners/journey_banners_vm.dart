import 'dart:async';

import 'package:felloapp/core/constants/analytics_events_constants.dart';
import 'package:felloapp/core/model/promo_cards_model.dart';
import 'package:felloapp/core/service/analytics/analytics_service.dart';
import 'package:felloapp/ui/architecture/base_vm.dart';
import 'package:felloapp/util/locator.dart';
import 'package:felloapp/core/repository/getters_repo.dart';
import 'package:flutter/material.dart';

class JourneyBannersViewModel extends BaseViewModel {
  final GetterRepository _getterRepo = locator<GetterRepository>();
  final AnalyticsService _analyticService = locator<AnalyticsService>();

  final PageController promoPageController = PageController(initialPage: 0);
  int _currentPage = 0;
  Timer? _timer;

  List<PromoCardModel>? _offerList;

  bool _isOfferListLoading = true;
  get isOfferListLoading => _isOfferListLoading;

  set isOfferListLoading(value) {
    _isOfferListLoading = value;
    notifyListeners();
  }

  List<PromoCardModel>? get offerList => _offerList;

  loadOfferList() async {
    isOfferListLoading = true;
    final response = await _getterRepo.getPromoCards();
    if (response.code == 200) {
      _offerList = response.model;
    } else {
      _offerList = [];
    }
    print(_offerList);
    if (_offerList != null && offerList!.length > 1) initiateAutoScroll();
    isOfferListLoading = false;
  }

  initiateAutoScroll() {
    _timer = Timer.periodic(const Duration(seconds: 6), (Timer timer) {
      if (_currentPage < offerList!.length - 1) {
        _currentPage++;
      } else {
        _currentPage = 0;
      }

      promoPageController.animateToPage(
        _currentPage,
        duration: const Duration(milliseconds: 600),
        curve: Curves.easeIn,
      );
    });
  }

  void trackJourneyBannerClickEvent(int bannerOrder, PromoCardModel promo) {
    _analyticService.track(eventName: AnalyticsEvents.bannerClick, properties: {
      "Location": "Journey Footer",
      "Order": bannerOrder,
      "Title": promo.title ?? '',
      "Subtitle": promo.subtitle ?? '',
      "ActionUri": promo.actionUri,
    });
  }

  void clear() {
    _timer?.cancel();
    promoPageController.dispose();
  }
}
