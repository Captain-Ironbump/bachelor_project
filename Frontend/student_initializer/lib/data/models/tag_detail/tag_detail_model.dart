import 'dart:convert';

import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:student_initializer/data/datasources/_mappers/entity_convertable.dart';
import 'package:student_initializer/domain/entities/tag_detail/tag_detail_entity.dart';

part 'tag_detail_model.g.dart';

@JsonSerializable()
class TagDetailModel extends Equatable
    with EntityConvertable<TagDetailModel, TagDetailEntity> {
  @JsonKey(name: "tag")
  final String? tag;
  @JsonKey(name: "color")
  final String? tagColor;

  const TagDetailModel({
    this.tag,
    this.tagColor,
  });

  factory TagDetailModel.fromJson(Map<String, dynamic> json) =>
      _$TagDetailModelFromJson(json);

  Map<String, dynamic> toJson() => _$TagDetailModelToJson(this);

  @override
  List<Object?> get props => [tag, tagColor];

  @override
  TagDetailEntity toEntity() => TagDetailEntity(
        tag: tag,
        tagColor: tagColor,
      );
}
