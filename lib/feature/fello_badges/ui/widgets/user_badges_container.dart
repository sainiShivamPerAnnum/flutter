import 'package:felloapp/ui/service_elements/user_service/profile_image.dart';
import 'package:felloapp/util/styles/styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class UserBadgeContainer extends StatelessWidget {
  const UserBadgeContainer({super.key, this.badgeUrl, this.badgeColor});

  final String? badgeUrl;
  final Color? badgeColor;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: SizeConfig.padding132,
      height: SizeConfig.padding132,
      child: Stack(
        children: [
          Positioned(
            left: 0.95,
            top: 0,
            child: SizedBox(
              width: 112.05,
              height: 113,
              child: Stack(
                children: [
                  Positioned(
                    left: 19.90,
                    top: 20.07,
                    child: SizedBox(
                      width: 72.24,
                      height: 72.86,
                      child: Stack(
                        children: [
                          Positioned(
                            left: 0,
                            top: 0,
                            child: Container(
                              width: 72.24,
                              height: 72.85,
                              decoration: const ShapeDecoration(
                                color: Color(0xFFCEC4FF),
                                shape: OvalBorder(),
                              ),
                            ),
                          ),

                          /// user profile
                          Positioned(
                            left: 0,
                            top: 0,
                            child: SizedBox(
                              width: 72.24,
                              height: 72.85,
                              child: Stack(
                                children: [
                                  Positioned(
                                    left: 0,
                                    top: 0,
                                    child: SizedBox(
                                      width: 72.24,
                                      height: 72.85,
                                      child: ProfileImageSE(
                                        radius: SizeConfig.avatarRadius * 0.7,
                                        reactive: false,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  /// outer border
                  Positioned(
                    left: 16.22,
                    top: 16.36,
                    child: Container(
                      width: 78.99,
                      height: 79.66,
                      decoration: ShapeDecoration(
                        shape: OvalBorder(
                          side: BorderSide(
                              width: 3,
                              color: badgeColor ?? const Color(0xFFA7A7A8)),
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    left: 16.22,
                    top: 16.36,
                    child: Container(
                      width: 78.88,
                      height: 79.55,
                      decoration: ShapeDecoration(
                        shape: OvalBorder(
                          side: BorderSide(
                            width: 0.50,
                            strokeAlign: BorderSide.strokeAlignOutside,
                            color: Colors.white.withOpacity(0.5),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    left: 8.52,
                    top: 8.59,
                    child: Container(
                      width: 95.01,
                      height: 95.82,
                      decoration: ShapeDecoration(
                        shape: OvalBorder(
                          side: BorderSide(
                              width: 1.3, color: Colors.white.withOpacity(0.3)),
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    left: 0,
                    top: 0,
                    child: Container(
                      width: 112.05,
                      height: 113,
                      decoration: ShapeDecoration(
                        shape: OvalBorder(
                          side: BorderSide(
                              width: 0.8,
                              color: const Color(0xFF727272).withOpacity(0.5)),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            left: 12.11,
            top: 35.68,
            child: Container(
              width: 3,
              height: 3,
              decoration: const ShapeDecoration(
                color: Color(0xFFD9D9D9),
                shape: OvalBorder(),
              ),
            ),
          ),
          Positioned(
            left: 102.89,
            top: 54.38,
            child: Container(
              width: 5,
              height: 5,
              decoration: ShapeDecoration(
                color: const Color(0xFFD9D9D9).withOpacity(0.3),
                shape: const OvalBorder(),
              ),
            ),
          ),
          Positioned(
            left: 0,
            top: 64.57,
            child: Container(
              width: 3,
              height: 3,
              decoration: ShapeDecoration(
                color: const Color(0xFFD9D9D9).withOpacity(0.3),
                shape: const OvalBorder(),
              ),
            ),
          ),
          Positioned(
            left: 76.35,
            top: 97.71,
            child: Container(
              width: 3,
              height: 3,
              decoration: ShapeDecoration(
                color: const Color(0xFFD9D9D9).withOpacity(0.3),
                shape: const OvalBorder(),
              ),
            ),
          ),
          Positioned(
            left: 92.15,
            top: 12.53,
            child: Container(
              width: 2,
              height: 2,
              decoration: ShapeDecoration(
                color: const Color(0xFFD9D9D9).withOpacity(0.75),
                shape: const OvalBorder(),
              ),
            ),
          ),
          if (badgeUrl != null && badgeUrl!.isNotEmpty)
            Positioned(
              right: 22,
              bottom: 18,
              child: SvgPicture.network(
                badgeUrl ?? "",
                height: SizeConfig.padding34,
                width: SizeConfig.padding40,
                fit: BoxFit.fill,
              ),
            )
        ],
      ),
    );
  }
}
