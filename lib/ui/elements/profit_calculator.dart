import 'package:felloapp/util/styles/size_config.dart';
import 'package:felloapp/util/styles/ui_constants.dart';
import 'package:flutter/material.dart';

class ProfitCalculator extends StatefulWidget {
  final List<Color> invGradient, retGradient;
  final double calFactor;

  const ProfitCalculator({
    @required this.calFactor,
    @required this.invGradient,
    @required this.retGradient,
  });
  @override
  _ProfitCalculatorState createState() => _ProfitCalculatorState();
}

class _ProfitCalculatorState extends State<ProfitCalculator> {
  TextEditingController inputPrice = new TextEditingController();
  int months = 12;
  double price = 1000;
  double outputprice = 1007;
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
        label: Text(
          "+${amt.toInt()}",
          style: TextStyle(
            fontSize: SizeConfig.mediumTextSize * 0.9,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    outputprice = price + price * widget.calFactor * months;
    return Container(
      margin: EdgeInsets.symmetric(
        horizontal: SizeConfig.globalMargin,
      ),
      width: double.infinity,
      padding: const EdgeInsets.all(16),
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
              fontSize: SizeConfig.largeTextSize,
            ),
          ),
          const SizedBox(
            height: 16,
          ),
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Investment Amount",
                      style: TextStyle(
                        fontSize: SizeConfig.mediumTextSize,
                      ),
                    ),
                    CalculatorCapsule(
                      gradColors: widget.invGradient,
                      child: TextField(
                        controller: inputPrice,
                        cursorColor: Colors.black,
                        keyboardType: TextInputType.number,
                        decoration: new InputDecoration(
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.only(
                              left: 15, bottom: 11, top: 11, right: 15),
                          hintText: price.toString(),
                          hintStyle: TextStyle(
                            fontSize: SizeConfig.mediumTextSize * 1.2,
                          ),
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
                    Text(
                      "Return Amount",
                      style: TextStyle(
                        fontSize: SizeConfig.mediumTextSize,
                      ),
                    ),
                    CalculatorCapsule(
                      gradColors: widget.retGradient,
                      child: Padding(
                        padding: const EdgeInsets.only(left: 16.0),
                        child: Text(
                          outputprice.truncateToDouble().toString(),
                          style: TextStyle(
                              fontSize: SizeConfig.mediumTextSize * 1.2,
                              fontWeight: FontWeight.bold),
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
          Text(
            "Select No of Months: $months",
            style: TextStyle(
              fontSize: SizeConfig.mediumTextSize,
            ),
          ),
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
            activeColor: widget.retGradient[0],
            inactiveColor: widget.retGradient[1],
          ),
          Text(
            '*Projected returns based on past 6 month performance',
            style: TextStyle(
                color: widget.invGradient[1],
                fontSize: SizeConfig.smallTextSize * 1.2),
          )
        ],
      ),
    );
  }
}

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
