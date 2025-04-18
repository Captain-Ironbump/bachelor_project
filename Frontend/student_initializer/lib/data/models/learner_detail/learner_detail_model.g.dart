// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'learner_detail_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

LearnerDetailModel _$LearnerDetailModelFromJson(Map<String, dynamic> json) =>
    LearnerDetailModel(
      learnerId: (json['learnerId'] as num?)?.toInt(),
      firstName: json['firstName'] as String?,
      lastName: json['lastName'] as String?,
    );

Map<String, dynamic> _$LearnerDetailModelToJson(LearnerDetailModel instance) =>
    <String, dynamic>{
      'learnerId': instance.learnerId,
      'firstName': instance.firstName,
      'lastName': instance.lastName,
    };
