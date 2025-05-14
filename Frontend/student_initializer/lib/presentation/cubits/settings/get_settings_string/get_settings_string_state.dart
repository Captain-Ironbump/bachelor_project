part of 'get_settings_string_cubit.dart';

sealed class GetSettingsStringState extends Equatable {
  const GetSettingsStringState();

  @override
  List<Object?> get props => [];
}

final class GetSettingsStringInit extends GetSettingsStringState {
  const GetSettingsStringInit();
}

final class GetSettingsStringLoading extends GetSettingsStringState {
  const GetSettingsStringLoading();
}

final class GetSettingsStringLoaded extends GetSettingsStringState {
  const GetSettingsStringLoaded({required this.value});

  final String? value;

  @override
  List<Object?> get props => [value];
}

final class GetSettingsStringError extends GetSettingsStringState {
  const GetSettingsStringError({required this.message});

  final String message;

  @override
  List<Object?> get props => [message];
}