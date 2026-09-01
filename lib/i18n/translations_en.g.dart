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
	late final Translations$common$en common = Translations$common$en.internal(_root);
	late final Translations$componentsConnectionTitle$en componentsConnectionTitle = Translations$componentsConnectionTitle$en.internal(_root);
	late final Translations$componentsCamera$en componentsCamera = Translations$componentsCamera$en.internal(_root);
	late final Translations$screenHome$en screenHome = Translations$screenHome$en.internal(_root);
	late final Translations$screenChats$en screenChats = Translations$screenChats$en.internal(_root);
	late final Translations$screenSettings$en screenSettings = Translations$screenSettings$en.internal(_root);
	late final Translations$screenSettingsAppearance$en screenSettingsAppearance = Translations$screenSettingsAppearance$en.internal(_root);
	late final Translations$screenSettingsDevices$en screenSettingsDevices = Translations$screenSettingsDevices$en.internal(_root);
	late final Translations$screenSettingsAboutApplication$en screenSettingsAboutApplication = Translations$screenSettingsAboutApplication$en.internal(_root);
	late final Translations$screenSettingsLanguage$en screenSettingsLanguage = Translations$screenSettingsLanguage$en.internal(_root);
	late final Translations$screenSettingsPasscode$en screenSettingsPasscode = Translations$screenSettingsPasscode$en.internal(_root);
	late final Translations$settingsPasscodeCreate$en settingsPasscodeCreate = Translations$settingsPasscodeCreate$en.internal(_root);
	late final Translations$sessionsPrivacyAndSecurity$en sessionsPrivacyAndSecurity = Translations$sessionsPrivacyAndSecurity$en.internal(_root);
	late final Translations$screenMyProfile$en screenMyProfile = Translations$screenMyProfile$en.internal(_root);
	late final Translations$screenAuth$en screenAuth = Translations$screenAuth$en.internal(_root);
	late final Translations$screenAuthModerationApplicationStore$en screenAuthModerationApplicationStore = Translations$screenAuthModerationApplicationStore$en.internal(_root);
	late final Translations$screenAuthCallpasswordConfirmation$en screenAuthCallpasswordConfirmation = Translations$screenAuthCallpasswordConfirmation$en.internal(_root);
	late final Translations$grpcError$en grpcError = Translations$grpcError$en.internal(_root);
	late final Translations$dateTime$en dateTime = Translations$dateTime$en.internal(_root);
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

	/// en: 'Cancel'
	String get cancel => 'Cancel';

	/// en: 'Back'
	String get back => 'Back';

	/// en: 'Save'
	String get save => 'Save';

	/// en: 'Online'
	String get online => 'Online';

	/// en: 'Done'
	String get done => 'Done';

	/// en: 'Close'
	String get close => 'Close';

	/// en: 'Error'
	String get error => 'Error';

	/// en: 'Authenticate to unlock'
	String get biometricAuthenticateReason => 'Authenticate to unlock';

	/// en: 'Please enter passcode'
	String get biometricPleaseEnterPasscode => 'Please enter passcode';

	/// en: 'Edit'
	String get edit => 'Edit';
}

// Path: componentsConnectionTitle
class Translations$componentsConnectionTitle$en {
	Translations$componentsConnectionTitle$en.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Waiting for network'
	String get waitingForNetwork => 'Waiting for network';

	/// en: 'Connecting'
	String get connecting => 'Connecting';

	/// en: 'Updating'
	String get updating => 'Updating';
}

// Path: componentsCamera
class Translations$componentsCamera$en {
	Translations$componentsCamera$en.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Camera unavailable'
	String get unavailable => 'Camera unavailable';

	/// en: 'No access to camera'
	String get accessDenied => 'No access to camera';

	/// en: 'Open settings'
	String get openSettings => 'Open settings';
}

// Path: screenHome
class Translations$screenHome$en {
	Translations$screenHome$en.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Contacts'
	String get contacts => 'Contacts';

	/// en: 'Calls'
	String get calls => 'Calls';

	/// en: 'Chats'
	String get chats => _root.screenChats.chats;

	/// en: 'Settings'
	String get settings => _root.screenSettings.settings;
}

// Path: screenChats
class Translations$screenChats$en {
	Translations$screenChats$en.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Chats'
	String get chats => 'Chats';
}

// Path: screenSettings
class Translations$screenSettings$en {
	Translations$screenSettings$en.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Settings'
	String get settings => 'Settings';

	/// en: 'My profile'
	String get myProfile => 'My profile';

	/// en: 'Devices'
	String get devices => _root.screenSettingsDevices.devices;

	/// en: 'Language'
	String get language => 'Language';

	/// en: 'Appearance'
	String get appearance => _root.screenSettingsAppearance.appearance;

	/// en: 'Privacy and security'
	String get privacyAndSecurity => 'Privacy and security';

	/// en: 'About the application'
	String get aboutApplication => 'About the application';

	/// en: 'Logout'
	String get logout => 'Logout';
}

// Path: screenSettingsAppearance
class Translations$screenSettingsAppearance$en {
	Translations$screenSettingsAppearance$en.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Appearance'
	String get appearance => 'Appearance';

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

	/// en: 'Blur on inactive'
	String get blurOnInactive => 'Blur on inactive';

	/// en: 'The app appears blurry in the list of open apps'
	String get blurOnInactiveDescription => 'The app appears blurry in the list of open apps';
}

// Path: screenSettingsDevices
class Translations$screenSettingsDevices$en {
	Translations$screenSettingsDevices$en.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Devices'
	String get devices => 'Devices';

	/// en: 'This device'
	String get thisDevice => 'This device';

	/// en: '{location} · {updateAt}'
	String deviceSessionListTileSubtitle({required Object location, required Object updateAt}) => '${location} · ${updateAt}';

	/// en: 'Terminate all other sessions'
	String get terminateAllOtherDeviceSessions => 'Terminate all other sessions';

	/// en: 'Active sessions'
	String get activeDeviceSession => 'Active sessions';

	/// en: 'Terminate session'
	String get terminateDeviceSession => 'Terminate session';

	/// en: 'Are you sure you want to log out from this device?'
	String get areYouSureYouLogOutFromThisDevice => 'Are you sure you want to log out from this device?';

	/// en: 'Cancel'
	String get cancel => _root.common.cancel;

	/// en: 'Online'
	String get online => _root.common.online;

	/// en: 'Terminate'
	String get terminate => 'Terminate';
}

// Path: screenSettingsAboutApplication
class Translations$screenSettingsAboutApplication$en {
	Translations$screenSettingsAboutApplication$en.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'About the application'
	String get aboutApplication => _root.screenSettings.aboutApplication;

	/// en: 'Version {version} ({build})'
	String version({required Object version, required Object build}) => 'Version ${version} (${build})';

	/// en: 'Licenses'
	String get licenses => 'Licenses';

	/// en: '{n} licenses'
	String licensesCount({required Object n}) => '${n} licenses';

	/// en: 'No licenses found'
	String get noLicenses => 'No licenses found';
}

// Path: screenSettingsLanguage
class Translations$screenSettingsLanguage$en {
	Translations$screenSettingsLanguage$en.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Language'
	String get language => 'Language';
}

// Path: screenSettingsPasscode
class Translations$screenSettingsPasscode$en {
	Translations$screenSettingsPasscode$en.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Passcode'
	String get passcode => 'Passcode';

	/// en: 'Passcode & Face ID'
	String get passcodeAndFaceID => 'Passcode & Face ID';

	/// en: 'Passcode & Biometric'
	String get passcodeAndBiometric => 'Passcode & Biometric';

	/// en: 'Note: If you forget your passcode, you will need to reinstall the app'
	String get note => 'Note: If you forget your passcode, you will need to reinstall the app';

	/// en: 'Turn passcode on'
	String get turnOn => 'Turn passcode on';

	/// en: 'Turn passcode off'
	String get turnOff => 'Turn passcode off';

	/// en: 'Change passcode'
	String get change => 'Change passcode';

	/// en: 'Auto-Lock'
	String get autoLock => 'Auto-Lock';

	/// en: 'Unlock with Face ID'
	String get faceIDUnlock => 'Unlock with Face ID';

	/// en: 'Unlock with biometric'
	String get biometricUnlock => 'Unlock with biometric';

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

	/// en: 'Please enter passcode'
	String get pleaseEnterPasscode => 'Please enter passcode';

	/// en: 'Cancel'
	String get cancel => _root.common.cancel;
}

// Path: settingsPasscodeCreate
class Translations$settingsPasscodeCreate$en {
	Translations$settingsPasscodeCreate$en.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Please enter new passcode'
	String get pleaseEnterNewPasscode => 'Please enter new passcode';

	/// en: 'Please enter new passcode again'
	String get pleaseEnterNewPasscodeAgain => 'Please enter new passcode again';

	/// en: 'Cancel'
	String get cancel => _root.common.cancel;
}

// Path: sessionsPrivacyAndSecurity
class Translations$sessionsPrivacyAndSecurity$en {
	Translations$sessionsPrivacyAndSecurity$en.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Privacy and security'
	String get privacyAndSecurity => 'Privacy and security';

	/// en: 'Passcode & Face ID'
	String get passcodeAndFaceID => 'Passcode & Face ID';

	/// en: 'Passcode & Biometric'
	String get passcodeAndBiometric => 'Passcode & Biometric';

	/// en: 'Passcode'
	String get passcode => 'Passcode';
}

// Path: screenMyProfile
class Translations$screenMyProfile$en {
	Translations$screenMyProfile$en.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'My profile'
	String get myprofile => 'My profile';

	/// en: 'First name'
	String get firstName => 'First name';

	/// en: 'Last name'
	String get lastName => 'Last name';

	/// en: 'About me'
	String get aboutMe => 'About me';

	/// en: 'Tell us about yourself'
	String get tellUsAboutYourself => 'Tell us about yourself';

	/// en: 'Add'
	String get add => 'Add';

	/// en: 'Birth date'
	String get birthDate => 'Birth date';

	/// en: 'Username'
	String get username => 'Username';

	/// en: 'Must contain no more than 25 characters'
	String get validationFirstNameMaxLength => 'Must contain no more than 25 characters';

	/// en: 'Must contain no more than 25 characters'
	String get validationLastNameMaxLength => 'Must contain no more than 25 characters';

	/// en: 'Must contain no more than 140 characters'
	String get validationAboutMeMaxLength => 'Must contain no more than 140 characters';

	/// en: 'Cancel'
	String get cancel => _root.common.cancel;

	/// en: 'Done'
	String get done => _root.common.done;

	/// en: 'Edit'
	String get edit => _root.common.edit;

	/// en: 'Close'
	String get close => _root.common.close;

	/// en: 'Error'
	String get error => _root.common.error;

	/// en: 'Saving profile'
	String get errorSavingProfile => 'Saving profile';

	/// en: '{date}'
	String birthDayFormat({required Object date}) => '${date}';

	/// en: 'Remove date birth'
	String get birthDayRemove => 'Remove date birth';

	/// en: 'Edit photo'
	String get editPhoto => 'Edit photo';

	/// en: 'Take photo'
	String get takePhoto => 'Take photo';

	/// en: 'Choose from gallery'
	String get chooseFromGallery => 'Choose from gallery';

	/// en: 'File'
	String get chooseFile => 'File';

	/// en: 'Emoji'
	String get chooseEmoji => 'Emoji';

	/// en: 'Link'
	String get chooseLink => 'Link';

	/// en: 'No photos'
	String get galleryEmpty => 'No photos';

	/// en: 'No access to photos'
	String get galleryAccessDenied => 'No access to photos';

	/// en: 'Open settings'
	String get galleryOpenSettings => 'Open settings';

	/// en: 'Manage access'
	String get galleryManageAccess => 'Manage access';

	/// en: 'Mobile phone'
	String get mobilePhone => 'Mobile phone';

	/// en: 'Number'
	String get number => 'Number';

	/// en: 'Copy'
	String get copy => 'Copy';

	/// en: 'Copied'
	String get copied => 'Copied';
}

// Path: screenAuth
class Translations$screenAuth$en {
	Translations$screenAuth$en.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Enter your mobile phone number'
	String get enterYourMobilePhoneNumber => 'Enter your mobile phone number';

	/// en: 'Currently, we only support phone numbers from Russian mobile operators'
	String get currentlyWeOnlySupportPhoneNumbersFromRussianMobileOperators => 'Currently, we only support phone numbers from Russian mobile operators';

	/// en: 'Insert debug phone'
	String get insertDebugPhone => 'Insert debug phone';

	/// en: 'Call for free'
	String get callForFree => 'Call for free';

	/// en: 'We are expecting your call within {duration}'
	String weAreExpectingYourCallWithin({required Object duration}) => 'We are expecting your call within ${duration}';

	/// en: 'Sign in with'
	String get signInWith => 'Sign in with';

	/// en: 'Continue'
	String get kContinue => _root.common.kContinue;

	/// en: 'Invalid phone number'
	String get invalidPhoneNumber => 'Invalid phone number';
}

// Path: screenAuthModerationApplicationStore
class Translations$screenAuthModerationApplicationStore$en {
	Translations$screenAuthModerationApplicationStore$en.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Verification code mismatch'
	String get verificationCodeMismatch => 'Verification code mismatch';

	/// en: 'Moderation application store session not found'
	String get moderationApplicationStoreSessionNotFound => 'Moderation application store session not found';

	/// en: 'Invalid public shared key'
	String get invalidPublicSharedKey => 'Invalid public shared key';

	/// en: 'Invalid public salt key'
	String get invalidPublicSaltKey => 'Invalid public salt key';

	/// en: 'Enter the code'
	String get enterTheCode => 'Enter the code';

	/// en: 'We sent a confirmation code to the number {phoneNumber}'
	String sentConfirmationCodeToNumber({required Object phoneNumber}) => 'We sent a confirmation code to the number ${phoneNumber}';

	/// en: 'Signature verification failed'
	String get signatureVerificationFailed => 'Signature verification failed';
}

// Path: screenAuthCallpasswordConfirmation
class Translations$screenAuthCallpasswordConfirmation$en {
	Translations$screenAuthCallpasswordConfirmation$en.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'We are expecting your call within {duration}'
	String weAreExpectingYourCallWithin({required Object duration}) => 'We are expecting your call within ${duration}';

	/// en: 'Call {confirmationPhoneNumberRu} from the phone number you provided and wait for the call to be disconnected.'
	String confirmYourNumberDetail({required Object confirmationPhoneNumberRu}) => 'Call ${confirmationPhoneNumberRu} from the phone number you provided and wait for the call to be disconnected.';

	/// en: 'Call for free'
	String get callForFree => 'Call for free';

	/// en: 'Signature verification failed'
	String get signatureVerificationFailed => 'Signature verification failed';
}

// Path: grpcError
class Translations$grpcError$en {
	Translations$grpcError$en.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Error connecting to the server'
	String get errorConnectingServer => 'Error connecting to the server';

	/// en: 'Unauthenticated'
	String get unauthenticated => 'Unauthenticated';

	/// en: 'Unable to connect to the server'
	String get unableConnectServer => 'Unable to connect to the server';

	/// en: 'Internal server error'
	String get internalServerError => 'Internal server error';

	/// en: 'Unknown error'
	String get unknownError => 'Unknown error';
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

/// The flat map containing all translations for locale <en>.
/// Only for edge cases! For simple maps, use the map function of this library.
///
/// The Dart AOT compiler has issues with very large switch statements,
/// so the map is split into smaller functions (512 entries each).
extension on Translations {
	dynamic _flatMapFunction(String path) {
		return switch (path) {
			'common.mobilePhone' => 'Mobile phone number',
			'common.kContinue' => 'Continue',
			'common.cancel' => 'Cancel',
			'common.back' => 'Back',
			'common.save' => 'Save',
			'common.online' => 'Online',
			'common.done' => 'Done',
			'common.close' => 'Close',
			'common.error' => 'Error',
			'common.biometricAuthenticateReason' => 'Authenticate to unlock',
			'common.biometricPleaseEnterPasscode' => 'Please enter passcode',
			'common.edit' => 'Edit',
			'componentsConnectionTitle.waitingForNetwork' => 'Waiting for network',
			'componentsConnectionTitle.connecting' => 'Connecting',
			'componentsConnectionTitle.updating' => 'Updating',
			'componentsCamera.unavailable' => 'Camera unavailable',
			'componentsCamera.accessDenied' => 'No access to camera',
			'componentsCamera.openSettings' => 'Open settings',
			'screenHome.contacts' => 'Contacts',
			'screenHome.calls' => 'Calls',
			'screenHome.chats' => _root.screenChats.chats,
			'screenHome.settings' => _root.screenSettings.settings,
			'screenChats.chats' => 'Chats',
			'screenSettings.settings' => 'Settings',
			'screenSettings.myProfile' => 'My profile',
			'screenSettings.devices' => _root.screenSettingsDevices.devices,
			'screenSettings.language' => 'Language',
			'screenSettings.appearance' => _root.screenSettingsAppearance.appearance,
			'screenSettings.privacyAndSecurity' => 'Privacy and security',
			'screenSettings.aboutApplication' => 'About the application',
			'screenSettings.logout' => 'Logout',
			'screenSettingsAppearance.appearance' => 'Appearance',
			'screenSettingsAppearance.colorTheme' => 'Color theme',
			'screenSettingsAppearance.colorThemeDefault' => 'Default',
			'screenSettingsAppearance.colorThemeGreen' => 'Green',
			'screenSettingsAppearance.colorThemePurple' => 'Purple',
			'screenSettingsAppearance.colorThemeOrange' => 'Orange',
			'screenSettingsAppearance.darkMode' => 'Dark mode',
			'screenSettingsAppearance.darkModeSystem' => 'System',
			'screenSettingsAppearance.darkModeAlwaysOn' => 'Always on',
			'screenSettingsAppearance.darkModeDisabled' => 'Disabled',
			'screenSettingsAppearance.darkModeSystemDescription' => 'As in the device settings',
			'screenSettingsAppearance.darkModeAlwaysOnDescription' => 'Dark mode is always on',
			'screenSettingsAppearance.darkModeDisabledDescription' => 'Dark mode is disabled',
			'screenSettingsAppearance.blurOnInactive' => 'Blur on inactive',
			'screenSettingsAppearance.blurOnInactiveDescription' => 'The app appears blurry in the list of open apps',
			'screenSettingsDevices.devices' => 'Devices',
			'screenSettingsDevices.thisDevice' => 'This device',
			'screenSettingsDevices.deviceSessionListTileSubtitle' => ({required Object location, required Object updateAt}) => '${location} · ${updateAt}',
			'screenSettingsDevices.terminateAllOtherDeviceSessions' => 'Terminate all other sessions',
			'screenSettingsDevices.activeDeviceSession' => 'Active sessions',
			'screenSettingsDevices.terminateDeviceSession' => 'Terminate session',
			'screenSettingsDevices.areYouSureYouLogOutFromThisDevice' => 'Are you sure you want to log out from this device?',
			'screenSettingsDevices.cancel' => _root.common.cancel,
			'screenSettingsDevices.online' => _root.common.online,
			'screenSettingsDevices.terminate' => 'Terminate',
			'screenSettingsAboutApplication.aboutApplication' => _root.screenSettings.aboutApplication,
			'screenSettingsAboutApplication.version' => ({required Object version, required Object build}) => 'Version ${version} (${build})',
			'screenSettingsAboutApplication.licenses' => 'Licenses',
			'screenSettingsAboutApplication.licensesCount' => ({required Object n}) => '${n} licenses',
			'screenSettingsAboutApplication.noLicenses' => 'No licenses found',
			'screenSettingsLanguage.language' => 'Language',
			'screenSettingsPasscode.passcode' => 'Passcode',
			'screenSettingsPasscode.passcodeAndFaceID' => 'Passcode & Face ID',
			'screenSettingsPasscode.passcodeAndBiometric' => 'Passcode & Biometric',
			'screenSettingsPasscode.note' => 'Note: If you forget your passcode, you will need to reinstall the app',
			'screenSettingsPasscode.turnOn' => 'Turn passcode on',
			'screenSettingsPasscode.turnOff' => 'Turn passcode off',
			'screenSettingsPasscode.change' => 'Change passcode',
			'screenSettingsPasscode.autoLock' => 'Auto-Lock',
			'screenSettingsPasscode.faceIDUnlock' => 'Unlock with Face ID',
			'screenSettingsPasscode.biometricUnlock' => 'Unlock with biometric',
			'screenSettingsPasscode.autoLockOff' => 'Off',
			'screenSettingsPasscode.autoLockMinutes' => ({required num n}) => (_root.$meta.cardinalResolver ?? PluralResolvers.cardinal('en'))(n, one: 'After ${n} minute', other: 'After ${n} minutes', ), 
			'screenSettingsPasscode.autoLockHours' => ({required num n}) => (_root.$meta.cardinalResolver ?? PluralResolvers.cardinal('en'))(n, one: 'After ${n} hour', other: 'After ${n} hours', ), 
			'screenSettingsPasscode.pleaseEnterPasscode' => 'Please enter passcode',
			'screenSettingsPasscode.cancel' => _root.common.cancel,
			'settingsPasscodeCreate.pleaseEnterNewPasscode' => 'Please enter new passcode',
			'settingsPasscodeCreate.pleaseEnterNewPasscodeAgain' => 'Please enter new passcode again',
			'settingsPasscodeCreate.cancel' => _root.common.cancel,
			'sessionsPrivacyAndSecurity.privacyAndSecurity' => 'Privacy and security',
			'sessionsPrivacyAndSecurity.passcodeAndFaceID' => 'Passcode & Face ID',
			'sessionsPrivacyAndSecurity.passcodeAndBiometric' => 'Passcode & Biometric',
			'sessionsPrivacyAndSecurity.passcode' => 'Passcode',
			'screenMyProfile.myprofile' => 'My profile',
			'screenMyProfile.firstName' => 'First name',
			'screenMyProfile.lastName' => 'Last name',
			'screenMyProfile.aboutMe' => 'About me',
			'screenMyProfile.tellUsAboutYourself' => 'Tell us about yourself',
			'screenMyProfile.add' => 'Add',
			'screenMyProfile.birthDate' => 'Birth date',
			'screenMyProfile.username' => 'Username',
			'screenMyProfile.validationFirstNameMaxLength' => 'Must contain no more than 25 characters',
			'screenMyProfile.validationLastNameMaxLength' => 'Must contain no more than 25 characters',
			'screenMyProfile.validationAboutMeMaxLength' => 'Must contain no more than 140 characters',
			'screenMyProfile.cancel' => _root.common.cancel,
			'screenMyProfile.done' => _root.common.done,
			'screenMyProfile.edit' => _root.common.edit,
			'screenMyProfile.close' => _root.common.close,
			'screenMyProfile.error' => _root.common.error,
			'screenMyProfile.errorSavingProfile' => 'Saving profile',
			'screenMyProfile.birthDayFormat' => ({required Object date}) => '${date}',
			'screenMyProfile.birthDayRemove' => 'Remove date birth',
			'screenMyProfile.editPhoto' => 'Edit photo',
			'screenMyProfile.takePhoto' => 'Take photo',
			'screenMyProfile.chooseFromGallery' => 'Choose from gallery',
			'screenMyProfile.chooseFile' => 'File',
			'screenMyProfile.chooseEmoji' => 'Emoji',
			'screenMyProfile.chooseLink' => 'Link',
			'screenMyProfile.galleryEmpty' => 'No photos',
			'screenMyProfile.galleryAccessDenied' => 'No access to photos',
			'screenMyProfile.galleryOpenSettings' => 'Open settings',
			'screenMyProfile.galleryManageAccess' => 'Manage access',
			'screenMyProfile.mobilePhone' => 'Mobile phone',
			'screenMyProfile.number' => 'Number',
			'screenMyProfile.copy' => 'Copy',
			'screenMyProfile.copied' => 'Copied',
			'screenAuth.enterYourMobilePhoneNumber' => 'Enter your mobile phone number',
			'screenAuth.currentlyWeOnlySupportPhoneNumbersFromRussianMobileOperators' => 'Currently, we only support phone numbers from Russian mobile operators',
			'screenAuth.insertDebugPhone' => 'Insert debug phone',
			'screenAuth.callForFree' => 'Call for free',
			'screenAuth.weAreExpectingYourCallWithin' => ({required Object duration}) => 'We are expecting your call within ${duration}',
			'screenAuth.signInWith' => 'Sign in with',
			'screenAuth.kContinue' => _root.common.kContinue,
			'screenAuth.invalidPhoneNumber' => 'Invalid phone number',
			'screenAuthModerationApplicationStore.verificationCodeMismatch' => 'Verification code mismatch',
			'screenAuthModerationApplicationStore.moderationApplicationStoreSessionNotFound' => 'Moderation application store session not found',
			'screenAuthModerationApplicationStore.invalidPublicSharedKey' => 'Invalid public shared key',
			'screenAuthModerationApplicationStore.invalidPublicSaltKey' => 'Invalid public salt key',
			'screenAuthModerationApplicationStore.enterTheCode' => 'Enter the code',
			'screenAuthModerationApplicationStore.sentConfirmationCodeToNumber' => ({required Object phoneNumber}) => 'We sent a confirmation code to the number ${phoneNumber}',
			'screenAuthModerationApplicationStore.signatureVerificationFailed' => 'Signature verification failed',
			'screenAuthCallpasswordConfirmation.weAreExpectingYourCallWithin' => ({required Object duration}) => 'We are expecting your call within ${duration}',
			'screenAuthCallpasswordConfirmation.confirmYourNumberDetail' => ({required Object confirmationPhoneNumberRu}) => 'Call ${confirmationPhoneNumberRu} from the phone number you provided and wait for the call to be disconnected.',
			'screenAuthCallpasswordConfirmation.callForFree' => 'Call for free',
			'screenAuthCallpasswordConfirmation.signatureVerificationFailed' => 'Signature verification failed',
			'grpcError.errorConnectingServer' => 'Error connecting to the server',
			'grpcError.unauthenticated' => 'Unauthenticated',
			'grpcError.unableConnectServer' => 'Unable to connect to the server',
			'grpcError.internalServerError' => 'Internal server error',
			'grpcError.unknownError' => 'Unknown error',
			'dateTime.relativeDateTimeToday' => ({required Object time}) => 'today at ${time}',
			'dateTime.relativeDateTimeYesterday' => ({required Object time}) => 'yesterday at ${time}',
			'dateTime.relativeDateTimeOther' => ({required Object date, required Object time}) => '${date} at ${time}',
			_ => null,
		};
	}
}
