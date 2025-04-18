part of 'get_observations_count_cubit.dart';

sealed class GetObservationsCountState extends Equatable {
  const GetObservationsCountState();

  @override
  List<Object?> get props => [];
}

final class GetObservationsCountInitial extends GetObservationsCountState {
  const GetObservationsCountInitial();
}

final class GetObservationsCountLoading extends GetObservationsCountState {
  const GetObservationsCountLoading();
}

final class GetObservationsCountLoaded extends GetObservationsCountState {
  const GetObservationsCountLoaded({required this.countMap});

  final Map<String, ObservationCountDetailEntity>? countMap;

  @override
  List<Object> get props => [countMap!];
}

final class GetObservationsCountError extends GetObservationsCountState {
  const GetObservationsCountError({required this.message});

  final String message;

  @override
  List<Object> get props => [message];
}