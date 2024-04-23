import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/widgets.dart';

class TransactionSection extends StatelessWidget {
  const TransactionSection({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return CachedNetworkImage(
      imageUrl: 'https://ik.imagekit.io/9xfwtu0xm/p2p_home_v2/funds_info.png',
    );
  }
}
