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
			default: return null;
		}
	}
}

