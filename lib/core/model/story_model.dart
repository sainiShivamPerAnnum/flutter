import 'package:felloapp/core/model/helper_model.dart';
import 'package:felloapp/util/logger.dart';
import 'package:flutter/material.dart';

class StoryItemModel {
  static Log log = new Log('StoryItemModel');

  final String _richText;
  final String _assetUri;

  static final helper =
      HelperModel<StoryItemModel>((map) => StoryItemModel.fromMap(map));

  StoryItemModel(this._richText, this._assetUri);

  StoryItemModel.fromMap(Map<String, dynamic> cMap)
      : this(cMap['richText'], cMap['asset']);

  String get richText => this._richText;

  String get assetUri => this._assetUri;
}
