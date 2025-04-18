part of 'get_observations_cubit.dart';

sealed class GetObservationsState extends Equatable {
  const GetObservationsState();

  @override
  List<Object?> get props => [];
}

final class GetObservationsInitial extends GetObservationsState {
  const GetObservationsInitial();
}

final class GetObservationsLoading extends GetObservationsState {
  const GetObservationsLoading();
}

final class GetObservationsLoaded extends GetObservationsState {
  const GetObservationsLoaded({required this.observations});

  final List<ObservationDetailEntity>? observations;

  @override
  List<Object?> get props => [observations!];
}

final class GetObservationsError extends GetObservationsState {
  const GetObservationsError({required this.message});

  final String message;
  
  @override
  List<Object> get props => [message];
}
