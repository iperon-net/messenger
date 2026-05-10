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

	/// en: 'Internal server error'
	String get internalServerError => 'Internal server error';

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

	/// en: 'Mobile phone number'
	String get mobilePhone => 'Mobile phone number';

	/// en: 'Enter your mobile phone number'
	String get enterYourMobilePhoneNumber => 'Enter your mobile phone number';

	/// en: 'Error connecting to the server'
	String get errorConnectingToTheServer => 'Error connecting to the server';

	/// en: 'Unable to connect to the server'
	String get unableToConnectToTheServer => 'Unable to connect to the server';

	/// en: 'Confirm your number'
	String get confirmYourNumber => 'Confirm your number';

	/// en: 'Call {confirmationPhoneNumberRu} from the phone number you provided and wait for the call to be disconnected.'
	String confirmYourNumberDetail({required Object confirmationPhoneNumberRu}) => 'Call ${confirmationPhoneNumberRu} from the phone number you provided and wait for the call to be disconnected.';

	/// en: 'Call for free'
	String get callForFree => 'Call for free';

	/// en: 'Close'
	String get close => 'Close';

	/// en: 'We are expecting your call within {duration}'
	String weAreExpectingYourCallWithin({required Object duration}) => 'We are expecting your call within ${duration}';

	/// en: 'Currently, we only support phone numbers from Russian mobile operators'
	String get currentlyWeOnlySupportPhoneNumbersFromRussianMobileOperators => 'Currently, we only support phone numbers from Russian mobile operators';

	/// en: 'Continue'
	String get kContinue => 'Continue';

	/// en: 'Login in with'
	String get loginInWith => 'Login in with';

	/// en: 'Signature verification error'
	String get signatureVerificationError => 'Signature verification error';
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
			'internalServerError' => 'Internal server error',
			'logs' => 'Logs',
			'organizationServerUrl' => 'Organization server URL',
			'organizationServerUrlHelper' => 'You can check the URL with your organization administrator',
			'next' => 'Next',
			'invalidOrganizationServerUrl' => 'Invalid organization server URL',
			'serverNotSupportAppVersion' => 'The server does not support this version of the application.',
			'mobilePhone' => 'Mobile phone number',
			'enterYourMobilePhoneNumber' => 'Enter your mobile phone number',
			'errorConnectingToTheServer' => 'Error connecting to the server',
			'unableToConnectToTheServer' => 'Unable to connect to the server',
			'confirmYourNumber' => 'Confirm your number',
			'confirmYourNumberDetail' => ({required Object confirmationPhoneNumberRu}) => 'Call ${confirmationPhoneNumberRu} from the phone number you provided and wait for the call to be disconnected.',
			'callForFree' => 'Call for free',
			'close' => 'Close',
			'weAreExpectingYourCallWithin' => ({required Object duration}) => 'We are expecting your call within ${duration}',
			'currentlyWeOnlySupportPhoneNumbersFromRussianMobileOperators' => 'Currently, we only support phone numbers from Russian mobile operators',
			'kContinue' => 'Continue',
			'loginInWith' => 'Login in with',
			'signatureVerificationError' => 'Signature verification error',
			_ => null,
		};
	}
}
