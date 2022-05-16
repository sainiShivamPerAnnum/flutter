import 'dart:convert';

import 'package:flutter/foundation.dart';

class EventModel {
  String title;
  String subtitle;
  String thumbnail;
  String type;
  int position;
  int color;
  String image;
  List<dynamic> instructions;
  int minVersion;
  String url; //only for new fello
  String formUrl;
  String todayMatch; //Only for FPL
  EventModel(
      {@required this.title,
      @required this.subtitle,
      @required this.thumbnail,
      @required this.type,
      @required this.position,
      @required this.color,
      @required this.image,
      @required this.minVersion,
      @required this.url,
      @required this.formUrl,
      @required this.instructions,
      this.todayMatch});

  EventModel copyWith(
      {String title,
      String subtitle,
      String thumbnail,
      String type,
      int position,
      int color,
      int minVersion,
      String image,
      List<dynamic> instructions}) {
    return EventModel(
        title: title ?? this.title,
        subtitle: subtitle ?? this.subtitle,
        thumbnail: thumbnail ?? this.thumbnail,
        type: type ?? this.type,
        position: position ?? this.position,
        color: color ?? this.color,
        image: image ?? this.image,
        minVersion: minVersion ?? this.minVersion,
        instructions: instructions ?? this.instructions,
        formUrl: formUrl ?? this.formUrl,
        url: url ?? this.url,
        todayMatch: todayMatch ?? this.todayMatch);
  }

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'subtitle': subtitle,
      'thumbnail': thumbnail,
      'type': type,
      'position': position,
      'color': color,
      'image': image,
      'minVersion': minVersion,
      'url': url,
      'instructions': instructions,
      'formUrl': formUrl,
      'todayMatch': todayMatch
    };
  }

  factory EventModel.fromMap(Map<String, dynamic> map) {
    return EventModel(
        title: map['title'] ?? '',
        subtitle: map['subtitle'] ?? '',
        thumbnail: map['thumbnail'] ?? '',
        type: map['type'] ?? '',
        position: map['position'] ?? 1,
        color: map['color'] ?? 4280492835,
        image: map['image'] ?? '',
        url: map['url'] ?? '',
        formUrl: map['formUrl'] ?? '',
        minVersion: map["minVersion"] ?? 0,
        instructions: map['info'] ?? ["Fello Event Instructions"],
        todayMatch: map['todayMatch'] ?? "");
  }

  String toJson() => json.encode(toMap());

  factory EventModel.fromJson(String source) =>
      EventModel.fromMap(json.decode(source));

  @override
  String toString() {
    return 'EventModel(title: $title, subtitle: $subtitle, thumbnail: $thumbnail, type: $type, position: $position color: $color image: $image  todayMatch : $todayMatch  minVersion: $minVersion url: $url formUrl: $formUrl)';
  }
}
