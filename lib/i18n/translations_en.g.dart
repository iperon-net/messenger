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

	/// en: 'Encryption synchronization error'
	String get encryptionSynchronizationError => 'Encryption synchronization error';

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

	/// en: 'Contacts'
	String get contacts => 'Contacts';

	/// en: 'Calls'
	String get calls => 'Calls';

	/// en: 'Chats'
	String get chats => 'Chats';

	/// en: 'Settings'
	String get settings => 'Settings';

	/// en: 'Language'
	String get language => 'Language';

	/// en: 'Appearance'
	String get appearance => 'Appearance';

	/// en: 'My profile'
	String get myProfile => 'My profile';

	/// en: 'Private & Security'
	String get privateAndSecurity => 'Private & Security';

	/// en: 'Notifications'
	String get notifications => 'Notifications';

	/// en: 'FAQ'
	String get faq => 'FAQ';

	/// en: 'Privacy Policy'
	String get privacyPolicy => 'Privacy Policy';

	/// en: 'Color theme'
	String get colorTheme => 'Color theme';

	/// en: 'Default'
	String get colorThemeDefault => 'Default';

	/// en: 'Green'
	String get colorThemeGreen => 'Green';

	/// en: 'Purple'
	String get colorThemePurple => 'Purple';

	/// en: 'Dark mode'
	String get darkMode => 'Dark mode';

	/// en: 'System'
	String get darkModeSystem => 'System';

	/// en: 'Always on'
	String get darkModeAlwaysOn => 'Always on';

	/// en: 'Disabled'
	String get darkModeDisabled => 'Disabled';

	/// en: 'As in the device settings'
	String get darkModeSystemDescription => 'As in the device settings';

	/// en: 'Dark mode is always on'
	String get darkModeAlwaysOnDescription => 'Dark mode is always on';

	/// en: 'Dark mode is disabled'
	String get darkModeDisabledDescription => 'Dark mode is disabled';

	/// en: 'Enter the code'
	String get enterTheCode => 'Enter the code';

	/// en: 'We sent a confirmation code to the number {phoneNumber}'
	String sentConfirmationCodeToNumber({required Object phoneNumber}) => 'We sent a confirmation code to the number ${phoneNumber}';

	/// en: 'Verification code mismatch'
	String get verificationCodeMismatch => 'Verification code mismatch';

	/// en: 'Logout'
	String get logout => 'Logout';

	/// en: 'Search'
	String get search => 'Search';

	/// en: 'Access to contacts'
	String get accessToContacts => 'Access to contacts';

	/// en: 'Please allow access to your contacts so that you can find your friends'
	String get pleaseAllowAccessPhoneSeamlesslyFindYourFriends => 'Please allow access to your contacts so that you can find your friends';

	/// en: 'Allow in settings'
	String get allowInSettings => 'Allow in settings';

	/// en: 'Limited access to contacts'
	String get limitedAccessToContacts => 'Limited access to contacts';

	/// en: 'The app does not have permission to access all contacts'
	String get appDoesNotHavePermissionAccessAllContacts => 'The app does not have permission to access all contacts';

	/// en: 'Devices'
	String get devices => 'Devices';

	/// en: 'This device'
	String get thisDevice => 'This device';

	/// en: 'Terminate all other sessions'
	String get terminateAllOtherSessions => 'Terminate all other sessions';

	/// en: 'Logs out all devices except for this one'
	String get logsOutAllDevicesExceptForThisOne => 'Logs out all devices except for this one';

	/// en: 'Active sessions'
	String get activeSessions => 'Active sessions';

	/// en: '{location} · {updateAt}'
	String deviceSessionListTileSubtitle({required Object location, required Object updateAt}) => '${location} · ${updateAt}';

	/// en: 'today at {time}'
	String relativeDateTimeToday({required Object time}) => 'today at ${time}';

	/// en: 'yesterday at {time}'
	String relativeDateTimeYesterday({required Object time}) => 'yesterday at ${time}';

	/// en: '{date} at {time}'
	String relativeDateTimeOther({required Object date, required Object time}) => '${date} at ${time}';

	/// en: 'Онлайн'
	String get online => 'Онлайн';

	/// en: 'Terminate'
	String get terminate => 'Terminate';

	/// en: 'Are you sure you want to log out from this device?'
	String get areYouSureYouLogOutFromThisDevice => 'Are you sure you want to log out from this device?';

	/// en: 'Terminate session'
	String get terminateSession => 'Terminate session';

	/// en: 'Cancel'
	String get cancel => 'Cancel';

	/// en: 'Two-Step Verification'
	String get twoStepVerification => 'Two-Step Verification';

	/// en: 'Off'
	String get off => 'Off';

	/// en: 'On'
	String get on => 'On';

	/// en: 'Password'
	String get password => 'Password';

	/// en: 'New password'
	String get newPassword => 'New password';

	/// en: 'You can set a password that will be required when logging in from a new device, minimum password length is 5 characters'
	String get youCanSetPasswordThatWillBeRequiredWhenLoggingInFromNewDevice => 'You can set a password that will be required when logging in from a new device, minimum password length is 5 characters';

	/// en: 'Password is too small'
	String get passwordIsToSmall => 'Password is too small';

	/// en: 'Email'
	String get email => 'Email';

	/// en: 'Email'
	String get emailEnglish => 'Email';

	/// en: 'Back'
	String get back => 'Back';

	/// en: 'Confirm your email'
	String get confirmYourEmail => 'Confirm your email';

	/// en: 'Code'
	String get code => 'Code';

	/// en: 'Invalid email'
	String get invalidEmail => 'Invalid email';

	/// en: 'Enter your email address in case you forget your password'
	String get enterYourEmailForgetYourPassword => 'Enter your email address in case you forget your password';
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
			'encryptionSynchronizationError' => 'Encryption synchronization error',
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
			'contacts' => 'Contacts',
			'calls' => 'Calls',
			'chats' => 'Chats',
			'settings' => 'Settings',
			'language' => 'Language',
			'appearance' => 'Appearance',
			'myProfile' => 'My profile',
			'privateAndSecurity' => 'Private & Security',
			'notifications' => 'Notifications',
			'faq' => 'FAQ',
			'privacyPolicy' => 'Privacy Policy',
			'colorTheme' => 'Color theme',
			'colorThemeDefault' => 'Default',
			'colorThemeGreen' => 'Green',
			'colorThemePurple' => 'Purple',
			'darkMode' => 'Dark mode',
			'darkModeSystem' => 'System',
			'darkModeAlwaysOn' => 'Always on',
			'darkModeDisabled' => 'Disabled',
			'darkModeSystemDescription' => 'As in the device settings',
			'darkModeAlwaysOnDescription' => 'Dark mode is always on',
			'darkModeDisabledDescription' => 'Dark mode is disabled',
			'enterTheCode' => 'Enter the code',
			'sentConfirmationCodeToNumber' => ({required Object phoneNumber}) => 'We sent a confirmation code to the number ${phoneNumber}',
			'verificationCodeMismatch' => 'Verification code mismatch',
			'logout' => 'Logout',
			'search' => 'Search',
			'accessToContacts' => 'Access to contacts',
			'pleaseAllowAccessPhoneSeamlesslyFindYourFriends' => 'Please allow access to your contacts so that you can find your friends',
			'allowInSettings' => 'Allow in settings',
			'limitedAccessToContacts' => 'Limited access to contacts',
			'appDoesNotHavePermissionAccessAllContacts' => 'The app does not have permission to access all contacts',
			'devices' => 'Devices',
			'thisDevice' => 'This device',
			'terminateAllOtherSessions' => 'Terminate all other sessions',
			'logsOutAllDevicesExceptForThisOne' => 'Logs out all devices except for this one',
			'activeSessions' => 'Active sessions',
			'deviceSessionListTileSubtitle' => ({required Object location, required Object updateAt}) => '${location} · ${updateAt}',
			'relativeDateTimeToday' => ({required Object time}) => 'today at ${time}',
			'relativeDateTimeYesterday' => ({required Object time}) => 'yesterday at ${time}',
			'relativeDateTimeOther' => ({required Object date, required Object time}) => '${date} at ${time}',
			'online' => 'Онлайн',
			'terminate' => 'Terminate',
			'areYouSureYouLogOutFromThisDevice' => 'Are you sure you want to log out from this device?',
			'terminateSession' => 'Terminate session',
			'cancel' => 'Cancel',
			'twoStepVerification' => 'Two-Step Verification',
			'off' => 'Off',
			'on' => 'On',
			'password' => 'Password',
			'newPassword' => 'New password',
			'youCanSetPasswordThatWillBeRequiredWhenLoggingInFromNewDevice' => 'You can set a password that will be required when logging in from a new device, minimum password length is 5 characters',
			'passwordIsToSmall' => 'Password is too small',
			'email' => 'Email',
			'emailEnglish' => 'Email',
			'back' => 'Back',
			'confirmYourEmail' => 'Confirm your email',
			'code' => 'Code',
			'invalidEmail' => 'Invalid email',
			'enterYourEmailForgetYourPassword' => 'Enter your email address in case you forget your password',
			_ => null,
		};
	}
}
