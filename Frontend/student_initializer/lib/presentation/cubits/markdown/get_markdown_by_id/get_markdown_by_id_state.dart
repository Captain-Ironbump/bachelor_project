part of 'get_markdown_by_id_cubit.dart';

sealed class GetMarkdownByIdState extends Equatable {
  const GetMarkdownByIdState();

  @override
  List<Object?> get props => [];
}

final class GetMarkdownByIdInitial extends GetMarkdownByIdState {
  const GetMarkdownByIdInitial();
}

final class GetMarkdownByIdLoading extends GetMarkdownByIdState {
  const GetMarkdownByIdLoading();
}

final class GetMarkdownByIdLoaded extends GetMarkdownByIdState {
  const GetMarkdownByIdLoaded({required this.markdownForm});

  final MarkdownFormEntity? markdownForm;

  @override
  List<Object?> get props => [markdownForm!];
}

final class GetMarkdownByIdError extends GetMarkdownByIdState {
  const GetMarkdownByIdError({required this.message});

  final String? message;

  @override
  List<Object?> get props => [message];
}