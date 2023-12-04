import 'dart:convert';

class EventModel {
  String title;
  String subtitle;
  String thumbnail;
  String bgImage;
  String type;
  int position;
  String textColor;
  String image;
  int maxWin;
  List<dynamic> instructions;
  int minVersion;
  List<dynamic> info;
  String url; //only for new fello
  String formUrl;
  String? todayMatch; //Only for FPL
  List<dynamic> winners; //only for bug_Bounty and new_Fello

  EventModel({
    required this.title,
    required this.subtitle,
    required this.thumbnail,
    required this.type,
    required this.position,
    required this.textColor,
    required this.image,
    required this.bgImage,
    required this.maxWin,
    required this.minVersion,
    required this.info,
    required this.url,
    required this.formUrl,
    required this.instructions,
    required this.winners,
    this.todayMatch,
  });

  EventModel copyWith({
    String? title,
    String? subtitle,
    String? thumbnail,
    String? type,
    int? position,
    int? maxWin,
    String? color,
    String? bgImage,
    int? minVersion,
    List<String>? info,
    String? image,
    List<dynamic>? instructions,
    List<dynamic>? winners,
  }) {
    return EventModel(
      title: title ?? this.title,
      subtitle: subtitle ?? this.subtitle,
      thumbnail: thumbnail ?? this.thumbnail,
      type: type ?? this.type,
      position: position ?? this.position,
      textColor: color ?? textColor,
      maxWin: maxWin ?? this.maxWin,
      image: image ?? this.image,
      bgImage: bgImage ?? this.bgImage,
      minVersion: minVersion ?? this.minVersion,
      info: info ?? this.info,
      instructions: instructions ?? this.instructions,
      formUrl: formUrl ?? formUrl,
      url: url ?? url,
      todayMatch: todayMatch ?? todayMatch,
      winners: winners ?? this.winners,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'subtitle': subtitle,
      'thumbnail': thumbnail,
      'type': type,
      'position': position,
      'color': textColor,
      'image': image,
      'maxWin': maxWin,
      'bgImage': bgImage,
      'minVersion': minVersion,
      'info': info,
      'url': url,
      'instructions': instructions,
      'formUrl': formUrl,
      'todayMatch': todayMatch,
      'winners': winners,
    };
  }

  factory EventModel.fromMap(Map<String, dynamic> map) {
    return EventModel(
      title: map['title'] ?? '',
      subtitle: map['subtitle'] ?? '',
      thumbnail: map['thumbnail'] ?? '',
      type: map['type'] ?? '',
      position: map['position'] ?? 1,
      textColor: map['textColor'] ?? "#ffffff",
      image: map['image'] ?? '',
      maxWin: map['maxWin'] ?? 250,
      url: map['url'] ?? '',
      bgImage: map['bgImage'] ?? '',
      formUrl: map['formUrl'] ?? '',
      minVersion: map["minVersion"] ?? 0,
      info: map["info"] ?? [],
      instructions: map['info'] ?? ["Fello Event Instructions"],
      todayMatch: map['todayMatch'] ?? "",
      winners: map['winners'] ?? ["ritika won ₹4000"],
    );
  }

  String toJson() => json.encode(toMap());

  factory EventModel.fromJson(String source) =>
      EventModel.fromMap(json.decode(source));

  @override
  String toString() {
    return 'EventModel(title: $title, subtitle: $subtitle, thumbnail: $thumbnail, type: $type, position: $position color: $textColor image: $image  todayMatch : $todayMatch  minVersion: $minVersion url: $url formUrl: $formUrl winners: $winners)';
  }
}
