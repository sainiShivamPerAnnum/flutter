import 'package:felloapp/base_util.dart';
import 'package:felloapp/ui/pages/gold_details_page.dart';
import 'package:felloapp/ui/pages/mf_details_page.dart';
import 'package:felloapp/util/ui_constants.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pie_chart/pie_chart.dart';
import 'package:felloapp/util/size_config.dart';
import 'package:provider/provider.dart';

class FinancePage extends StatefulWidget {
  @override
  _FinancePageState createState() => _FinancePageState();
}

class _FinancePageState extends State<FinancePage> {
  final bool hasFund = true;
  BaseUtil baseProvider;
  Map<String, double> chartData;
  Map<String, double> getChartMap() {
    return {
      "ICICI Balance": baseProvider.myUser.icici_balance,
      "Augmont Balance": baseProvider.myUser.augmont_balance.toDouble(),
      "Prize Balance": baseProvider.myUser.prize_balance.toDouble(),
    };
  }

  @override
  Widget build(BuildContext context) {
    baseProvider = Provider.of<BaseUtil>(context, listen: false);
    print(baseProvider.myUser.account_balance);
    chartData = getChartMap();
    return Container(
      height: SizeConfig.screenHeight,
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
            padding: EdgeInsets.symmetric(
                horizontal: SizeConfig.screenHeight * 0.016),
            child: CustomScrollView(
              slivers: [
                SliverList(
                    delegate: SliverChildListDelegate([
                  Container(
                    height: AppBar().preferredSize.height,
                  ),
                  Container(
                    child: baseProvider.myUser.account_balance > 0
                        ? FundChartView(
                            dataMap: chartData,
                            totalBal:
                                baseProvider.myUser.account_balance.toDouble(),
                          )
                        : ZeroBalView(),
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
                      FundWidget(fund: fundList[1],
                        onPressed: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (ctx) => GoldDetailsPage(),
                          ),
                        ),
                      ),
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
  final Map<String, double> dataMap;
  final double totalBal;

  FundChartView({this.dataMap, this.totalBal});

  final List<Color> colorList = [
    UiConstants.primaryColor.withGreen(200),
    UiConstants.primaryColor.withGreen(400),
    UiConstants.primaryColor.withGreen(600),
  ];

  @override
  Widget build(BuildContext context) {
    List<String> title = dataMap.keys.toList();
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
                title: title[0],
                amount: "₹ ${dataMap[title[0]]}",
                color: UiConstants.primaryColor,
              ),
              Legend(
                icon: Icons.money,
                title: title[1],
                amount: "₹ ${dataMap[title[1]]}",
                color: UiConstants.primaryColor.withGreen(200),
              ),
              Legend(
                icon: Icons.share,
                title: title[2],
                amount: "₹ ${dataMap[title[2]]}",
                color: UiConstants.primaryColor.withGreen(400),
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
            centerText: "₹ $totalBal",
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
      child: Column(
        children: [
          Expanded(
            child: Center(
              child: Image.asset(
                "images/zero-balance.png",
                fit: BoxFit.contain,
              ),
            ),
          ),

          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Text(
              "Your savings and prizes will show up here!",
              style: GoogleFonts.montserrat(
                fontWeight: FontWeight.w500,
                fontSize: SizeConfig.mediumTextSize,
              ),
            ),
          ),
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
    title: "ICICI Prudential Fund ",
  ),
  Fund(
    assetName: "images/augmont.png",
    title: "Augmont Gold Fund",
  ),
];
