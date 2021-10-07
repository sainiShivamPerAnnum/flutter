import 'package:felloapp/util/styles/size_config.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class FAQCard extends StatefulWidget {
  final List<String> faqHeaders;
  final List<String> faqResponses;
  final Color borderColor;

  FAQCard(this.faqHeaders, this.faqResponses, this.borderColor);
  @override
  State<StatefulWidget> createState() => FAQCardState();
}

class FAQCardState extends State<FAQCard> {
  List<bool> detStatus;

  @override
  void initState() {
    detStatus = List.filled(widget.faqHeaders.length, false);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: SizeConfig.screenWidth,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          color: Colors.white,
          boxShadow: [
            BoxShadow(
                color: Colors.grey.withOpacity(0.2),
                offset: Offset(5, 5),
                spreadRadius: 5,
                blurRadius: 5)
          ]),
      margin: EdgeInsets.all(SizeConfig.globalMargin),
      padding: EdgeInsets.only(top: 12, left: 10),
      child: Column(
        children: [
          Text(
            "FAQs",
            style: GoogleFonts.montserrat(
              color: Colors.black,
              fontSize: SizeConfig.largeTextSize,
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(height: 10),
          _buildItems()
        ],
      ),
    );
  }

  _buildItems() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: Container(
        width: SizeConfig.screenWidth,
        child: Column(
          children: [
            ExpansionPanelList(
              animationDuration: Duration(milliseconds: 600),
              expandedHeaderPadding: EdgeInsets.all(0),
              dividerColor: Colors.grey.withOpacity(0.2),
              elevation: 0,
              children: List.generate(
                widget.faqHeaders.length,
                (index) => ExpansionPanel(
                  canTapOnHeader: true,
                  headerBuilder: (ctx, isOpen) =>
                      _prizeFAQHeader(widget.faqHeaders[index]),
                  isExpanded: detStatus[index],
                  body: Container(
                    alignment: Alignment.centerLeft,
                    margin: EdgeInsets.symmetric(
                      horizontal: SizeConfig.blockSizeHorizontal * 6,
                    ),
                    child: Text(
                      widget.faqResponses[index],
                      textAlign: TextAlign.start,
                      style: TextStyle(
                        height: 1.5,
                        fontSize: SizeConfig.mediumTextSize,
                      ),
                    ),
                  ),
                ),
              ),
              expansionCallback: (i, isOpen) {
                setState(() {
                  detStatus[i] = !isOpen;
                });
              },
            ),
          ],
        ),
      ),
    );
  }

  _prizeFAQHeader(String title) {
    return Padding(
      padding: EdgeInsets.only(
          top: 10, bottom: 10, left: SizeConfig.blockSizeHorizontal * 5),
      child: Text(
        title,
        style: TextStyle(
          fontSize: SizeConfig.mediumTextSize,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}
