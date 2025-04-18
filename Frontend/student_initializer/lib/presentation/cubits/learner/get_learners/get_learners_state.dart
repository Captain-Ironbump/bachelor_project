part of 'get_learners_cubit.dart';

sealed class GetLearnersState extends Equatable {
  const GetLearnersState();
  
  @override
  List<Object?> get props => [];
}

final class GetLearnersInitial extends GetLearnersState {
  const GetLearnersInitial();
}

final class GetLearnersLoading extends GetLearnersState {
  const GetLearnersLoading();
}

final class GetLearnersLoaded extends GetLearnersState {
  const GetLearnersLoaded({required this.learners});

  final List<LearnerDetailEntity>? learners;

  @override
  List<Object> get props => [learners!];
}

final class GetLearnersError extends GetLearnersState {
  const GetLearnersError({required this.message});

  final String message;

  @override
  List<Object> get props => [message];
}