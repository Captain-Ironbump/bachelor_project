part of 'generate_markdown_form_cubit.dart';

sealed class GenerateMarkdownFormState extends Equatable {
  const GenerateMarkdownFormState();

  @override
  List<Object?> get props => [];
}

final class GenerateMarkdownFormInitial extends GenerateMarkdownFormState {
  const GenerateMarkdownFormInitial();
}

final class GenerateMarkdownFormLoading extends GenerateMarkdownFormState {
  const GenerateMarkdownFormLoading();
}

final class GenerateMarkdownFormLoaded extends GenerateMarkdownFormState {
  const GenerateMarkdownFormLoaded({required this.message});

  final String? message;

  @override
  List<Object?> get props => [message!];
}

final class GenerateMarkdownFormError extends GenerateMarkdownFormState {
  const GenerateMarkdownFormError(this.message);

  final String? message;

  @override
  List<Object?> get props => [message];
}
