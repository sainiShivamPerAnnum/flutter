// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:felloapp/base_util.dart';
import 'package:felloapp/core/repository/getters_repo.dart';
import 'package:felloapp/navigator/app_state.dart';
import 'package:felloapp/ui/pages/static/loader_widget.dart';
import 'package:felloapp/util/locator.dart';
import 'package:felloapp/util/styles/styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class EarnMoreReturns extends StatefulWidget {
  const EarnMoreReturns({super.key});

  @override
  State<EarnMoreReturns> createState() => _EarnMoreReturnsState();
}

class _EarnMoreReturnsState extends State<EarnMoreReturns> {
  final _getterRepo = locator<GetterRepository>();
  List<dynamic> incentivesList = [];
  bool _isLoading = true;
  bool get isLoading => _isLoading;

  set isLoading(bool value) {
    setState(() {
      _isLoading = value;
    });
  }

  @override
  void initState() {
    super.initState();
    _getterRepo.getIncentivesList().then((res) {
      if (res.isSuccess()) {
        incentivesList = res.model!;
      }
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    // List<EMRModel> emrOptions = [
    //   EMRModel(
    //       title: "Get more Tambola Tickets",
    //       subtitle: "Earn upto 10K in interest every week",
    //       asset: Assets.tambola_instant_view,
    //       actionUrl: '/tambolaHome'),
    //   EMRModel(
    //       title: "Get more Tambola Tickets",
    //       subtitle: "Earn upto 10K in interest every week",
    //       asset: Assets.tambola_instant_view,
    //       actionUrl: '/play'),
    //   EMRModel(
    //       title: "Get more Tambola Tickets",
    //       subtitle: "Earn upto 10K in interest every week",
    //       asset: Assets.tambola_instant_view,
    //       actionUrl: '/tambolaHome'),
    //   EMRModel(
    //       title: "Get more Tambola Tickets",
    //       subtitle: "Earn upto 10K in interest every week",
    //       asset: Assets.tambola_instant_view,
    //       actionUrl: '/tambolaHome'),
    //   EMRModel(
    //       title: "Get more Tambola Tickets",
    //       subtitle: "Earn upto 10K in interest every week",
    //       asset: Assets.tambola_instant_view,
    //       actionUrl: '/tambolaHome')
    // ];
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Badges on Fello",
          style: TextStyles.sourceSansSB.title3,
        ),
        backgroundColor: UiConstants.kBackgroundColor,
      ),
      backgroundColor: UiConstants.kBackgroundColor,
      body: isLoading
          ? const FullScreenLoader()
          : ListView.builder(
              padding: EdgeInsets.symmetric(vertical: SizeConfig.padding20),
              itemCount: incentivesList.length,
              itemBuilder: (ctx, i) => Card(
                  color: UiConstants.kTambolaMidTextColor,
                  shape: RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.circular(SizeConfig.cardBorderRadius),
                  ),
                  margin: EdgeInsets.symmetric(
                    horizontal: SizeConfig.pageHorizontalMargins,
                    vertical: SizeConfig.padding8,
                  ),
                  child: GestureDetector(
                    onTap: () {
                      if (incentivesList[i]["actionUri"].contains("Https")) {
                        BaseUtil.launchUrl(incentivesList[i]["actionUri"]);
                      } else {
                        AppState.delegate!.parseRoute(
                            Uri.parse(incentivesList[i]["actionUri"]));
                      }
                    },
                    child: ClipRRect(
                      borderRadius:
                          BorderRadius.circular(SizeConfig.cardBorderRadius),
                      child: SvgPicture.network(
                        incentivesList[i]["cardImageUrl"],
                      ),
                    ),
                  )
                  //  ListTile(
                  //   onTap: () => AppState.delegate!
                  //       .parseRoute(Uri.parse(incentivesList[i].actionUrl)),
                  //   leading: Transform.translate(
                  //     offset: Offset(0, SizeConfig.padding8),
                  //     child: SvgPicture.asset(
                  //       emrOptions[i].asset,
                  //       width: SizeConfig.padding54,
                  //     ),
                  //   ),
                  //   title:
                  //       Text(emrOptions[i].title, style: TextStyles.rajdhaniSB.body2),
                  //   subtitle: Text(
                  //     emrOptions[i].subtitle,
                  //     style: TextStyles.sourceSans.body3.colour(Colors.grey),
                  //   ),
                  // ),
                  ),
            ),
    );
  }
}

class EMRModel {
  final String title;
  final String asset;
  final String subtitle;
  final String actionUrl;
  EMRModel({
    required this.title,
    required this.asset,
    required this.subtitle,
    required this.actionUrl,
  });

  EMRModel copyWith({
    String? title,
    String? asset,
    String? subtitle,
    String? actionUrl,
  }) {
    return EMRModel(
      title: title ?? this.title,
      asset: asset ?? this.asset,
      subtitle: subtitle ?? this.subtitle,
      actionUrl: actionUrl ?? this.actionUrl,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'title': title,
      'asset': asset,
      'subtitle': subtitle,
      'actionUrl': actionUrl,
    };
  }

  factory EMRModel.fromMap(Map<String, dynamic> map) {
    return EMRModel(
      title: map['title'] as String,
      asset: map['asset'] as String,
      subtitle: map['subtitle'] as String,
      actionUrl: map['actionUrl'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory EMRModel.fromJson(String source) =>
      EMRModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'EMRModel(title: $title, asset: $asset, subtitle: $subtitle, actionUrl: $actionUrl)';
  }

  @override
  bool operator ==(covariant EMRModel other) {
    if (identical(this, other)) return true;

    return other.title == title &&
        other.asset == asset &&
        other.subtitle == subtitle &&
        other.actionUrl == actionUrl;
  }

  @override
  int get hashCode {
    return title.hashCode ^
        asset.hashCode ^
        subtitle.hashCode ^
        actionUrl.hashCode;
  }
}
