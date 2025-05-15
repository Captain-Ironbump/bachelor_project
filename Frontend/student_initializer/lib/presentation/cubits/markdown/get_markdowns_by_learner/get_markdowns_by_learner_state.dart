part of 'get_markdowns_by_learner_cubit.dart';

sealed class GetMarkdownsByLearnerState extends Equatable {
  const GetMarkdownsByLearnerState();

  @override
  List<Object?> get props => [];
}

final class GetMarkdownsByLearnerInitial extends GetMarkdownsByLearnerState {
  const GetMarkdownsByLearnerInitial();
}

final class GetMarkdownsByLearnerLoading extends GetMarkdownsByLearnerState {
  const GetMarkdownsByLearnerLoading();
}

final class GetMarkdownsByLearnerLoaded extends GetMarkdownsByLearnerState {
  const GetMarkdownsByLearnerLoaded({required this.markdownForms});

  final List<MarkdownFormEntity>? markdownForms;

  @override
  List<Object?> get props => [markdownForms!];
}

final class GetMarkdownsByLearnerError extends GetMarkdownsByLearnerState {
  const GetMarkdownsByLearnerError({required this.message});

  final String? message;

  @override
  List<Object?> get props => [message];
}