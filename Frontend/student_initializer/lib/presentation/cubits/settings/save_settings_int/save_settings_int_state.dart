part of 'save_settings_int_cubit.dart';

sealed class SaveSettingsIntState extends Equatable {
  const SaveSettingsIntState();

  @override
  List<Object?> get props => [];
}

final class SaveSettingsIntInit extends SaveSettingsIntState {
  const SaveSettingsIntInit();
}

final class SaveSettingsIntLoading extends SaveSettingsIntState {
  const SaveSettingsIntLoading();
}

final class SaveSettingsIntSuccess extends SaveSettingsIntState {
  const SaveSettingsIntSuccess();
}

final class SaveSettingsIntError extends SaveSettingsIntState {
  const SaveSettingsIntError({required this.message});

  final String message;

  @override
  List<Object?> get props => [message];
}
