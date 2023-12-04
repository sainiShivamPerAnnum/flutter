import 'dart:convert';

class SettingsListItemModel {
  final String title;
  final String asset;
  final String actionUri;
  SettingsListItemModel({
    required this.title,
    required this.asset,
    required this.actionUri,
  });

  SettingsListItemModel copyWith({
    required String title,
    required String asset,
    required String actionUri,
  }) {
    return SettingsListItemModel(
      title: title ?? this.title,
      asset: asset ?? this.asset,
      actionUri: actionUri ?? this.actionUri,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'title': title,
      'asset': asset,
      'actionUri': actionUri,
    };
  }

  factory SettingsListItemModel.fromMap(Map<String, dynamic> map) {
    return SettingsListItemModel(
      title: map['title'] as String,
      asset: map['asset'] as String,
      actionUri: map['actionUri'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory SettingsListItemModel.fromJson(String source) =>
      SettingsListItemModel.fromMap(
          json.decode(source) as Map<String, dynamic>);

  @override
  String toString() =>
      'SettingsListItems(title: $title, asset: $asset, actionUri: $actionUri)';

  @override
  bool operator ==(covariant SettingsListItemModel other) {
    if (identical(this, other)) return true;

    return other.title == title &&
        other.asset == asset &&
        other.actionUri == actionUri;
  }

  @override
  int get hashCode => title.hashCode ^ asset.hashCode ^ actionUri.hashCode;
}
