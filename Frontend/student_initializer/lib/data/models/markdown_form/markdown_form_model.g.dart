// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'markdown_form_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MarkdownFormModel _$MarkdownFormModelFromJson(Map<String, dynamic> json) =>
    MarkdownFormModel(
      reportId: (json['reportId'] as num?)?.toInt(),
      learnerId: (json['learnerId'] as num?)?.toInt(),
      eventId: (json['eventId'] as num?)?.toInt(),
      reportData: json['reportData'] as String?,
      createdDateTime: json['createdDateTime'] as String?,
      quality: json['quality'] as String?,
    );

Map<String, dynamic> _$MarkdownFormModelToJson(MarkdownFormModel instance) =>
    <String, dynamic>{
      'reportId': instance.reportId,
      'learnerId': instance.learnerId,
      'eventId': instance.eventId,
      'reportData': instance.reportData,
      'createdDateTime': instance.createdDateTime,
      'quality': instance.quality,
    };
