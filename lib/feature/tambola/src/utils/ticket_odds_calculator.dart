import 'dart:math' as math;

import 'package:felloapp/feature/tambola/src/models/tambola_ticket_model.dart';

int getRowOdds(
    TambolaTicketModel ticket, int rowIndex, List<int> calledDigits) {
  if (ticket == TambolaTicketModel.none() || ticket.tambolaBoard == null)
    return 5;

  int rowCalledCount = 0;
  for (int i = 0; i < boardLength; i++) {
    if (ticket.tambolaBoard![rowIndex][i] != 0 &&
        calledDigits.contains(ticket.tambolaBoard![rowIndex][i])) {
      rowCalledCount++;
    }
  }
  int rowLeftCount = 5 - rowCalledCount;
  return rowLeftCount;
}

int getOneRowOdds(TambolaTicketModel ticket, List<int> calledDigits) {
  int row_1 = getRowOdds(ticket, 0, calledDigits);
  int row_2 = getRowOdds(ticket, 1, calledDigits);
  int row_3 = getRowOdds(ticket, 2, calledDigits);

  int min = row_1;
  min = math.min(min, row_2);
  min = math.min(min, row_3);

  return min;
}

int getTwoRowOdds(TambolaTicketModel ticket, List<int> calledDigits) {
  int row_1 = getRowOdds(ticket, 0, calledDigits);
  int row_2 = getRowOdds(ticket, 1, calledDigits);
  int row_3 = getRowOdds(ticket, 2, calledDigits);

  int min = row_1 + row_2;
  min = math.min(min, row_1 + row_3);
  min = math.min(min, row_2 + row_3);

  return min;
}

int getCornerOdds(TambolaTicketModel ticket, List<int> calledDigits) {
  if (ticket.tambolaBoard == null ||
      ticket.tambolaBoard!.isEmpty ||
      calledDigits == [] ||
      calledDigits.isEmpty) return 4;
  int cornerA = 0;
  int cornerB = 0;
  int cornerC = 0;
  int cornerD = 0;
  int cornerCount = 0;
  for (int i = 0; i < boardHeight; i++) {
    for (int j = 0; j < boardLength; j++) {
      if (ticket.tambolaBoard![i][j] != 0) {
        if (i == 0 && cornerA == 0) cornerA = ticket.tambolaBoard![i][j];
        if (i == 0) cornerB = ticket.tambolaBoard![i][j];
        if (i == 2 && cornerC == 0) cornerC = ticket.tambolaBoard![i][j];
        if (i == 2) cornerD = ticket.tambolaBoard![i][j];
      }
    }
  }
  if (calledDigits.contains(cornerA)) cornerCount++;
  if (calledDigits.contains(cornerB)) cornerCount++;
  if (calledDigits.contains(cornerC)) cornerCount++;
  if (calledDigits.contains(cornerD)) cornerCount++;

  int cornerLeftCount = 4 - cornerCount;

  return cornerLeftCount;
}

int getFullHouseOdds(TambolaTicketModel ticket, List<int> calledDigits) {
  if (ticket.tambolaBoard == null ||
      ticket.tambolaBoard!.isEmpty ||
      calledDigits == [] ||
      calledDigits.isEmpty) return 15;
  int fullHouseCount = 0;
  // int digitsLeftToBeAnnounced =
  //     _tambolaService.dailyPicksCount * 7 - calledDigits.length;
  for (int i = 0; i < boardHeight; i++) {
    for (int j = 0; j < boardLength; j++) {
      if (ticket.tambolaBoard![i][j] != 0) {
        if (calledDigits.contains(ticket.tambolaBoard![i][j])) {
          fullHouseCount++;
        }
      }
    }
  }
  int fullHouseLeftCount = 15 - fullHouseCount;

  return fullHouseLeftCount;
}
