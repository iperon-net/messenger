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
	@override String get contacts => 'Контакты';
	@override String get chats => 'Чаты';
	@override String get settings => 'Настройки';
	@override String get language => 'Язык';
	@override String get favorites => 'Избранное';
	@override String get appearance => 'Оформление';
	@override String get myProfile => 'Мой профиль';
	@override String get myPersonalInfo => 'Моя личная информация';
	@override String get versionApplication => 'Версия приложения';
	@override String get privacyAndSecurity => 'Конфиденциальность';
	@override String get devices => 'Устройства';
	@override String get updates => 'Обновления';
	@override String get interfaceLanguage => 'Язык интерфейса';
	@override String get sort => 'Сортировка';
	@override String get search => 'Поиск';
	@override String get favorite_contacts => 'Избранные контакты';
	@override String get back => 'Назад';
	@override String get theme => 'Тема';
	@override String get themeSystem => 'Системная';
	@override String get themeLight => 'Светлая';
	@override String get themeDark => 'Темная';
	@override String get online => 'В сети';
	@override String last_seen_minutes({required num n}) => (_root.$meta.cardinalResolver ?? PluralResolvers.cardinal('ru'))(n,
		one: 'был(а) ${n} минуту назад',
		few: 'был(а) ${n} минуты назад',
		many: 'был(а) ${n} минут назад',
		other: 'был(а) ${n} минут назад',
	);
	@override String get waiting_for_network => 'Ожидание сети...';
	@override String get all_contacts => 'Все контакты';
	@override String get all => 'Все';
}

/// Flat map(s) containing all translations.
/// Only for edge cases! For simple maps, use the map function of this library.
extension on TranslationsRu {
	dynamic _flatMapFunction(String path) {
		switch (path) {
			case 'notImplementedScreen': return 'Не реализованный экран';
			case 'contacts': return 'Контакты';
			case 'chats': return 'Чаты';
			case 'settings': return 'Настройки';
			case 'language': return 'Язык';
			case 'favorites': return 'Избранное';
			case 'appearance': return 'Оформление';
			case 'myProfile': return 'Мой профиль';
			case 'myPersonalInfo': return 'Моя личная информация';
			case 'versionApplication': return 'Версия приложения';
			case 'privacyAndSecurity': return 'Конфиденциальность';
			case 'devices': return 'Устройства';
			case 'updates': return 'Обновления';
			case 'interfaceLanguage': return 'Язык интерфейса';
			case 'sort': return 'Сортировка';
			case 'search': return 'Поиск';
			case 'favorite_contacts': return 'Избранные контакты';
			case 'back': return 'Назад';
			case 'theme': return 'Тема';
			case 'themeSystem': return 'Системная';
			case 'themeLight': return 'Светлая';
			case 'themeDark': return 'Темная';
			case 'online': return 'В сети';
			case 'last_seen_minutes': return ({required num n}) => (_root.$meta.cardinalResolver ?? PluralResolvers.cardinal('ru'))(n,
				one: 'был(а) ${n} минуту назад',
				few: 'был(а) ${n} минуты назад',
				many: 'был(а) ${n} минут назад',
				other: 'был(а) ${n} минут назад',
			);
			case 'waiting_for_network': return 'Ожидание сети...';
			case 'all_contacts': return 'Все контакты';
			case 'all': return 'Все';
			default: return null;
		}
	}
}

