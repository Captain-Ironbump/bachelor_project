part of 'add_learners_to_event_cubit.dart';

sealed class AddLearnersToEventState extends Equatable {
  const AddLearnersToEventState();

  @override
  List<Object?> get props => [];
}

class AddLearnersToEventInitial extends AddLearnersToEventState {
  const AddLearnersToEventInitial();
}

class AddLearnersToEventLoading extends AddLearnersToEventState {
  const AddLearnersToEventLoading();
}

class AddLearnersToEventSuccess extends AddLearnersToEventState {
  const AddLearnersToEventSuccess();
}

class AddLearnersToEventError extends AddLearnersToEventState {
  final String? message;

  const AddLearnersToEventError({required this.message});

  @override
  List<Object?> get props => [message!];
}