part of 'get_events_cubit.dart';

sealed class GetEventsState extends Equatable {
  const GetEventsState();

  @override
  List<Object?> get props => [];
}

final class GetEventsInitial extends GetEventsState {
  const GetEventsInitial();
}

final class GetEventsLoading extends GetEventsState {
  const GetEventsLoading();
}

final class GetEventsLoaded extends GetEventsState {
  const GetEventsLoaded({required this.events});

  final List<EventDetailEntity>? events;

  @override
  List<Object> get props => [events!];
}

final class GetEventsError extends GetEventsState {
  const GetEventsError({required this.message});

  final String message;

  @override
  List<Object> get props => [message];
}
