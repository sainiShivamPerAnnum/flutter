import 'package:carousel_slider/carousel_slider.dart';
import 'package:felloapp/core/model/sdui/sdui_parsers/carousel/carousel_widget.dart';
import 'package:felloapp/util/stac/lib/src/framework/stac.dart';
import 'package:felloapp/util/stac_framework/lib/src/stac_parser.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CarouselWidgetParser extends StacParser<CarouselWidget> {
  const CarouselWidgetParser();

  @override
  CarouselWidget getModel(Map<String, dynamic> json) =>
      CarouselWidget.fromJson(json);

  @override
  String get type => 'carousel';

  @override
  Widget parse(BuildContext context, CarouselWidget model) {
    return _CustomCarouselBuilder(
      model: model,
    );
  }
}

class _CustomCarouselBuilder extends StatefulWidget {
  const _CustomCarouselBuilder({
    required this.model,
  });

  final CarouselWidget model;

  @override
  State<_CustomCarouselBuilder> createState() => _CustomCarouselBuilderState();
}

class _CustomCarouselBuilderState extends State<_CustomCarouselBuilder> {
  @override
  Widget build(BuildContext context) {
    return CarouselSlider(
      items: widget.model.items
          .map((item) => Stac.fromJson(item, context)!)
          .toList(),
      options: CarouselOptions(
        height: 0.21.sh,
        aspectRatio: widget.model.aspectRatio,
        viewportFraction: widget.model.viewportFraction,
        initialPage: widget.model.initialPage,
        enableInfiniteScroll: widget.model.enableInfiniteScroll,
        reverse: widget.model.reverse,
        autoPlay: widget.model.autoPlay,
        autoPlayInterval:
            Duration(seconds: widget.model.autoPlayIntervalSeconds),
        autoPlayAnimationDuration:
            Duration(milliseconds: widget.model.autoPlayAnimationMills),
        autoPlayCurve: Curves.fastOutSlowIn,
        enlargeCenterPage: widget.model.enlargeCenterPage,
        enlargeFactor: widget.model.enlargeFactor,
        scrollDirection: Axis.horizontal,
      ),
    );
  }
}
