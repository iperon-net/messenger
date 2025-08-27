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

	/// en: 'Not implemented screen'
	String get notImplementedScreen => 'Not implemented screen';

	late final TranslationsUiEn ui = TranslationsUiEn.internal(_root);
	late final TranslationsDrawerEn drawer = TranslationsDrawerEn.internal(_root);
	late final TranslationsContactsEn contacts = TranslationsContactsEn.internal(_root);
	late final TranslationsChatsEn chats = TranslationsChatsEn.internal(_root);
	late final TranslationsSettingsEn settings = TranslationsSettingsEn.internal(_root);
}

// Path: ui
class TranslationsUiEn {
	TranslationsUiEn.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Settings'
	String get settings => 'Settings';

	/// en: 'Cancel'
	String get cancel => 'Cancel';

	/// en: 'Done'
	String get done => 'Done';
}

// Path: drawer
class TranslationsDrawerEn {
	TranslationsDrawerEn.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Settings'
	String get settings => _root.ui.settings;

	/// en: 'Favorites'
	String get favorites => 'Favorites';

	/// en: 'Contacts'
	String get contacts => 'Contacts';
}

// Path: contacts
class TranslationsContactsEn {
	TranslationsContactsEn.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Contacts'
	String get contacts => 'Contacts';

	/// en: 'Search'
	String get search => 'Search';

	late final TranslationsContactsTabsEn tabs = TranslationsContactsTabsEn.internal(_root);
}

// Path: chats
class TranslationsChatsEn {
	TranslationsChatsEn.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Chats'
	String get chats => 'Chats';
}

// Path: settings
class TranslationsSettingsEn {
	TranslationsSettingsEn.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Settings'
	String get settings => 'Settings';

	/// en: 'Favorites'
	String get favorites => 'Favorites';

	/// en: 'My personal info'
	String get myPersonalInfo => 'My personal info';

	/// en: 'My profile'
	String get myProfile => 'My profile';

	late final TranslationsSettingsNotificationsEn notifications = TranslationsSettingsNotificationsEn.internal(_root);
	late final TranslationsSettingsPrivacyAndSecurityEn privacyAndSecurity = TranslationsSettingsPrivacyAndSecurityEn.internal(_root);

	/// en: 'Devices'
	String get devices => 'Devices';

	/// en: 'Updates'
	String get updates => 'Updates';

	late final TranslationsSettingsAppearanceEn appearance = TranslationsSettingsAppearanceEn.internal(_root);
	late final TranslationsSettingsLanguageEn language = TranslationsSettingsLanguageEn.internal(_root);
}

// Path: contacts.tabs
class TranslationsContactsTabsEn {
	TranslationsContactsTabsEn.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'All'
	String get all => 'All';

	/// en: 'Favorites'
	String get favorites => 'Favorites';
}

// Path: settings.notifications
class TranslationsSettingsNotificationsEn {
	TranslationsSettingsNotificationsEn.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Notifications'
	String get notifications => 'Notifications';
}

// Path: settings.privacyAndSecurity
class TranslationsSettingsPrivacyAndSecurityEn {
	TranslationsSettingsPrivacyAndSecurityEn.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Privacy and security'
	String get privacyAndSecurity => 'Privacy and security';

	/// en: 'Two step verification'
	String get twoStepVerification => 'Two step verification';

	late final TranslationsSettingsPrivacyAndSecurityPasscodeEn passcode = TranslationsSettingsPrivacyAndSecurityPasscodeEn.internal(_root);
}

// Path: settings.appearance
class TranslationsSettingsAppearanceEn {
	TranslationsSettingsAppearanceEn.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Appearance'
	String get appearance => 'Appearance';

	/// en: 'Back'
	String get back => 'Back';

	late final TranslationsSettingsAppearanceDarkModeEn darkMode = TranslationsSettingsAppearanceDarkModeEn.internal(_root);
	late final TranslationsSettingsAppearanceColorSchemeEn colorScheme = TranslationsSettingsAppearanceColorSchemeEn.internal(_root);
}

// Path: settings.language
class TranslationsSettingsLanguageEn {
	TranslationsSettingsLanguageEn.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Language'
	String get language => 'Language';

	/// en: 'Back'
	String get back => 'Back';

	/// en: 'Interface language'
	String get interfaceLanguage => 'Interface language';
}

// Path: settings.privacyAndSecurity.passcode
class TranslationsSettingsPrivacyAndSecurityPasscodeEn {
	TranslationsSettingsPrivacyAndSecurityPasscodeEn.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Passcode'
	String get passcode => 'Passcode';

	/// en: 'Set a passcode'
	String get setPasscode => 'Set a passcode';

	/// en: 'Important: If you forget your passcode, you will need to reinstall the application.'
	String get importantDescription => 'Important: If you forget your passcode, you will need to reinstall the application.';

	/// en: 'New passcode'
	String get newPasscode => 'New passcode';

	/// en: 'Confirm the passcode'
	String get confirmNewPasscode => 'Confirm the passcode';

	/// en: 'Cancel'
	String get cancel => 'Cancel';

	/// en: 'Disable passcode'
	String get disable_passcode => 'Disable passcode';

	/// en: 'Change passcode'
	String get change_passcode => 'Change passcode';

	/// en: 'Auto-lock'
	String get auto_lock => 'Auto-lock';

	/// en: 'Disabled'
	String get auto_lock_in_disabled => 'Disabled';

	/// en: 'Immediately'
	String get auto_lock_timer_in_1_seconds => 'Immediately';

	/// en: 'in 1 minute'
	String get auto_lock_timer_in_1_minute => 'in 1 minute';

	/// en: 'in 5 minutes'
	String get auto_lock_timer_in_5_minutes => 'in 5 minutes';

	/// en: 'in 1 hour'
	String get auto_lock_timer_in_1_hour => 'in 1 hour';

	/// en: 'in 5 hours'
	String get auto_lock_timer_in_5_hours => 'in 5 hours';
}

// Path: settings.appearance.darkMode
class TranslationsSettingsAppearanceDarkModeEn {
	TranslationsSettingsAppearanceDarkModeEn.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Dark mode'
	String get darkMode => 'Dark mode';

	/// en: 'System'
	String get system => 'System';

	/// en: 'Disabled'
	String get disabled => 'Disabled';

	/// en: 'Always on'
	String get alwaysOn => 'Always on';
}

// Path: settings.appearance.colorScheme
class TranslationsSettingsAppearanceColorSchemeEn {
	TranslationsSettingsAppearanceColorSchemeEn.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Color scheme'
	String get colorScheme => 'Color scheme';

	/// en: 'System'
	String get system => 'System';

	/// en: 'Green'
	String get green => 'Green';

	/// en: 'Purple'
	String get purple => 'Purple';
}

/// Flat map(s) containing all translations.
/// Only for edge cases! For simple maps, use the map function of this library.
extension on Translations {
	dynamic _flatMapFunction(String path) {
		switch (path) {
			case 'notImplementedScreen': return 'Not implemented screen';
			case 'ui.settings': return 'Settings';
			case 'ui.cancel': return 'Cancel';
			case 'ui.done': return 'Done';
			case 'drawer.settings': return _root.ui.settings;
			case 'drawer.favorites': return 'Favorites';
			case 'drawer.contacts': return 'Contacts';
			case 'contacts.contacts': return 'Contacts';
			case 'contacts.search': return 'Search';
			case 'contacts.tabs.all': return 'All';
			case 'contacts.tabs.favorites': return 'Favorites';
			case 'chats.chats': return 'Chats';
			case 'settings.settings': return 'Settings';
			case 'settings.favorites': return 'Favorites';
			case 'settings.myPersonalInfo': return 'My personal info';
			case 'settings.myProfile': return 'My profile';
			case 'settings.notifications.notifications': return 'Notifications';
			case 'settings.privacyAndSecurity.privacyAndSecurity': return 'Privacy and security';
			case 'settings.privacyAndSecurity.twoStepVerification': return 'Two step verification';
			case 'settings.privacyAndSecurity.passcode.passcode': return 'Passcode';
			case 'settings.privacyAndSecurity.passcode.setPasscode': return 'Set a passcode';
			case 'settings.privacyAndSecurity.passcode.importantDescription': return 'Important: If you forget your passcode, you will need to reinstall the application.';
			case 'settings.privacyAndSecurity.passcode.newPasscode': return 'New passcode';
			case 'settings.privacyAndSecurity.passcode.confirmNewPasscode': return 'Confirm the passcode';
			case 'settings.privacyAndSecurity.passcode.cancel': return 'Cancel';
			case 'settings.privacyAndSecurity.passcode.disable_passcode': return 'Disable passcode';
			case 'settings.privacyAndSecurity.passcode.change_passcode': return 'Change passcode';
			case 'settings.privacyAndSecurity.passcode.auto_lock': return 'Auto-lock';
			case 'settings.privacyAndSecurity.passcode.auto_lock_in_disabled': return 'Disabled';
			case 'settings.privacyAndSecurity.passcode.auto_lock_timer_in_1_seconds': return 'Immediately';
			case 'settings.privacyAndSecurity.passcode.auto_lock_timer_in_1_minute': return 'in 1 minute';
			case 'settings.privacyAndSecurity.passcode.auto_lock_timer_in_5_minutes': return 'in 5 minutes';
			case 'settings.privacyAndSecurity.passcode.auto_lock_timer_in_1_hour': return 'in 1 hour';
			case 'settings.privacyAndSecurity.passcode.auto_lock_timer_in_5_hours': return 'in 5 hours';
			case 'settings.devices': return 'Devices';
			case 'settings.updates': return 'Updates';
			case 'settings.appearance.appearance': return 'Appearance';
			case 'settings.appearance.back': return 'Back';
			case 'settings.appearance.darkMode.darkMode': return 'Dark mode';
			case 'settings.appearance.darkMode.system': return 'System';
			case 'settings.appearance.darkMode.disabled': return 'Disabled';
			case 'settings.appearance.darkMode.alwaysOn': return 'Always on';
			case 'settings.appearance.colorScheme.colorScheme': return 'Color scheme';
			case 'settings.appearance.colorScheme.system': return 'System';
			case 'settings.appearance.colorScheme.green': return 'Green';
			case 'settings.appearance.colorScheme.purple': return 'Purple';
			case 'settings.language.language': return 'Language';
			case 'settings.language.back': return 'Back';
			case 'settings.language.interfaceLanguage': return 'Interface language';
			default: return null;
		}
	}
}

