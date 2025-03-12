// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:flutter/foundation.dart';

class DynamicUI {
  List<String> play;
  SaveUi save;
  SingleInfo journeyFab;
  List<String> navBar;
  DynamicUI(
      {required this.play,
      required this.save,
      required this.journeyFab,
      required this.navBar});

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'play': play,
      'save': save.toMap(),
      'journeyFab': journeyFab.toMap(),
      'navBar': navBar
    };
  }

  factory DynamicUI.fromMap(Map<String, dynamic> map) {
    return DynamicUI(
        play: List<String>.from(map['play'].cast<String>() as List<String>),
        navBar:
            List<String>.from(map['navbarv1'].cast<String>() as List<String>),
        save: SaveUi.fromMap(map['save'] as Map<String, dynamic>),
        journeyFab: SingleInfo.fromMap(map['journeyFab']));
  }

  String toJson() => json.encode(toMap());

  factory DynamicUI.fromJson(String source) =>
      DynamicUI.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() => 'DynamicUI(play: $play, save: $save)';

  @override
  bool operator ==(covariant DynamicUI other) {
    if (identical(this, other)) return true;

    return listEquals(other.play, play) && other.save == save;
  }

  @override
  int get hashCode => play.hashCode ^ save.hashCode;
}

class SaveUi {
  List<String> assets;
  List<String> sections;
  List<String> sectionsNew;
  final CtaText? ctaText;
  final BadgeText? badgeText;
  final String trendingAsset;
  SaveUi(
      {required this.assets,
      required this.sections,
      required this.sectionsNew,
      required this.badgeText,
      required this.trendingAsset,
      required this.ctaText});

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'assets': assets,
      'sections': sections,
    };
  }

  factory SaveUi.fromMap(Map<String, dynamic> map) {
    return SaveUi(
        assets: List<String>.from(map['assets'].cast<String>() as List<String>),
        sections:
            List<String>.from(map['sectionsv1'].cast<String>() as List<String>),
        sectionsNew: map['sectionsNew'] != null
            ? List<String>.from(
                map['sectionsNew'].cast<String>() as List<String>)
            : List<String>.from(
                map['sectionsNew'].cast<String>() as List<String>),
        badgeText: map['badgeText'] != null
            ? BadgeText.fromMap(map['badgeText'])
            : null,
        trendingAsset: map['trendingAsset'] ?? "",
        ctaText:
            map["ctaText"] != null ? CtaText.fromMap(map["ctaText"]) : null);
  }

  String toJson() => json.encode(toMap());

  factory SaveUi.fromJson(String source) =>
      SaveUi.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() => 'SaveUi(assets: $assets, sections: $sections)';

  @override
  bool operator ==(covariant SaveUi other) {
    if (identical(this, other)) return true;

    return listEquals(other.assets, assets) &&
        listEquals(other.sections, sections);
  }

  @override
  int get hashCode => assets.hashCode ^ sections.hashCode;
}

class CtaText {
  final String? AUGGOLD99;
  final String? LENDBOXP2P;

  CtaText(this.AUGGOLD99, this.LENDBOXP2P);

  factory CtaText.fromMap(Map<String, dynamic> data) =>
      CtaText(data["AUGGOLD99"], data["LENDBOXP2P"]);
}

class BadgeText {
  final String? AUGGOLD99;
  final String? LENDBOXP2P;

  BadgeText(this.AUGGOLD99, this.LENDBOXP2P);

  factory BadgeText.fromMap(Map<String, dynamic> data) =>
      BadgeText(data["AUGGOLD99"], data["LENDBOXP2P"]);
}

class SingleInfo {
  String iconUri;
  String actionUri;
  String title;
  bool isCollapse;
  SingleInfo({
    required this.iconUri,
    required this.actionUri,
    required this.title,
    required this.isCollapse,
  });

  SingleInfo copyWith({
    required String iconUri,
    required String actionUri,
    required String title,
  }) {
    return SingleInfo(
      iconUri: iconUri,
      actionUri: actionUri,
      title: title,
      isCollapse: isCollapse,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'iconUri': iconUri,
      'actionUri': actionUri,
      'title': title,
      'isCollapse': isCollapse,
    };
  }

  factory SingleInfo.fromMap(Map<String, dynamic> map) {
    return SingleInfo(
        iconUri: (map['iconUri'] ?? '') as String,
        actionUri: (map['actionUri'] ?? '') as String,
        title: (map['title'] ?? '') as String,
        isCollapse: (map['isCollapse'] ?? true) as bool);
  }

  String toJson() => json.encode(toMap());

  factory SingleInfo.fromJson(String source) =>
      SingleInfo.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() =>
      'SingleInfo(iconUri: $iconUri, actionUri: $actionUri, title: $title, isCollapse: $isCollapse)';

  @override
  bool operator ==(covariant SingleInfo other) {
    if (identical(this, other)) return true;

    return other.iconUri == iconUri &&
        other.actionUri == actionUri &&
        other.title == title;
  }

  @override
  int get hashCode => iconUri.hashCode ^ actionUri.hashCode ^ title.hashCode;
}
