import 'package:felloapp/core/base_remote_config.dart';
import 'package:felloapp/util/styles/size_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';

class TambolaFaqSection extends StatefulWidget {
  @override
  _TambolaFaqSectionState createState() => _TambolaFaqSectionState();
}

class _TambolaFaqSectionState extends State<TambolaFaqSection> {
  List<bool> detStatus = [false, false, false, false];

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
      margin: EdgeInsets.all(SizeConfig.blockSizeHorizontal * 3),
      padding: EdgeInsets.only(top: 12, left: 10),
      child: Column(
        children: [
          Text(
            "FAQs",
            style: GoogleFonts.montserrat(
              color: Colors.black54,
              fontSize: 30,
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(height: 10),
          _buildPrizePodium()
        ],
      ),
    );
  }

  _buildPrizePodium() {
    List<Map<String, String>> _faqList = _buildFaqList();
    List<String> faqLeadIcons = [
      "images/svgs/howitworks.svg",
      "images/svgs/cash-distribution.svg",
      "images/svgs/redeem.svg",
      "images/svgs/winmore.svg",
    ];
    return Container(
      width: SizeConfig.screenWidth,
      child: Column(
        children: [
          ExpansionPanelList(
            animationDuration: Duration(milliseconds: 600),
            expandedHeaderPadding: EdgeInsets.all(0),
            dividerColor: Colors.grey.withOpacity(0.2),
            elevation: 0,
            children: List.generate(
              _faqList.length,
              (index) => ExpansionPanel(
                canTapOnHeader: true,
                headerBuilder: (ctx, isOpen) => _prizeFAQHeader(
                    faqLeadIcons[index], _faqList[index].keys.first),
                isExpanded: detStatus[index],
                body: Container(
                  alignment: Alignment.centerLeft,
                  margin: EdgeInsets.only(
                    left: SizeConfig.blockSizeHorizontal * 2,
                    right: SizeConfig.blockSizeHorizontal * 6,
                  ),
                  child: Text(
                    _faqList[index].values.first,
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
              print("$i th item is $isOpen");
              setState(() {
                detStatus[i] = !isOpen;
              });
              print(detStatus[i]);
            },
          ),
        ],
      ),
    );
  }

  _prizeFAQHeader(String asset, String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        children: [
          SvgPicture.asset(asset, height: 20, width: 20),
          SizedBox(
            width: 10,
          ),
          Expanded(
            child: Text(
              title,
              style: TextStyle(
                fontSize: SizeConfig.mediumTextSize,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );
  }

  List<Map<String, String>> _buildFaqList() {
    return [
      {
        'How does one participate in Tambola?':
            '- Everyday, ${BaseRemoteConfig.remoteConfig.getString(BaseRemoteConfig.TAMBOLA_DAILY_PICK_COUNT)} random numbers are picked.\n\n- The matching numbers on your tickets get automatically crossed, starting from the day they were generated.\n\n- On Sunday, your tickets are processed to see if they matched a category.'
      },
      {
        'How does one win the game?':
            '- Every Sunday, your winning tickets get processed, and the winnings for that week are shared with you in the next few days. \n\n- If there are more than 1 winners for a category, the prize amount gets equally distributed amongst all the category winners.'
      },
      {
        'How can I redeem my winnings?':
            '- If you\'re a tambola winner, your reward gets credited to your Fello wallet in a few days. \n\n- Once credited, you can choose how you would like to redeem it. It could be as digital gold or as Amazon pay balance.'
      },
      {
        'How can I maximize my winnings ?':
            'As traditional tambola goes, the more tickets you have, the better your odds of stealing a category! 💪\n'
      },
    ];
  }
}
