import 'package:json_annotation/json_annotation.dart';

part 'fd_home.g.dart';

const _deserializable = JsonSerializable(
  createToJson: false,
);

@_deserializable
class AllFdsData {
  final String id;
  final String displayName;
  final String subText;
  final List<InvestDetail> investDetailsList;
  final List<Tag> tags;
  final String icon;
  final String tncLink;
  final DetailsPage detailsPage;

  AllFdsData({
    required this.id,
    required this.displayName,
    required this.subText,
    required this.investDetailsList,
    required this.tags,
    required this.icon,
    required this.tncLink,
    required this.detailsPage,
  });

  factory AllFdsData.fromJson(Map<String, dynamic> json) =>
      _$AllFdsDataFromJson(json);
}

@_deserializable
class InvestDetail {
  final String label;
  final String value;

  InvestDetail({
    required this.label,
    required this.value,
  });

  factory InvestDetail.fromJson(Map<String, dynamic> json) =>
      _$InvestDetailFromJson(json);
}

@_deserializable
class Tag {
  final String text;
  final String color;
  final String textColor;

  Tag({
    required this.text,
    required this.color,
    required this.textColor,
  });

  factory Tag.fromJson(Map<String, dynamic> json) => _$TagFromJson(json);
}

@_deserializable
class DetailsPage {
  final Cta cta;

  DetailsPage({
    required this.cta,
  });

  factory DetailsPage.fromJson(Map<String, dynamic> json) =>
      _$DetailsPageFromJson(json);
}

@_deserializable
class Cta {
  final InvestNow investNow;
  final BookCall bookCall;
  final LockInTenure lockInTenure;
  final List<int> displayAmounts;
  final Map<String, Map<String, FrequencyValue>> frequencyValues;

  Cta({
    required this.investNow,
    required this.bookCall,
    required this.lockInTenure,
    required this.displayAmounts,
    required this.frequencyValues,
  });

  factory Cta.fromJson(Map<String, dynamic> json) => _$CtaFromJson(json);
}

@_deserializable
class InvestNow {
  final String label;
  final String action;

  InvestNow({
    required this.label,
    required this.action,
  });

  factory InvestNow.fromJson(Map<String, dynamic> json) =>
      _$InvestNowFromJson(json);
}

@_deserializable
class BookCall {
  final String label;
  final String description;
  final String action;
  final int usersBookedToday;

  BookCall({
    required this.label,
    required this.description,
    required this.action,
    required this.usersBookedToday,
  });

  factory BookCall.fromJson(Map<String, dynamic> json) =>
      _$BookCallFromJson(json);
}

@_deserializable
class LockInTenure {
  final List<String> options;
  final String selected;

  LockInTenure({
    required this.options,
    required this.selected,
  });

  factory LockInTenure.fromJson(Map<String, dynamic> json) =>
      _$LockInTenureFromJson(json);
}

@_deserializable
class FrequencyValue {
  final String label;
  final int months;
  final String? returns;
  final String? seniorReturns;

  FrequencyValue({
    required this.label,
    required this.months,
    required this.returns,
    required this.seniorReturns,
  });

  factory FrequencyValue.fromJson(Map<String, dynamic> json) =>
      _$FrequencyValueFromJson(json);
}
