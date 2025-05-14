import 'package:equatable/equatable.dart';

class MarkdownFormEntity extends Equatable {
  final String? markdownText;

  const MarkdownFormEntity({
    this.markdownText,
  });

  @override
  List<Object?> get props => [markdownText];
}
