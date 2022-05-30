import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class RankWidget extends StatelessWidget {
  const RankWidget({
    Key key,
    this.firstPriceMoney,
    this.secondPriceMoney,
    this.thirdPriceMoney,
    this.firstPricePoint,
    this.secondPricePoint,
    this.thirdPricePoint,
  }) : super(key: key);

  final int firstPriceMoney, secondPriceMoney, thirdPriceMoney;
  final int firstPricePoint, secondPricePoint, thirdPricePoint;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(
          height: 80,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            _buildRankPiller(
              rank: 3,
              image: 'rank_third.svg',
              priceMoney: thirdPriceMoney,
              pricePoint: thirdPricePoint,
              color: const Color(0xFF34C3A7),
              context: context,
            ),
            _buildRankPiller(
              rank: 1,
              image: 'rank_first.svg',
              priceMoney: firstPriceMoney,
              pricePoint: firstPricePoint,
              color: const Color(0xFFF2B826),
              context: context,
            ),
            _buildRankPiller(
              rank: 2,
              image: 'rank_second.svg',
              priceMoney: secondPriceMoney,
              pricePoint: secondPricePoint,
              color: const Color(0xFF5371EE),
              context: context,
            ),
          ],
        ),
      ],
    );
  }

  _buildRankPiller({
    int rank,
    String image,
    int priceMoney,
    int pricePoint,
    Color color,
    BuildContext context,
  }) {
    return SizedBox(
      height: 200.0 - ((rank - 1.0) * 20.0),
      child: Stack(
        children: [
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 5),
              padding: const EdgeInsets.symmetric(vertical: 10),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
                color: color.withOpacity(0.1),
              ),
              height: 180.0 - ((rank - 1.0) * 20.0),
              width: 90,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const SizedBox(
                    height: 30,
                  ),
                  Text(
                    "$rank${rank == 1 ? 'st' : rank == 2 ? 'nd' : 'rd'}",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        'Rs $priceMoney',
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 3),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SvgPicture.asset('assets/temp/Tokens.svg'),
                          const SizedBox(
                            width: 5,
                          ),
                          Text(
                            '$pricePoint',
                            style: const TextStyle(
                              fontSize: 12,
                              color: Color(0xFFB3B3B3),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            left: rank == 1 ? 20 : 25,
            child: SvgPicture.asset(
              'assets/temp/$image',
              width: rank == 1 ? 60 : 50,
            ),
          ),
        ],
      ),
    );
  }
}
