// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'testimonials_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TestimonialsModel _$TestimonialsModelFromJson(Map<String, dynamic> json) =>
    TestimonialsModel(
      userName: json['userName'] as String,
      rating: json['rating'] as num,
      review: json['review'] as String,
      createdAt: json['createdAt'] as String,
      avatarId: json['avatarId'] as String? ?? "AV1",
      dpUrl: json['dpUrl'] as String? ?? "",
    );

Map<String, dynamic> _$TestimonialsModelToJson(TestimonialsModel instance) =>
    <String, dynamic>{
      'userName': instance.userName,
      'rating': instance.rating,
      'review': instance.review,
      'createdAt': instance.createdAt,
      'avatarId': instance.avatarId,
      'dpUrl': instance.dpUrl,
    };
