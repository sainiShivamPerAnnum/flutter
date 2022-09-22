import 'dart:async';

import 'package:felloapp/core/model/promo_cards_model.dart';
import 'package:felloapp/ui/architecture/base_vm.dart';
import 'package:felloapp/util/locator.dart';
import 'package:felloapp/core/repository/getters_repo.dart';
import 'package:flutter/material.dart';

class JourneyBannersViewModel extends BaseViewModel {
  final _getterRepo = locator<GetterRepository>();
  final PageController promoPageController = new PageController(initialPage: 0);
  int _currentPage = 0;
  Timer _timer;

  List<PromoCardModel> _offerList;

  bool _isOfferListLoading = true;
  get isOfferListLoading => this._isOfferListLoading;

  set isOfferListLoading(value) {
    this._isOfferListLoading = value;
    notifyListeners();
  }

  List<PromoCardModel> get offerList => _offerList;

  loadOfferList() async {
    isOfferListLoading = true;
    final response = await _getterRepo.getPromoCards();
    if (response.code == 200) {
      _offerList = response.model;
    } else {
      _offerList = [];
    }
    print(_offerList);
    if (_offerList != null && offerList.length > 1) initiateAutoScroll();
    isOfferListLoading = false;
  }

  initiateAutoScroll() {
    _timer = Timer.periodic(Duration(seconds: 6), (Timer timer) {
      if (_currentPage < offerList.length - 1) {
        _currentPage++;
      } else {
        _currentPage = 0;
      }

      promoPageController.animateToPage(
        _currentPage,
        duration: Duration(milliseconds: 600),
        curve: Curves.easeIn,
      );
    });
  }

  void clear() {
    _timer?.cancel();
  }
}
