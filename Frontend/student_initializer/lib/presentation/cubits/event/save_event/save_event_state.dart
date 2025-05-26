part of 'save_event_cubit.dart';

sealed class SaveEventState extends Equatable {
  const SaveEventState();

  @override
  List<Object?> get props => [];
}

final class SaveEventInitial extends SaveEventState {
  const SaveEventInitial();
}

final class SaveEventLoading extends SaveEventState {
  const SaveEventLoading();
}

final class SaveEventSuccess extends SaveEventState {
  const SaveEventSuccess();
}

final class SaveEventError extends SaveEventState {
  final String? message;

  const SaveEventError({required this.message});

  @override
  List<Object?> get props => [message!];
}

