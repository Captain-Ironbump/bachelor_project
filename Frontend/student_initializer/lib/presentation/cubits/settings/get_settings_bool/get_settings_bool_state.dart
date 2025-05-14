part of 'get_settings_bool_cubit.dart';

sealed class GetSettingsBoolState extends Equatable {
  const GetSettingsBoolState();

  @override
  List<Object?> get props => [];
}

final class GetSettingsBoolInit extends GetSettingsBoolState {
  const GetSettingsBoolInit();
}

final class GetSettingsBoolLoading extends GetSettingsBoolState {
  const GetSettingsBoolLoading();
}

final class GetSettingsBoolLoaded extends GetSettingsBoolState {
  const GetSettingsBoolLoaded({required this.value});

  final bool? value;

  @override
  List<Object?> get props => [value];
}

final class GetSettingsBoolError extends GetSettingsBoolState {
  const GetSettingsBoolError({required this.message});

  final String message;

  @override
  List<Object?> get props => [message];
}
