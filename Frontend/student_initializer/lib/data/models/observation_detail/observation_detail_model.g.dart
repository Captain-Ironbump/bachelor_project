// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'observation_detail_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ObservationDetailModel _$ObservationDetailModelFromJson(
        Map<String, dynamic> json) =>
    ObservationDetailModel(
      observationId: (json['observationId'] as num?)?.toInt(),
      learnerId: (json['learnerId'] as num?)?.toInt(),
      createdDate: json['createdDate'] as String?,
      rawObservation: json['rawObservation'] as String?,
    );

Map<String, dynamic> _$ObservationDetailModelToJson(
        ObservationDetailModel instance) =>
    <String, dynamic>{
      'observationId': instance.observationId,
      'learnerId': instance.learnerId,
      'createdDate': instance.createdDate,
      'rawObservation': instance.rawObservation,
    };
