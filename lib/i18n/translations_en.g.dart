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
	late final Translations$auth$en auth = Translations$auth$en.internal(_root);
	late final Translations$settings$en settings = Translations$settings$en.internal(_root);
	late final Translations$common$en common = Translations$common$en.internal(_root);
	late final Translations$connection$en connection = Translations$connection$en.internal(_root);
	late final Translations$grpcError$en grpcError = Translations$grpcError$en.internal(_root);
	late final Translations$dateTime$en dateTime = Translations$dateTime$en.internal(_root);
}

// Path: auth
class Translations$auth$en {
	Translations$auth$en.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Enter your mobile phone number'
	String get enterYourMobilePhoneNumber => 'Enter your mobile phone number';

	/// en: 'Currently, we only support phone numbers from Russian mobile operators'
	String get currentlyWeOnlySupportPhoneNumbersFromRussianMobileOperators => 'Currently, we only support phone numbers from Russian mobile operators';

	/// en: 'Phone number does not match allowed region'
	String get phoneNumberDoesNotMatchAllowedRegion => 'Phone number does not match allowed region';

	/// en: 'Enter the code'
	String get enterTheCode => 'Enter the code';

	/// en: 'We sent a confirmation code to the number {phoneNumber}'
	String sentConfirmationCodeToNumber({required Object phoneNumber}) => 'We sent a confirmation code to the number ${phoneNumber}';

	/// en: 'Insert debug phone'
	String get insertDebugPhone => 'Insert debug phone';

	/// en: 'Call {confirmationPhoneNumberRu} from the phone number you provided and wait for the call to be disconnected.'
	String confirmYourNumberDetail({required Object confirmationPhoneNumberRu}) => 'Call ${confirmationPhoneNumberRu} from the phone number you provided and wait for the call to be disconnected.';

	/// en: 'Call for free'
	String get callForFree => 'Call for free';

	/// en: 'We are expecting your call within {duration}'
	String weAreExpectingYourCallWithin({required Object duration}) => 'We are expecting your call within ${duration}';

	/// en: 'Login In with'
	String get loginInWith => 'Login In with';
}

// Path: settings
class Translations$settings$en {
	Translations$settings$en.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'My profile'
	String get myProfile => 'My profile';

	/// en: 'Logout'
	String get logout => 'Logout';

	/// en: 'Devices'
	String get devices => 'Devices';

	/// en: 'Language'
	String get language => 'Language';

	/// en: 'Appearance'
	String get appearance => 'Appearance';

	/// en: 'Privacy and security'
	String get privacyAndSecurity => 'Privacy and security';

	/// en: 'Color theme'
	String get colorTheme => 'Color theme';

	/// en: 'Default'
	String get colorThemeDefault => 'Default';

	/// en: 'Green'
	String get colorThemeGreen => 'Green';

	/// en: 'Purple'
	String get colorThemePurple => 'Purple';

	/// en: 'Orange'
	String get colorThemeOrange => 'Orange';

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

	/// en: 'This device'
	String get thisDevice => 'This device';

	/// en: '{location} · {updateAt}'
	String deviceSessionListTileSubtitle({required Object location, required Object updateAt}) => '${location} · ${updateAt}';

	/// en: 'Online'
	String get online => 'Online';

	/// en: 'Terminate all other sessions'
	String get terminateAllOtherDeviceSessions => 'Terminate all other sessions';

	/// en: 'Active sessions'
	String get activeDeviceSession => 'Active sessions';

	/// en: 'Terminate session'
	String get terminateDeviceSession => 'Terminate session';

	/// en: 'Are you sure you want to log out from this device?'
	String get areYouSureYouLogOutFromThisDevice => 'Are you sure you want to log out from this device?';

	/// en: 'Terminate'
	String get terminate => 'Terminate';

	/// en: 'Blur on inactive'
	String get blurOnInactive => 'Blur on inactive';

	/// en: 'The app appears blurry in the list of open apps'
	String get blurOnInactiveDescription => 'The app appears blurry in the list of open apps';

	/// en: 'Passcode & Face ID'
	String get passcodeAndFaceID => 'Passcode & Face ID';

	late final Translations$settings$passcode$en passcode = Translations$settings$passcode$en.internal(_root);
}

// Path: common
class Translations$common$en {
	Translations$common$en.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Mobile phone number'
	String get mobilePhone => 'Mobile phone number';

	/// en: 'Continue'
	String get kContinue => 'Continue';

	/// en: 'Contacts'
	String get contacts => 'Contacts';

	/// en: 'Calls'
	String get calls => 'Calls';

	/// en: 'Chats'
	String get chats => 'Chats';

	/// en: 'Settings'
	String get settings => 'Settings';

	/// en: 'Cancel'
	String get cancel => 'Cancel';

	/// en: 'Back'
	String get back => 'Back';

	/// en: 'Save'
	String get save => 'Save';
}

// Path: connection
class Translations$connection$en {
	Translations$connection$en.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Waiting for network'
	String get waitingForNetwork => 'Waiting for network';

	/// en: 'Connecting'
	String get connecting => 'Connecting';

	/// en: 'Updating'
	String get updating => 'Updating';
}

// Path: grpcError
class Translations$grpcError$en {
	Translations$grpcError$en.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Error connecting to the server'
	String get errorConnectingServer => 'Error connecting to the server';

	/// en: 'Unable to connect to the server'
	String get unableConnectServer => 'Unable to connect to the server';

	/// en: 'Internal server error'
	String get internalServerError => 'Internal server error';
}

// Path: dateTime
class Translations$dateTime$en {
	Translations$dateTime$en.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'today at {time}'
	String relativeDateTimeToday({required Object time}) => 'today at ${time}';

	/// en: 'yesterday at {time}'
	String relativeDateTimeYesterday({required Object time}) => 'yesterday at ${time}';

	/// en: '{date} at {time}'
	String relativeDateTimeOther({required Object date, required Object time}) => '${date} at ${time}';
}

// Path: settings.passcode
class Translations$settings$passcode$en {
	Translations$settings$passcode$en.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Passcode'
	String get title => 'Passcode';

	/// en: 'Turn passcode on'
	String get passcodeTurnOn => 'Turn passcode on';

	/// en: 'Turn passcode off'
	String get passcodeTurnOff => 'Turn passcode off';

	/// en: 'Please enter passcode'
	String get pleaseEnterPasscode => 'Please enter passcode';

	/// en: 'Authenticate to unlock'
	String get authenticateReason => 'Authenticate to unlock';

	/// en: 'Please enter new passcode'
	String get pleaseEnterNewPasscode => 'Please enter new passcode';

	/// en: 'Please enter new passcode again'
	String get pleaseEnterNewPasscodeAgain => 'Please enter new passcode again';

	/// en: 'Change passcode'
	String get changePasscode => 'Change passcode';

	/// en: 'Note: If you forget your passcode, you will need to reinstall the app'
	String get note => 'Note: If you forget your passcode, you will need to reinstall the app';

	/// en: 'Cancel'
	String get cancel => _root.common.cancel;

	/// en: 'Auto-Lock'
	String get autoLock => 'Auto-Lock';

	/// en: 'Unlock with Face ID'
	String get faceIDUnlock => 'Unlock with Face ID';

	/// en: 'Off'
	String get autoLockOff => 'Off';

	/// en: '(one) {After {n} minute} (other) {After {n} minutes}'
	String autoLockMinutes({required num n}) => (_root.$meta.cardinalResolver ?? PluralResolvers.cardinal('en'))(n,
		one: 'After ${n} minute',
		other: 'After ${n} minutes',
	);

	/// en: '(one) {After {n} hour} (other) {After {n} hours}'
	String autoLockHours({required num n}) => (_root.$meta.cardinalResolver ?? PluralResolvers.cardinal('en'))(n,
		one: 'After ${n} hour',
		other: 'After ${n} hours',
	);
}

/// The flat map containing all translations for locale <en>.
/// Only for edge cases! For simple maps, use the map function of this library.
///
/// The Dart AOT compiler has issues with very large switch statements,
/// so the map is split into smaller functions (512 entries each).
extension on Translations {
	dynamic _flatMapFunction(String path) {
		return switch (path) {
			'auth.enterYourMobilePhoneNumber' => 'Enter your mobile phone number',
			'auth.currentlyWeOnlySupportPhoneNumbersFromRussianMobileOperators' => 'Currently, we only support phone numbers from Russian mobile operators',
			'auth.phoneNumberDoesNotMatchAllowedRegion' => 'Phone number does not match allowed region',
			'auth.enterTheCode' => 'Enter the code',
			'auth.sentConfirmationCodeToNumber' => ({required Object phoneNumber}) => 'We sent a confirmation code to the number ${phoneNumber}',
			'auth.insertDebugPhone' => 'Insert debug phone',
			'auth.confirmYourNumberDetail' => ({required Object confirmationPhoneNumberRu}) => 'Call ${confirmationPhoneNumberRu} from the phone number you provided and wait for the call to be disconnected.',
			'auth.callForFree' => 'Call for free',
			'auth.weAreExpectingYourCallWithin' => ({required Object duration}) => 'We are expecting your call within ${duration}',
			'auth.loginInWith' => 'Login In with',
			'settings.myProfile' => 'My profile',
			'settings.logout' => 'Logout',
			'settings.devices' => 'Devices',
			'settings.language' => 'Language',
			'settings.appearance' => 'Appearance',
			'settings.privacyAndSecurity' => 'Privacy and security',
			'settings.colorTheme' => 'Color theme',
			'settings.colorThemeDefault' => 'Default',
			'settings.colorThemeGreen' => 'Green',
			'settings.colorThemePurple' => 'Purple',
			'settings.colorThemeOrange' => 'Orange',
			'settings.darkMode' => 'Dark mode',
			'settings.darkModeSystem' => 'System',
			'settings.darkModeAlwaysOn' => 'Always on',
			'settings.darkModeDisabled' => 'Disabled',
			'settings.darkModeSystemDescription' => 'As in the device settings',
			'settings.darkModeAlwaysOnDescription' => 'Dark mode is always on',
			'settings.darkModeDisabledDescription' => 'Dark mode is disabled',
			'settings.thisDevice' => 'This device',
			'settings.deviceSessionListTileSubtitle' => ({required Object location, required Object updateAt}) => '${location} · ${updateAt}',
			'settings.online' => 'Online',
			'settings.terminateAllOtherDeviceSessions' => 'Terminate all other sessions',
			'settings.activeDeviceSession' => 'Active sessions',
			'settings.terminateDeviceSession' => 'Terminate session',
			'settings.areYouSureYouLogOutFromThisDevice' => 'Are you sure you want to log out from this device?',
			'settings.terminate' => 'Terminate',
			'settings.blurOnInactive' => 'Blur on inactive',
			'settings.blurOnInactiveDescription' => 'The app appears blurry in the list of open apps',
			'settings.passcodeAndFaceID' => 'Passcode & Face ID',
			'settings.passcode.title' => 'Passcode',
			'settings.passcode.passcodeTurnOn' => 'Turn passcode on',
			'settings.passcode.passcodeTurnOff' => 'Turn passcode off',
			'settings.passcode.pleaseEnterPasscode' => 'Please enter passcode',
			'settings.passcode.authenticateReason' => 'Authenticate to unlock',
			'settings.passcode.pleaseEnterNewPasscode' => 'Please enter new passcode',
			'settings.passcode.pleaseEnterNewPasscodeAgain' => 'Please enter new passcode again',
			'settings.passcode.changePasscode' => 'Change passcode',
			'settings.passcode.note' => 'Note: If you forget your passcode, you will need to reinstall the app',
			'settings.passcode.cancel' => _root.common.cancel,
			'settings.passcode.autoLock' => 'Auto-Lock',
			'settings.passcode.faceIDUnlock' => 'Unlock with Face ID',
			'settings.passcode.autoLockOff' => 'Off',
			'settings.passcode.autoLockMinutes' => ({required num n}) => (_root.$meta.cardinalResolver ?? PluralResolvers.cardinal('en'))(n, one: 'After ${n} minute', other: 'After ${n} minutes', ), 
			'settings.passcode.autoLockHours' => ({required num n}) => (_root.$meta.cardinalResolver ?? PluralResolvers.cardinal('en'))(n, one: 'After ${n} hour', other: 'After ${n} hours', ), 
			'common.mobilePhone' => 'Mobile phone number',
			'common.kContinue' => 'Continue',
			'common.contacts' => 'Contacts',
			'common.calls' => 'Calls',
			'common.chats' => 'Chats',
			'common.settings' => 'Settings',
			'common.cancel' => 'Cancel',
			'common.back' => 'Back',
			'common.save' => 'Save',
			'connection.waitingForNetwork' => 'Waiting for network',
			'connection.connecting' => 'Connecting',
			'connection.updating' => 'Updating',
			'grpcError.errorConnectingServer' => 'Error connecting to the server',
			'grpcError.unableConnectServer' => 'Unable to connect to the server',
			'grpcError.internalServerError' => 'Internal server error',
			'dateTime.relativeDateTimeToday' => ({required Object time}) => 'today at ${time}',
			'dateTime.relativeDateTimeYesterday' => ({required Object time}) => 'yesterday at ${time}',
			'dateTime.relativeDateTimeOther' => ({required Object date, required Object time}) => '${date} at ${time}',
			_ => null,
		};
	}
}
