///
/// Generated file. Do not edit.
///
// coverage:ignore-file
// ignore_for_file: type=lint, unused_import
// dart format off

import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';
import 'package:slang/generated.dart';
import 'translations.g.dart';

// Path: <root>
class TranslationsRu extends Translations with BaseTranslations<AppLocale, Translations> {
	/// You can call this constructor and build your own translation instance of this locale.
	/// Constructing via the enum [AppLocale.build] is preferred.
	TranslationsRu({Map<String, Node>? overrides, PluralResolver? cardinalResolver, PluralResolver? ordinalResolver, TranslationMetadata<AppLocale, Translations>? meta})
		: assert(overrides == null, 'Set "translation_overrides: true" in order to enable this feature.'),
		  $meta = meta ?? TranslationMetadata(
		    locale: AppLocale.ru,
		    overrides: overrides ?? {},
		    cardinalResolver: cardinalResolver,
		    ordinalResolver: ordinalResolver,
		  ),
		  super(cardinalResolver: cardinalResolver, ordinalResolver: ordinalResolver) {
		super.$meta.setFlatMapFunction($meta.getTranslation); // copy base translations to super.$meta
		$meta.setFlatMapFunction(_flatMapFunction);
	}

	/// Metadata for the translations of <ru>.
	@override final TranslationMetadata<AppLocale, Translations> $meta;

	/// Access flat map
	@override dynamic operator[](String key) => $meta.getTranslation(key) ?? super.$meta.getTranslation(key);

	late final TranslationsRu _root = this; // ignore: unused_field

	@override 
	TranslationsRu $copyWith({TranslationMetadata<AppLocale, Translations>? meta}) => TranslationsRu(meta: meta ?? this.$meta);

	// Translations
	@override late final _Translations$common$ru common = _Translations$common$ru._(_root);
	@override late final _Translations$componentsConnectionTitle$ru componentsConnectionTitle = _Translations$componentsConnectionTitle$ru._(_root);
	@override late final _Translations$screenHome$ru screenHome = _Translations$screenHome$ru._(_root);
	@override late final _Translations$screenChats$ru screenChats = _Translations$screenChats$ru._(_root);
	@override late final _Translations$screenSettings$ru screenSettings = _Translations$screenSettings$ru._(_root);
	@override late final _Translations$screenSettingsAppearance$ru screenSettingsAppearance = _Translations$screenSettingsAppearance$ru._(_root);
	@override late final _Translations$screenSettingsDevices$ru screenSettingsDevices = _Translations$screenSettingsDevices$ru._(_root);
	@override late final _Translations$screenSettingsAboutApplication$ru screenSettingsAboutApplication = _Translations$screenSettingsAboutApplication$ru._(_root);
	@override late final _Translations$screenSettingsLanguage$ru screenSettingsLanguage = _Translations$screenSettingsLanguage$ru._(_root);
	@override late final _Translations$screenSettingsPasscode$ru screenSettingsPasscode = _Translations$screenSettingsPasscode$ru._(_root);
	@override late final _Translations$settingsPasscodeCreate$ru settingsPasscodeCreate = _Translations$settingsPasscodeCreate$ru._(_root);
	@override late final _Translations$sessionsPrivacyAndSecurity$ru sessionsPrivacyAndSecurity = _Translations$sessionsPrivacyAndSecurity$ru._(_root);
	@override late final _Translations$screenMyProfile$ru screenMyProfile = _Translations$screenMyProfile$ru._(_root);
	@override late final _Translations$screenAuth$ru screenAuth = _Translations$screenAuth$ru._(_root);
	@override late final _Translations$screenAuthModerationApplicationStore$ru screenAuthModerationApplicationStore = _Translations$screenAuthModerationApplicationStore$ru._(_root);
	@override late final _Translations$screenAuthCallpasswordConfirmation$ru screenAuthCallpasswordConfirmation = _Translations$screenAuthCallpasswordConfirmation$ru._(_root);
	@override late final _Translations$grpcError$ru grpcError = _Translations$grpcError$ru._(_root);
	@override late final _Translations$dateTime$ru dateTime = _Translations$dateTime$ru._(_root);
}

// Path: common
class _Translations$common$ru extends Translations$common$en {
	_Translations$common$ru._(TranslationsRu root) : this._root = root, super.internal(root);

	final TranslationsRu _root; // ignore: unused_field

	// Translations
	@override String get mobilePhone => 'Номер мобильного телефона';
	@override String get kContinue => 'Продолжить';
	@override String get cancel => 'Отмена';
	@override String get back => 'Назад';
	@override String get save => 'Сохранить';
	@override String get online => 'В сети';
	@override String get done => 'Готово';
	@override String get close => 'Закрыть';
	@override String get error => 'Ошибка';
	@override String get biometricAuthenticateReason => 'Пройдите аутентификацию для разблокировки';
	@override String get biometricPleaseEnterPasscode => 'Введите код-пароль';
	@override String get edit => 'Изменить';
}

// Path: componentsConnectionTitle
class _Translations$componentsConnectionTitle$ru extends Translations$componentsConnectionTitle$en {
	_Translations$componentsConnectionTitle$ru._(TranslationsRu root) : this._root = root, super.internal(root);

	final TranslationsRu _root; // ignore: unused_field

	// Translations
	@override String get waitingForNetwork => 'Ожидание сети';
	@override String get connecting => 'Подключение';
	@override String get updating => 'Обновление';
}

// Path: screenHome
class _Translations$screenHome$ru extends Translations$screenHome$en {
	_Translations$screenHome$ru._(TranslationsRu root) : this._root = root, super.internal(root);

	final TranslationsRu _root; // ignore: unused_field

	// Translations
	@override String get contacts => 'Контакты';
	@override String get calls => 'Звонки';
	@override String get chats => _root.screenChats.chats;
	@override String get settings => _root.screenSettings.settings;
}

// Path: screenChats
class _Translations$screenChats$ru extends Translations$screenChats$en {
	_Translations$screenChats$ru._(TranslationsRu root) : this._root = root, super.internal(root);

	final TranslationsRu _root; // ignore: unused_field

	// Translations
	@override String get chats => 'Чаты';
}

// Path: screenSettings
class _Translations$screenSettings$ru extends Translations$screenSettings$en {
	_Translations$screenSettings$ru._(TranslationsRu root) : this._root = root, super.internal(root);

	final TranslationsRu _root; // ignore: unused_field

	// Translations
	@override String get settings => 'Настройки';
	@override String get myProfile => 'Мой профиль';
	@override String get devices => _root.screenSettingsDevices.devices;
	@override String get language => 'Язык';
	@override String get appearance => _root.screenSettingsAppearance.appearance;
	@override String get privacyAndSecurity => 'Конфиденциальность';
	@override String get aboutApplication => 'О приложении';
	@override String get logout => 'Выйти';
}

// Path: screenSettingsAppearance
class _Translations$screenSettingsAppearance$ru extends Translations$screenSettingsAppearance$en {
	_Translations$screenSettingsAppearance$ru._(TranslationsRu root) : this._root = root, super.internal(root);

	final TranslationsRu _root; // ignore: unused_field

	// Translations
	@override String get appearance => 'Оформление';
	@override String get colorTheme => 'Цветовая тема';
	@override String get colorThemeDefault => 'По умолчанию';
	@override String get colorThemeGreen => 'Зелёная';
	@override String get colorThemePurple => 'Фиолетовая';
	@override String get colorThemeOrange => 'Оранжевая';
	@override String get darkMode => 'Тёмная тема';
	@override String get darkModeSystem => 'Системная';
	@override String get darkModeAlwaysOn => 'Всегда включена';
	@override String get darkModeDisabled => 'Отключена';
	@override String get darkModeSystemDescription => 'Как в настройках устройства';
	@override String get darkModeAlwaysOnDescription => 'Тёмная тема всегда включена';
	@override String get darkModeDisabledDescription => 'Тёмная тема отключена';
	@override String get blurOnInactive => 'Размытие в неактивном состоянии';
	@override String get blurOnInactiveDescription => 'Приложение отображается размытым в списке открытых приложений';
}

// Path: screenSettingsDevices
class _Translations$screenSettingsDevices$ru extends Translations$screenSettingsDevices$en {
	_Translations$screenSettingsDevices$ru._(TranslationsRu root) : this._root = root, super.internal(root);

	final TranslationsRu _root; // ignore: unused_field

	// Translations
	@override String get devices => 'Устройства';
	@override String get thisDevice => 'Это устройство';
	@override String deviceSessionListTileSubtitle({required Object location, required Object updateAt}) => '${location} · ${updateAt}';
	@override String get terminateAllOtherDeviceSessions => 'Завершить все другие сеансы';
	@override String get activeDeviceSession => 'Активные сеансы';
	@override String get terminateDeviceSession => 'Завершить сеанс';
	@override String get areYouSureYouLogOutFromThisDevice => 'Вы уверены, что хотите выйти на этом устройстве?';
	@override String get cancel => _root.common.cancel;
	@override String get online => _root.common.online;
	@override String get terminate => 'Завершить';
}

// Path: screenSettingsAboutApplication
class _Translations$screenSettingsAboutApplication$ru extends Translations$screenSettingsAboutApplication$en {
	_Translations$screenSettingsAboutApplication$ru._(TranslationsRu root) : this._root = root, super.internal(root);

	final TranslationsRu _root; // ignore: unused_field

	// Translations
	@override String get aboutApplication => _root.screenSettings.aboutApplication;
	@override String version({required Object version, required Object build}) => 'Версия ${version} (${build})';
	@override String get licenses => 'Лицензии';
	@override String licensesCount({required Object n}) => 'Лицензий: ${n}';
	@override String get noLicenses => 'Лицензии не найдены';
}

// Path: screenSettingsLanguage
class _Translations$screenSettingsLanguage$ru extends Translations$screenSettingsLanguage$en {
	_Translations$screenSettingsLanguage$ru._(TranslationsRu root) : this._root = root, super.internal(root);

	final TranslationsRu _root; // ignore: unused_field

	// Translations
	@override String get language => 'Язык';
}

// Path: screenSettingsPasscode
class _Translations$screenSettingsPasscode$ru extends Translations$screenSettingsPasscode$en {
	_Translations$screenSettingsPasscode$ru._(TranslationsRu root) : this._root = root, super.internal(root);

	final TranslationsRu _root; // ignore: unused_field

	// Translations
	@override String get passcode => 'Код-пароль';
	@override String get passcodeAndFaceID => 'Код-пароль и Face ID';
	@override String get note => 'Примечание: если вы забудете код-пароль, потребуется переустановить приложение';
	@override String get turnOn => 'Включить код-пароль';
	@override String get turnOff => 'Отключить код-пароль';
	@override String get change => 'Изменить код-пароль';
	@override String get autoLock => 'Автоблокировка';
	@override String get faceIDUnlock => 'Разблокировка с Face ID';
	@override String get autoLockOff => 'Выключена';
	@override String autoLockMinutes({required num n}) => (_root.$meta.cardinalResolver ?? PluralResolvers.cardinal('ru'))(n,
		one: 'Через ${n} минуту',
		other: 'Через ${n} минут',
	);
	@override String autoLockHours({required num n}) => (_root.$meta.cardinalResolver ?? PluralResolvers.cardinal('ru'))(n,
		one: 'Через ${n} час',
		other: 'Через ${n} часов',
	);
	@override String get pleaseEnterPasscode => 'Введите код-пароль';
	@override String get cancel => _root.common.cancel;
}

// Path: settingsPasscodeCreate
class _Translations$settingsPasscodeCreate$ru extends Translations$settingsPasscodeCreate$en {
	_Translations$settingsPasscodeCreate$ru._(TranslationsRu root) : this._root = root, super.internal(root);

	final TranslationsRu _root; // ignore: unused_field

	// Translations
	@override String get pleaseEnterNewPasscode => 'Введите новый код-пароль';
	@override String get pleaseEnterNewPasscodeAgain => 'Введите новый код-пароль ещё раз';
	@override String get cancel => _root.common.cancel;
}

// Path: sessionsPrivacyAndSecurity
class _Translations$sessionsPrivacyAndSecurity$ru extends Translations$sessionsPrivacyAndSecurity$en {
	_Translations$sessionsPrivacyAndSecurity$ru._(TranslationsRu root) : this._root = root, super.internal(root);

	final TranslationsRu _root; // ignore: unused_field

	// Translations
	@override String get privacyAndSecurity => 'Конфиденциальность';
	@override String get passcodeAndFaceID => 'Код-пароль и Face ID';
	@override String get passcode => 'Код-пароль';
}

// Path: screenMyProfile
class _Translations$screenMyProfile$ru extends Translations$screenMyProfile$en {
	_Translations$screenMyProfile$ru._(TranslationsRu root) : this._root = root, super.internal(root);

	final TranslationsRu _root; // ignore: unused_field

	// Translations
	@override String get myprofile => 'Мой профиль';
	@override String get firstName => 'Имя';
	@override String get lastName => 'Фамилия';
	@override String get aboutMe => 'О себе';
	@override String get tellUsAboutYourself => 'Расскажите о себе';
	@override String get add => 'Указать';
	@override String get birthDate => 'Дата рождения';
	@override String get username => 'Имя пользователя';
	@override String get validationFirstNameMaxLength => 'Должно содержать не более 25 символов';
	@override String get validationLastNameMaxLength => 'Должно содержать не более 25 символов';
	@override String get validationAboutMeMaxLength => 'Должно содержать не более 140 символов';
	@override String get cancel => _root.common.cancel;
	@override String get done => _root.common.done;
	@override String get edit => _root.common.edit;
	@override String get close => _root.common.close;
	@override String get error => _root.common.error;
	@override String get errorSavingProfile => 'Сохранение профиля';
	@override String birthDayFormat({required Object date}) => '${date}';
	@override String get birthDayRemove => 'Удалить дату рождения';
	@override String get editPhoto => 'Изменить фото';
	@override String get takePhoto => 'Сделать фото';
	@override String get chooseFromGallery => 'Выбрать из галереи';
	@override String get chooseFile => 'Файл';
	@override String get chooseEmoji => 'Эмодзи';
	@override String get chooseLink => 'Ссылка';
	@override String get mobilePhone => 'Номер телефона';
	@override String get number => 'Номер';
	@override String get copy => 'Скопировать';
	@override String get copied => 'Скопировано';
}

// Path: screenAuth
class _Translations$screenAuth$ru extends Translations$screenAuth$en {
	_Translations$screenAuth$ru._(TranslationsRu root) : this._root = root, super.internal(root);

	final TranslationsRu _root; // ignore: unused_field

	// Translations
	@override String get enterYourMobilePhoneNumber => 'Введите номер мобильного телефона';
	@override String get currentlyWeOnlySupportPhoneNumbersFromRussianMobileOperators => 'Сейчас мы поддерживаем только номера российских мобильных операторов';
	@override String get insertDebugPhone => 'Вставить тестовый номер';
	@override String get callForFree => 'Позвонить бесплатно';
	@override String weAreExpectingYourCallWithin({required Object duration}) => 'Мы ждём вашего звонка в течение ${duration}';
	@override String get signInWith => 'Войти через';
	@override String get kContinue => _root.common.kContinue;
	@override String get invalidPhoneNumber => 'Неверный номер телефона';
}

// Path: screenAuthModerationApplicationStore
class _Translations$screenAuthModerationApplicationStore$ru extends Translations$screenAuthModerationApplicationStore$en {
	_Translations$screenAuthModerationApplicationStore$ru._(TranslationsRu root) : this._root = root, super.internal(root);

	final TranslationsRu _root; // ignore: unused_field

	// Translations
	@override String get verificationCodeMismatch => 'Неверный код подтверждения';
	@override String get moderationApplicationStoreSessionNotFound => 'Сессия не найдена';
	@override String get invalidPublicSharedKey => 'Неверный публичный общий ключ';
	@override String get invalidPublicSaltKey => 'Неверный публичный ключ соли';
	@override String get enterTheCode => 'Введите код';
	@override String sentConfirmationCodeToNumber({required Object phoneNumber}) => 'Мы отправили код подтверждения на номер ${phoneNumber}';
	@override String get signatureVerificationFailed => 'Не удалось проверить подпись';
}

// Path: screenAuthCallpasswordConfirmation
class _Translations$screenAuthCallpasswordConfirmation$ru extends Translations$screenAuthCallpasswordConfirmation$en {
	_Translations$screenAuthCallpasswordConfirmation$ru._(TranslationsRu root) : this._root = root, super.internal(root);

	final TranslationsRu _root; // ignore: unused_field

	// Translations
	@override String weAreExpectingYourCallWithin({required Object duration}) => 'Мы ждём вашего звонка в течение ${duration}';
	@override String confirmYourNumberDetail({required Object confirmationPhoneNumberRu}) => 'Позвоните на номер ${confirmationPhoneNumberRu} с указанного вами номера телефона и дождитесь сброса вызова.';
	@override String get callForFree => 'Позвонить бесплатно';
	@override String get signatureVerificationFailed => 'Не удалось проверить подпись';
}

// Path: grpcError
class _Translations$grpcError$ru extends Translations$grpcError$en {
	_Translations$grpcError$ru._(TranslationsRu root) : this._root = root, super.internal(root);

	final TranslationsRu _root; // ignore: unused_field

	// Translations
	@override String get errorConnectingServer => 'Ошибка подключения к серверу';
	@override String get unauthenticated => 'Неавторизован';
	@override String get unableConnectServer => 'Не удалось подключиться к серверу';
	@override String get internalServerError => 'Внутренняя ошибка сервера';
	@override String get unknownError => 'Unknown error';
}

// Path: dateTime
class _Translations$dateTime$ru extends Translations$dateTime$en {
	_Translations$dateTime$ru._(TranslationsRu root) : this._root = root, super.internal(root);

	final TranslationsRu _root; // ignore: unused_field

	// Translations
	@override String relativeDateTimeToday({required Object time}) => 'сегодня в ${time}';
	@override String relativeDateTimeYesterday({required Object time}) => 'вчера в ${time}';
	@override String relativeDateTimeOther({required Object date, required Object time}) => '${date} в ${time}';
}

/// The flat map containing all translations for locale <ru>.
/// Only for edge cases! For simple maps, use the map function of this library.
///
/// The Dart AOT compiler has issues with very large switch statements,
/// so the map is split into smaller functions (512 entries each).
extension on TranslationsRu {
	dynamic _flatMapFunction(String path) {
		return switch (path) {
			'common.mobilePhone' => 'Номер мобильного телефона',
			'common.kContinue' => 'Продолжить',
			'common.cancel' => 'Отмена',
			'common.back' => 'Назад',
			'common.save' => 'Сохранить',
			'common.online' => 'В сети',
			'common.done' => 'Готово',
			'common.close' => 'Закрыть',
			'common.error' => 'Ошибка',
			'common.biometricAuthenticateReason' => 'Пройдите аутентификацию для разблокировки',
			'common.biometricPleaseEnterPasscode' => 'Введите код-пароль',
			'common.edit' => 'Изменить',
			'componentsConnectionTitle.waitingForNetwork' => 'Ожидание сети',
			'componentsConnectionTitle.connecting' => 'Подключение',
			'componentsConnectionTitle.updating' => 'Обновление',
			'screenHome.contacts' => 'Контакты',
			'screenHome.calls' => 'Звонки',
			'screenHome.chats' => _root.screenChats.chats,
			'screenHome.settings' => _root.screenSettings.settings,
			'screenChats.chats' => 'Чаты',
			'screenSettings.settings' => 'Настройки',
			'screenSettings.myProfile' => 'Мой профиль',
			'screenSettings.devices' => _root.screenSettingsDevices.devices,
			'screenSettings.language' => 'Язык',
			'screenSettings.appearance' => _root.screenSettingsAppearance.appearance,
			'screenSettings.privacyAndSecurity' => 'Конфиденциальность',
			'screenSettings.aboutApplication' => 'О приложении',
			'screenSettings.logout' => 'Выйти',
			'screenSettingsAppearance.appearance' => 'Оформление',
			'screenSettingsAppearance.colorTheme' => 'Цветовая тема',
			'screenSettingsAppearance.colorThemeDefault' => 'По умолчанию',
			'screenSettingsAppearance.colorThemeGreen' => 'Зелёная',
			'screenSettingsAppearance.colorThemePurple' => 'Фиолетовая',
			'screenSettingsAppearance.colorThemeOrange' => 'Оранжевая',
			'screenSettingsAppearance.darkMode' => 'Тёмная тема',
			'screenSettingsAppearance.darkModeSystem' => 'Системная',
			'screenSettingsAppearance.darkModeAlwaysOn' => 'Всегда включена',
			'screenSettingsAppearance.darkModeDisabled' => 'Отключена',
			'screenSettingsAppearance.darkModeSystemDescription' => 'Как в настройках устройства',
			'screenSettingsAppearance.darkModeAlwaysOnDescription' => 'Тёмная тема всегда включена',
			'screenSettingsAppearance.darkModeDisabledDescription' => 'Тёмная тема отключена',
			'screenSettingsAppearance.blurOnInactive' => 'Размытие в неактивном состоянии',
			'screenSettingsAppearance.blurOnInactiveDescription' => 'Приложение отображается размытым в списке открытых приложений',
			'screenSettingsDevices.devices' => 'Устройства',
			'screenSettingsDevices.thisDevice' => 'Это устройство',
			'screenSettingsDevices.deviceSessionListTileSubtitle' => ({required Object location, required Object updateAt}) => '${location} · ${updateAt}',
			'screenSettingsDevices.terminateAllOtherDeviceSessions' => 'Завершить все другие сеансы',
			'screenSettingsDevices.activeDeviceSession' => 'Активные сеансы',
			'screenSettingsDevices.terminateDeviceSession' => 'Завершить сеанс',
			'screenSettingsDevices.areYouSureYouLogOutFromThisDevice' => 'Вы уверены, что хотите выйти на этом устройстве?',
			'screenSettingsDevices.cancel' => _root.common.cancel,
			'screenSettingsDevices.online' => _root.common.online,
			'screenSettingsDevices.terminate' => 'Завершить',
			'screenSettingsAboutApplication.aboutApplication' => _root.screenSettings.aboutApplication,
			'screenSettingsAboutApplication.version' => ({required Object version, required Object build}) => 'Версия ${version} (${build})',
			'screenSettingsAboutApplication.licenses' => 'Лицензии',
			'screenSettingsAboutApplication.licensesCount' => ({required Object n}) => 'Лицензий: ${n}',
			'screenSettingsAboutApplication.noLicenses' => 'Лицензии не найдены',
			'screenSettingsLanguage.language' => 'Язык',
			'screenSettingsPasscode.passcode' => 'Код-пароль',
			'screenSettingsPasscode.passcodeAndFaceID' => 'Код-пароль и Face ID',
			'screenSettingsPasscode.note' => 'Примечание: если вы забудете код-пароль, потребуется переустановить приложение',
			'screenSettingsPasscode.turnOn' => 'Включить код-пароль',
			'screenSettingsPasscode.turnOff' => 'Отключить код-пароль',
			'screenSettingsPasscode.change' => 'Изменить код-пароль',
			'screenSettingsPasscode.autoLock' => 'Автоблокировка',
			'screenSettingsPasscode.faceIDUnlock' => 'Разблокировка с Face ID',
			'screenSettingsPasscode.autoLockOff' => 'Выключена',
			'screenSettingsPasscode.autoLockMinutes' => ({required num n}) => (_root.$meta.cardinalResolver ?? PluralResolvers.cardinal('ru'))(n, one: 'Через ${n} минуту', other: 'Через ${n} минут', ), 
			'screenSettingsPasscode.autoLockHours' => ({required num n}) => (_root.$meta.cardinalResolver ?? PluralResolvers.cardinal('ru'))(n, one: 'Через ${n} час', other: 'Через ${n} часов', ), 
			'screenSettingsPasscode.pleaseEnterPasscode' => 'Введите код-пароль',
			'screenSettingsPasscode.cancel' => _root.common.cancel,
			'settingsPasscodeCreate.pleaseEnterNewPasscode' => 'Введите новый код-пароль',
			'settingsPasscodeCreate.pleaseEnterNewPasscodeAgain' => 'Введите новый код-пароль ещё раз',
			'settingsPasscodeCreate.cancel' => _root.common.cancel,
			'sessionsPrivacyAndSecurity.privacyAndSecurity' => 'Конфиденциальность',
			'sessionsPrivacyAndSecurity.passcodeAndFaceID' => 'Код-пароль и Face ID',
			'sessionsPrivacyAndSecurity.passcode' => 'Код-пароль',
			'screenMyProfile.myprofile' => 'Мой профиль',
			'screenMyProfile.firstName' => 'Имя',
			'screenMyProfile.lastName' => 'Фамилия',
			'screenMyProfile.aboutMe' => 'О себе',
			'screenMyProfile.tellUsAboutYourself' => 'Расскажите о себе',
			'screenMyProfile.add' => 'Указать',
			'screenMyProfile.birthDate' => 'Дата рождения',
			'screenMyProfile.username' => 'Имя пользователя',
			'screenMyProfile.validationFirstNameMaxLength' => 'Должно содержать не более 25 символов',
			'screenMyProfile.validationLastNameMaxLength' => 'Должно содержать не более 25 символов',
			'screenMyProfile.validationAboutMeMaxLength' => 'Должно содержать не более 140 символов',
			'screenMyProfile.cancel' => _root.common.cancel,
			'screenMyProfile.done' => _root.common.done,
			'screenMyProfile.edit' => _root.common.edit,
			'screenMyProfile.close' => _root.common.close,
			'screenMyProfile.error' => _root.common.error,
			'screenMyProfile.errorSavingProfile' => 'Сохранение профиля',
			'screenMyProfile.birthDayFormat' => ({required Object date}) => '${date}',
			'screenMyProfile.birthDayRemove' => 'Удалить дату рождения',
			'screenMyProfile.editPhoto' => 'Изменить фото',
			'screenMyProfile.takePhoto' => 'Сделать фото',
			'screenMyProfile.chooseFromGallery' => 'Выбрать из галереи',
			'screenMyProfile.chooseFile' => 'Файл',
			'screenMyProfile.chooseEmoji' => 'Эмодзи',
			'screenMyProfile.chooseLink' => 'Ссылка',
			'screenMyProfile.mobilePhone' => 'Номер телефона',
			'screenMyProfile.number' => 'Номер',
			'screenMyProfile.copy' => 'Скопировать',
			'screenMyProfile.copied' => 'Скопировано',
			'screenAuth.enterYourMobilePhoneNumber' => 'Введите номер мобильного телефона',
			'screenAuth.currentlyWeOnlySupportPhoneNumbersFromRussianMobileOperators' => 'Сейчас мы поддерживаем только номера российских мобильных операторов',
			'screenAuth.insertDebugPhone' => 'Вставить тестовый номер',
			'screenAuth.callForFree' => 'Позвонить бесплатно',
			'screenAuth.weAreExpectingYourCallWithin' => ({required Object duration}) => 'Мы ждём вашего звонка в течение ${duration}',
			'screenAuth.signInWith' => 'Войти через',
			'screenAuth.kContinue' => _root.common.kContinue,
			'screenAuth.invalidPhoneNumber' => 'Неверный номер телефона',
			'screenAuthModerationApplicationStore.verificationCodeMismatch' => 'Неверный код подтверждения',
			'screenAuthModerationApplicationStore.moderationApplicationStoreSessionNotFound' => 'Сессия не найдена',
			'screenAuthModerationApplicationStore.invalidPublicSharedKey' => 'Неверный публичный общий ключ',
			'screenAuthModerationApplicationStore.invalidPublicSaltKey' => 'Неверный публичный ключ соли',
			'screenAuthModerationApplicationStore.enterTheCode' => 'Введите код',
			'screenAuthModerationApplicationStore.sentConfirmationCodeToNumber' => ({required Object phoneNumber}) => 'Мы отправили код подтверждения на номер ${phoneNumber}',
			'screenAuthModerationApplicationStore.signatureVerificationFailed' => 'Не удалось проверить подпись',
			'screenAuthCallpasswordConfirmation.weAreExpectingYourCallWithin' => ({required Object duration}) => 'Мы ждём вашего звонка в течение ${duration}',
			'screenAuthCallpasswordConfirmation.confirmYourNumberDetail' => ({required Object confirmationPhoneNumberRu}) => 'Позвоните на номер ${confirmationPhoneNumberRu} с указанного вами номера телефона и дождитесь сброса вызова.',
			'screenAuthCallpasswordConfirmation.callForFree' => 'Позвонить бесплатно',
			'screenAuthCallpasswordConfirmation.signatureVerificationFailed' => 'Не удалось проверить подпись',
			'grpcError.errorConnectingServer' => 'Ошибка подключения к серверу',
			'grpcError.unauthenticated' => 'Неавторизован',
			'grpcError.unableConnectServer' => 'Не удалось подключиться к серверу',
			'grpcError.internalServerError' => 'Внутренняя ошибка сервера',
			'grpcError.unknownError' => 'Unknown error',
			'dateTime.relativeDateTimeToday' => ({required Object time}) => 'сегодня в ${time}',
			'dateTime.relativeDateTimeYesterday' => ({required Object time}) => 'вчера в ${time}',
			'dateTime.relativeDateTimeOther' => ({required Object date, required Object time}) => '${date} в ${time}',
			_ => null,
		};
	}
}
