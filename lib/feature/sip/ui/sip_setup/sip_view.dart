import 'package:felloapp/feature/sip/cubit/autosave_cubit.dart';
import 'package:felloapp/feature/sip/shared/tab_slider.dart';
import 'package:felloapp/ui/pages/static/app_widget.dart';
import 'package:felloapp/util/styles/styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SipView extends StatelessWidget {
  const SipView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AutosaveCubit(),
      child: const _SipView(),
    );
  }
}

class _SipView extends StatelessWidget {
  const _SipView();

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: BaseScaffold(
        showBackgroundGrid: false,
        backgroundColor: UiConstants.bg,
        appBar: AppBar(
          backgroundColor: UiConstants.bg,
          elevation: 1,
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
              const _AmountInputWidget(
                1000,
              )
            ],
          ),
        ),
      ),
    );
  }
}

class _AmountInputWidget extends StatefulWidget {
  const _AmountInputWidget(
    this.preFilledAmount, {
    this.upperLimit = 15000,
    this.lowerLimit = 500,
    this.adjustFactorAmount = 500,
  });

  final int preFilledAmount;
  final int upperLimit;
  final int lowerLimit;
  final int adjustFactorAmount;

  @override
  State<_AmountInputWidget> createState() => _AmountInputWidgetState();
}

class _AmountInputWidgetState extends State<_AmountInputWidget> {
  final ValueNotifier<int> _amount = ValueNotifier(0);

  @override
  void initState() {
    super.initState();
    _amount.value = widget.preFilledAmount;
  }

  @override
  void dispose() {
    _amount.dispose();
    super.dispose();
  }

  void _onIncrement() {
    if (_amount.value < widget.upperLimit) {
      _amount.value += widget.adjustFactorAmount;
    }
  }

  void _onDecrement() {
    if (_amount.value > widget.lowerLimit) {
      _amount.value -= widget.adjustFactorAmount;
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
          ValueListenableBuilder(
              valueListenable: _amount,
              builder: (context, value, child) {
                return Column(
                  children: [
                    Text(
                      '₹ ${_amount.value}',
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
                );
              }),
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
