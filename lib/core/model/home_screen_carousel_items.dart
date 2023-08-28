// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:felloapp/core/model/helper_model.dart';

class HomeScreenCarouselItemsModel {
  final String type;
  final String thumbnail;
  final String action;
  final int order;
  HomeScreenCarouselItemsModel({
    required this.type,
    required this.thumbnail,
    required this.action,
    required this.order,
  });

  static final helper = HelperModel<HomeScreenCarouselItemsModel>(
      HomeScreenCarouselItemsModel.fromMap);

  factory HomeScreenCarouselItemsModel.fromMap(Map<String, dynamic> map) {
    return HomeScreenCarouselItemsModel(
      type: map['type'] as String,
      thumbnail: map['thumbnail'] as String,
      action: map['action'] as String,
      order: map['order'] as int,
    );
  }
}
