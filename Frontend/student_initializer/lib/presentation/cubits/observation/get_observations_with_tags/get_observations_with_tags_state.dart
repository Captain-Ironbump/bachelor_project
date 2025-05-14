part of 'get_observations_with_tags_cubit.dart';

sealed class GetObservationsWithTagsState extends Equatable {
  const GetObservationsWithTagsState();

  @override
  List<Object?> get props => [];
}

final class GetObservationsWithTagsInitial
    extends GetObservationsWithTagsState {
  const GetObservationsWithTagsInitial();
}

final class GetObservationsWithTagsLoading
    extends GetObservationsWithTagsState {
  const GetObservationsWithTagsLoading();
}

final class GetObservationsWithTagsLoaded extends GetObservationsWithTagsState {
  const GetObservationsWithTagsLoaded({required this.observations});

  final List<ObservationDetailWithTagsEntity>? observations;

  @override
  List<Object?> get props => [observations!];
}

final class GetObservationsWithTagsError extends GetObservationsWithTagsState {
  const GetObservationsWithTagsError({required this.message});

  final String message;

  @override
  List<Object> get props => [message];
}
