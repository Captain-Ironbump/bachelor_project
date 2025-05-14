part of 'save_settings_string_cubit.dart';

sealed class SaveSettingsStringState extends Equatable {
  const SaveSettingsStringState();

  @override
  List<Object?> get props => [];
}

final class SaveSettingsStringInit extends SaveSettingsStringState {
  const SaveSettingsStringInit();
}

final class SaveSettingsStringLoading extends SaveSettingsStringState {
  const SaveSettingsStringLoading();
}

final class SaveSettingsStringSuccess extends SaveSettingsStringState {
  const SaveSettingsStringSuccess();
}

final class SaveSettingsStringError extends SaveSettingsStringState {
  const SaveSettingsStringError({required this.message});

  final String message;

  @override
  List<Object?> get props => [message];
}