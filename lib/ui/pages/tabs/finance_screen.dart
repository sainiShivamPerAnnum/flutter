import 'package:felloapp/ui/pages/mf_details_page.dart';
import 'package:felloapp/util/ui_constants.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pie_chart/pie_chart.dart';
import 'package:felloapp/util/size_config.dart';

class FinancePage extends StatelessWidget {
  final bool hasFund = false;
  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    return Container(
      height: height,
      decoration: BoxDecoration(
        color: Color(0xFFEFEFEF),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(50),
          bottomRight: Radius.circular(50),
        ),
      ),
      child: SafeArea(
        child: ClipRRect(
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(50),
            bottomRight: Radius.circular(50),
          ),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: height * 0.016),
            child: CustomScrollView(
              slivers: [
                SliverList(
                    delegate: SliverChildListDelegate([
                  Container(
                    height: AppBar().preferredSize.height,
                  ),
                  Container(
                    child: hasFund ? FundChartView() : ZeroBalView(),
                  ),
                  Divider(),
                  Text(
                    "Available Funds",
                    textAlign: TextAlign.center,
                    style: GoogleFonts.poppins(
                      fontWeight: FontWeight.w500,
                      fontSize: 24,
                      color: Colors.black87,
                    ),
                  ),
                ])),
                SliverGrid(
                  gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                    maxCrossAxisExtent: 275,
                    childAspectRatio: 2 / 3,
                    crossAxisSpacing: 20,
                    mainAxisSpacing: 20,
                  ),
                  delegate: SliverChildListDelegate(
                    [
                      FundWidget(
                        fund: fundList[0],
                        onPressed: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (ctx) => MFDetailsPage(),
                          ),
                        ),
                      ),
                      FundWidget(fund: fundList[1]),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class FundChartView extends StatelessWidget {
  final Map<String, double> dataMap = {
    "Funds": 5,
    "Gold": 3,
    "Referrals": 2,
    "Prizes": 2,
  };

  final List<Color> colorList = [
    UiConstants.primaryColor,
    UiConstants.primaryColor.withGreen(200),
    UiConstants.primaryColor.withGreen(400),
    UiConstants.primaryColor.withGreen(600),
  ];

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          padding: EdgeInsets.symmetric(
            horizontal: SizeConfig.blockSizeHorizontal,
          ),
          height: MediaQuery.of(context).size.height * 0.3,
          alignment: Alignment.centerRight,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Legend(
                icon: Icons.money,
                title: "FUNDS",
                amount: "₹ 200",
                color: UiConstants.primaryColor,
              ),
              Legend(
                icon: Icons.money,
                title: "GOLD",
                amount: "₹ 100",
                color: UiConstants.primaryColor.withGreen(200),
              ),
              Legend(
                icon: Icons.share,
                title: "REFERRALS",
                amount: "₹ 50",
                color: UiConstants.primaryColor.withGreen(400),
              ),
              Legend(
                icon: Icons.satellite,
                title: "PRIZES",
                amount: "₹ 10",
                color: UiConstants.primaryColor.withGreen(600),
              ),
            ],
          ),
        ),
        SizedBox(
          width: SizeConfig.blockSizeHorizontal * 10,
        ),
        Container(
          child: PieChart(
            dataMap: dataMap,
            animationDuration: Duration(milliseconds: 800),
            chartLegendSpacing: 40,
            chartRadius: MediaQuery.of(context).size.width / 2,
            colorList: colorList,
            initialAngleInDegree: 0,
            chartType: ChartType.ring,
            ringStrokeWidth: 5,
            centerText: "₹ 360",
            legendOptions: LegendOptions(
              showLegendsInRow: false,
              legendPosition: LegendPosition.left,
              showLegends: false,
              legendShape: BoxShape.circle,
              legendTextStyle: GoogleFonts.montserrat(
                fontWeight: FontWeight.bold,
              ),
            ),
            chartValuesOptions: ChartValuesOptions(
              showChartValueBackground: true,
              showChartValues: false,
              chartValueStyle: GoogleFonts.montserrat(
                fontSize: 40,
                color: Colors.black,
              ),
              showChartValuesInPercentage: false,
              showChartValuesOutside: false,
            ),
          ),
        ),
      ],
    );
  }
}

class ZeroBalView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: SizeConfig.screenHeight * 0.3,
      padding: EdgeInsets.all(SizeConfig.blockSizeHorizontal * 2),
      child: Row(
        children: [
          Expanded(
            child: Center(
              child: Image.asset(
                "images/zero-balance.png",
                fit: BoxFit.contain,
              ),
            ),
          ),
          // Expanded(
          //   flex: 4,
          //   child: Text(
          //     "Wallet Empty!!\n\nKickstart your investing journey today with Fello",
          //     style: GoogleFonts.montserrat(
          //       fontSize: SizeConfig.mediumTextSize,
          //       color: Colors.black87,
          //     ),
          //   ),
          // )
        ],
      ),
    );
  }
}

class Legend extends StatelessWidget {
  final IconData icon;
  final String title, amount;
  final Color color;

  Legend({this.amount, this.icon, this.title, this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.bottomCenter,
      padding: const EdgeInsets.only(
        top: 15,
      ),
      child: Row(
        children: [
          Icon(
            icon,
            color: color,
            size: MediaQuery.of(context).size.width * 0.04,
          ),
          SizedBox(
            width: 5,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                amount,
                style: GoogleFonts.montserrat(
                  fontSize: SizeConfig.mediumTextSize,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 4.0),
                child: Text(
                  title,
                  style: GoogleFonts.montserrat(
                    fontSize: SizeConfig.smallTextSize,
                  ),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}

class FundWidget extends StatelessWidget {
  final Fund fund;
  final Function onPressed;
  FundWidget({this.fund, this.onPressed});
  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        padding: EdgeInsets.all(
          height * 0.02,
        ),
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(fund.assetName),
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              fund.title,
              style: GoogleFonts.montserrat(
                color: Colors.white,
                fontSize: height * 0.024,
                fontWeight: FontWeight.w500,
              ),
            )
          ],
        ),
      ),
    );
  }
}

class Fund {
  final String assetName;
  final String title;
  final Function onPressed;

  Fund({this.assetName, this.onPressed, this.title});
}

List<Fund> fundList = [
  Fund(
    assetName: "images/integrated.png",
    title: "ICICI Prudential Fund (Integrated)",
  ),
  Fund(
    assetName: "images/augmont.png",
    title: "Augmont Gold Fund",
  ),
];
