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
		  _meta = meta ?? TranslationMetadata(
		    locale: AppLocale.en,
		    overrides: overrides ?? {},
		    cardinalResolver: cardinalResolver,
		    ordinalResolver: ordinalResolver,
		  ) {
		_meta.setFlatMapFunction(_flatMapFunction);
	}

	/// Metadata for the translations of <en>.
	final TranslationMetadata<AppLocale, Translations> _meta;
	@override TranslationMetadata<AppLocale, Translations> get $meta => _meta;

	/// Access flat map
	dynamic operator[](String key) => _meta.getTranslation(key);

	late final Translations _root = this; // ignore: unused_field

	Translations $copyWith({TranslationMetadata<AppLocale, Translations>? meta}) => Translations(meta: meta ?? this.$meta);

	// Translations
	late final Translations$common$en common = Translations$common$en.internal(_root);
	late final Translations$componentsConnectionTitle$en componentsConnectionTitle = Translations$componentsConnectionTitle$en.internal(_root);
	late final Translations$componentsCamera$en componentsCamera = Translations$componentsCamera$en.internal(_root);
	late final Translations$screenHome$en screenHome = Translations$screenHome$en.internal(_root);
	late final Translations$screenChats$en screenChats = Translations$screenChats$en.internal(_root);
	late final Translations$screenChat$en screenChat = Translations$screenChat$en.internal(_root);
	late final Translations$screenSettings$en screenSettings = Translations$screenSettings$en.internal(_root);
	late final Translations$screenSettingsNotifications$en screenSettingsNotifications = Translations$screenSettingsNotifications$en.internal(_root);
	late final Translations$screenDeveloper$en screenDeveloper = Translations$screenDeveloper$en.internal(_root);
	late final Translations$screenSettingsAppearance$en screenSettingsAppearance = Translations$screenSettingsAppearance$en.internal(_root);
	late final Translations$screenSettingsDevices$en screenSettingsDevices = Translations$screenSettingsDevices$en.internal(_root);
	late final Translations$screenSettingsAboutApplication$en screenSettingsAboutApplication = Translations$screenSettingsAboutApplication$en.internal(_root);
	late final Translations$screenSettingsLanguage$en screenSettingsLanguage = Translations$screenSettingsLanguage$en.internal(_root);
	late final Translations$screenSettingsPasscode$en screenSettingsPasscode = Translations$screenSettingsPasscode$en.internal(_root);
	late final Translations$settingsPasscodeCreate$en settingsPasscodeCreate = Translations$settingsPasscodeCreate$en.internal(_root);
	late final Translations$sessionsPrivacyAndSecurity$en sessionsPrivacyAndSecurity = Translations$sessionsPrivacyAndSecurity$en.internal(_root);
	late final Translations$cloudPassword$en cloudPassword = Translations$cloudPassword$en.internal(_root);
	late final Translations$screenMyProfile$en screenMyProfile = Translations$screenMyProfile$en.internal(_root);
	late final Translations$screenProfile$en screenProfile = Translations$screenProfile$en.internal(_root);
	late final Translations$screenHideProfile$en screenHideProfile = Translations$screenHideProfile$en.internal(_root);
	late final Translations$screenContacts$en screenContacts = Translations$screenContacts$en.internal(_root);
	late final Translations$screenCalls$en screenCalls = Translations$screenCalls$en.internal(_root);
	late final Translations$screenAuth$en screenAuth = Translations$screenAuth$en.internal(_root);
	late final Translations$screenAuthModerationApplicationStore$en screenAuthModerationApplicationStore = Translations$screenAuthModerationApplicationStore$en.internal(_root);
	late final Translations$screenAuthCallpasswordConfirmation$en screenAuthCallpasswordConfirmation = Translations$screenAuthCallpasswordConfirmation$en.internal(_root);
	late final Translations$grpcError$en grpcError = Translations$grpcError$en.internal(_root);
	late final Translations$dateTime$en dateTime = Translations$dateTime$en.internal(_root);
	late final Translations$screenCall$en screenCall = Translations$screenCall$en.internal(_root);
	late final Translations$passkey$en passkey = Translations$passkey$en.internal(_root);
	late final Translations$yandex$en yandex = Translations$yandex$en.internal(_root);
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

	/// en: 'OK'
	String get ok => 'OK';

	/// en: 'Cancel'
	String get cancel => 'Cancel';

	/// en: 'Not now'
	String get notNow => 'Not now';

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

	/// en: 'No internet connection'
	String get noConnectionTitle => 'No internet connection';

	/// en: 'Check your connection and try again.'
	String get noConnectionMessage => 'Check your connection and try again.';

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

	/// en: 'Turn on notifications'
	String get notificationPermissionTitle => 'Turn on notifications';

	/// en: 'Allow notifications to hear about new messages and contacts even when Iperon is in the background.'
	String get notificationPermissionMessage => 'Allow notifications to hear about new messages and contacts even when Iperon is in the background.';

	/// en: 'Allow'
	String get allowAccess => 'Allow';

	/// en: 'All chats'
	String get allFolder => 'All chats';

	/// en: 'Search'
	String get search => 'Search';

	/// en: 'No chats yet'
	String get empty => 'No chats yet';

	/// en: 'No chats in this folder yet'
	String get emptyFolder => 'No chats in this folder yet';

	/// en: 'Archive is empty'
	String get emptyArchive => 'Archive is empty';

	/// en: 'Archive'
	String get archive => 'Archive';

	/// en: 'Saved Messages'
	String get savedMessages => 'Saved Messages';

	/// en: 'Draft:'
	String get draft => 'Draft:';

	/// en: 'typing…'
	String get typing => 'typing…';

	/// en: '{name} is typing…'
	String typingName({required Object name}) => '${name} is typing…';

	/// en: 'Photo'
	String get photo => 'Photo';

	/// en: 'Video'
	String get video => 'Video';

	/// en: 'File'
	String get file => 'File';

	/// en: 'Voice message'
	String get voice => 'Voice message';

	/// en: 'Pin'
	String get pin => 'Pin';

	/// en: 'Unpin'
	String get unpin => 'Unpin';

	/// en: 'Mark as read'
	String get markRead => 'Mark as read';

	/// en: 'Mark as unread'
	String get markUnread => 'Mark as unread';

	/// en: 'Mute'
	String get mute => 'Mute';

	/// en: 'Unmute'
	String get unmute => 'Unmute';

	/// en: 'Archive'
	String get toArchive => 'Archive';

	/// en: 'Unarchive'
	String get fromArchive => 'Unarchive';

	/// en: 'Delete'
	String get delete => 'Delete';

	/// en: 'Delete chat?'
	String get deleteChatTitle => 'Delete chat?';

	/// en: 'Chat "{title}" will be removed from the list.'
	String deleteChatMessage({required Object title}) => 'Chat "${title}" will be removed from the list.';

	/// en: 'Read all'
	String get readAll => 'Read all';

	/// en: 'Delete folder'
	String get deleteFolder => 'Delete folder';

	/// en: 'Delete folder "{title}"?'
	String deleteFolderTitle({required Object title}) => 'Delete folder "${title}"?';

	/// en: 'Chats in the folder are not deleted.'
	String get deleteFolderMessage => 'Chats in the folder are not deleted.';
}

// Path: screenChat
class Translations$screenChat$en {
	Translations$screenChat$en.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Today'
	String get today => 'Today';

	/// en: 'Yesterday'
	String get yesterday => 'Yesterday';

	/// en: 'online'
	String get online => 'online';

	/// en: 'last seen recently'
	String get lastSeenRecently => 'last seen recently';

	/// en: '(one) {{n} member} (other) {{n} members}'
	String members({required num n}) => (_root.$meta.cardinalResolver ?? PluralResolvers.cardinal('en'))(n,
		one: '${n} member',
		other: '${n} members',
	);

	/// en: '(one) {{n} subscriber} (other) {{n} subscribers}'
	String subscribers({required num n}) => (_root.$meta.cardinalResolver ?? PluralResolvers.cardinal('en'))(n,
		one: '${n} subscriber',
		other: '${n} subscribers',
	);

	/// en: 'Message'
	String get message => 'Message';

	/// en: 'No messages yet'
	String get empty => 'No messages yet';

	/// en: 'Chat not found'
	String get notFound => 'Chat not found';

	/// en: 'Reply'
	String get reply => 'Reply';

	/// en: 'Copy'
	String get copy => 'Copy';

	/// en: 'Copied'
	String get copied => 'Copied';

	/// en: 'Edit'
	String get edit => 'Edit';

	/// en: 'Editing'
	String get editing => 'Editing';

	/// en: 'edited'
	String get edited => 'edited';

	/// en: 'Delete'
	String get delete => 'Delete';

	/// en: 'Delete message?'
	String get deleteTitle => 'Delete message?';

	/// en: 'The message will be deleted for everyone in the chat.'
	String get deleteMessage => 'The message will be deleted for everyone in the chat.';

	/// en: 'You'
	String get you => 'You';

	/// en: 'Mute'
	String get mute => 'Mute';

	/// en: 'Unmute'
	String get unmute => 'Unmute';

	/// en: 'Photo'
	String get photo => _root.screenChats.photo;

	/// en: 'Video'
	String get video => _root.screenChats.video;

	/// en: 'File'
	String get file => _root.screenChats.file;

	/// en: 'Voice message'
	String get voice => _root.screenChats.voice;
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

	/// en: 'Notifications and sounds'
	String get notifications => _root.screenSettingsNotifications.notifications;

	/// en: 'Privacy and security'
	String get privacyAndSecurity => 'Privacy and security';

	/// en: 'About the application'
	String get aboutApplication => 'About the application';

	/// en: 'Logs'
	String get logs => 'Logs';

	/// en: 'Logout'
	String get logout => 'Logout';
}

// Path: screenSettingsNotifications
class Translations$screenSettingsNotifications$en {
	Translations$screenSettingsNotifications$en.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Notifications and sounds'
	String get notifications => 'Notifications and sounds';

	/// en: 'Message notifications'
	String get messageNotifications => 'Message notifications';

	/// en: 'Private chats'
	String get privateChats => 'Private chats';

	/// en: 'Groups'
	String get groups => 'Groups';

	/// en: 'Channels'
	String get channels => 'Channels';

	/// en: 'On'
	String get on => 'On';

	/// en: 'Off'
	String get off => 'Off';

	/// en: 'Events'
	String get events => 'Events';

	/// en: 'Contact joined Iperon'
	String get contactJoined => 'Contact joined Iperon';

	/// en: 'Missed calls'
	String get missedCalls => 'Missed calls';

	/// en: 'Show notifications'
	String get showNotifications => 'Show notifications';

	/// en: 'Message preview'
	String get messagePreview => 'Message preview';

	/// en: 'Sound'
	String get sound => 'Sound';

	/// en: 'Without a preview, notifications show only who sent the message.'
	String get messagePreviewNote => 'Without a preview, notifications show only who sent the message.';

	/// en: 'Settings apply to all your devices.'
	String get settingsSyncNote => 'Settings apply to all your devices.';

	/// en: 'Notifications are turned off'
	String get permissionMissingTitle => 'Notifications are turned off';

	/// en: 'Iperon isn't allowed to show notifications on this device, so these settings won't take effect.'
	String get permissionMissingMessage => 'Iperon isn\'t allowed to show notifications on this device, so these settings won\'t take effect.';

	/// en: 'Turn on'
	String get enable => 'Turn on';

	/// en: 'Couldn't load the settings'
	String get loadError => 'Couldn\'t load the settings';

	/// en: 'No connection. You can change this once you're back online.'
	String get offlineNote => 'No connection. You can change this once you\'re back online.';

	/// en: 'Retry'
	String get retry => 'Retry';
}

// Path: screenDeveloper
class Translations$screenDeveloper$en {
	Translations$screenDeveloper$en.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Developer'
	String get developer => 'Developer';

	/// en: 'Logs'
	String get logs => _root.screenSettings.logs;

	/// en: 'Export logs'
	String get exportLogs => 'Export logs';

	/// en: 'Call screen preview'
	String get callPreview => 'Call screen preview';

	/// en: 'Chats demo'
	String get chatsDemo => 'Chats demo';

	/// en: 'Test notification'
	String get testPush => 'Test notification';

	/// en: 'Sent: APNs — {apns}, FCM — {fcm}, failed — {failed}. Minimize the app or lock the screen to check background delivery.'
	String testPushSent({required Object apns, required Object fcm, required Object failed}) => 'Sent: APNs — ${apns}, FCM — ${fcm}, failed — ${failed}. Minimize the app or lock the screen to check background delivery.';

	/// en: 'None of your devices has a push token. Make sure notifications are allowed and restart the app.'
	String get testPushNoTokens => 'None of your devices has a push token. Make sure notifications are allowed and restart the app.';

	/// en: 'Failed to send: {error}'
	String testPushError({required Object error}) => 'Failed to send: ${error}';

	/// en: 'Test notification (encrypted)'
	String get testPushEncrypted => 'Test notification (encrypted)';

	/// en: 'Queued on the server. Android shows "Encrypted test notification: decryption works"; iPhone shows "New notification" for now (iOS decryption comes later).'
	String get testPushQueued => 'Queued on the server. Android shows "Encrypted test notification: decryption works"; iPhone shows "New notification" for now (iOS decryption comes later).';
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

	/// en: 'Cloud password'
	String get cloudPassword => 'Cloud password';

	/// en: 'Passkeys'
	String get passkeys => 'Passkeys';

	/// en: 'Who can call me'
	String get whoCanCall => 'Who can call me';

	/// en: 'Calls'
	String get calls => 'Calls';

	/// en: 'Everybody'
	String get callsEverybody => 'Everybody';

	/// en: 'My contacts'
	String get callsContacts => 'My contacts';

	/// en: 'Nobody'
	String get callsNobody => 'Nobody';

	/// en: 'Couldn't load the setting'
	String get callsLoadError => 'Couldn\'t load the setting';

	/// en: 'No connection. You can change this once you're back online.'
	String get callsOfflineNote => 'No connection. You can change this once you\'re back online.';

	/// en: 'Retry'
	String get retry => 'Retry';

	/// en: 'Exceptions'
	String get exceptions => 'Exceptions';

	/// en: 'Always allow'
	String get callsAlwaysAllow => 'Always allow';

	/// en: 'Always deny'
	String get callsAlwaysDeny => 'Always deny';

	/// en: 'No contacts registered on Iperon'
	String get callsAllowEmpty => 'No contacts registered on Iperon';

	/// en: 'Birthday'
	String get birthday => 'Birthday';

	/// en: 'Who can see my birthday'
	String get whoCanSeeBirthday => 'Who can see my birthday';

	/// en: 'Hide birth year'
	String get hideBirthYear => 'Hide birth year';

	/// en: 'Contacts will see only the day and month — no birth year or age.'
	String get hideBirthYearNote => 'Contacts will see only the day and month — no birth year or age.';

	/// en: 'About me'
	String get aboutMe => 'About me';

	/// en: 'Who can see my About me'
	String get whoCanSeeAboutMe => 'Who can see my About me';

	/// en: 'Last seen'
	String get lastSeen => 'Last seen';

	/// en: 'Who can see my last seen'
	String get whoCanSeeLastSeen => 'Who can see my last seen';

	/// en: 'If you choose Nobody, you won't see others' last seen or online status either.'
	String get lastSeenReciprocityNote => 'If you choose Nobody, you won\'t see others\' last seen or online status either.';
}

// Path: cloudPassword
class Translations$cloudPassword$en {
	Translations$cloudPassword$en.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Cloud password'
	String get title => 'Cloud password';

	/// en: 'An additional password asked when signing in on a new device. Add an email so you can recover access if you forget it.'
	String get description => 'An additional password asked when signing in on a new device. Add an email so you can recover access if you forget it.';

	/// en: 'Enter your cloud password'
	String get enterPasswordHint => 'Enter your cloud password';

	/// en: 'Two-step verification is enabled. Your account is protected by an additional password.'
	String get unlockInfo => 'Two-step verification is enabled. Your account is protected by an additional password.';

	/// en: 'Add an email to recover access if you forget your cloud password.'
	String get setupEmailHint => 'Add an email to recover access if you forget your cloud password.';

	/// en: 'Now set a cloud password. You'll be asked for it when signing in on a new device.'
	String get setupPasswordHint => 'Now set a cloud password. You\'ll be asked for it when signing in on a new device.';

	/// en: 'Enter a new cloud password.'
	String get changePasswordHint => 'Enter a new cloud password.';

	/// en: 'Enable'
	String get enableButton => 'Enable';

	/// en: 'Cloud password'
	String get passwordPlaceholder => 'Cloud password';

	/// en: 'Continue'
	String get continueButton => 'Continue';

	/// en: 'Next'
	String get next => 'Next';

	/// en: 'Forgot password?'
	String get forgotPassword => 'Forgot password?';

	/// en: 'We sent a recovery code to {email}'
	String recoveryHint({required Object email}) => 'We sent a recovery code to ${email}';

	/// en: 'Enter the email linked to your account. If it matches, we'll send a recovery code to it.'
	String get recoveryEmailHint => 'Enter the email linked to your account. If it matches, we\'ll send a recovery code to it.';

	/// en: 'Code from email'
	String get codePlaceholder => 'Code from email';

	/// en: 'New password'
	String get newPasswordPlaceholder => 'New password';

	/// en: 'Repeat password'
	String get repeatPasswordPlaceholder => 'Repeat password';

	/// en: 'Current password'
	String get currentPasswordPlaceholder => 'Current password';

	/// en: 'Reset password'
	String get resetPassword => 'Reset password';

	/// en: 'Reset'
	String get reset => 'Reset';

	/// en: 'Attempts left: {count}'
	String attemptsLeft({required Object count}) => 'Attempts left: ${count}';

	/// en: '(one) {{n} attempt left} (other) {{n} attempts left}'
	String attemptsLeftInline({required num n}) => (_root.$meta.cardinalResolver ?? PluralResolvers.cardinal('en'))(n,
		one: '${n} attempt left',
		other: '${n} attempts left',
	);

	/// en: 'Set password'
	String get setPassword => 'Set password';

	/// en: 'New password'
	String get newPasswordTitle => 'New password';

	/// en: 'Set a cloud password. You'll be asked for it when signing in on a new device.'
	String get newPasswordDescription => 'Set a cloud password. You\'ll be asked for it when signing in on a new device.';

	/// en: 'Change password'
	String get changePassword => 'Change password';

	/// en: 'Email'
	String get email => 'Email';

	/// en: 'Email'
	String get emailPlaceholder => 'Email';

	/// en: 'Not set'
	String get emailNotSet => 'Not set';

	/// en: 'We sent a verification code to your email.'
	String get emailCodeSent => 'We sent a verification code to your email.';

	/// en: 'Verify email'
	String get verifyEmail => 'Verify email';

	/// en: 'Disable password'
	String get disable => 'Disable password';

	/// en: 'Couldn't load cloud password settings'
	String get loadError => 'Couldn\'t load cloud password settings';

	/// en: 'Retry'
	String get retry => 'Retry';

	/// en: 'Enter an email'
	String get emailRequired => 'Enter an email';

	/// en: 'Enter a password'
	String get passwordRequired => 'Enter a password';

	/// en: 'Password must be at least 5 characters'
	String get passwordTooShort => 'Password must be at least 5 characters';

	/// en: 'Enter the code'
	String get codeRequired => 'Enter the code';

	/// en: 'Passwords don't match'
	String get passwordsDoNotMatch => 'Passwords don\'t match';

	/// en: 'Wrong password'
	String get wrongPassword => 'Wrong password';

	/// en: 'Too many attempts. Please start again.'
	String get tooManyAttempts => 'Too many attempts. Please start again.';

	/// en: 'Wrong code'
	String get codeMismatch => 'Wrong code';

	/// en: 'Cloud password is not set'
	String get notSet => 'Cloud password is not set';

	/// en: 'Invalid email'
	String get invalidEmail => 'Invalid email';

	/// en: 'Session expired. Please start again.'
	String get sessionExpired => 'Session expired. Please start again.';
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

	/// en: 'Saving avatar'
	String get errorSavingAvatar => 'Saving avatar';

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

	/// en: 'username'
	String get usernameHint => 'username';

	/// en: 'You can choose a username. Use 5–24 characters: lowercase Latin letters, digits and underscores'
	String get usernameDescription => 'You can choose a username. Use 5–24 characters: lowercase Latin letters, digits and underscores';

	/// en: 'Username must contain 5–24 characters: lowercase Latin letters, digits and underscores'
	String get usernameInvalid => 'Username must contain 5–24 characters:\nlowercase Latin letters, digits and underscores';

	/// en: 'This username is already taken'
	String get usernameTaken => 'This username is already taken';

	/// en: 'Saving username'
	String get errorSavingUsername => 'Saving username';
}

// Path: screenProfile
class Translations$screenProfile$en {
	Translations$screenProfile$en.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Profile'
	String get profile => 'Profile';

	/// en: 'First name'
	String get firstName => _root.screenMyProfile.firstName;

	/// en: 'Last name'
	String get lastName => _root.screenMyProfile.lastName;

	/// en: 'Mobile phone'
	String get mobilePhone => _root.screenMyProfile.mobilePhone;

	/// en: 'Username'
	String get username => _root.screenMyProfile.username;

	/// en: 'About me'
	String get aboutMe => _root.screenMyProfile.aboutMe;

	/// en: 'Birth date'
	String get birthDate => _root.screenMyProfile.birthDate;

	/// en: '(one) {{n} year} (other) {{n} years}'
	String age({required num n}) => (_root.$meta.cardinalResolver ?? PluralResolvers.cardinal('en'))(n,
		one: '${n} year',
		other: '${n} years',
	);

	/// en: 'Copy'
	String get copy => _root.screenMyProfile.copy;

	/// en: 'Hide profile'
	String get hideProfile => 'Hide profile';
}

// Path: screenHideProfile
class Translations$screenHideProfile$en {
	Translations$screenHideProfile$en.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Hide profile'
	String get title => 'Hide profile';

	/// en: 'The person disappears from your Contacts, Calls, and Chats on this device. To show them again, type “/passphrase” in search. The passphrase is stored only as a hash and never leaves the device.'
	String get description => 'The person disappears from your Contacts, Calls, and Chats on this device. To show them again, type “/passphrase” in search. The passphrase is stored only as a hash and never leaves the device.';

	/// en: 'Passphrase'
	String get phrasePlaceholder => 'Passphrase';

	/// en: 'Hide'
	String get hideAction => 'Hide';

	/// en: 'Reset passphrase'
	String get resetAction => 'Reset passphrase';

	/// en: 'Enter a passphrase to hide the profile.'
	String get errorEmptyPhrase => 'Enter a passphrase to hide the profile.';
}

// Path: screenContacts
class Translations$screenContacts$en {
	Translations$screenContacts$en.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Contacts'
	String get title => 'Contacts';

	/// en: 'On Iperon'
	String get onIperon => 'On Iperon';

	/// en: 'On Contacts'
	String get onContacts => 'On Contacts';

	/// en: 'Cloud contacts'
	String get cloudContacts => 'Cloud contacts';

	/// en: 'Invite'
	String get invite => 'Invite';

	/// en: 'Invite'
	String get inviteAction => 'Invite';

	/// en: 'Search'
	String get search => 'Search';

	/// en: 'Contacts access needed'
	String get permissionTitle => 'Contacts access needed';

	/// en: 'Allow access to your contacts to find friends already on Iperon. Your phone numbers are matched privately and never revealed to the server.'
	String get permissionMessage => 'Allow access to your contacts to find friends already on Iperon. Your phone numbers are matched privately and never revealed to the server.';

	/// en: 'Allow access'
	String get allowAccess => 'Allow access';

	/// en: 'Open settings'
	String get openSettings => 'Open settings';

	/// en: 'No contacts found'
	String get empty => 'No contacts found';

	/// en: 'Let's chat on Iperon'
	String get inviteMessage => 'Let\'s chat on Iperon';

	/// en: 'online'
	String get statusOnline => 'online';

	/// en: 'last seen recently'
	String get statusLastSeenRecently => 'last seen recently';

	/// en: 'last seen {date}'
	String statusLastSeen({required Object date}) => 'last seen ${date}';

	/// en: 'Add by number'
	String get addByNumber => 'Add by number';

	/// en: 'Add contact'
	String get addContact => 'Add contact';

	/// en: 'Phone number'
	String get addByNumberHint => 'Phone number';

	/// en: 'First name'
	String get addFirstName => 'First name';

	/// en: 'Last name'
	String get addLastName => 'Last name';

	/// en: 'Add'
	String get add => 'Add';

	/// en: 'Invalid phone number'
	String get addInvalidNumber => 'Invalid phone number';

	/// en: 'Couldn’t add contact'
	String get addFailed => 'Couldn’t add contact';

	/// en: 'Cloud contacts limit reached'
	String get validationCloudLimitReached => 'Cloud contacts limit reached';

	/// en: 'This contact will be available on all your devices'
	String get addSyncHint => 'This contact will be available on all your devices';

	/// en: 'Remove'
	String get remove => 'Remove';

	/// en: 'Remove contact?'
	String get removeTitle => 'Remove contact?';

	/// en: 'They will no longer be able to call you unless your call privacy allows everyone.'
	String get removeMessage => 'They will no longer be able to call you unless your call privacy allows everyone.';
}

// Path: screenCalls
class Translations$screenCalls$en {
	Translations$screenCalls$en.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Calls'
	String get title => 'Calls';

	/// en: 'Your calls will appear here'
	String get empty => 'Your calls will appear here';

	/// en: 'No missed calls'
	String get emptyMissed => 'No missed calls';

	/// en: 'Microphone access needed'
	String get permissionTitle => 'Microphone access needed';

	/// en: 'Allow microphone access to make and receive calls on Iperon.'
	String get permissionMessage => 'Allow microphone access to make and receive calls on Iperon.';

	/// en: 'Enable call notifications'
	String get notificationPermissionTitle => 'Enable call notifications';

	/// en: 'Allow notifications so you can see incoming calls even when Iperon is in the background.'
	String get notificationPermissionMessage => 'Allow notifications so you can see incoming calls even when Iperon is in the background.';

	/// en: 'Set up calls'
	String get permissionsTitle => 'Set up calls';

	/// en: 'Allow microphone and notifications so you can make calls and see incoming ones on Iperon.'
	String get permissionsMessage => 'Allow microphone and notifications so you can make calls and see incoming ones on Iperon.';

	/// en: 'Mini window during calls'
	String get pipPermissionTitle => 'Mini window during calls';

	/// en: 'Allow Picture-in-Picture so a video call keeps playing in a small window over your screen when you minimize Iperon.'
	String get pipPermissionMessage => 'Allow Picture-in-Picture so a video call keeps playing in a small window over your screen when you minimize Iperon.';

	/// en: 'Allow access'
	String get allowAccess => 'Allow access';

	/// en: 'Open settings'
	String get openSettings => 'Open settings';

	/// en: 'Search'
	String get search => 'Search';

	/// en: 'All'
	String get filterAll => 'All';

	/// en: 'Missed'
	String get filterMissed => 'Missed';

	/// en: 'Incoming'
	String get incoming => 'Incoming';

	/// en: 'Outgoing'
	String get outgoing => 'Outgoing';

	/// en: 'Missed'
	String get missed => 'Missed';

	/// en: 'Cancelled'
	String get cancelled => 'Cancelled';

	/// en: '{s} sec'
	String durationSec({required Object s}) => '${s} sec';

	/// en: '{m} min'
	String durationMin({required Object m}) => '${m} min';

	/// en: '{h} h'
	String durationHour({required Object h}) => '${h} h';

	/// en: '{h} h {m} min'
	String durationHourMin({required Object h, required Object m}) => '${h} h ${m} min';

	/// en: 'Unknown'
	String get unknown => 'Unknown';

	/// en: 'Delete'
	String get delete => 'Delete';

	/// en: 'Clear'
	String get clear => 'Clear';

	/// en: 'Clear call history?'
	String get clearTitle => 'Clear call history?';

	/// en: 'All call records will be deleted. This cannot be undone.'
	String get clearMessage => 'All call records will be deleted. This cannot be undone.';
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

// Path: screenCall
class Translations$screenCall$en {
	Translations$screenCall$en.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Call'
	String get title => 'Call';

	/// en: 'Tap to return to the call'
	String get returnToCall => 'Tap to return to the call';

	/// en: 'Call'
	String get bannerRinging => 'Call';

	/// en: 'In call'
	String get bannerActive => 'In call';

	/// en: 'Incoming call'
	String get incomingAudio => 'Incoming call';

	/// en: 'Incoming video call'
	String get incomingVideo => 'Incoming video call';

	/// en: 'Calling…'
	String get calling => 'Calling…';

	/// en: 'Connecting…'
	String get connecting => 'Connecting…';

	/// en: 'In call'
	String get talking => 'In call';

	/// en: 'Call declined'
	String get endedRejected => 'Call declined';

	/// en: 'Couldn’t connect'
	String get endedFailed => 'Couldn’t connect';

	/// en: 'Busy'
	String get endedBusy => 'Busy';

	/// en: 'Can’t call this user'
	String get endedNotAllowed => 'Can’t call this user';

	/// en: 'Call not available'
	String get notAllowedTitle => 'Call not available';

	/// en: 'This user only accepts calls from their contacts. They need to add you before you can call them.'
	String get notAllowedMessage => 'This user only accepts calls from their contacts. They need to add you before you can call them.';

	/// en: 'You’re already on a call'
	String get deviceBusyTitle => 'You’re already on a call';

	/// en: 'Your phone is busy with another call. End the current call before making a new one.'
	String get deviceBusyMessage => 'Your phone is busy with another call. End the current call before making a new one.';

	/// en: 'No internet connection'
	String get endedNoConnection => 'No internet connection';

	/// en: 'Subscriber unavailable'
	String get endedUnavailable => 'Subscriber unavailable';

	/// en: 'Call ended'
	String get ended => 'Call ended';

	/// en: 'Decline'
	String get decline => 'Decline';

	/// en: 'Accept'
	String get accept => 'Accept';

	/// en: 'End'
	String get hangup => 'End';

	/// en: 'Unmute'
	String get micOn => 'Unmute';

	/// en: 'Mute'
	String get micOff => 'Mute';

	/// en: 'Speaker on'
	String get speakerOn => 'Speaker on';

	/// en: 'Speaker off'
	String get speakerOff => 'Speaker off';

	/// en: 'Speaker'
	String get audioOutput => 'Speaker';

	/// en: 'Audio output'
	String get audioOutputTitle => 'Audio output';

	/// en: 'Phone'
	String get routeEarpiece => 'Phone';

	/// en: 'Speaker'
	String get routeSpeaker => 'Speaker';

	/// en: 'Headphones'
	String get routeWiredHeadset => 'Headphones';

	/// en: 'Bluetooth'
	String get routeBluetooth => 'Bluetooth';

	/// en: 'Hearing aid'
	String get routeHearingAid => 'Hearing aid';

	/// en: 'Car'
	String get routeCar => 'Car';

	/// en: 'Other'
	String get routeUnknown => 'Other';

	/// en: 'No audio outputs available'
	String get routeUnavailable => 'No audio outputs available';

	/// en: 'Camera on'
	String get cameraOn => 'Camera on';

	/// en: 'Camera off'
	String get cameraOff => 'Camera off';

	/// en: 'Video'
	String get startVideo => 'Video';

	/// en: 'Flip camera'
	String get switchCamera => 'Flip camera';

	/// en: 'Poor connection'
	String get qualityPoor => 'Poor connection';

	/// en: 'Good connection'
	String get qualityGood => 'Good connection';

	/// en: 'Excellent connection'
	String get qualityExcellent => 'Excellent connection';

	/// en: 'Their microphone is off'
	String get remoteMicMuted => 'Their microphone is off';
}

// Path: passkey
class Translations$passkey$en {
	Translations$passkey$en.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Passkeys'
	String get title => 'Passkeys';

	/// en: 'Passkeys are stored securely in your password manager.'
	String get description => 'Passkeys are stored securely in your password manager.';

	/// en: 'Add a passkey'
	String get add => 'Add a passkey';

	/// en: 'Passkey'
	String get genericName => 'Passkey';

	/// en: 'Added {date}'
	String created({required Object date}) => 'Added ${date}';

	/// en: 'Signed in {date}'
	String lastUsed({required Object date}) => 'Signed in ${date}';

	/// en: 'This account already has a passkey on this device. Add one on another device or in a different password manager.'
	String get alreadyOnThisDevice => 'This account already has a passkey on this device. Add one on another device or in a different password manager.';

	/// en: 'Delete'
	String get delete => 'Delete';

	/// en: 'Delete passkey?'
	String get deleteConfirmTitle => 'Delete passkey?';

	/// en: 'You won't be able to sign in with this passkey anymore.'
	String get deleteConfirmMessage => 'You won\'t be able to sign in with this passkey anymore.';

	/// en: 'Couldn't load passkeys'
	String get loadError => 'Couldn\'t load passkeys';

	/// en: 'Retry'
	String get retry => 'Retry';

	/// en: 'Couldn't verify the passkey. Please try again.'
	String get verificationFailed => 'Couldn\'t verify the passkey. Please try again.';

	/// en: 'The request expired. Please try again.'
	String get ceremonyExpired => 'The request expired. Please try again.';

	/// en: 'This passkey isn't recognized.'
	String get unknownCredential => 'This passkey isn\'t recognized.';

	/// en: 'This passkey is already registered.'
	String get alreadyRegistered => 'This passkey is already registered.';

	/// en: 'Passkey not found.'
	String get notFound => 'Passkey not found.';
}

// Path: yandex
class Translations$yandex$en {
	Translations$yandex$en.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Couldn't sign in with Yandex. Please try again.'
	String get failed => 'Couldn\'t sign in with Yandex. Please try again.';

	/// en: 'Couldn't verify the Yandex sign-in. Please try again.'
	String get invalidToken => 'Couldn\'t verify the Yandex sign-in. Please try again.';

	/// en: 'Your Yandex ID has no phone number. Add one in Yandex ID or sign in with your phone number.'
	String get phoneMissing => 'Your Yandex ID has no phone number. Add one in Yandex ID or sign in with your phone number.';

	/// en: 'The phone number in your Yandex ID can't be used to sign in. Sign in with your phone number.'
	String get invalidPhone => 'The phone number in your Yandex ID can\'t be used to sign in. Sign in with your phone number.';

	/// en: 'Yandex ID is unavailable right now. Please try again later.'
	String get unavailable => 'Yandex ID is unavailable right now. Please try again later.';
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
			'common.ok' => 'OK',
			'common.cancel' => 'Cancel',
			'common.notNow' => 'Not now',
			'common.back' => 'Back',
			'common.save' => 'Save',
			'common.online' => 'Online',
			'common.done' => 'Done',
			'common.close' => 'Close',
			'common.error' => 'Error',
			'common.noConnectionTitle' => 'No internet connection',
			'common.noConnectionMessage' => 'Check your connection and try again.',
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
			'screenChats.notificationPermissionTitle' => 'Turn on notifications',
			'screenChats.notificationPermissionMessage' => 'Allow notifications to hear about new messages and contacts even when Iperon is in the background.',
			'screenChats.allowAccess' => 'Allow',
			'screenChats.allFolder' => 'All chats',
			'screenChats.search' => 'Search',
			'screenChats.empty' => 'No chats yet',
			'screenChats.emptyFolder' => 'No chats in this folder yet',
			'screenChats.emptyArchive' => 'Archive is empty',
			'screenChats.archive' => 'Archive',
			'screenChats.savedMessages' => 'Saved Messages',
			'screenChats.draft' => 'Draft:',
			'screenChats.typing' => 'typing…',
			'screenChats.typingName' => ({required Object name}) => '${name} is typing…',
			'screenChats.photo' => 'Photo',
			'screenChats.video' => 'Video',
			'screenChats.file' => 'File',
			'screenChats.voice' => 'Voice message',
			'screenChats.pin' => 'Pin',
			'screenChats.unpin' => 'Unpin',
			'screenChats.markRead' => 'Mark as read',
			'screenChats.markUnread' => 'Mark as unread',
			'screenChats.mute' => 'Mute',
			'screenChats.unmute' => 'Unmute',
			'screenChats.toArchive' => 'Archive',
			'screenChats.fromArchive' => 'Unarchive',
			'screenChats.delete' => 'Delete',
			'screenChats.deleteChatTitle' => 'Delete chat?',
			'screenChats.deleteChatMessage' => ({required Object title}) => 'Chat "${title}" will be removed from the list.',
			'screenChats.readAll' => 'Read all',
			'screenChats.deleteFolder' => 'Delete folder',
			'screenChats.deleteFolderTitle' => ({required Object title}) => 'Delete folder "${title}"?',
			'screenChats.deleteFolderMessage' => 'Chats in the folder are not deleted.',
			'screenChat.today' => 'Today',
			'screenChat.yesterday' => 'Yesterday',
			'screenChat.online' => 'online',
			'screenChat.lastSeenRecently' => 'last seen recently',
			'screenChat.members' => ({required num n}) => (_root.$meta.cardinalResolver ?? PluralResolvers.cardinal('en'))(n, one: '${n} member', other: '${n} members', ), 
			'screenChat.subscribers' => ({required num n}) => (_root.$meta.cardinalResolver ?? PluralResolvers.cardinal('en'))(n, one: '${n} subscriber', other: '${n} subscribers', ), 
			'screenChat.message' => 'Message',
			'screenChat.empty' => 'No messages yet',
			'screenChat.notFound' => 'Chat not found',
			'screenChat.reply' => 'Reply',
			'screenChat.copy' => 'Copy',
			'screenChat.copied' => 'Copied',
			'screenChat.edit' => 'Edit',
			'screenChat.editing' => 'Editing',
			'screenChat.edited' => 'edited',
			'screenChat.delete' => 'Delete',
			'screenChat.deleteTitle' => 'Delete message?',
			'screenChat.deleteMessage' => 'The message will be deleted for everyone in the chat.',
			'screenChat.you' => 'You',
			'screenChat.mute' => 'Mute',
			'screenChat.unmute' => 'Unmute',
			'screenChat.photo' => _root.screenChats.photo,
			'screenChat.video' => _root.screenChats.video,
			'screenChat.file' => _root.screenChats.file,
			'screenChat.voice' => _root.screenChats.voice,
			'screenSettings.settings' => 'Settings',
			'screenSettings.myProfile' => 'My profile',
			'screenSettings.devices' => _root.screenSettingsDevices.devices,
			'screenSettings.language' => 'Language',
			'screenSettings.appearance' => _root.screenSettingsAppearance.appearance,
			'screenSettings.notifications' => _root.screenSettingsNotifications.notifications,
			'screenSettings.privacyAndSecurity' => 'Privacy and security',
			'screenSettings.aboutApplication' => 'About the application',
			'screenSettings.logs' => 'Logs',
			'screenSettings.logout' => 'Logout',
			'screenSettingsNotifications.notifications' => 'Notifications and sounds',
			'screenSettingsNotifications.messageNotifications' => 'Message notifications',
			'screenSettingsNotifications.privateChats' => 'Private chats',
			'screenSettingsNotifications.groups' => 'Groups',
			'screenSettingsNotifications.channels' => 'Channels',
			'screenSettingsNotifications.on' => 'On',
			'screenSettingsNotifications.off' => 'Off',
			'screenSettingsNotifications.events' => 'Events',
			'screenSettingsNotifications.contactJoined' => 'Contact joined Iperon',
			'screenSettingsNotifications.missedCalls' => 'Missed calls',
			'screenSettingsNotifications.showNotifications' => 'Show notifications',
			'screenSettingsNotifications.messagePreview' => 'Message preview',
			'screenSettingsNotifications.sound' => 'Sound',
			'screenSettingsNotifications.messagePreviewNote' => 'Without a preview, notifications show only who sent the message.',
			'screenSettingsNotifications.settingsSyncNote' => 'Settings apply to all your devices.',
			'screenSettingsNotifications.permissionMissingTitle' => 'Notifications are turned off',
			'screenSettingsNotifications.permissionMissingMessage' => 'Iperon isn\'t allowed to show notifications on this device, so these settings won\'t take effect.',
			'screenSettingsNotifications.enable' => 'Turn on',
			'screenSettingsNotifications.loadError' => 'Couldn\'t load the settings',
			'screenSettingsNotifications.offlineNote' => 'No connection. You can change this once you\'re back online.',
			'screenSettingsNotifications.retry' => 'Retry',
			'screenDeveloper.developer' => 'Developer',
			'screenDeveloper.logs' => _root.screenSettings.logs,
			'screenDeveloper.exportLogs' => 'Export logs',
			'screenDeveloper.callPreview' => 'Call screen preview',
			'screenDeveloper.chatsDemo' => 'Chats demo',
			'screenDeveloper.testPush' => 'Test notification',
			'screenDeveloper.testPushSent' => ({required Object apns, required Object fcm, required Object failed}) => 'Sent: APNs — ${apns}, FCM — ${fcm}, failed — ${failed}. Minimize the app or lock the screen to check background delivery.',
			'screenDeveloper.testPushNoTokens' => 'None of your devices has a push token. Make sure notifications are allowed and restart the app.',
			'screenDeveloper.testPushError' => ({required Object error}) => 'Failed to send: ${error}',
			'screenDeveloper.testPushEncrypted' => 'Test notification (encrypted)',
			'screenDeveloper.testPushQueued' => 'Queued on the server. Android shows "Encrypted test notification: decryption works"; iPhone shows "New notification" for now (iOS decryption comes later).',
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
			'sessionsPrivacyAndSecurity.cloudPassword' => 'Cloud password',
			'sessionsPrivacyAndSecurity.passkeys' => 'Passkeys',
			'sessionsPrivacyAndSecurity.whoCanCall' => 'Who can call me',
			'sessionsPrivacyAndSecurity.calls' => 'Calls',
			'sessionsPrivacyAndSecurity.callsEverybody' => 'Everybody',
			'sessionsPrivacyAndSecurity.callsContacts' => 'My contacts',
			'sessionsPrivacyAndSecurity.callsNobody' => 'Nobody',
			'sessionsPrivacyAndSecurity.callsLoadError' => 'Couldn\'t load the setting',
			'sessionsPrivacyAndSecurity.callsOfflineNote' => 'No connection. You can change this once you\'re back online.',
			'sessionsPrivacyAndSecurity.retry' => 'Retry',
			'sessionsPrivacyAndSecurity.exceptions' => 'Exceptions',
			'sessionsPrivacyAndSecurity.callsAlwaysAllow' => 'Always allow',
			'sessionsPrivacyAndSecurity.callsAlwaysDeny' => 'Always deny',
			'sessionsPrivacyAndSecurity.callsAllowEmpty' => 'No contacts registered on Iperon',
			'sessionsPrivacyAndSecurity.birthday' => 'Birthday',
			'sessionsPrivacyAndSecurity.whoCanSeeBirthday' => 'Who can see my birthday',
			'sessionsPrivacyAndSecurity.hideBirthYear' => 'Hide birth year',
			'sessionsPrivacyAndSecurity.hideBirthYearNote' => 'Contacts will see only the day and month — no birth year or age.',
			'sessionsPrivacyAndSecurity.aboutMe' => 'About me',
			'sessionsPrivacyAndSecurity.whoCanSeeAboutMe' => 'Who can see my About me',
			'sessionsPrivacyAndSecurity.lastSeen' => 'Last seen',
			'sessionsPrivacyAndSecurity.whoCanSeeLastSeen' => 'Who can see my last seen',
			'sessionsPrivacyAndSecurity.lastSeenReciprocityNote' => 'If you choose Nobody, you won\'t see others\' last seen or online status either.',
			'cloudPassword.title' => 'Cloud password',
			'cloudPassword.description' => 'An additional password asked when signing in on a new device. Add an email so you can recover access if you forget it.',
			'cloudPassword.enterPasswordHint' => 'Enter your cloud password',
			'cloudPassword.unlockInfo' => 'Two-step verification is enabled. Your account is protected by an additional password.',
			'cloudPassword.setupEmailHint' => 'Add an email to recover access if you forget your cloud password.',
			'cloudPassword.setupPasswordHint' => 'Now set a cloud password. You\'ll be asked for it when signing in on a new device.',
			'cloudPassword.changePasswordHint' => 'Enter a new cloud password.',
			'cloudPassword.enableButton' => 'Enable',
			'cloudPassword.passwordPlaceholder' => 'Cloud password',
			'cloudPassword.continueButton' => 'Continue',
			'cloudPassword.next' => 'Next',
			'cloudPassword.forgotPassword' => 'Forgot password?',
			'cloudPassword.recoveryHint' => ({required Object email}) => 'We sent a recovery code to ${email}',
			'cloudPassword.recoveryEmailHint' => 'Enter the email linked to your account. If it matches, we\'ll send a recovery code to it.',
			'cloudPassword.codePlaceholder' => 'Code from email',
			'cloudPassword.newPasswordPlaceholder' => 'New password',
			'cloudPassword.repeatPasswordPlaceholder' => 'Repeat password',
			'cloudPassword.currentPasswordPlaceholder' => 'Current password',
			'cloudPassword.resetPassword' => 'Reset password',
			'cloudPassword.reset' => 'Reset',
			'cloudPassword.attemptsLeft' => ({required Object count}) => 'Attempts left: ${count}',
			'cloudPassword.attemptsLeftInline' => ({required num n}) => (_root.$meta.cardinalResolver ?? PluralResolvers.cardinal('en'))(n, one: '${n} attempt left', other: '${n} attempts left', ), 
			'cloudPassword.setPassword' => 'Set password',
			'cloudPassword.newPasswordTitle' => 'New password',
			'cloudPassword.newPasswordDescription' => 'Set a cloud password. You\'ll be asked for it when signing in on a new device.',
			'cloudPassword.changePassword' => 'Change password',
			'cloudPassword.email' => 'Email',
			'cloudPassword.emailPlaceholder' => 'Email',
			'cloudPassword.emailNotSet' => 'Not set',
			'cloudPassword.emailCodeSent' => 'We sent a verification code to your email.',
			'cloudPassword.verifyEmail' => 'Verify email',
			'cloudPassword.disable' => 'Disable password',
			'cloudPassword.loadError' => 'Couldn\'t load cloud password settings',
			'cloudPassword.retry' => 'Retry',
			'cloudPassword.emailRequired' => 'Enter an email',
			'cloudPassword.passwordRequired' => 'Enter a password',
			'cloudPassword.passwordTooShort' => 'Password must be at least 5 characters',
			'cloudPassword.codeRequired' => 'Enter the code',
			'cloudPassword.passwordsDoNotMatch' => 'Passwords don\'t match',
			'cloudPassword.wrongPassword' => 'Wrong password',
			'cloudPassword.tooManyAttempts' => 'Too many attempts. Please start again.',
			'cloudPassword.codeMismatch' => 'Wrong code',
			'cloudPassword.notSet' => 'Cloud password is not set',
			'cloudPassword.invalidEmail' => 'Invalid email',
			'cloudPassword.sessionExpired' => 'Session expired. Please start again.',
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
			'screenMyProfile.errorSavingAvatar' => 'Saving avatar',
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
			'screenMyProfile.usernameHint' => 'username',
			'screenMyProfile.usernameDescription' => 'You can choose a username. Use 5–24 characters: lowercase Latin letters, digits and underscores',
			'screenMyProfile.usernameInvalid' => 'Username must contain 5–24 characters:\nlowercase Latin letters, digits and underscores',
			'screenMyProfile.usernameTaken' => 'This username is already taken',
			'screenMyProfile.errorSavingUsername' => 'Saving username',
			'screenProfile.profile' => 'Profile',
			'screenProfile.firstName' => _root.screenMyProfile.firstName,
			'screenProfile.lastName' => _root.screenMyProfile.lastName,
			'screenProfile.mobilePhone' => _root.screenMyProfile.mobilePhone,
			'screenProfile.username' => _root.screenMyProfile.username,
			'screenProfile.aboutMe' => _root.screenMyProfile.aboutMe,
			'screenProfile.birthDate' => _root.screenMyProfile.birthDate,
			'screenProfile.age' => ({required num n}) => (_root.$meta.cardinalResolver ?? PluralResolvers.cardinal('en'))(n, one: '${n} year', other: '${n} years', ), 
			'screenProfile.copy' => _root.screenMyProfile.copy,
			'screenProfile.hideProfile' => 'Hide profile',
			'screenHideProfile.title' => 'Hide profile',
			'screenHideProfile.description' => 'The person disappears from your Contacts, Calls, and Chats on this device. To show them again, type “/passphrase” in search. The passphrase is stored only as a hash and never leaves the device.',
			'screenHideProfile.phrasePlaceholder' => 'Passphrase',
			'screenHideProfile.hideAction' => 'Hide',
			'screenHideProfile.resetAction' => 'Reset passphrase',
			'screenHideProfile.errorEmptyPhrase' => 'Enter a passphrase to hide the profile.',
			'screenContacts.title' => 'Contacts',
			'screenContacts.onIperon' => 'On Iperon',
			'screenContacts.onContacts' => 'On Contacts',
			'screenContacts.cloudContacts' => 'Cloud contacts',
			'screenContacts.invite' => 'Invite',
			'screenContacts.inviteAction' => 'Invite',
			'screenContacts.search' => 'Search',
			'screenContacts.permissionTitle' => 'Contacts access needed',
			'screenContacts.permissionMessage' => 'Allow access to your contacts to find friends already on Iperon. Your phone numbers are matched privately and never revealed to the server.',
			'screenContacts.allowAccess' => 'Allow access',
			'screenContacts.openSettings' => 'Open settings',
			'screenContacts.empty' => 'No contacts found',
			'screenContacts.inviteMessage' => 'Let\'s chat on Iperon',
			'screenContacts.statusOnline' => 'online',
			'screenContacts.statusLastSeenRecently' => 'last seen recently',
			'screenContacts.statusLastSeen' => ({required Object date}) => 'last seen ${date}',
			'screenContacts.addByNumber' => 'Add by number',
			'screenContacts.addContact' => 'Add contact',
			'screenContacts.addByNumberHint' => 'Phone number',
			'screenContacts.addFirstName' => 'First name',
			'screenContacts.addLastName' => 'Last name',
			'screenContacts.add' => 'Add',
			'screenContacts.addInvalidNumber' => 'Invalid phone number',
			'screenContacts.addFailed' => 'Couldn’t add contact',
			'screenContacts.validationCloudLimitReached' => 'Cloud contacts limit reached',
			'screenContacts.addSyncHint' => 'This contact will be available on all your devices',
			'screenContacts.remove' => 'Remove',
			'screenContacts.removeTitle' => 'Remove contact?',
			'screenContacts.removeMessage' => 'They will no longer be able to call you unless your call privacy allows everyone.',
			'screenCalls.title' => 'Calls',
			'screenCalls.empty' => 'Your calls will appear here',
			'screenCalls.emptyMissed' => 'No missed calls',
			'screenCalls.permissionTitle' => 'Microphone access needed',
			'screenCalls.permissionMessage' => 'Allow microphone access to make and receive calls on Iperon.',
			'screenCalls.notificationPermissionTitle' => 'Enable call notifications',
			'screenCalls.notificationPermissionMessage' => 'Allow notifications so you can see incoming calls even when Iperon is in the background.',
			'screenCalls.permissionsTitle' => 'Set up calls',
			'screenCalls.permissionsMessage' => 'Allow microphone and notifications so you can make calls and see incoming ones on Iperon.',
			'screenCalls.pipPermissionTitle' => 'Mini window during calls',
			'screenCalls.pipPermissionMessage' => 'Allow Picture-in-Picture so a video call keeps playing in a small window over your screen when you minimize Iperon.',
			'screenCalls.allowAccess' => 'Allow access',
			'screenCalls.openSettings' => 'Open settings',
			'screenCalls.search' => 'Search',
			'screenCalls.filterAll' => 'All',
			'screenCalls.filterMissed' => 'Missed',
			'screenCalls.incoming' => 'Incoming',
			'screenCalls.outgoing' => 'Outgoing',
			'screenCalls.missed' => 'Missed',
			'screenCalls.cancelled' => 'Cancelled',
			'screenCalls.durationSec' => ({required Object s}) => '${s} sec',
			'screenCalls.durationMin' => ({required Object m}) => '${m} min',
			'screenCalls.durationHour' => ({required Object h}) => '${h} h',
			'screenCalls.durationHourMin' => ({required Object h, required Object m}) => '${h} h ${m} min',
			'screenCalls.unknown' => 'Unknown',
			'screenCalls.delete' => 'Delete',
			'screenCalls.clear' => 'Clear',
			'screenCalls.clearTitle' => 'Clear call history?',
			'screenCalls.clearMessage' => 'All call records will be deleted. This cannot be undone.',
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
			'screenCall.title' => 'Call',
			'screenCall.returnToCall' => 'Tap to return to the call',
			'screenCall.bannerRinging' => 'Call',
			'screenCall.bannerActive' => 'In call',
			'screenCall.incomingAudio' => 'Incoming call',
			'screenCall.incomingVideo' => 'Incoming video call',
			'screenCall.calling' => 'Calling…',
			'screenCall.connecting' => 'Connecting…',
			'screenCall.talking' => 'In call',
			'screenCall.endedRejected' => 'Call declined',
			'screenCall.endedFailed' => 'Couldn’t connect',
			'screenCall.endedBusy' => 'Busy',
			'screenCall.endedNotAllowed' => 'Can’t call this user',
			'screenCall.notAllowedTitle' => 'Call not available',
			'screenCall.notAllowedMessage' => 'This user only accepts calls from their contacts. They need to add you before you can call them.',
			'screenCall.deviceBusyTitle' => 'You’re already on a call',
			'screenCall.deviceBusyMessage' => 'Your phone is busy with another call. End the current call before making a new one.',
			'screenCall.endedNoConnection' => 'No internet connection',
			'screenCall.endedUnavailable' => 'Subscriber unavailable',
			'screenCall.ended' => 'Call ended',
			'screenCall.decline' => 'Decline',
			'screenCall.accept' => 'Accept',
			'screenCall.hangup' => 'End',
			'screenCall.micOn' => 'Unmute',
			'screenCall.micOff' => 'Mute',
			'screenCall.speakerOn' => 'Speaker on',
			'screenCall.speakerOff' => 'Speaker off',
			'screenCall.audioOutput' => 'Speaker',
			'screenCall.audioOutputTitle' => 'Audio output',
			'screenCall.routeEarpiece' => 'Phone',
			'screenCall.routeSpeaker' => 'Speaker',
			'screenCall.routeWiredHeadset' => 'Headphones',
			'screenCall.routeBluetooth' => 'Bluetooth',
			'screenCall.routeHearingAid' => 'Hearing aid',
			'screenCall.routeCar' => 'Car',
			'screenCall.routeUnknown' => 'Other',
			'screenCall.routeUnavailable' => 'No audio outputs available',
			'screenCall.cameraOn' => 'Camera on',
			'screenCall.cameraOff' => 'Camera off',
			'screenCall.startVideo' => 'Video',
			'screenCall.switchCamera' => 'Flip camera',
			'screenCall.qualityPoor' => 'Poor connection',
			'screenCall.qualityGood' => 'Good connection',
			'screenCall.qualityExcellent' => 'Excellent connection',
			'screenCall.remoteMicMuted' => 'Their microphone is off',
			'passkey.title' => 'Passkeys',
			'passkey.description' => 'Passkeys are stored securely in your password manager.',
			'passkey.add' => 'Add a passkey',
			'passkey.genericName' => 'Passkey',
			'passkey.created' => ({required Object date}) => 'Added ${date}',
			'passkey.lastUsed' => ({required Object date}) => 'Signed in ${date}',
			'passkey.alreadyOnThisDevice' => 'This account already has a passkey on this device. Add one on another device or in a different password manager.',
			'passkey.delete' => 'Delete',
			'passkey.deleteConfirmTitle' => 'Delete passkey?',
			'passkey.deleteConfirmMessage' => 'You won\'t be able to sign in with this passkey anymore.',
			'passkey.loadError' => 'Couldn\'t load passkeys',
			'passkey.retry' => 'Retry',
			'passkey.verificationFailed' => 'Couldn\'t verify the passkey. Please try again.',
			'passkey.ceremonyExpired' => 'The request expired. Please try again.',
			'passkey.unknownCredential' => 'This passkey isn\'t recognized.',
			'passkey.alreadyRegistered' => 'This passkey is already registered.',
			'passkey.notFound' => 'Passkey not found.',
			'yandex.failed' => 'Couldn\'t sign in with Yandex. Please try again.',
			'yandex.invalidToken' => 'Couldn\'t verify the Yandex sign-in. Please try again.',
			'yandex.phoneMissing' => 'Your Yandex ID has no phone number. Add one in Yandex ID or sign in with your phone number.',
			'yandex.invalidPhone' => 'The phone number in your Yandex ID can\'t be used to sign in. Sign in with your phone number.',
			'yandex.unavailable' => 'Yandex ID is unavailable right now. Please try again later.',
			_ => null,
		};
	}
}
