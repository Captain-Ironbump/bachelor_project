part of 'save_learner_cubit.dart';

sealed class SaveLearnerState extends Equatable {
  const SaveLearnerState();

  @override
  List<Object?> get props => [];
}

final class SaveLearnerInitial extends SaveLearnerState {
  const SaveLearnerInitial();
}

final class SaveLearnerLoading extends SaveLearnerState {
  const SaveLearnerLoading();
}

final class SaveLearnerLoaded extends SaveLearnerState {
  const SaveLearnerLoaded();
}

final class SaveLearnerError extends SaveLearnerState {
  const SaveLearnerError({required this.message});

  final String message;

  @override
  List<Object?> get props => [message];
}
