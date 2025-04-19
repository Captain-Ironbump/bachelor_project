part of 'get_settings_int_cubit.dart';

sealed class GetSettingsIntState extends Equatable {
  const GetSettingsIntState();

  @override
  List<Object?> get props => [];
}

final class GetSettingsIntInit extends GetSettingsIntState {
  const GetSettingsIntInit();
}

final class GetSettingsIntLoading extends GetSettingsIntState {
  const GetSettingsIntLoading();
}

final class GetSettingsIntLoaded extends GetSettingsIntState {
  const GetSettingsIntLoaded({required this.value});

  final int? value;

  @override
  List<Object?> get props => [value];
}

final class GetSettingsIntError extends GetSettingsIntState {
  const GetSettingsIntError({required this.message});

  final String message;

  @override
  List<Object?> get props => [message];
}

