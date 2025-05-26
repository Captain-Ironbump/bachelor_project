part of 'delete_observation_cubit.dart';

sealed class DeleteObservationState extends Equatable {
  const DeleteObservationState();

  @override
  List<Object?> get props => [];
}

final class DeleteObservationInitial extends DeleteObservationState {
  const DeleteObservationInitial();
}

final class DeleteObservationLoading extends DeleteObservationState {
  const DeleteObservationLoading();
}

final class DeleteObservationSuccess extends DeleteObservationState {
  const DeleteObservationSuccess();
}

final class DeleteObservationError extends DeleteObservationState {
  const DeleteObservationError({required this.message});

  final String? message;

  @override
  List<Object> get props => [message!];
}