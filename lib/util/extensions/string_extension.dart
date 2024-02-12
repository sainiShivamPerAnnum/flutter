extension StringExtension on String {
  String capitalize() {
    return "${this[0].toUpperCase()}${substring(1).toLowerCase()}";
  }

  String frequencyRename() {
    switch (this) {
      case "Daily":
        return "day";
      case "Weekly":
        return "week";
      case "Monthly":
        return "month";
    }
    return "";
  }
}

extension IndianNumberSystem on String {
  String formatToIndianNumberSystem() {
    String num = this;
    if (length == 1) return this;
    while (this[0] == '0') {
      num = num.substring(1);
    }
    String? decimalPart = ".${num.split('.').last}";
    if (!num.contains('.')) {
      decimalPart = '';
    }
    String wholePart = num.split('.').first;
    switch (wholePart.length) {
      case 4:
        return "${wholePart.substring(0, 1)},${wholePart.substring(1)}$decimalPart";
      case 5:
        return "${wholePart.substring(0, 2)},${wholePart.substring(2)}$decimalPart";
      case 6:
        return "${wholePart.substring(0, 1)},${wholePart.substring(1, 3)},${wholePart.substring(3)}$decimalPart";
      case 7:
        return "${wholePart.substring(0, 2)},${wholePart.substring(2, 4)},${wholePart.substring(4)}$decimalPart";
      case 8:
        return "${wholePart.substring(0, 1)},${wholePart.substring(1, 3)},${wholePart.substring(3, 5)},${wholePart.substring(5)}$decimalPart";
      case 9:
        return "${wholePart.substring(0, 2)},${wholePart.substring(2, 4)},${wholePart.substring(4, 6)},${wholePart.substring(6)}$decimalPart";
      case 10:
        return "Ambaani k Choxe";
      default:
        return "0.0";
    }
  }
}
