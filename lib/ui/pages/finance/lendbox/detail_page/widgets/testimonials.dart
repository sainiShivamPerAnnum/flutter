// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:felloapp/core/enums/investment_type.dart';
import 'package:felloapp/util/styles/size_config.dart';
import 'package:felloapp/util/styles/textStyles.dart';
import 'package:felloapp/util/styles/ui_constants.dart';
import 'package:flutter/material.dart';

class Testimonials extends StatelessWidget {
  const Testimonials({
    super.key,
    this.type = InvestmentType.LENDBOXP2P,
  });

  final InvestmentType? type;

  static const _testimonials = <String, List<String>>{
    "Akash mahesh": [
      "Fello has completely changed the way I save money. I now earn interest on saving money and save more to play tambola and win rewards. The app has truly motimvated me to save more. Highly recommend it to everyone",
      'https://d37gtxigg82zaw.cloudfront.net/testimonials/1.jpg'
    ],
    "Vinay Kumar": [
      "I wanted to build a habit of saving money and Fello made it possible. It is a win win situation where I save and invest money and then play Tambola and get chance for getting more rewards",
      'https://d37gtxigg82zaw.cloudfront.net/testimonials/2.jpg',
    ],
    "Rohit": [
      "Fello has taken monotony out of saving money. It is very easy to use. The addition of Tambola to a savings app is a very good idea as it makes saving money rewarding and fun. I have personally won rewards when playing Tambola",
      'https://d37gtxigg82zaw.cloudfront.net/testimonials/3.jpg',
    ]
  };

  @override
  Widget build(BuildContext context) {
    List<String> shuffledKeys = _testimonials.keys.toList()..shuffle();

    return SizedBox(
      height: SizeConfig.padding160,
      child: ListView.builder(
        itemCount: _testimonials.length,
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, index) {
          String name = shuffledKeys[index];
          String? testimonial = _testimonials[name]![0];
          String image = _testimonials[name]![1];

          return Container(
            width: SizeConfig.padding300,
            margin: EdgeInsets.only(left: SizeConfig.pageHorizontalMargins),
            height: SizeConfig.padding160,
            decoration: BoxDecoration(
              border: Border.all(
                color: UiConstants.kGoldProBorder,
                width: type == InvestmentType.AUGGOLD99 ? 1 : 0,
              ),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                Expanded(
                  flex: 2,
                  child: ClipRRect(
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(8),
                      bottomLeft: Radius.circular(8),
                    ),
                    clipBehavior: Clip.hardEdge,
                    child: Image.network(
                      image,
                      fit: BoxFit.fitHeight,
                      height: SizeConfig.padding160,
                    ),
                  ),
                ),
                Expanded(
                  flex: 3,
                  child: Stack(
                    children: [
                      Container(
                        decoration: const BoxDecoration(
                          borderRadius: BorderRadius.only(
                            topRight: Radius.circular(8),
                            bottomRight: Radius.circular(8),
                          ),
                        ),
                        child: ClipRRect(
                          borderRadius: const BorderRadius.only(
                            topRight: Radius.circular(8),
                            bottomRight: Radius.circular(8),
                          ),
                          clipBehavior: Clip.hardEdge,
                          child: Image.asset(
                            'assets/svg/comma.png',
                            fit: BoxFit.fitHeight,
                            height: SizeConfig.padding160,
                          ),
                        ),
                      ),
                      if (type == InvestmentType.AUGGOLD99)
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: const BorderRadius.only(
                              topRight: Radius.circular(8),
                              bottomRight: Radius.circular(8),
                            ),
                            color: UiConstants.kGoldProBorder.withOpacity(0.2),
                          ),
                          child: ClipRRect(
                            borderRadius: const BorderRadius.only(
                              topRight: Radius.circular(8),
                              bottomRight: Radius.circular(8),
                            ),
                            clipBehavior: Clip.hardEdge,
                            child: SizedBox(
                              width: SizeConfig.screenWidth,
                              height: SizeConfig.screenWidth,
                            ),
                          ),
                        ),
                      Positioned(
                        left: 15,
                        top: 10,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              name,
                              style: TextStyles.sourceSansSB.body3
                                  .colour(Colors.white),
                            ),
                            SizedBox(height: SizeConfig.padding8),
                            Padding(
                              padding:
                                  EdgeInsets.only(right: SizeConfig.padding12),
                              child: SizedBox(
                                width: SizeConfig.padding152,
                                child: Text(
                                  testimonial,
                                  style: TextStyles.sourceSans.body4
                                      .colour(Colors.white),
                                  maxLines: 5,
                                  overflow: TextOverflow.ellipsis,
                                  textAlign: TextAlign.left,
                                ),
                              ),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                )
              ],
            ),
          );
        },
      ),
    );
  }
}
