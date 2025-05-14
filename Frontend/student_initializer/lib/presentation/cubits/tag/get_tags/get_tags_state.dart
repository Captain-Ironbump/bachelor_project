part of 'get_tags_cubit.dart';

sealed class GetTagsState extends Equatable {
  const GetTagsState();

  @override
  List<Object?> get props => [];
}

final class GetTagsInitial extends GetTagsState {
  const GetTagsInitial();
}

final class GetTagsLoading extends GetTagsState {
  const GetTagsLoading();
}

final class GetTagsLoaded extends GetTagsState {
  const GetTagsLoaded({required this.tags});

  final List<TagDetailEntity>? tags;

  @override
  List<Object?> get props => [tags!];
}

final class GetTagsError extends GetTagsState {
  const GetTagsError({required this.message});

  final String message;

  @override
  List<Object> get props => [message];
}
