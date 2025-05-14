part of 'get_observation_by_id_with_tags_cubit.dart';

sealed class GetObservationDetailByIdWithTagsState extends Equatable {
  const GetObservationDetailByIdWithTagsState();

  @override
  List<Object?> get props => [];
}

final class GetObservationDetailByIdWithTagsInitial
    extends GetObservationDetailByIdWithTagsState {
  const GetObservationDetailByIdWithTagsInitial();
}

final class GetObservationDetailByIdWithTagsLoading
    extends GetObservationDetailByIdWithTagsState {
  const GetObservationDetailByIdWithTagsLoading();
}

final class GetObservationDetailByIdWithTagsLoaded
    extends GetObservationDetailByIdWithTagsState {
  const GetObservationDetailByIdWithTagsLoaded({required this.observation});

  final ObservationDetailWithTagsEntity? observation;

  @override
  List<Object?> get props => [observation!];
}

final class GetObservationDetailByIdWithTagsError
    extends GetObservationDetailByIdWithTagsState {
  const GetObservationDetailByIdWithTagsError({required this.message});

  final String message;

  @override
  List<Object?> get props => [message];
}
