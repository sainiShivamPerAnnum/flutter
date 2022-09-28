import 'package:felloapp/ui/elements/tambola-global/tambola_ticket.dart';
import 'package:felloapp/ui/widgets/appbar/appbar.dart';
import 'package:felloapp/util/styles/size_config.dart';
import 'package:felloapp/util/styles/textStyles.dart';
import 'package:felloapp/util/styles/ui_constants.dart';
import 'package:flutter/material.dart';

class ShowAllTickets extends StatelessWidget {
  final List<Ticket> tambolaBoardView;
  ShowAllTickets({Key key, this.tambolaBoardView}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: FAppBar(
        title: "All Tickets",
        showAvatar: false,
        showCoinBar: false,
        showHelpButton: false,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height: 10),
              Container(
                height: SizeConfig.screenWidth * 0.94 * 2,
                width: SizeConfig.screenWidth,
                child: GridView.builder(
                  shrinkWrap: true,
                  itemCount: tambolaBoardView.length,
                  physics: BouncingScrollPhysics(),
                  scrollDirection: Axis.horizontal,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisSpacing: 10, crossAxisCount: 2),
                  itemBuilder: (ctx, i) => Container(
                    margin: EdgeInsets.symmetric(vertical: 10),
                    child: tambolaBoardView[i],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
