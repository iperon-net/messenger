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
	@override String get unknownError => 'Неизвестная ошибка';
	@override String get internalServerError => 'Внутренняя ошибка сервера';
	@override String get logs => 'Логи';
	@override String get organizationServerUrl => 'URL-адрес сервера организации';
	@override String get organizationServerUrlHelper => 'URL-адрес вы можете уточнить у администратора организации';
	@override String get next => 'Далее';
	@override String get invalidOrganizationServerUrl => 'Неверный URL-адрес сервера организации';
	@override String get serverNotSupportAppVersion => 'Сервер не поддерживает данную версию приложения';
	@override String get mobilePhone => 'Мобильный номер телефона';
	@override String get enterYourMobilePhoneNumber => 'Введите мобильный номер телефона';
	@override String get errorConnectingToTheServer => 'Ошибка подключения к серверу';
	@override String get unableToConnectToTheServer => 'Невозможно подключиться к серверу';
	@override String get confirmYourNumber => 'Подтвердите номер';
	@override String confirmYourNumberDetail({required Object confirmationPhoneNumberRu}) => 'Позвоните на номер ${confirmationPhoneNumberRu} с телефона который указали и дождитесь сброса звонка';
	@override String get callForFree => 'Позвонить бесплатно';
	@override String get close => 'Закрыть';
	@override String weAreExpectingYourCallWithin({required Object duration}) => 'Ожидаем вашего звонка в течении ${duration}';
	@override String get currentlyWeOnlySupportPhoneNumbersFromRussianMobileOperators => 'В настоящие время мы поддерживаем только номера российских сотовых операторов';
	@override String get kContinue => 'Продолжить';
	@override String get loginInWith => 'Войти с помощью';
	@override String get signatureVerificationError => 'Ошибка проверка подписи';
	@override String get contacts => 'Контакты';
	@override String get calls => 'Звонки';
	@override String get chats => 'Чаты';
	@override String get settings => 'Настройки';
	@override String get language => 'Язык';
	@override String get appearance => 'Оформление';
	@override String get myProfile => 'Мой профиль';
	@override String get privateAndSecurity => 'Конфиденциальность';
	@override String get notifications => 'Уведомления';
	@override String get faq => 'FAQ';
	@override String get privacyPolicy => 'Политика конфиденциальности';
	@override String get colorTheme => 'Цветовая схема';
	@override String get colorThemeDefault => 'По умолчанию';
	@override String get colorThemeGreen => 'Зеленая';
	@override String get colorThemePurple => 'Пурпурная';
	@override String get darkMode => 'Темный режим';
	@override String get darkModeSystem => 'Системный';
	@override String get darkModeAlwaysOn => 'Всегда включено';
	@override String get darkModeDisabled => 'Отключено';
	@override String get darkModeSystemDescription => 'Как в настройках устройства';
	@override String get darkModeAlwaysOnDescription => 'Тёмный режим всегда включён';
	@override String get darkModeDisabledDescription => 'Тёмный режим отключён';
}

/// The flat map containing all translations for locale <ru>.
/// Only for edge cases! For simple maps, use the map function of this library.
///
/// The Dart AOT compiler has issues with very large switch statements,
/// so the map is split into smaller functions (512 entries each).
extension on TranslationsRu {
	dynamic _flatMapFunction(String path) {
		return switch (path) {
			'unknownError' => 'Неизвестная ошибка',
			'internalServerError' => 'Внутренняя ошибка сервера',
			'logs' => 'Логи',
			'organizationServerUrl' => 'URL-адрес сервера организации',
			'organizationServerUrlHelper' => 'URL-адрес вы можете уточнить у администратора организации',
			'next' => 'Далее',
			'invalidOrganizationServerUrl' => 'Неверный URL-адрес сервера организации',
			'serverNotSupportAppVersion' => 'Сервер не поддерживает данную версию приложения',
			'mobilePhone' => 'Мобильный номер телефона',
			'enterYourMobilePhoneNumber' => 'Введите мобильный номер телефона',
			'errorConnectingToTheServer' => 'Ошибка подключения к серверу',
			'unableToConnectToTheServer' => 'Невозможно подключиться к серверу',
			'confirmYourNumber' => 'Подтвердите номер',
			'confirmYourNumberDetail' => ({required Object confirmationPhoneNumberRu}) => 'Позвоните на номер ${confirmationPhoneNumberRu} с телефона который указали и дождитесь сброса звонка',
			'callForFree' => 'Позвонить бесплатно',
			'close' => 'Закрыть',
			'weAreExpectingYourCallWithin' => ({required Object duration}) => 'Ожидаем вашего звонка в течении ${duration}',
			'currentlyWeOnlySupportPhoneNumbersFromRussianMobileOperators' => 'В настоящие время мы поддерживаем только номера российских сотовых операторов',
			'kContinue' => 'Продолжить',
			'loginInWith' => 'Войти с помощью',
			'signatureVerificationError' => 'Ошибка проверка подписи',
			'contacts' => 'Контакты',
			'calls' => 'Звонки',
			'chats' => 'Чаты',
			'settings' => 'Настройки',
			'language' => 'Язык',
			'appearance' => 'Оформление',
			'myProfile' => 'Мой профиль',
			'privateAndSecurity' => 'Конфиденциальность',
			'notifications' => 'Уведомления',
			'faq' => 'FAQ',
			'privacyPolicy' => 'Политика конфиденциальности',
			'colorTheme' => 'Цветовая схема',
			'colorThemeDefault' => 'По умолчанию',
			'colorThemeGreen' => 'Зеленая',
			'colorThemePurple' => 'Пурпурная',
			'darkMode' => 'Темный режим',
			'darkModeSystem' => 'Системный',
			'darkModeAlwaysOn' => 'Всегда включено',
			'darkModeDisabled' => 'Отключено',
			'darkModeSystemDescription' => 'Как в настройках устройства',
			'darkModeAlwaysOnDescription' => 'Тёмный режим всегда включён',
			'darkModeDisabledDescription' => 'Тёмный режим отключён',
			_ => null,
		};
	}
}
