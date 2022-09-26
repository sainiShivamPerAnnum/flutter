import 'package:felloapp/ui/widgets/appbar/appbar.dart';
import 'package:felloapp/util/styles/size_config.dart';
import 'package:felloapp/util/styles/ui_constants.dart';
import 'package:flutter/material.dart';

class AllTambolaTickets extends StatelessWidget {
  const AllTambolaTickets({Key key, @required this.ticketList})
      : super(key: key);

  final List<Widget> ticketList;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: UiConstants.kArowButtonBackgroundColor,
      appBar: FAppBar(
        showAvatar: false,
        showCoinBar: false,
        showHelpButton: false,
        title: "Tickets",
        backgroundColor: UiConstants.kArowButtonBackgroundColor,
      ),
      body: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: ListView.builder(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          scrollDirection: Axis.vertical,
          itemCount: ticketList.length,
          itemBuilder: (ctx, index) {
            return Container(
                margin: EdgeInsets.symmetric(
                    vertical: SizeConfig.pageHorizontalMargins),
                child: ticketList[index]);
          },
        ),
      ),
    );
  }
}
