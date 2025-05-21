part of 'update_markdown_quality_cubit.dart';

sealed class UpdateMarkdownQualityState extends Equatable {
  const UpdateMarkdownQualityState();

  @override
  List<Object?> get props => [];
}

final class UpdateMarkdownQualityInitial extends UpdateMarkdownQualityState {
  const UpdateMarkdownQualityInitial();
}

final class UpdateMarkdownQualityLoading extends UpdateMarkdownQualityState {
  const UpdateMarkdownQualityLoading();
}

final class UpdateMarkdownQualitySuccess
    extends UpdateMarkdownQualityState {
  const UpdateMarkdownQualitySuccess({required this.markdownForm});

  final MarkdownFormEntity? markdownForm;

  @override
  List<Object?> get props => [markdownForm!];
}

final class UpdateMarkdownQualityError extends UpdateMarkdownQualityState {
  const UpdateMarkdownQualityError({required this.message});

  final String? message;

  @override
  List<Object> get props => [message!];
}