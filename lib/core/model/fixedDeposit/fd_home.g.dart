// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'fd_home.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AllFdsData _$AllFdsDataFromJson(Map<String, dynamic> json) => AllFdsData(
      id: json['id'] as String,
      displayName: json['displayName'] as String,
      subText: json['subText'] as String,
      investDetailsList: (json['investDetailsList'] as List<dynamic>)
          .map((e) => InvestDetail.fromJson(e as Map<String, dynamic>))
          .toList(),
      tags: (json['tags'] as List<dynamic>)
          .map((e) => Tag.fromJson(e as Map<String, dynamic>))
          .toList(),
      icon: json['icon'] as String,
      tncLink: json['tncLink'] as String,
      detailsPage:
          DetailsPage.fromJson(json['detailsPage'] as Map<String, dynamic>),
    );

InvestDetail _$InvestDetailFromJson(Map<String, dynamic> json) => InvestDetail(
      label: json['label'] as String,
      value: json['value'] as String,
    );

Tag _$TagFromJson(Map<String, dynamic> json) => Tag(
      text: json['text'] as String,
      color: json['color'] as String,
      textColor: json['textColor'] as String,
    );

DetailsPage _$DetailsPageFromJson(Map<String, dynamic> json) => DetailsPage(
      cta: Cta.fromJson(json['cta'] as Map<String, dynamic>),
    );

Cta _$CtaFromJson(Map<String, dynamic> json) => Cta(
      investNow: InvestNow.fromJson(json['investNow'] as Map<String, dynamic>),
      bookCall: BookCall.fromJson(json['bookCall'] as Map<String, dynamic>),
      lockInTenure:
          LockInTenure.fromJson(json['lockInTenure'] as Map<String, dynamic>),
      displayAmounts: (json['displayAmounts'] as List<dynamic>)
          .map((e) => e as int)
          .toList(),
      frequencyValues: (json['frequencyValues'] as Map<String, dynamic>).map(
        (k, e) => MapEntry(
            k,
            (e as Map<String, dynamic>).map(
              (k, e) => MapEntry(
                  k, FrequencyValue.fromJson(e as Map<String, dynamic>)),
            )),
      ),
    );

InvestNow _$InvestNowFromJson(Map<String, dynamic> json) => InvestNow(
      label: json['label'] as String,
      action: json['action'] as String,
    );

BookCall _$BookCallFromJson(Map<String, dynamic> json) => BookCall(
      label: json['label'] as String,
      description: json['description'] as String,
      action: json['action'] as String,
      usersBookedToday: json['usersBookedToday'] as int,
    );

LockInTenure _$LockInTenureFromJson(Map<String, dynamic> json) => LockInTenure(
      options:
          (json['options'] as List<dynamic>).map((e) => e as String).toList(),
      selected: json['selected'] as String,
    );

FrequencyValue _$FrequencyValueFromJson(Map<String, dynamic> json) =>
    FrequencyValue(
      label: json['label'] as String,
      months: json['months'] as int,
      returns: json['returns'] as String,
      seniorReturns: json['seniorReturns'] as String?,
    );
