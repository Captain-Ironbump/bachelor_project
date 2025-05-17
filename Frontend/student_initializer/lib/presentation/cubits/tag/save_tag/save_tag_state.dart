part of 'save_tag_cubit.dart';

abstract class SaveTagState extends Equatable {
  const SaveTagState();

  @override
  List<Object?> get props => [];
}

final class SaveTagInitial extends SaveTagState {
  const SaveTagInitial();
}

final class SaveTagLoading extends SaveTagState {
  const SaveTagLoading();
}

final class SaveTagSuccess extends SaveTagState {
  const SaveTagSuccess();
}

final class SaveTagError extends SaveTagState {
  const SaveTagError({required this.message});

  final String? message;

  @override
  List<Object> get props => [message!];
}
