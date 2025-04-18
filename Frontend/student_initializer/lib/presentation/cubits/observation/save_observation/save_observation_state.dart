part of 'save_observation_cubit.dart';

sealed class SaveObservationState extends Equatable {
  const SaveObservationState();

  @override
  List<Object?> get props => [];
}

final class SaveObservationInitial extends SaveObservationState {
  const SaveObservationInitial();
}

final class SaveObservationLoading extends SaveObservationState {
  const SaveObservationLoading();
}

final class SaveObservationSuccess extends SaveObservationState {
  const SaveObservationSuccess();
}

final class SaveObservationError extends SaveObservationState {
  const SaveObservationError({required this.message});

  final String message;

  @override
  List<Object?> get props => [message];
}
