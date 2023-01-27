import 'dart:developer';
import 'package:felloapp/base_util.dart';
import 'package:felloapp/core/enums/investment_type.dart';
import 'package:felloapp/ui/elements/buttons/black_white_button/black_white_button.dart';
import 'package:felloapp/ui/pages/hometabs/save/save_components/asset_view_section.dart';
import 'package:felloapp/util/assets.dart';
import 'package:felloapp/util/styles/size_config.dart';
import 'package:felloapp/util/styles/textStyles.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';

// ignore: camel_case_types
typedef onInvestmentChange = void Function(int amount);

Map<String, String> _goldInfo = {
  "24K": "Gold",
  "99.9%": "Pure",
  "Live": "Gold Rate"
};

Map<String, String> _lbInfo = {
  "P2P": "Asset",
  "10%": "Returns",
  "Everyday": "Credits"
};

class SaveContainer extends StatelessWidget {
  const SaveContainer({
    Key? key,
    required this.investmentType,
    this.isPopular = false,
  }) : super(key: key);
  final InvestmentType investmentType;
  final bool isPopular;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: SizeConfig.padding12),
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: SizeConfig.padding24),
        height: SizeConfig.screenHeight! * 0.42,
        decoration: BoxDecoration(
          color: getCardBgColor,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [BoxShadow(color: Color.fromRGBO(0, 0, 0, 1))],
          border: isPopular
              ? Border.all(
                  color: Color(0xff93B5FE),
                )
              : null,
        ),
        child: Stack(
          children: [
            Column(
              children: [
                _Header(
                  investmentType: investmentType,
                ),
                SizedBox(
                  height: SizeConfig.padding16,
                ),
                _InvestmentDetails(
                  onChange: (amount) {
                    log(amount.toString());
                  },
                  gain: 200,
                ),
                SizedBox(
                  height: SizeConfig.padding20,
                ),
                Stack(
                  children: [
                    Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: SizeConfig.padding16),
                      child: Divider(
                        color: Color(0xff93B5FE).withOpacity(0.3),
                      ),
                    ),
                    Align(
                      alignment: Alignment.center,
                      child: ColoredBox(
                        color: getCardBgColor,
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 8),
                          child: Text(
                            "You will invest in",
                            style: TextStyles.sourceSans.body4
                                .colour(Colors.white.withOpacity(0.6)),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: SizeConfig.padding14,
                ),
                _buildInformationRow(),
                SizedBox(
                  height: SizeConfig.padding14,
                ),
                Expanded(
                  child: Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: SizeConfig.padding16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: BlackWhiteButton(
                            onPress: () {},
                            title: "Invest Now",
                          ),
                        ),
                        SizedBox(
                          width: SizeConfig.padding6,
                        ),
                        Expanded(
                          child: BlackWhiteButton.inverse(
                              onPress: () => Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder: (_) => AssetSectionView(
                                        type: investmentType,
                                      ),
                                    ),
                                  ),
                              title: "Learn More"),
                        )
                      ],
                    ),
                  ),
                ),
                Text(
                  "₹100K + invested till date",
                  style: TextStyles.sourceSans.body3
                      .colour(Colors.white.withOpacity(0.4)),
                ),
                SizedBox(
                  height: SizeConfig.padding8,
                ),
              ],
            ),
            if (isPopular)
              Align(
                alignment: Alignment.topCenter,
                child: Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: SizeConfig.padding12,
                    vertical: SizeConfig.padding2,
                  ),
                  decoration: BoxDecoration(
                      color: Color(0xff93B5FE),
                      borderRadius:
                          BorderRadius.vertical(bottom: Radius.circular(5))),
                  child: Text(
                    "POPULAR",
                    style:
                        TextStyles.sourceSansSB.body4.colour(Color(0xff39498C)),
                  ),
                ),
              )
          ],
        ),
      ),
    );
  }

  Widget _buildInformationRow() {
    final info = investmentType == InvestmentType.AUGGOLD99 ? _goldInfo : _lbInfo;

    List<Widget> children = [];

    info.forEach((key, value) {
      final child = Column(
        crossAxisAlignment: getAlignment(info.keys.toList().indexOf(key)),
        children: [
          Text(
            key,
            style: TextStyles.rajdhaniSB.body2.colour(
              Colors.white.withOpacity(0.5),
            ),
          ),
          Text(
            value,
            style: TextStyles.sourceSans.body4
                .colour(Colors.white.withOpacity(0.4)),
          )
        ],
      );

      children.add(child);
    });

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: SizeConfig.padding16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: children,
      ),
    );
  }

  CrossAxisAlignment getAlignment(int i) {
    switch (i) {
      case 0:
        return CrossAxisAlignment.start;
      case 1:
        return CrossAxisAlignment.center;
      case 2:
        return CrossAxisAlignment.end;

      default:
        return CrossAxisAlignment.center;
    }
  }

  Color get getCardBgColor {
    if (investmentType == InvestmentType.AUGGOLD99) return Color(0xff293566);

    return Color(0xff173B3F);
  }

  //TODO: Get a border color for lendbox container
  // Color get borderColor

}

class _InvestmentDetails extends StatelessWidget {
  const _InvestmentDetails(
      {Key? key, required this.onChange, required this.gain})
      : super(key: key);
  final onInvestmentChange onChange;
  final double gain;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: SizeConfig.padding16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                "Invest",
                style: TextStyles.body4.colour(
                  Colors.white.withOpacity(0.7),
                ),
              ),
              _InvestCounter(initialCount: 200, onChange: onChange),
            ],
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                "Gain",
                style: TextStyles.body4.colour(
                  Colors.white.withOpacity(0.7),
                ),
              ),
              Text("₹${gain.round()}", style: TextStyles.rajdhaniSB.title4)
            ],
          ),
        ],
      ),
    );
  }
}

class _Header extends StatelessWidget {
  const _Header({Key? key, required this.investmentType}) : super(key: key);
  final InvestmentType investmentType;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: SizeConfig.padding16),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(12),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text(
                investmentType == InvestmentType.AUGGOLD99
                    ? "Digital Gold"
                    : "Fello Flo",
                style: TextStyles.rajdhaniSB.title4,
              ),
              Text(
                investmentType == InvestmentType.AUGGOLD99
                    ? "Low risk  • Withdraw anytime  • No KYC"
                    : "Quick returns  • Withdraw anytime ",
                style: TextStyles.sourceSans.body4,
              ),
            ],
          ),
          SvgPicture.asset(
            investmentType == InvestmentType.AUGGOLD99
                ? Assets.goldAsset
                : Assets.floAsset,
          )
        ],
      ),
    );
  }

  Color get bgColor => investmentType == InvestmentType.AUGGOLD99
      ? Color(0xff495DB2)
      : Color(0xff01656B);
}

class _InvestCounter extends StatefulWidget {
  _InvestCounter({Key? key, this.initialCount, required this.onChange})
      : super(key: key);
  final int? initialCount;
  final onInvestmentChange onChange;

  @override
  State<_InvestCounter> createState() => _InvestCounterState();
}

class _InvestCounterState extends State<_InvestCounter> {
  late ValueNotifier<int> _investmentCounter;

  @override
  initState() {
    _investmentCounter = ValueNotifier(widget.initialCount ?? 200);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Row(
          children: [
            _buildIconButton(Icons.remove, _onRemove),
            ValueListenableBuilder<int>(
                valueListenable: _investmentCounter,
                builder: (context, snapshot, child) {
                  return Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: SizeConfig.padding12),
                    child: Text(
                      "₹$snapshot",
                      style: TextStyles.rajdhaniSB.title4,
                    ),
                  );
                }),
            _buildIconButton(Icons.add, _onAdd),
          ],
        ),
      ],
    );
  }

  void _onAdd() {
    _investmentCounter.value += 100;
    widget.onChange(_investmentCounter.value);
  }

  void _onRemove() {
    if (_investmentCounter.value == 100) return;
    _investmentCounter.value -= 100;
    widget.onChange(_investmentCounter.value);
  }

  Widget _buildIconButton(IconData icons, void Function() onChange) {
    return InkWell(
      onTap: () {
        HapticFeedback.lightImpact();
        onChange.call();
      },
      child: Container(
        height: SizeConfig.padding32,
        width: SizeConfig.padding32,
        decoration:
            BoxDecoration(color: Color(0Xff0C1D20), shape: BoxShape.circle),
        child: Icon(icons, color: Colors.white, size: SizeConfig.padding24),
      ),
    );
  }
}
