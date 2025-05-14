part of 'get_learners_by_event_id_cubit.dart';

sealed class GetLearnersByEventIdState extends Equatable {
  const GetLearnersByEventIdState();
  
  @override
  List<Object?> get props => [];
}

final class GetLearnersByEventIdInitial extends GetLearnersByEventIdState {
  const GetLearnersByEventIdInitial();
}

final class GetLearnersByEventIdLoading extends GetLearnersByEventIdState {
  const GetLearnersByEventIdLoading();
}

final class GetLearnersByEventIdLoaded extends GetLearnersByEventIdState {
  const GetLearnersByEventIdLoaded({required this.learners});

  final List<LearnerDetailEntity>? learners;

  @override
  List<Object> get props => [learners!];
}

final class GetLearnersByEventIdError extends GetLearnersByEventIdState {
  const GetLearnersByEventIdError({required this.message});

  final String message;

  @override
  List<Object> get props => [message];
}