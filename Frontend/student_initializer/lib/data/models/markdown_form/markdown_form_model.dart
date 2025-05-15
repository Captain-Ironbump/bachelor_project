import 'dart:convert';

import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:student_initializer/domain/entities/markdown_from/markdown_form_entity.dart';

part 'markdown_form_model.g.dart';

@JsonSerializable()
class MarkdownFormModel extends Equatable {
  @JsonKey(name: "reportId")
  final int? reportId;
  @JsonKey(name: "learnerId")
  final int? learnerId;
  @JsonKey(name: "eventId")
  final int? eventId;
  @JsonKey(name: "reportData")
  final String? reportData;
  @JsonKey(name: "createdDateTime")
  final String? createdDateTime;

  const MarkdownFormModel({
    this.reportId,
    this.learnerId,
    this.eventId,
    this.reportData,
    this.createdDateTime,
  });

  factory MarkdownFormModel.fromJson(Map<String, dynamic> json) =>
      _$MarkdownFormModelFromJson(json);

  Map<String, dynamic> toJson() => _$MarkdownFormModelToJson(this);

  @override
  List<Object?> get props => [
        reportId,
        learnerId,
        eventId,
        reportData,
        createdDateTime,
      ];

  MarkdownFormEntity toEntity() => MarkdownFormEntity(
        reportId: reportId,
        learnerId: learnerId,
        eventId: eventId,
        createdDateTime: createdDateTime,
        report: utf8.decode(base64.decode(reportData!)),
      );
}
