import 'package:cached_network_image/cached_network_image.dart';
import 'package:felloapp/core/service/user_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProfileImage extends StatelessWidget {
  final height;
  const ProfileImage({this.height = 0.3});

  @override
  Widget build(BuildContext context) {
    return Consumer<UserService>(
      builder: (context, model, child) => CircleAvatar(
        radius: kToolbarHeight * height,
        backgroundImage: model.myUserDpUrl == null
            ? AssetImage(
                "images/profile.png",
              )
            : CachedNetworkImageProvider(
                model.myUserDpUrl,
              ),
      ),
    );
  }
}