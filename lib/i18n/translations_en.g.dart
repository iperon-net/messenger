///
/// Generated file. Do not edit.
///
// coverage:ignore-file
// ignore_for_file: type=lint, unused_import

part of 'translations.g.dart';

// Path: <root>
typedef TranslationsEn = Translations; // ignore: unused_element
class Translations implements BaseTranslations<AppLocale, Translations> {
	/// Returns the current translations of the given [context].
	///
	/// Usage:
	/// final t = Translations.of(context);
	static Translations of(BuildContext context) => InheritedLocaleData.of<AppLocale, Translations>(context).translations;

	/// You can call this constructor and build your own translation instance of this locale.
	/// Constructing via the enum [AppLocale.build] is preferred.
	Translations({Map<String, Node>? overrides, PluralResolver? cardinalResolver, PluralResolver? ordinalResolver, TranslationMetadata<AppLocale, Translations>? meta})
		: assert(overrides == null, 'Set "translation_overrides: true" in order to enable this feature.'),
		  $meta = meta ?? TranslationMetadata(
		    locale: AppLocale.en,
		    overrides: overrides ?? {},
		    cardinalResolver: cardinalResolver,
		    ordinalResolver: ordinalResolver,
		  ) {
		$meta.setFlatMapFunction(_flatMapFunction);
	}

	/// Metadata for the translations of <en>.
	@override final TranslationMetadata<AppLocale, Translations> $meta;

	/// Access flat map
	dynamic operator[](String key) => $meta.getTranslation(key);

	late final Translations _root = this; // ignore: unused_field

	Translations $copyWith({TranslationMetadata<AppLocale, Translations>? meta}) => Translations(meta: meta ?? this.$meta);

	// Translations
	String get notImplementedScreen => 'Not implemented screen';
	String get contacts => 'Contacts';
	String get chats => 'Chats';
	String get settings => 'Settings';
	String get language => 'Language';
	String get favorites => 'Favorites';
	String get appearance => 'Appearance';
	String get myProfile => 'My profile';
	String get myPersonalInfo => 'My personal info';
	String get versionApplication => 'Version application';
	String get privacyAndSecurity => 'Privacy and security';
	String get devices => 'Devices';
	String get updates => 'Updates';
	String get interfaceLanguage => 'Interface language';
	String get sort => 'Sort';
	String get search => 'Search';
	String get favorite_contacts => 'Favorite contacts';
	String get back => 'Back';
	String get theme => 'Theme';
	String get themeSystem => 'System';
	String get themeLight => 'Light';
	String get themeDark => 'Dark';
	String get online => 'Online';
	String last_seen_minutes({required num n}) => (_root.$meta.cardinalResolver ?? PluralResolvers.cardinal('en'))(n,
		one: 'last seen ${n} minute ago',
		other: 'last seen ${n} minutes ago',
	);
	String get waiting_for_network => 'Waiting for network...';
	String get all_contacts => 'All contacts';
	String get all => 'All';
}

/// Flat map(s) containing all translations.
/// Only for edge cases! For simple maps, use the map function of this library.
extension on Translations {
	dynamic _flatMapFunction(String path) {
		switch (path) {
			case 'notImplementedScreen': return 'Not implemented screen';
			case 'contacts': return 'Contacts';
			case 'chats': return 'Chats';
			case 'settings': return 'Settings';
			case 'language': return 'Language';
			case 'favorites': return 'Favorites';
			case 'appearance': return 'Appearance';
			case 'myProfile': return 'My profile';
			case 'myPersonalInfo': return 'My personal info';
			case 'versionApplication': return 'Version application';
			case 'privacyAndSecurity': return 'Privacy and security';
			case 'devices': return 'Devices';
			case 'updates': return 'Updates';
			case 'interfaceLanguage': return 'Interface language';
			case 'sort': return 'Sort';
			case 'search': return 'Search';
			case 'favorite_contacts': return 'Favorite contacts';
			case 'back': return 'Back';
			case 'theme': return 'Theme';
			case 'themeSystem': return 'System';
			case 'themeLight': return 'Light';
			case 'themeDark': return 'Dark';
			case 'online': return 'Online';
			case 'last_seen_minutes': return ({required num n}) => (_root.$meta.cardinalResolver ?? PluralResolvers.cardinal('en'))(n,
				one: 'last seen ${n} minute ago',
				other: 'last seen ${n} minutes ago',
			);
			case 'waiting_for_network': return 'Waiting for network...';
			case 'all_contacts': return 'All contacts';
			case 'all': return 'All';
			default: return null;
		}
	}
}

