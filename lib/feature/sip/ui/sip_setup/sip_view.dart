import 'package:felloapp/feature/sip/cubit/autosave_cubit.dart';
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
        body: Column(
          children: [
            SizedBox(
              height: SizeConfig.padding34,
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: SizeConfig.padding52),
              child: _TabBar<String>(
                tabs: const ['DAILY', 'WEEKLY', 'MONTHLY'],
                labelBuilder: (label) => label,
                onTap: (_, i) {},
              ),
            )
          ],
        ),
      ),
    );
  }
}

class _TabBar<T> extends StatelessWidget {
  const _TabBar({
    required this.tabs,
    required this.labelBuilder,
    required this.onTap,
    super.key,
  });

  final List<T> tabs;
  final String Function(T) labelBuilder;
  final void Function(T, int index) onTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(SizeConfig.padding3),
      decoration: BoxDecoration(
        border: Border.all(color: UiConstants.kDividerColor),
        borderRadius: BorderRadius.circular(100),
      ),
      child: TabBar(
        splashFactory: NoSplash.splashFactory,
        splashBorderRadius: BorderRadius.circular(SizeConfig.roundness32),
        labelStyle: TextStyles.sourceSansB.body3,
        unselectedLabelStyle: TextStyles.sourceSans.body3.colour(
          UiConstants.textGray70,
        ),
        labelColor: Colors.white,
        unselectedLabelColor: Colors.white,
        indicatorPadding: EdgeInsets.zero,
        padding: EdgeInsets.zero,
        labelPadding: EdgeInsets.zero,
        indicator: BoxDecoration(
          borderRadius: BorderRadius.circular(SizeConfig.roundness32),
          color: UiConstants.primaryColor,
        ),
        onTap: (i) => onTap(tabs[i], i),
        tabs: [
          for (var i = 0; i < tabs.length; i++)
            Tab(
              text: labelBuilder(tabs[i]),
              height: 35,
            )
        ],
      ),
    );
  }
}
