// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:felloapp/core/model/helper_model.dart';

class SubComboModel {
  int order;
  String title;
  bool popular;
  int AUGGOLD99;
  int LENDBOXP2P;
  String icon;
  bool isSelected;
  SubComboModel(
      {required this.order,
      required this.title,
      required this.popular,
      required this.AUGGOLD99,
      required this.LENDBOXP2P,
      required this.icon,
      required this.isSelected});

  static final helper = HelperModel<SubComboModel>(
    (map) => SubComboModel.fromMap(map),
  );

  factory SubComboModel.fromMap(Map<String, dynamic> map) {
    return SubComboModel(
      order: map['order'] as int,
      title: map['title'] as String,
      popular: map['popular'] as bool,
      AUGGOLD99: map['AUGGOLD99'] as int,
      LENDBOXP2P: map['LENDBOXP2P'] as int,
      icon: map['icon'] as String,
      isSelected: false,
    );
  }

  @override
  String toString() {
    return 'SubCombos(order: $order, title: $title, popular: $popular, AUGGOLD99: $AUGGOLD99, LENDBOXP2P: $LENDBOXP2P, icon: $icon)';
  }
}
