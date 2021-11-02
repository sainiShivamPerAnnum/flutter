import 'package:felloapp/util/styles/size_config.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:felloapp/ui/elements/Parallax-card/data_model.dart';
import 'styles.dart';

class TravelCardRenderer extends StatelessWidget {
  final double offset;
  final double cardWidth;
  final double cardHeight;
  final Game game;

  const TravelCardRenderer(this.offset,
      {Key key, this.cardWidth, @required this.game, this.cardHeight})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(
        right: 20,
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
          Positioned(left: -25, child: _buildGameImage()),
          // City information
          _buildCityData()
        ],
      ),
    );
  }

  Widget _buildGameImage() {
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
          _buildPositionedLayer("images/${game.name}/back.png", containerWidth,
              maxParallax * .1, globalOffset),
          _buildPositionedLayer("images/${game.name}/middle.png",
              containerWidth * .9, maxParallax * .6, globalOffset),
          _buildPositionedLayer("images/${game.name}/top.png",
              containerWidth * .9, maxParallax, globalOffset),
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
          child: Text(game.title,
              style: GoogleFonts.poppins(
                  color: Color(0xff272768),
                  fontWeight: FontWeight.w700,
                  fontSize: cardWidth * 0.07),
              textAlign: TextAlign.center),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 25.0),
          child: Text(game.description,
              style: TextStyle(
                color: Color(0xff272768),
                fontSize: SizeConfig.mediumTextSize,
              ),
              textAlign: TextAlign.center),
        ),

        TextButton(
          style: ButtonStyle(),
          // disabledColor: Colors.transparent,
          // color: Colors.transparent,
          child: Text((game.title == 'Tambola') ? 'TAP TO PLAY' : 'TAP TO VOTE',
              style: Styles.cardAction),
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
