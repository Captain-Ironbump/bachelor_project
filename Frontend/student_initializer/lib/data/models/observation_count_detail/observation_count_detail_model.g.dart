// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'observation_count_detail_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ObservationCountDetailModel _$ObservationCountDetailModelFromJson(
        Map<String, dynamic> json) =>
    ObservationCountDetailModel(
      count: (json['count'] as num?)?.toInt(),
      countWithTimespan: (json['countWithTimespan'] as num?)?.toInt(),
    );

Map<String, dynamic> _$ObservationCountDetailModelToJson(
        ObservationCountDetailModel instance) =>
    <String, dynamic>{
      'count': instance.count,
      'countWithTimespan': instance.countWithTimespan,
    };
