part of 'save_settings_bool_cubit.dart';

sealed class SaveSettingsBoolState extends Equatable {
  const SaveSettingsBoolState();

  @override
  List<Object?> get props => [];
}

final class SaveSettingsBoolInit extends SaveSettingsBoolState {
  const SaveSettingsBoolInit();
}

final class SaveSettingsBoolLoading extends SaveSettingsBoolState {
  const SaveSettingsBoolLoading();
}

final class SaveSettingsBoolSuccess extends SaveSettingsBoolState {
  const SaveSettingsBoolSuccess();
}

final class SaveSettingsBoolError extends SaveSettingsBoolState {
  const SaveSettingsBoolError({required this.message});

  final String message;

  @override
  List<Object?> get props => [message];
}