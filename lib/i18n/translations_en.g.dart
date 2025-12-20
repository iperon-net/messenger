///
/// Generated file. Do not edit.
///
// coverage:ignore-file
// ignore_for_file: type=lint, unused_import
// dart format off

part of 'translations.g.dart';

// Path: <root>
typedef TranslationsEn = Translations; // ignore: unused_element
class Translations with BaseTranslations<AppLocale, Translations> {
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

	/// en: 'Unknown error'
	String get unknownError => 'Unknown error';

	/// en: 'Logs'
	String get logs => 'Logs';

	/// en: 'Organization server URL'
	String get organizationServerUrl => 'Organization server URL';

	/// en: 'You can check the URL with your organization administrator'
	String get organizationServerUrlHelper => 'You can check the URL with your organization administrator';

	/// en: 'Next'
	String get next => 'Next';

	/// en: 'Invalid organization server URL'
	String get invalidOrganizationServerUrl => 'Invalid organization server URL';

	/// en: 'The server does not support this version of the application.'
	String get serverNotSupportAppVersion => 'The server does not support this version of the application.';
}

/// The flat map containing all translations for locale <en>.
/// Only for edge cases! For simple maps, use the map function of this library.
///
/// The Dart AOT compiler has issues with very large switch statements,
/// so the map is split into smaller functions (512 entries each).
extension on Translations {
	dynamic _flatMapFunction(String path) {
		return switch (path) {
			'unknownError' => 'Unknown error',
			'logs' => 'Logs',
			'organizationServerUrl' => 'Organization server URL',
			'organizationServerUrlHelper' => 'You can check the URL with your organization administrator',
			'next' => 'Next',
			'invalidOrganizationServerUrl' => 'Invalid organization server URL',
			'serverNotSupportAppVersion' => 'The server does not support this version of the application.',
			_ => null,
		};
	}
}
