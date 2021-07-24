import 'package:felloapp/util/fundPalettes.dart';
import 'package:felloapp/util/size_config.dart';
import 'package:felloapp/util/ui_constants.dart';
import 'package:flutter/material.dart';

class GoldProfitCalculator extends StatefulWidget {
  @override
  _GoldProfitCalculatorState createState() => _GoldProfitCalculatorState();
}

class _GoldProfitCalculatorState extends State<GoldProfitCalculator> {
  TextEditingController inputPrice = new TextEditingController();
  int months = 1;
  double price = 1000;
  double outputprice = 1014;
  List<double> chipAmountList = [100, 500, 1000, 5000];

  Widget amoutChip(double amt) {
    return GestureDetector(
      onTap: () {
        setState(() {
          price += amt;
          inputPrice.text = price.toString();
        });
      },
      child: Chip(
        backgroundColor: UiConstants.chipColor,
        label: Text("+${amt.toInt()}"),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    outputprice = price + price * (0.17 / 12) * months;
    return Container(
      margin: EdgeInsets.symmetric(
        horizontal: SizeConfig.blockSizeHorizontal * 5,
      ),
      width: double.infinity,
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: <BoxShadow>[
          BoxShadow(
            offset: Offset(5, 5),
            blurRadius: 5,
            color: Colors.black.withOpacity(0.1),
            spreadRadius: 0,
          ),
        ],
      ),
      child: Column(
        children: [
          Text(
            "PROFIT CALCULATOR",
            style: TextStyle(
              fontWeight: FontWeight.w700,
              fontSize: 24,
            ),
          ),
          SizedBox(
            height: 16,
          ),
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Investment Amount"),
                    CalculatorCapsule(
                      gradColors: [
                        augmontGoldPalette.secondaryColor.withBlue(800),
                        augmontGoldPalette.secondaryColor
                      ],
                      child: TextField(
                        controller: inputPrice,
                        cursorColor: Colors.black,
                        keyboardType: TextInputType.number,
                        decoration: new InputDecoration(
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.only(
                              left: 15, bottom: 11, top: 11, right: 15),
                          hintText: price.toString(),
                          enabledBorder:
                              OutlineInputBorder(borderSide: BorderSide.none),
                          focusedBorder:
                              OutlineInputBorder(borderSide: BorderSide.none),
                        ),
                        onChanged: (value) {
                          setState(() {
                            price = double.parse(value);
                          });
                        },
                      ),
                    )
                  ],
                ),
              ),
              SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Return Amount"),
                    CalculatorCapsule(
                      gradColors: [
                        // Colors.blueGrey[600],
                        // Colors.blueGrey,
                        augmontGoldPalette.primaryColor,
                        augmontGoldPalette.primaryColor2
                      ],
                      child: Padding(
                        padding: const EdgeInsets.only(left: 16.0),
                        child: Text(
                          outputprice.truncateToDouble().toString(),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
          SizedBox(
            height: 16,
          ),
          Wrap(
            spacing: 20,
            children: [
              amoutChip(chipAmountList[0]),
              amoutChip(chipAmountList[1]),
              amoutChip(chipAmountList[2]),
              amoutChip(chipAmountList[3]),
            ],
          ),
          SizedBox(
            height: 16,
          ),
          Text("Select No of Months: $months"),
          Slider(
            value: months.toDouble(),
            onChanged: (val) {
              setState(() {
                months = val.toInt();
              });
            },
            label: months.toString(),
            max: 36,
            min: 0,
            divisions: 18,
            activeColor:
                augmontGoldPalette.primaryColor, // UiConstants.primaryColor,
            inactiveColor:
                augmontGoldPalette.primaryColor2, //  UiConstants.primaryColor,
          ),
          Text(
            '*Projected returns based on past 3 year performance',
            style: TextStyle(
                color: Colors.blueGrey[600],
                fontSize: SizeConfig.smallTextSize * 1.2),
          )
        ],
      ),
    );
  }
}

// class AmountChip extends StatefulWidget {
//   @override
//   _AmountChipState createState() => _AmountChipState();
// }

// class _AmountChipState extends State<AmountChip> {
//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//                 onTap: () {
//                   setState(() {
//                     price += 100;
//                     inputPrice.text = price.toString();
//                   });
//                 },
//                 child: Chip(
//                   backgroundColor: UiConstants.chipColor,
//                   label: Text("+100"),
//                 ),
//               );
//   }
// }

class CalculatorCapsule extends StatelessWidget {
  final List<Color> gradColors;
  final Widget child;

  CalculatorCapsule({
    @required this.gradColors,
    @required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 10),
      height: 50,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(100),
        color: Colors.white,
        boxShadow: <BoxShadow>[
          BoxShadow(
            offset: Offset(3, 3),
            blurRadius: 5,
            color: Colors.black.withOpacity(0.1),
            spreadRadius: 0,
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            height: 50,
            width: 50,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(100),
                bottomLeft: Radius.circular(100),
              ),
              gradient: new LinearGradient(
                colors: gradColors,
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
              ),
            ),
            child: Center(
              child: Text(
                "₹",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 30,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
          Expanded(
            child: child,
          ),
        ],
      ),
    );
  }
}
