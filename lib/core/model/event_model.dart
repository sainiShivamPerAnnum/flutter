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
  EventModel({
    @required this.title,
    @required this.subtitle,
    @required this.thumbnail,
    @required this.type,
    @required this.position,
    @required this.color,
    @required this.image,
    @required this.instructions,
  });

  EventModel copyWith(
      {String title,
      String subtitle,
      String thumbnail,
      String type,
      int position,
      int color,
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
        instructions: instructions ?? this.instructions);
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
      'instructions': instructions
    };
  }

  factory EventModel.fromMap(Map<String, dynamic> map) {
    return EventModel(
        title: map['title'] ?? '',
        subtitle: map['subtitle'] ?? '',
        thumbnail: map['thumbnail'] ?? '',
        type: map['type'] ?? '',
        position: map['position'] ?? 1,
        color: map['color'] ?? 0,
        image: map['image'] ?? '',
        instructions: map['info'] ?? []);
  }

  String toJson() => json.encode(toMap());

  factory EventModel.fromJson(String source) =>
      EventModel.fromMap(json.decode(source));

  @override
  String toString() {
    return 'EventModel(title: $title, subtitle: $subtitle, thumbnail: $thumbnail, type: $type, position: $position color: $color image: $image)';
  }
}
