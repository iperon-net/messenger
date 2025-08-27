///
/// Generated file. Do not edit.
///
// coverage:ignore-file
// ignore_for_file: type=lint, unused_import

import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';
import 'package:slang/generated.dart';

import 'translations.g.dart';

// Path: <root>
class TranslationsRu extends Translations {
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
	@override String get notImplementedScreen => 'Не реализованный экран';
	@override late final _TranslationsUiRu ui = _TranslationsUiRu._(_root);
	@override late final _TranslationsDrawerRu drawer = _TranslationsDrawerRu._(_root);
	@override late final _TranslationsContactsRu contacts = _TranslationsContactsRu._(_root);
	@override late final _TranslationsChatsRu chats = _TranslationsChatsRu._(_root);
	@override late final _TranslationsSettingsRu settings = _TranslationsSettingsRu._(_root);
}

// Path: ui
class _TranslationsUiRu extends TranslationsUiEn {
	_TranslationsUiRu._(TranslationsRu root) : this._root = root, super.internal(root);

	final TranslationsRu _root; // ignore: unused_field

	// Translations
	@override String get settings => 'Настройки';
	@override String get cancel => 'Отмена';
	@override String get done => 'Готово';
}

// Path: drawer
class _TranslationsDrawerRu extends TranslationsDrawerEn {
	_TranslationsDrawerRu._(TranslationsRu root) : this._root = root, super.internal(root);

	final TranslationsRu _root; // ignore: unused_field

	// Translations
	@override String get settings => _root.ui.settings;
	@override String get favorites => 'Избранное';
	@override String get contacts => 'Контакты';
}

// Path: contacts
class _TranslationsContactsRu extends TranslationsContactsEn {
	_TranslationsContactsRu._(TranslationsRu root) : this._root = root, super.internal(root);

	final TranslationsRu _root; // ignore: unused_field

	// Translations
	@override String get contacts => 'Контакты';
	@override String get search => 'Поиск';
	@override late final _TranslationsContactsTabsRu tabs = _TranslationsContactsTabsRu._(_root);
}

// Path: chats
class _TranslationsChatsRu extends TranslationsChatsEn {
	_TranslationsChatsRu._(TranslationsRu root) : this._root = root, super.internal(root);

	final TranslationsRu _root; // ignore: unused_field

	// Translations
	@override String get chats => 'Чаты';
}

// Path: settings
class _TranslationsSettingsRu extends TranslationsSettingsEn {
	_TranslationsSettingsRu._(TranslationsRu root) : this._root = root, super.internal(root);

	final TranslationsRu _root; // ignore: unused_field

	// Translations
	@override String get settings => 'Настройки';
	@override String get favorites => 'Избранное';
	@override String get myPersonalInfo => 'Моя личная информация';
	@override String get myProfile => 'Мой профиль';
	@override late final _TranslationsSettingsNotificationsRu notifications = _TranslationsSettingsNotificationsRu._(_root);
	@override late final _TranslationsSettingsPrivacyAndSecurityRu privacyAndSecurity = _TranslationsSettingsPrivacyAndSecurityRu._(_root);
	@override String get devices => 'Девайсы';
	@override String get updates => 'Обновления';
	@override late final _TranslationsSettingsAppearanceRu appearance = _TranslationsSettingsAppearanceRu._(_root);
	@override late final _TranslationsSettingsLanguageRu language = _TranslationsSettingsLanguageRu._(_root);
}

// Path: contacts.tabs
class _TranslationsContactsTabsRu extends TranslationsContactsTabsEn {
	_TranslationsContactsTabsRu._(TranslationsRu root) : this._root = root, super.internal(root);

	final TranslationsRu _root; // ignore: unused_field

	// Translations
	@override String get all => 'Все';
	@override String get favorites => 'Избранное';
}

// Path: settings.notifications
class _TranslationsSettingsNotificationsRu extends TranslationsSettingsNotificationsEn {
	_TranslationsSettingsNotificationsRu._(TranslationsRu root) : this._root = root, super.internal(root);

	final TranslationsRu _root; // ignore: unused_field

	// Translations
	@override String get notifications => 'Уведомления';
}

// Path: settings.privacyAndSecurity
class _TranslationsSettingsPrivacyAndSecurityRu extends TranslationsSettingsPrivacyAndSecurityEn {
	_TranslationsSettingsPrivacyAndSecurityRu._(TranslationsRu root) : this._root = root, super.internal(root);

	final TranslationsRu _root; // ignore: unused_field

	// Translations
	@override String get privacyAndSecurity => 'Конфиденциальность';
	@override String get twoStepVerification => 'Двухэтапная проверка';
	@override late final _TranslationsSettingsPrivacyAndSecurityPasscodeRu passcode = _TranslationsSettingsPrivacyAndSecurityPasscodeRu._(_root);
}

// Path: settings.appearance
class _TranslationsSettingsAppearanceRu extends TranslationsSettingsAppearanceEn {
	_TranslationsSettingsAppearanceRu._(TranslationsRu root) : this._root = root, super.internal(root);

	final TranslationsRu _root; // ignore: unused_field

	// Translations
	@override String get appearance => 'Оформление';
	@override String get back => 'Назад';
	@override late final _TranslationsSettingsAppearanceDarkModeRu darkMode = _TranslationsSettingsAppearanceDarkModeRu._(_root);
	@override late final _TranslationsSettingsAppearanceColorSchemeRu colorScheme = _TranslationsSettingsAppearanceColorSchemeRu._(_root);
}

// Path: settings.language
class _TranslationsSettingsLanguageRu extends TranslationsSettingsLanguageEn {
	_TranslationsSettingsLanguageRu._(TranslationsRu root) : this._root = root, super.internal(root);

	final TranslationsRu _root; // ignore: unused_field

	// Translations
	@override String get language => 'Язык';
	@override String get back => 'Назад';
	@override String get interfaceLanguage => 'Язык интерфейса';
}

// Path: settings.privacyAndSecurity.passcode
class _TranslationsSettingsPrivacyAndSecurityPasscodeRu extends TranslationsSettingsPrivacyAndSecurityPasscodeEn {
	_TranslationsSettingsPrivacyAndSecurityPasscodeRu._(TranslationsRu root) : this._root = root, super.internal(root);

	final TranslationsRu _root; // ignore: unused_field

	// Translations
	@override String get passcode => 'Код-пароль';
	@override String get setPasscode => 'Установить код-пароль';
	@override String get importantDescription => 'Важно: Если Вы забудете код-пароль, вам нужно будет переустановить приложение';
	@override String get newPasscode => 'Новый код-пароль';
	@override String get confirmNewPasscode => 'Подтвердите код-пароль';
	@override String get cancel => 'Отмена';
	@override String get disable_passcode => 'Отключить код-пароль';
	@override String get change_passcode => 'Изменить код-пароль';
	@override String get auto_lock => 'Автоблокировка';
	@override String get auto_lock_in_disabled => 'Отключена';
	@override String get auto_lock_timer_in_1_seconds => 'Немедленно';
	@override String get auto_lock_timer_in_1_minute => 'через 1 минуту';
	@override String get auto_lock_timer_in_5_minutes => 'через 5 минут';
	@override String get auto_lock_timer_in_1_hour => 'через 1 час';
	@override String get auto_lock_timer_in_5_hours => 'через 5 часов';
}

// Path: settings.appearance.darkMode
class _TranslationsSettingsAppearanceDarkModeRu extends TranslationsSettingsAppearanceDarkModeEn {
	_TranslationsSettingsAppearanceDarkModeRu._(TranslationsRu root) : this._root = root, super.internal(root);

	final TranslationsRu _root; // ignore: unused_field

	// Translations
	@override String get darkMode => 'Темная тема';
	@override String get system => 'Системная';
	@override String get disabled => 'Выключена';
	@override String get alwaysOn => 'Всегда включена';
}

// Path: settings.appearance.colorScheme
class _TranslationsSettingsAppearanceColorSchemeRu extends TranslationsSettingsAppearanceColorSchemeEn {
	_TranslationsSettingsAppearanceColorSchemeRu._(TranslationsRu root) : this._root = root, super.internal(root);

	final TranslationsRu _root; // ignore: unused_field

	// Translations
	@override String get colorScheme => 'Цветовая схема';
	@override String get system => 'Системная';
	@override String get green => 'Зеленая';
	@override String get purple => 'Пурпурный';
}

/// Flat map(s) containing all translations.
/// Only for edge cases! For simple maps, use the map function of this library.
extension on TranslationsRu {
	dynamic _flatMapFunction(String path) {
		switch (path) {
			case 'notImplementedScreen': return 'Не реализованный экран';
			case 'ui.settings': return 'Настройки';
			case 'ui.cancel': return 'Отмена';
			case 'ui.done': return 'Готово';
			case 'drawer.settings': return _root.ui.settings;
			case 'drawer.favorites': return 'Избранное';
			case 'drawer.contacts': return 'Контакты';
			case 'contacts.contacts': return 'Контакты';
			case 'contacts.search': return 'Поиск';
			case 'contacts.tabs.all': return 'Все';
			case 'contacts.tabs.favorites': return 'Избранное';
			case 'chats.chats': return 'Чаты';
			case 'settings.settings': return 'Настройки';
			case 'settings.favorites': return 'Избранное';
			case 'settings.myPersonalInfo': return 'Моя личная информация';
			case 'settings.myProfile': return 'Мой профиль';
			case 'settings.notifications.notifications': return 'Уведомления';
			case 'settings.privacyAndSecurity.privacyAndSecurity': return 'Конфиденциальность';
			case 'settings.privacyAndSecurity.twoStepVerification': return 'Двухэтапная проверка';
			case 'settings.privacyAndSecurity.passcode.passcode': return 'Код-пароль';
			case 'settings.privacyAndSecurity.passcode.setPasscode': return 'Установить код-пароль';
			case 'settings.privacyAndSecurity.passcode.importantDescription': return 'Важно: Если Вы забудете код-пароль, вам нужно будет переустановить приложение';
			case 'settings.privacyAndSecurity.passcode.newPasscode': return 'Новый код-пароль';
			case 'settings.privacyAndSecurity.passcode.confirmNewPasscode': return 'Подтвердите код-пароль';
			case 'settings.privacyAndSecurity.passcode.cancel': return 'Отмена';
			case 'settings.privacyAndSecurity.passcode.disable_passcode': return 'Отключить код-пароль';
			case 'settings.privacyAndSecurity.passcode.change_passcode': return 'Изменить код-пароль';
			case 'settings.privacyAndSecurity.passcode.auto_lock': return 'Автоблокировка';
			case 'settings.privacyAndSecurity.passcode.auto_lock_in_disabled': return 'Отключена';
			case 'settings.privacyAndSecurity.passcode.auto_lock_timer_in_1_seconds': return 'Немедленно';
			case 'settings.privacyAndSecurity.passcode.auto_lock_timer_in_1_minute': return 'через 1 минуту';
			case 'settings.privacyAndSecurity.passcode.auto_lock_timer_in_5_minutes': return 'через 5 минут';
			case 'settings.privacyAndSecurity.passcode.auto_lock_timer_in_1_hour': return 'через 1 час';
			case 'settings.privacyAndSecurity.passcode.auto_lock_timer_in_5_hours': return 'через 5 часов';
			case 'settings.devices': return 'Девайсы';
			case 'settings.updates': return 'Обновления';
			case 'settings.appearance.appearance': return 'Оформление';
			case 'settings.appearance.back': return 'Назад';
			case 'settings.appearance.darkMode.darkMode': return 'Темная тема';
			case 'settings.appearance.darkMode.system': return 'Системная';
			case 'settings.appearance.darkMode.disabled': return 'Выключена';
			case 'settings.appearance.darkMode.alwaysOn': return 'Всегда включена';
			case 'settings.appearance.colorScheme.colorScheme': return 'Цветовая схема';
			case 'settings.appearance.colorScheme.system': return 'Системная';
			case 'settings.appearance.colorScheme.green': return 'Зеленая';
			case 'settings.appearance.colorScheme.purple': return 'Пурпурный';
			case 'settings.language.language': return 'Язык';
			case 'settings.language.back': return 'Назад';
			case 'settings.language.interfaceLanguage': return 'Язык интерфейса';
			default: return null;
		}
	}
}

