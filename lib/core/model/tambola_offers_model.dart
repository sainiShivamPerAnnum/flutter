// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:felloapp/core/model/helper_model.dart';

class TicketsOffers {
  final String deep_uri;
  final String image;
  final int order;
  TicketsOffers({
    required this.deep_uri,
    required this.image,
    required this.order,
  });

  static final helper =
      HelperModel<TicketsOffers>((map) => TicketsOffers.fromMap(map));

  factory TicketsOffers.fromMap(Map<String, dynamic> map) {
    return TicketsOffers(
      deep_uri: map['deep_uri'] as String,
      image: map['image'] as String,
      order: map['order'] as int,
    );
  }

  @override
  String toString() =>
      'TicketsOffers(deep_uri: $deep_uri, image: $image, order: $order)';

  @override
  bool operator ==(covariant TicketsOffers other) {
    if (identical(this, other)) return true;

    return other.deep_uri == deep_uri &&
        other.image == image &&
        other.order == order;
  }

  @override
  int get hashCode => deep_uri.hashCode ^ image.hashCode ^ order.hashCode;
}
