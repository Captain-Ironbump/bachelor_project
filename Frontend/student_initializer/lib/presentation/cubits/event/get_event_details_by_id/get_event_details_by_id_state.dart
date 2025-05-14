part of 'get_event_details_by_id_cubit.dart';

sealed class GetEventDetailsByIdState extends Equatable {
  const GetEventDetailsByIdState();

  @override
  List<Object?> get props => [];
}

final class GetEventDetailsByIdInitial extends GetEventDetailsByIdState {
  const GetEventDetailsByIdInitial();
}

final class GetEventDetailsByIdLoading extends GetEventDetailsByIdState {
  const GetEventDetailsByIdLoading();
}

final class GetEventDetailsByIdLoaded extends GetEventDetailsByIdState {
  const GetEventDetailsByIdLoaded({required this.event});

  final EventDetailEntity? event;

  @override
  List<Object?> get props => [event!];
}

final class GetEventDetailsByIdError extends GetEventDetailsByIdState {
  const GetEventDetailsByIdError({required this.message});

  final String message;

  @override
  List<Object?> get props => [message];
}


