import 'dart:convert';

class JourneyPathModel {
  final String asset;
  final double dx, dy;
  final double height, width;
  final int dz;
  final int page;
  final int level;
  final bool isBase;
  final String type; // [PNG,SVG.CSP]
  final String alignment; //Left || Right
  final String source; // [NWT, AST, FILE, RAW, MMRY]
  JourneyPathModel({
    this.asset,
    this.dy,
    this.width,
    this.dz,
    this.dx,
    this.height,
    this.page,
    this.level,
    this.isBase,
    this.type,
    this.alignment,
    this.source,
  });

  JourneyPathModel copyWith({
    String asset,
    double dx,
    dy,
    double height,
    width,
    int dz,
    int page,
    int level,
    bool isBase,
    String type,
    String alignment,
    String source,
  }) {
    return JourneyPathModel(
      asset: asset ?? this.asset,
      dy: dy ?? this.dy,
      width: width ?? this.width,
      dz: dz ?? this.dz,
      page: page ?? this.page,
      level: level ?? this.level,
      isBase: isBase ?? this.isBase,
      type: type ?? this.type,
      alignment: alignment ?? this.alignment,
      source: source ?? this.source,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'asset': asset,
      'dy': dy,
      'width': width,
      'dz': dz,
      'page': page,
      'level': level,
      'isBase': isBase,
      'type': type,
      'alignment': alignment,
      'source': source,
    };
  }

  factory JourneyPathModel.fromMap(Map<String, dynamic> map) {
    return JourneyPathModel(
      asset: map['asset'] ?? '',
      dy: map['dy'] ?? 0,
      dx: map['dx'] ?? 0,
      dz: map['dz']?.toInt() ?? 0,
      height: map['height'] ?? 0,
      width: map['width'] ?? 0.0,
      page: map['page']?.toInt() ?? 0,
      level: map['level']?.toInt() ?? 0,
      isBase: map['isBase'] ?? false,
      type: map['type'] ?? '',
      alignment: map['alignment'] ?? '',
      source: map['source'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory JourneyPathModel.fromJson(String source) =>
      JourneyPathModel.fromMap(json.decode(source));

  @override
  String toString() {
    return 'JourneyPathModel(asset: $asset, dy: $dy, width: $width, dz: $dz, page: $page, level: $level, isBase: $isBase, type: $type, alignment: $alignment, source: $source)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is JourneyPathModel &&
        other.asset == asset &&
        other.dy == dy &&
        other.width == width &&
        other.dz == dz &&
        other.page == page &&
        other.level == level &&
        other.isBase == isBase &&
        other.type == type &&
        other.alignment == alignment &&
        other.source == source;
  }

  @override
  int get hashCode {
    return asset.hashCode ^
        dy.hashCode ^
        width.hashCode ^
        dz.hashCode ^
        page.hashCode ^
        level.hashCode ^
        isBase.hashCode ^
        type.hashCode ^
        alignment.hashCode ^
        source.hashCode;
  }
}
