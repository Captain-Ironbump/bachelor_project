// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'observation_detail_with_tags_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ObservationDetailWithTagsModel _$ObservationDetailWithTagsModelFromJson(
        Map<String, dynamic> json) =>
    ObservationDetailWithTagsModel(
      observationDTO: ObservationDetailModel.fromJson(
          json['observationDTO'] as Map<String, dynamic>),
      tags: (json['tags'] as List<dynamic>)
          .map((e) => TagDetailModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$ObservationDetailWithTagsModelToJson(
        ObservationDetailWithTagsModel instance) =>
    <String, dynamic>{
      'observationDTO': instance.observationDTO,
      'tags': instance.tags,
    };
