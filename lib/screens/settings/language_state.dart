part of 'language_cubit.dart';

@freezed
abstract class LanguageState with _$LanguageState {
    const LanguageState._();

  const factory LanguageState({
    @Default(Status.initial) Status status,
    @Default("") String errorMessage,
    @Default(AppLocale.en) AppLocale currentLanguage,
    @Default(AppLocale.en) AppLocale selectedLanguage,
  }) = _LanguageState;
}
