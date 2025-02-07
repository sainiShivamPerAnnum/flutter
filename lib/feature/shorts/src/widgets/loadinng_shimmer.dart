import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class ShimmerReelsButtons extends StatelessWidget {
  const ShimmerReelsButtons({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Positioned(
      right: 16,
      left: 16,
      bottom: 50,
      child: Shimmer.fromColors(
        baseColor: Colors.black.withOpacity(0.2),
        highlightColor: Colors.black.withOpacity(0.4),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            _shimmerCircle(50),
            const SizedBox(height: 16),
            _shimmerCircle(50),
            const SizedBox(height: 16),
            _shimmerCircle(50),
            const SizedBox(height: 16),
            _shimmerCircle(50),
            const SizedBox(height: 16),
            _shimmerRectangle(50, 550),
          ],
        ),
      ),
    );
  }

  Widget _shimmerCircle(double size) {
    return Container(
      width: size,
      height: size,
      decoration: const BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.white,
      ),
    );
  }

  Widget _shimmerRectangle(double height, double width) {
    return Container(
      width: width,
      height: height,
      decoration: const BoxDecoration(
        shape: BoxShape.rectangle,
        color: Colors.white,
      ),
    );
  }
}
