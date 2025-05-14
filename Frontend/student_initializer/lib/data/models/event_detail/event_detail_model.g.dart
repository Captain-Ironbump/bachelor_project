// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'event_detail_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

EventDetailModel _$EventDetailModelFromJson(Map<String, dynamic> json) =>
    EventDetailModel(
      eventId: (json['eventId'] as num?)?.toInt(),
      name: json['name'] as String?,
      learnerCount: (json['learnerCount'] as num?)?.toInt(),
    );

Map<String, dynamic> _$EventDetailModelToJson(EventDetailModel instance) =>
    <String, dynamic>{
      'eventId': instance.eventId,
      'name': instance.name,
      'learnerCount': instance.learnerCount,
    };
