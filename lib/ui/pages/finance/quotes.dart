// ignore_for_file: unnecessary_lambdas

import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:felloapp/core/model/quote_model.dart' as q_model;
import 'package:felloapp/util/styles/styles.dart';
import 'package:flutter/material.dart';

class QuotesComponent extends StatefulWidget {
  final q_model.QuotesType quotesType;

  const QuotesComponent({
    required this.quotesType,
    super.key,
  });

  @override
  State<QuotesComponent> createState() => _QuotesComponentState();
}

class _QuotesComponentState extends State<QuotesComponent>
    with SingleTickerProviderStateMixin {
  late final List<q_model.QuoteModel> quotes;

  double opacity = 1.0;
  int currentIndex = 0;
  late Timer _timer;
  late final AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    quotes = q_model.QuoteModel.getQuotesFromAssetType(widget.quotesType);
    _timer = Timer.periodic(const Duration(seconds: 12), (timer) {
      _animationController.reset();
      _animationController.forward();

      if (quotes.length - 1 == currentIndex) {
        currentIndex = 0;
      } else {
        currentIndex++;
      }
    });

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    );

    _animationController.value = 1;
  }

  @override
  void dispose() {
    _timer.cancel();
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (quotes.isEmpty) {
      return const SizedBox.shrink();
    }

    return AnimatedBuilder(
      animation: _animationController,
      builder: (context, child) => Opacity(
        opacity: _animationController.value,
        child: QuoteCard(
          quote: quotes[currentIndex],
        ),
      ),
    );
  }
}

class QuoteCard extends StatelessWidget {
  final q_model.QuoteModel quote;
  const QuoteCard({
    required this.quote,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(
        SizeConfig.padding32,
      ),
      padding: EdgeInsets.all(
        SizeConfig.padding16,
      ),
      decoration: BoxDecoration(
        color: const Color(0xffD9D9D9).withOpacity(.04),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            backgroundColor: Colors.white.withOpacity(.10),
            radius: 22,
            child: Padding(
              padding: const EdgeInsets.all(8),
              child: CachedNetworkImage(
                imageUrl: quote.icon,
              ),
            ),
          ),
          SizedBox(
            height: SizeConfig.padding12,
          ),
          Row(
            children: [
              Expanded(
                child: Text(
                  quote.quote,
                  style: TextStyles.sourceSans.body3.copyWith(),
                ),
              )
            ],
          )
        ],
      ),
    );
  }
}
