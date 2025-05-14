part of 'get_learner_by_id_cubit.dart';

sealed class GetLearnerByIdState extends Equatable {
  const GetLearnerByIdState();
  
  @override
  List<Object?> get props => [];
}

final class GetLearnerByIdInitial extends GetLearnerByIdState {
  const GetLearnerByIdInitial();
}

final class GetLearnerByIdLoading extends GetLearnerByIdState {
  const GetLearnerByIdLoading();
}

final class GetLearnerByIdLoaded extends GetLearnerByIdState {
  const GetLearnerByIdLoaded({required this.learner});

  final LearnerDetailEntity? learner;

  @override
  List<Object> get props => [learner!];
}

final class GetLearnerByIdError extends GetLearnerByIdState {
  const GetLearnerByIdError({required this.message});

  final String message;

  @override
  List<Object> get props => [message];
}