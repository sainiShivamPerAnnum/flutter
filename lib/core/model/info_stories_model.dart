import 'dart:convert';

import 'package:flutter/material.dart';

class InfoStoryItem {
  String type;
  String data;
  String caption;
  InfoStoryItem({
    @required this.type,
    @required this.data,
    @required this.caption,
  });

  InfoStoryItem copyWith({
    String type,
    String data,
    String caption,
  }) {
    return InfoStoryItem(
      type: type ?? this.type,
      data: data ?? this.data,
      caption: caption ?? this.caption,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'type': type,
      'data': data,
      'caption': caption,
    };
  }

  factory InfoStoryItem.fromMap(Map<String, dynamic> map) {
    return InfoStoryItem(
      type: map['type'] as String,
      data: map['data'] as String,
      caption: map['caption'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory InfoStoryItem.fromJson(String source) =>
      InfoStoryItem.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() =>
      'InfoStoryItem(type: $type, data: $data, caption: $caption)';

  @override
  bool operator ==(covariant InfoStoryItem other) {
    if (identical(this, other)) return true;

    return other.type == type && other.data == data && other.caption == caption;
  }

  @override
  int get hashCode => type.hashCode ^ data.hashCode ^ caption.hashCode;
}
