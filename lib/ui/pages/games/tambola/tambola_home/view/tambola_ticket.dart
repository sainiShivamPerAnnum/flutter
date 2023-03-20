import 'package:felloapp/ui/pages/games/tambola/tambola_home/widgets/ticket_painter.dart';
import 'package:flutter/material.dart';

import 'tambola_existing_user_landing_page.dart';

class TambolaTicket extends StatelessWidget {
  const TambolaTicket({
    Key? key,
    this.ticketNo,
    this.generatedDate,
    required this.child,
  }) : super(key: key);

  final String? ticketNo;
  final String? generatedDate;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        ClipPath(
          clipper: TicketPainter(),
          child: Container(
            height: 180,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
              color: const Color(0xff30363C),
              borderRadius: BorderRadius.circular(10.0),
              border: Border.all(
                  color: const Color(0xff627F8E).withOpacity(0.2), width: 1.5),
            ),
            child: child,
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          margin: const EdgeInsets.only(top: 40),
          child: MySeparator(
            color: Colors.white.withOpacity(0.3),
          ),
        ),
      ],
    );
  }
}
