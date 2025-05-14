part of 'get_observation_by_id_cubit.dart';

sealed class GetObservationDetailByIdState extends Equatable {
  const GetObservationDetailByIdState();

  @override
  List<Object?> get props => [];
}

final class GetObservationDetailByIdInitial
    extends GetObservationDetailByIdState {
  const GetObservationDetailByIdInitial();
}

final class GetObservationDetailByIdLoading
    extends GetObservationDetailByIdState {
  const GetObservationDetailByIdLoading();
}

final class GetObservationDetailByIdLoaded
    extends GetObservationDetailByIdState {
  const GetObservationDetailByIdLoaded({required this.observation});

  final ObservationDetailEntity? observation;

  @override
  List<Object?> get props => [observation!];
}

final class GetObservationDetailByIdError
    extends GetObservationDetailByIdState {
  const GetObservationDetailByIdError({required this.message});

  final String message;

  @override
  List<Object?> get props => [message];
}
