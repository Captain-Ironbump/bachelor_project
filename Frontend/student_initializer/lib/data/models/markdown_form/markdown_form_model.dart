import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:student_initializer/domain/entities/markdown_from/markdown_form_entity.dart';

part 'markdown_form_model.g.dart';

@JsonSerializable()
class MarkdownFormModel extends Equatable {
  final String? markdownText;

  const MarkdownFormModel({
    this.markdownText,
  });

  factory MarkdownFormModel.fromJson(Map<String, dynamic> json) =>
      _$MarkdownFormModelFromJson(json);

  Map<String, dynamic> toJson() => _$MarkdownFormModelToJson(this);

  @override
  List<Object?> get props => [markdownText];

  toEntity() => MarkdownFormEntity(
        markdownText: markdownText,
      );
}
