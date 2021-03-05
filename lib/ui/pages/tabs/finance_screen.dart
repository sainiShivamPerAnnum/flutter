import 'package:felloapp/util/ui_constants.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pie_chart/pie_chart.dart';

class FinancePage extends StatelessWidget {
  final Map<String, double> dataMap = {
    "Flutter": 5,
    "React": 3,
    "Xamarin": 2,
    "Ionic": 2,
  };

  final List<Color> colorList = [
    UiConstants.primaryColor,
    UiConstants.primaryColor.withGreen(200),
    UiConstants.primaryColor.withGreen(400),
    UiConstants.primaryColor.withGreen(600),
  ];
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
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
                  Container(height: height * 0.024),
                  Container(
                    child: Row(
                      children: [
                        Expanded(
                          child: Container(
                            padding: EdgeInsets.symmetric(horizontal: 10),
                            height: MediaQuery.of(context).size.height * 0.3,
                            child: Column(
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
                                  color:
                                      UiConstants.primaryColor.withGreen(200),
                                ),
                                Legend(
                                  icon: Icons.share,
                                  title: "REFERRALS",
                                  amount: "₹ 50",
                                  color:
                                      UiConstants.primaryColor.withGreen(400),
                                ),
                                Legend(
                                  icon: Icons.satellite,
                                  title: "PRIZES",
                                  amount: "₹ 10",
                                  color:
                                      UiConstants.primaryColor.withGreen(600),
                                ),
                              ],
                            ),
                          ),
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
                    ),
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
                      FundWidget(fund: fundList[0]),
                      FundWidget(fund: fundList[1]),
                      FundWidget(fund: fundList[2]),
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
                title,
                style: GoogleFonts.montserrat(
                  fontSize: MediaQuery.of(context).size.width * 0.03,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 4.0),
                child: Text(
                  amount,
                  style: GoogleFonts.montserrat(
                    fontSize: MediaQuery.of(context).size.width * 0.025,
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
  FundWidget({this.fund});
  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    return Container(
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
    onPressed: () {},
  ),
  Fund(
    assetName: "images/manual.png",
    title: "ICICI Prudential Fund   (Manual)",
    onPressed: () {},
  ),
  Fund(
    assetName: "images/augmont.png",
    title: "Augmont Gold Fund",
    onPressed: () {},
  ),
];
