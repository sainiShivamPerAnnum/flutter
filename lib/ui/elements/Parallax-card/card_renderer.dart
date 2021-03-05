import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:felloapp/ui/elements/Parallax-card/data_model.dart';
import 'styles.dart';

class TravelCardRenderer extends StatelessWidget {
  final double offset;
  final double cardWidth;
  final double cardHeight;
  final City city;

  const TravelCardRenderer(this.offset,
      {Key key, this.cardWidth, @required this.city, this.cardHeight})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      margin: EdgeInsets.only(
        top: 16,
        left: 30,
      ),
      child: Stack(
        overflow: Overflow.visible,
        alignment: Alignment.center,
        children: <Widget>[
          // Card background color & decoration
          Container(
            margin: EdgeInsets.only(top: 40, left: 12, right: 12, bottom: 12),
            height: cardHeight * 0.74,
            decoration: BoxDecoration(
              color: Color(0xffE5EBF7),
              image: DecorationImage(
                image: AssetImage("images/Tambola/card.png"),
                fit: BoxFit.cover,
              ),
              borderRadius: BorderRadius.circular(8),
              boxShadow: [
                BoxShadow(color: Colors.black12, blurRadius: 4 * offset.abs()),
                BoxShadow(
                    color: Colors.black12, blurRadius: 10 + 6 * offset.abs()),
              ],
            ),
          ),
          // City image, out of card by 15px
          Positioned(top: -15, child: _buildCityImage()),
          // City information
          _buildCityData()
        ],
      ),
    );
  }

  Widget _buildCityImage() {
    double maxParallax = 30;
    double globalOffset = offset * maxParallax * 2;
    double cardPadding = 28;
    double containerWidth = cardWidth - cardPadding;
    return Container(
      height: cardHeight,
      width: cardWidth,
      alignment: Alignment.bottomCenter,
      child: Stack(
        alignment: Alignment.bottomRight,
        children: <Widget>[
          _buildPositionedLayer("images/Tambola/back.png", containerWidth,
              maxParallax * .1, globalOffset),
          _buildPositionedLayer("images/Tambola/middle.png",
              containerWidth * .9, maxParallax * .6, globalOffset),
          _buildPositionedLayer("images/Tambola/top.png", containerWidth * .9,
              maxParallax, globalOffset),
        ],
      ),
    );
  }

  Widget _buildCityData() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        // The sized box mock the space of the city image
        SizedBox(width: double.infinity, height: cardHeight * .5),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12.0),
          child: Text(city.title,
              style: GoogleFonts.montserrat(
                  color: Color(0xff272768),
                  fontWeight: FontWeight.w700,
                  fontSize: cardWidth * 0.08),
              textAlign: TextAlign.center),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 25.0),
          child: Text(city.description,
              style: GoogleFonts.montserrat(
                color: Color(0xff272768),
              ),
              textAlign: TextAlign.center),
        ),

        FlatButton(
          disabledColor: Colors.transparent,
          color: Colors.transparent,
          child: Text('Tap to Play'.toUpperCase(), style: Styles.cardAction),
          onPressed: null,
        ),
      ],
    );
  }

  Widget _buildPositionedLayer(
      String path, double width, double maxOffset, double globalOffset) {
    double cardPadding = 24;
    double layerWidth = cardWidth;
    return Positioned(
        left: ((layerWidth * .5) - (width / 2) - offset * maxOffset) +
            globalOffset,
        bottom: cardHeight * .4,
        child: Image.asset(
          path,
          width: width,
        ));
  }
}
