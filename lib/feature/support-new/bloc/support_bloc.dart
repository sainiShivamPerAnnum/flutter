import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:felloapp/core/model/app_config_serialized_model.dart';
import 'package:felloapp/core/model/support/social_items.dart';
import 'package:felloapp/feature/support-new/support_components/find_us.dart';
import 'package:felloapp/feature/support-new/support_components/help.dart';
import 'package:felloapp/feature/support-new/support_components/learn.dart';
import 'package:felloapp/feature/support-new/support_components/what_new.dart';
import 'package:felloapp/util/dynamic_ui_utils.dart';
import 'package:flutter/material.dart';

part 'support_event.dart';
part 'support_state.dart';

class SupportBloc extends Bloc<SupportEvent, SupportState> {
  SupportBloc() : super(const LoadingSupportData()) {
    on<LoadSupportData>(_onLoadHomeData);
  }
  FutureOr<void> _onLoadHomeData(
    LoadSupportData event,
    Emitter<SupportState> emitter,
  ) async {
    emitter(const LoadingSupportData());
    List<SocialItems> socialItems = AppConfigV2.instance.socialLinks;
    List<SocialVideo> socialVidoes = AppConfigV2.instance.socialVideos;
    String contactDetails = AppConfigV2.instance.contactDetails;
    String btnTxt = AppConfigV2.instance.socialBtnTxt;
    List<Widget> saveViewItems = [];
    for (final key in DynamicUiUtils.support) {
      switch (key) {
        case "LV":
          saveViewItems.add(
            const Learn(),
          );
          break;
        case "QL":
          saveViewItems.add(const WhatNew());
          break;

        case "BL":
          saveViewItems.add(const HelpWidget());
          break;
        case "SN":
          saveViewItems.add(const FindUs());
          break;
      }
    }
    emitter(
      SupportData(
        supportItems: saveViewItems,
        socialItems: socialItems,
        introData: socialVidoes,
        btnTxt: btnTxt,
        contactDetails: contactDetails,
      ),
    );
  }
}
