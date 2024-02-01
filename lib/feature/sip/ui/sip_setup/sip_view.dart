import 'package:felloapp/feature/sip/cubit/autosave_cubit.dart';
import 'package:felloapp/feature/sip/shared/tab_slider.dart';
import 'package:felloapp/ui/pages/static/app_widget.dart';
import 'package:felloapp/util/assets.dart';
import 'package:felloapp/util/localization/generated/l10n.dart';
import 'package:felloapp/util/locator.dart';
import 'package:felloapp/util/styles/styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SipPage extends StatelessWidget {
  const SipPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AutosaveCubit(),
      child: const SipView(),
    );
  }
}

class SipView extends StatefulWidget {
  const SipView({super.key});

  @override
  State<SipView> createState() => _SipViewState();
}

class _SipViewState extends State<SipView> {
  final _amount = ValueNotifier<double>(7500);
  static const _upperLimit = 10000.0;
  static const _lowerLimit = _upperLimit / _division;
  static const _division = 4;

  @override
  void dispose() {
    super.dispose();
    _amount.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: BaseScaffold(
        showBackgroundGrid: false,
        backgroundColor: UiConstants.bg,
        appBar: AppBar(
          leading: IconButton(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(
              Icons.chevron_left,
              size: 32,
            ),
          ),
          backgroundColor: UiConstants.bg,
          title: const Text('SIP with Fello'),
          titleTextStyle: TextStyles.rajdhaniSB.title4.setHeight(1.3),
          centerTitle: true,
          elevation: .5,
        ),
        body: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: SizeConfig.padding24,
          ),
          child: Column(
            children: [
              SizedBox(
                height: SizeConfig.padding34,
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: SizeConfig.padding28),
                child: TabSlider<String>(
                  tabs: const ['DAILY', 'WEEKLY', 'MONTHLY'],
                  labelBuilder: (label) => label,
                  onTap: (_, i) {},
                ),
              ),
              SizedBox(
                height: SizeConfig.padding28,
              ),
              Text(
                'Select SIP amount',
                style: TextStyles.rajdhaniSB.body1.copyWith(height: 1.2),
              ),
              SizedBox(
                height: SizeConfig.padding16,
              ),
              ValueListenableBuilder(
                valueListenable: _amount,
                builder: (context, value, child) => Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AmountInputWidget(
                      division: _division,
                      upperLimit: _upperLimit,
                      amount: _amount.value,
                      lowerLimit: _lowerLimit,
                      onChange: (v) => _amount.value = v,
                    ),
                    SizedBox(
                      height: SizeConfig.padding32,
                    ),
                    AmountSlider(
                      division: _division,
                      amount: _amount.value,
                      upperLimit: _upperLimit,
                      lowerLimit: _lowerLimit,
                      onChanged: (v) => _amount.value = v,
                    ),
                  ],
                ),
              ),
              const Spacer(),
              Container(
                padding: EdgeInsets.all(SizeConfig.padding16),
                decoration: BoxDecoration(
                  color: UiConstants.grey5,
                  borderRadius: BorderRadius.circular(SizeConfig.roundness12),
                ),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Expected Returns in 5Y',
                          style: TextStyles.sourceSans.body2,
                        ),
                        Text(
                          '₹10,500',
                          style: TextStyles.sourceSansB.body1,
                        ),
                      ],
                    ),
                    SizedBox(
                      height: SizeConfig.padding3,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'with Fello SIP',
                          style: TextStyles.sourceSans.body4
                              .copyWith(color: UiConstants.grey1),
                        ),
                        Text(
                          'with extra 12% returns',
                          style: TextStyles.sourceSans.body4
                              .copyWith(color: UiConstants.grey1),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: SizeConfig.padding16,
              ),
            ],
          ),
        ),
        bottomNavigationBar: const _Footer(),
      ),
    );
  }
}

class _Footer extends StatelessWidget {
  const _Footer();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: SizeConfig.padding24,
        vertical: SizeConfig.padding20,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(SizeConfig.roundness12),
        ),
        color: UiConstants.grey5,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              const AppImage(
                Assets.bulb,
                height: 45,
                width: 45,
              ),
              SizedBox(
                width: SizeConfig.padding18,
              ),
              Expanded(
                child: Text(
                  'You will receive a mandate for ₹5000 on the selected UPI App. But don’t worry, We will not deduct anymore than ₹1100/week.',
                  style: TextStyles.sourceSans.body3.copyWith(
                    color: UiConstants.textGray50,
                  ),
                ),
              )
            ],
          ),
          SizedBox(
            height: SizeConfig.padding14,
          ),
          SecondaryButton(
            label: '2 CLICKS AWAY',
            onPressed: () {},
          )
        ],
      ),
    );
  }
}

class SipAmountChip extends StatelessWidget {
  final bool isBest;
  final bool isSelected;
  final String label;

  const SipAmountChip({
    required this.label,
    super.key,
    this.isBest = false,
    this.isSelected = false,
  });

  @override
  Widget build(BuildContext context) {
    const nippleHeight = 14.0;
    final locale = locator<S>();
    final borderColor =
        isSelected ? UiConstants.yellow3 : UiConstants.kSnackBarBgColor;
    final textColor = isSelected ? UiConstants.yellow3 : Colors.white;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        if (isBest)
          Container(
            decoration: BoxDecoration(
              color: UiConstants.yellow3,
              borderRadius: BorderRadius.vertical(
                top: Radius.circular(SizeConfig.roundness2),
              ),
            ),
            padding: EdgeInsets.symmetric(
              horizontal: SizeConfig.padding8,
            ),
            child: Text(
              locale.best,
              style: TextStyles.sourceSansB.copyWith(
                fontSize: 10,
                height: 1.4,
                color: UiConstants.grey3,
              ),
            ),
          ),
        SizedBox(
          width: SizeConfig.padding60,
          child: CustomPaint(
            painter: BorderPainter(
              nippleHeight: nippleHeight,
              borderColor: borderColor,
            ),
            child: Padding(
              padding: const EdgeInsets.only(bottom: nippleHeight),
              child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: SizeConfig.padding10,
                  vertical: SizeConfig.padding8,
                ),
                child: FittedBox(
                  child: Text(
                    label,
                    style: TextStyles.sourceSans.body3.colour(
                      textColor,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class BorderPainter extends CustomPainter {
  const BorderPainter({
    this.cornerRadius = 6.0,
    this.nippleHeight = 5.0,
    this.nippleBaseWidth = 20.0,
    this.nippleRadius = 2.5,
    this.nippleEdgeRadius = 2,
    this.borderColor = UiConstants.yellow3,
  });

  final double cornerRadius;
  final double nippleHeight;
  final double nippleBaseWidth;
  final double nippleRadius;
  final double nippleEdgeRadius;
  final Color borderColor;

  @override
  void paint(Canvas canvas, Size size) {
    Path path = Path();
    path.moveTo(cornerRadius, 0);

    path.lineTo(size.width - cornerRadius, 0);

    path.quadraticBezierTo(size.width, 0, size.width, cornerRadius);

    path.lineTo(size.width, size.height - nippleHeight - cornerRadius);

    path.quadraticBezierTo(
      size.width,
      size.height - nippleHeight,
      size.width - cornerRadius,
      size.height - nippleHeight,
    );

    final halfOfBaseWidthWithoutNippleBase = (size.width - nippleBaseWidth) / 2;

    path.lineTo(
      size.width - halfOfBaseWidthWithoutNippleBase + (2 * nippleEdgeRadius),
      size.height - nippleHeight,
    );

    final edgeSpacing =
        (nippleEdgeRadius * nippleBaseWidth * .5) / nippleHeight;

    final rightPoint =
        halfOfBaseWidthWithoutNippleBase + nippleBaseWidth - edgeSpacing;

    final leftPoint = halfOfBaseWidthWithoutNippleBase + edgeSpacing;

    path.quadraticBezierTo(
      size.width - halfOfBaseWidthWithoutNippleBase,
      size.height - nippleHeight,
      rightPoint,
      size.height - nippleHeight + nippleRadius,
    );

    final y = size.height - nippleRadius;
    final spacing = (nippleRadius * nippleBaseWidth) / nippleHeight;
    final addition = (nippleBaseWidth - spacing) / 2;
    final x2 = halfOfBaseWidthWithoutNippleBase + nippleBaseWidth - addition;
    final x1 = halfOfBaseWidthWithoutNippleBase + addition;

    path.lineTo(x2, y);

    path.quadraticBezierTo(size.width / 2, size.height, x1, y);

    path.lineTo(leftPoint, size.height - nippleHeight + nippleEdgeRadius);

    path.quadraticBezierTo(
      halfOfBaseWidthWithoutNippleBase,
      size.height - nippleHeight,
      halfOfBaseWidthWithoutNippleBase - 2 * nippleEdgeRadius,
      size.height - nippleHeight,
    );

    path.lineTo(cornerRadius, size.height - nippleHeight);

    path.quadraticBezierTo(
      0,
      size.height - nippleHeight,
      0,
      size.height - nippleHeight - cornerRadius,
    );

    path.lineTo(0, cornerRadius);

    path.quadraticBezierTo(0, 0, cornerRadius, 0);

    path.close();

    final paint = Paint()
      ..color = borderColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1;

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant BorderPainter oldDelegate) =>
      oldDelegate.cornerRadius != cornerRadius ||
      oldDelegate.nippleBaseWidth != nippleBaseWidth ||
      oldDelegate.nippleEdgeRadius != nippleEdgeRadius ||
      oldDelegate.nippleHeight != nippleHeight ||
      oldDelegate.nippleRadius != nippleRadius;
}

class AmountSlider extends StatelessWidget {
  const AmountSlider({
    required this.onChanged,
    this.amount = 10000,
    this.upperLimit = 15000,
    this.lowerLimit = 500,
    super.key,
    this.division = 5,
  });

  final void Function(double) onChanged;
  final double amount;
  final double upperLimit;
  final double lowerLimit;
  final int division;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(
        horizontal: SizeConfig.pageHorizontalMargins,
      ),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              for (int i = 0; i < division; i++)
                Builder(
                  builder: (context) {
                    final amt = (upperLimit / division) * (i + 1).toInt();
                    return GestureDetector(
                      onTap: () => onChanged(amt),
                      child: SipAmountChip(
                        isBest: i == division - 1, // Change it.
                        isSelected: amount == amt,
                        label: '₹$amt',
                      ),
                    );
                  },
                ),
            ],
          ),
          Slider(
            max: upperLimit,
            min: lowerLimit,
            divisions: division - 1,
            value: amount,
            onChanged: onChanged,
            inactiveColor: Colors.grey,
          ),
        ],
      ),
    );
  }
}

class AmountInputWidget extends StatelessWidget {
  const AmountInputWidget({
    required this.amount,
    required this.onChange,
    super.key,
    this.upperLimit = 15000,
    this.lowerLimit = 500,
    this.division = 5,
  });

  final double amount;
  final double upperLimit;
  final double lowerLimit;
  final int division;
  final void Function(double value) onChange;

  void _onIncrement() {
    if (amount < upperLimit) {
      final value = amount + (upperLimit / division);
      onChange(value);
    }
  }

  void _onDecrement() {
    if (amount > lowerLimit) {
      final value = amount - (upperLimit / division);
      onChange(value);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: UiConstants.grey5,
        borderRadius: BorderRadius.circular(SizeConfig.roundness16),
      ),
      margin: EdgeInsets.symmetric(
        horizontal: SizeConfig.padding20,
      ),
      padding: EdgeInsets.only(
        left: SizeConfig.padding16,
        right: SizeConfig.padding16,
        top: SizeConfig.padding20,
        bottom: SizeConfig.padding12,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _ActionButton(
            actionType: _ActionType.decrement,
            onPressed: _onDecrement,
          ),
          Column(
            children: [
              Text(
                '₹ ${amount.round()}',
                style: TextStyles.rajdhaniB.title2,
              ),
              Row(
                children: [
                  Text(
                    '+10 Tambola Ticket',
                    style: TextStyles.sourceSans.body3.copyWith(
                      color: UiConstants.teal3,
                      height: 1.5,
                    ),
                  ),
                  SizedBox(
                    width: SizeConfig.padding4,
                  ),
                ],
              )
            ],
          ),
          _ActionButton(
            actionType: _ActionType.increment,
            onPressed: _onIncrement,
          )
        ],
      ),
    );
  }
}

enum _ActionType {
  increment,
  decrement;
}

class _ActionButton extends StatelessWidget {
  const _ActionButton({
    required this.onPressed,
    this.actionType = _ActionType.increment,
  });

  final _ActionType actionType;
  final VoidCallback onPressed;

  IconData _getIcon() {
    return switch (actionType) {
      _ActionType.increment => Icons.add,
      _ActionType.decrement => Icons.remove
    };
  }

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      radius: SizeConfig.padding24,
      backgroundColor: Colors.black,
      foregroundColor: Colors.white,
      child: IconButton(
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent,
        onPressed: onPressed,
        icon: Icon(
          _getIcon(),
        ),
      ),
    );
  }
}
