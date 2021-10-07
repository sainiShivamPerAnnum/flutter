import 'package:felloapp/base_util.dart';
import 'package:felloapp/ui/pages/tabs/games/tambola/tambola-home.dart';
import 'package:felloapp/util/styles/size_config.dart';
import 'package:felloapp/util/styles/ui_constants.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SummaryTicketsDisplay extends StatelessWidget {
  final TicketSummaryCardModel summary;
  const SummaryTicketsDisplay({this.summary});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: BaseUtil.getAppBar(context, summary.cardType + " tickets"),
      body: ListView(
        shrinkWrap: true,
        children: List.generate(
          summary.data.length,
          (index) {
            return Container(
              height: SizeConfig.screenWidth * 1.1,
              width: SizeConfig.screenWidth,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: SizeConfig.blockSizeHorizontal * 3,
                        vertical: SizeConfig.blockSizeHorizontal * 2),
                    child: Row(
                      children: [
                        CircleAvatar(
                          backgroundColor: UiConstants.primaryColor,
                          radius: SizeConfig.mediumTextSize,
                          child: Padding(
                            padding: EdgeInsets.all(2),
                            child: Text(
                              (index + 1).toString(),
                              style: GoogleFonts.montserrat(
                                color: Colors.white,
                                fontWeight: FontWeight.w300,
                                fontSize: SizeConfig.mediumTextSize,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            summary.data[index].title,
                            style: TextStyle(
                                fontWeight: FontWeight.w700,
                                fontSize: SizeConfig.mediumTextSize,
                                color: Colors.black54,
                                height: 1.2),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    height: SizeConfig.screenWidth * 0.95,
                    width: SizeConfig.screenWidth,
                    child: summary.data[index].boards.length == 1
                        ? Container(
                            padding:
                                EdgeInsets.only(right: SizeConfig.globalMargin),
                            width: SizeConfig.screenWidth,
                            child: Center(
                              child: summary.data[index].boards[0],
                            ),
                          )
                        : ListView.builder(
                            itemCount: summary.data[index].boards.length,
                            scrollDirection: Axis.horizontal,
                            itemBuilder: (ctx, i) =>
                                summary.data[index].boards[i],
                          ),
                  ),
                  Divider()
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
