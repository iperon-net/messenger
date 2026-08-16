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
	@override late final _Translations$auth$ru auth = _Translations$auth$ru._(_root);
	@override late final _Translations$settings$ru settings = _Translations$settings$ru._(_root);
	@override late final _Translations$common$ru common = _Translations$common$ru._(_root);
	@override late final _Translations$connection$ru connection = _Translations$connection$ru._(_root);
	@override late final _Translations$grpcError$ru grpcError = _Translations$grpcError$ru._(_root);
	@override late final _Translations$dateTime$ru dateTime = _Translations$dateTime$ru._(_root);
}

// Path: auth
class _Translations$auth$ru extends Translations$auth$en {
	_Translations$auth$ru._(TranslationsRu root) : this._root = root, super.internal(root);

	final TranslationsRu _root; // ignore: unused_field

	// Translations
	@override String get enterYourMobilePhoneNumber => 'Введите номер мобильного телефона';
	@override String get currentlyWeOnlySupportPhoneNumbersFromRussianMobileOperators => 'В настоящее время мы поддерживаем только номера российских мобильных операторов';
	@override String get phoneNumberDoesNotMatchAllowedRegion => 'Номер телефона не соответствует разрешённому региону';
	@override String get enterTheCode => 'Введите код';
	@override String sentConfirmationCodeToNumber({required Object phoneNumber}) => 'Мы отправили код подтверждения на номер ${phoneNumber}';
	@override String get insertDebugPhone => 'Вставить отладочный номер';
	@override String confirmYourNumberDetail({required Object confirmationPhoneNumberRu}) => 'Позвоните на номер ${confirmationPhoneNumberRu} с телефона который указали и дождитесь сброса звонка';
	@override String get callForFree => 'Позвонить бесплатно';
	@override String weAreExpectingYourCallWithin({required Object duration}) => 'Ожидаем вашего звонка в течении ${duration}';
	@override String get loginInWith => 'Войти с помощью';
}

// Path: settings
class _Translations$settings$ru extends Translations$settings$en {
	_Translations$settings$ru._(TranslationsRu root) : this._root = root, super.internal(root);

	final TranslationsRu _root; // ignore: unused_field

	// Translations
	@override String get myProfile => 'Мой профиль';
	@override String get logout => 'Выйти';
	@override String get devices => 'Устройства';
	@override String get language => 'Язык';
	@override String get appearance => 'Оформление';
	@override String get privacyAndSecurity => 'Конфиденциальность';
	@override String get colorTheme => 'Цветовая схема';
	@override String get colorThemeDefault => 'По умолчанию';
	@override String get colorThemeGreen => 'Зеленая';
	@override String get colorThemePurple => 'Пурпурный';
	@override String get colorThemeRed => 'Красная';
	@override String get darkMode => 'Тёмный режим';
	@override String get darkModeSystem => 'Системный';
	@override String get darkModeAlwaysOn => 'Всегда включено';
	@override String get darkModeDisabled => 'Отключено';
	@override String get darkModeSystemDescription => 'Как в настройках устройства';
	@override String get darkModeAlwaysOnDescription => 'Тёмный режим всегда включён';
	@override String get darkModeDisabledDescription => 'Тёмный режим отключён';
	@override String get thisDevice => 'Это устройство';
	@override String deviceSessionListTileSubtitle({required Object location, required Object updateAt}) => '${location} · ${updateAt}';
	@override String get online => 'Онлайн';
	@override String get terminateAllOtherDeviceSessions => 'Завершить сеансы, кроме текущего';
	@override String get activeDeviceSession => 'Активные сеансы';
	@override String get terminateDeviceSession => 'Завершить сеанс';
	@override String get areYouSureYouLogOutFromThisDevice => 'Вы уверены, что хотите выйти на этом устройстве?';
	@override String get terminate => 'Завершить';
	@override String get blurOnInactive => 'Размытие при фоне';
	@override String get blurOnInactiveDescription => 'В списке открытых приложений приложение отображается размытым';
	@override String get passcodeAndFaceID => 'Код-пароль и Face ID';
	@override late final _Translations$settings$passcode$ru passcode = _Translations$settings$passcode$ru._(_root);
}

// Path: common
class _Translations$common$ru extends Translations$common$en {
	_Translations$common$ru._(TranslationsRu root) : this._root = root, super.internal(root);

	final TranslationsRu _root; // ignore: unused_field

	// Translations
	@override String get mobilePhone => 'Номер мобильного телефона';
	@override String get kContinue => 'Продолжить';
	@override String get contacts => 'Контакты';
	@override String get calls => 'Звонки';
	@override String get chats => 'Чаты';
	@override String get settings => 'Настройки';
	@override String get cancel => 'Отмена';
}

// Path: connection
class _Translations$connection$ru extends Translations$connection$en {
	_Translations$connection$ru._(TranslationsRu root) : this._root = root, super.internal(root);

	final TranslationsRu _root; // ignore: unused_field

	// Translations
	@override String get waitingForNetwork => 'Ожидание сети';
	@override String get connecting => 'Соединение';
	@override String get updating => 'Обновление';
}

// Path: grpcError
class _Translations$grpcError$ru extends Translations$grpcError$en {
	_Translations$grpcError$ru._(TranslationsRu root) : this._root = root, super.internal(root);

	final TranslationsRu _root; // ignore: unused_field

	// Translations
	@override String get errorConnectingServer => 'Ошибка подключения к серверу';
	@override String get unableConnectServer => 'Не удалось подключиться к серверу';
	@override String get internalServerError => 'Внутренняя ошибка сервера';
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

// Path: settings.passcode
class _Translations$settings$passcode$ru extends Translations$settings$passcode$en {
	_Translations$settings$passcode$ru._(TranslationsRu root) : this._root = root, super.internal(root);

	final TranslationsRu _root; // ignore: unused_field

	// Translations
	@override String get passcodeTurnOn => 'Включить код-пароль';
	@override String get passcodeTurnOff => 'Выключить код-пароль';
	@override String get pleaseEnterPasscode => 'Введите код-пароль';
	@override String get authenticateReason => 'Подтвердите личность для входа';
	@override String get pleaseEnterNewPasscode => 'Введите новый код-пароль';
	@override String get pleaseEnterNewPasscodeAgain => 'Введите новый код-пароль ещё раз';
	@override String get changePasscode => 'Изменить код-пароль';
	@override String get note => 'Важно: если Вы забудете код-пароль, Вам придётся переустановить приложение';
	@override String get cancel => _root.common.cancel;
	@override String get autoLock => 'Автоблокировка';
	@override String get faceIDUnlock => 'Разблокировка по Face ID';
	@override String get autoLockOff => 'Выключена';
	@override String autoLockMinutes({required num n}) => (_root.$meta.cardinalResolver ?? PluralResolvers.cardinal('ru'))(n,
		one: 'через ${n} минуту',
		few: 'через ${n} минуты',
		many: 'через ${n} минут',
		other: 'через ${n} минут',
	);
	@override String autoLockHours({required num n}) => (_root.$meta.cardinalResolver ?? PluralResolvers.cardinal('ru'))(n,
		one: 'через ${n} час',
		few: 'через ${n} часа',
		many: 'через ${n} часов',
		other: 'через ${n} часов',
	);
}

/// The flat map containing all translations for locale <ru>.
/// Only for edge cases! For simple maps, use the map function of this library.
///
/// The Dart AOT compiler has issues with very large switch statements,
/// so the map is split into smaller functions (512 entries each).
extension on TranslationsRu {
	dynamic _flatMapFunction(String path) {
		return switch (path) {
			'auth.enterYourMobilePhoneNumber' => 'Введите номер мобильного телефона',
			'auth.currentlyWeOnlySupportPhoneNumbersFromRussianMobileOperators' => 'В настоящее время мы поддерживаем только номера российских мобильных операторов',
			'auth.phoneNumberDoesNotMatchAllowedRegion' => 'Номер телефона не соответствует разрешённому региону',
			'auth.enterTheCode' => 'Введите код',
			'auth.sentConfirmationCodeToNumber' => ({required Object phoneNumber}) => 'Мы отправили код подтверждения на номер ${phoneNumber}',
			'auth.insertDebugPhone' => 'Вставить отладочный номер',
			'auth.confirmYourNumberDetail' => ({required Object confirmationPhoneNumberRu}) => 'Позвоните на номер ${confirmationPhoneNumberRu} с телефона который указали и дождитесь сброса звонка',
			'auth.callForFree' => 'Позвонить бесплатно',
			'auth.weAreExpectingYourCallWithin' => ({required Object duration}) => 'Ожидаем вашего звонка в течении ${duration}',
			'auth.loginInWith' => 'Войти с помощью',
			'settings.myProfile' => 'Мой профиль',
			'settings.logout' => 'Выйти',
			'settings.devices' => 'Устройства',
			'settings.language' => 'Язык',
			'settings.appearance' => 'Оформление',
			'settings.privacyAndSecurity' => 'Конфиденциальность',
			'settings.colorTheme' => 'Цветовая схема',
			'settings.colorThemeDefault' => 'По умолчанию',
			'settings.colorThemeGreen' => 'Зеленая',
			'settings.colorThemePurple' => 'Пурпурный',
			'settings.colorThemeRed' => 'Красная',
			'settings.darkMode' => 'Тёмный режим',
			'settings.darkModeSystem' => 'Системный',
			'settings.darkModeAlwaysOn' => 'Всегда включено',
			'settings.darkModeDisabled' => 'Отключено',
			'settings.darkModeSystemDescription' => 'Как в настройках устройства',
			'settings.darkModeAlwaysOnDescription' => 'Тёмный режим всегда включён',
			'settings.darkModeDisabledDescription' => 'Тёмный режим отключён',
			'settings.thisDevice' => 'Это устройство',
			'settings.deviceSessionListTileSubtitle' => ({required Object location, required Object updateAt}) => '${location} · ${updateAt}',
			'settings.online' => 'Онлайн',
			'settings.terminateAllOtherDeviceSessions' => 'Завершить сеансы, кроме текущего',
			'settings.activeDeviceSession' => 'Активные сеансы',
			'settings.terminateDeviceSession' => 'Завершить сеанс',
			'settings.areYouSureYouLogOutFromThisDevice' => 'Вы уверены, что хотите выйти на этом устройстве?',
			'settings.terminate' => 'Завершить',
			'settings.blurOnInactive' => 'Размытие при фоне',
			'settings.blurOnInactiveDescription' => 'В списке открытых приложений приложение отображается размытым',
			'settings.passcodeAndFaceID' => 'Код-пароль и Face ID',
			'settings.passcode.passcodeTurnOn' => 'Включить код-пароль',
			'settings.passcode.passcodeTurnOff' => 'Выключить код-пароль',
			'settings.passcode.pleaseEnterPasscode' => 'Введите код-пароль',
			'settings.passcode.authenticateReason' => 'Подтвердите личность для входа',
			'settings.passcode.pleaseEnterNewPasscode' => 'Введите новый код-пароль',
			'settings.passcode.pleaseEnterNewPasscodeAgain' => 'Введите новый код-пароль ещё раз',
			'settings.passcode.changePasscode' => 'Изменить код-пароль',
			'settings.passcode.note' => 'Важно: если Вы забудете код-пароль, Вам придётся переустановить приложение',
			'settings.passcode.cancel' => _root.common.cancel,
			'settings.passcode.autoLock' => 'Автоблокировка',
			'settings.passcode.faceIDUnlock' => 'Разблокировка по Face ID',
			'settings.passcode.autoLockOff' => 'Выключена',
			'settings.passcode.autoLockMinutes' => ({required num n}) => (_root.$meta.cardinalResolver ?? PluralResolvers.cardinal('ru'))(n, one: 'через ${n} минуту', few: 'через ${n} минуты', many: 'через ${n} минут', other: 'через ${n} минут', ), 
			'settings.passcode.autoLockHours' => ({required num n}) => (_root.$meta.cardinalResolver ?? PluralResolvers.cardinal('ru'))(n, one: 'через ${n} час', few: 'через ${n} часа', many: 'через ${n} часов', other: 'через ${n} часов', ), 
			'common.mobilePhone' => 'Номер мобильного телефона',
			'common.kContinue' => 'Продолжить',
			'common.contacts' => 'Контакты',
			'common.calls' => 'Звонки',
			'common.chats' => 'Чаты',
			'common.settings' => 'Настройки',
			'common.cancel' => 'Отмена',
			'connection.waitingForNetwork' => 'Ожидание сети',
			'connection.connecting' => 'Соединение',
			'connection.updating' => 'Обновление',
			'grpcError.errorConnectingServer' => 'Ошибка подключения к серверу',
			'grpcError.unableConnectServer' => 'Не удалось подключиться к серверу',
			'grpcError.internalServerError' => 'Внутренняя ошибка сервера',
			'dateTime.relativeDateTimeToday' => ({required Object time}) => 'сегодня в ${time}',
			'dateTime.relativeDateTimeYesterday' => ({required Object time}) => 'вчера в ${time}',
			'dateTime.relativeDateTimeOther' => ({required Object date, required Object time}) => '${date} в ${time}',
			_ => null,
		};
	}
}
