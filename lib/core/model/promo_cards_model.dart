import 'package:felloapp/core/model/helper_model.dart';
import 'package:felloapp/util/logger.dart';

class PromoCardModel {
  static Log log = const Log('PromoCard');

  int? _position;
  final String? _title;
  final String? _subtitle;
  final String? _buttonText;
  final String? _actionUri;
  final int? _bgColor;
  final String? _bgImage;
  final int _gridX;
  final int minVersion;
  get position => _position;
  static final helper =
      HelperModel<PromoCardModel>((map) => PromoCardModel.fromMap(map));

  PromoCardModel(
      this._position,
      this._title,
      this._subtitle,
      this._actionUri,
      this._buttonText,
      this._bgColor,
      this._bgImage,
      this._gridX,
      this.minVersion);

  PromoCardModel.fromMap(Map<String, dynamic> cMap)
      : this(
            cMap['position'] ?? 0,
            cMap['title'] ?? '',
            cMap['subtitle'] ?? '',
            cMap['actionUri'] ?? '',
            cMap['btnText'] ?? '',
            cMap['color'] ?? 0,
            cMap['bgImage'] ?? '',
            cMap['gridX'] ?? 2,
            cMap['minVersion'] ?? 0);

  set position(value) => position = value;

  String? get title => _title;

  String? get subtitle => _subtitle;

  String? get buttonText => _buttonText;

  String? get actionUri => _actionUri;

  int? get bgColor => _bgColor;

  String? get bgImage => _bgImage;
  int get gridX => _gridX;
}
