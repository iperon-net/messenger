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
	String get settings => 'Settings';
}

// Path: drawer
class TranslationsDrawerEn {
	TranslationsDrawerEn.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations
	String get settings => _root.ui.settings;
	String get favorites => 'Favorites';
	String get contacts => 'Contacts';
}

// Path: contacts
class TranslationsContactsEn {
	TranslationsContactsEn.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations
	String get contacts => 'Contacts';
	String get search => 'Search';
	late final TranslationsContactsTabsEn tabs = TranslationsContactsTabsEn.internal(_root);
}

// Path: chats
class TranslationsChatsEn {
	TranslationsChatsEn.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations
	String get chats => 'Chats';
}

// Path: settings
class TranslationsSettingsEn {
	TranslationsSettingsEn.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations
	String get settings => 'Settings';
	String get favorites => 'Favorites';
	String get myPersonalInfo => 'My personal info';
	String get myProfile => 'My profile';
	late final TranslationsSettingsNotificationsEn notifications = TranslationsSettingsNotificationsEn.internal(_root);
	late final TranslationsSettingsPrivacyAndSecurityEn privacyAndSecurity = TranslationsSettingsPrivacyAndSecurityEn.internal(_root);
	String get devices => 'Devices';
	String get updates => 'Updates';
	late final TranslationsSettingsAppearanceEn appearance = TranslationsSettingsAppearanceEn.internal(_root);
	late final TranslationsSettingsLanguageEn language = TranslationsSettingsLanguageEn.internal(_root);
}

// Path: contacts.tabs
class TranslationsContactsTabsEn {
	TranslationsContactsTabsEn.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations
	String get all => 'All';
	String get favorites => 'Favorites';
}

// Path: settings.notifications
class TranslationsSettingsNotificationsEn {
	TranslationsSettingsNotificationsEn.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations
	String get notifications => 'Notifications';
}

// Path: settings.privacyAndSecurity
class TranslationsSettingsPrivacyAndSecurityEn {
	TranslationsSettingsPrivacyAndSecurityEn.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations
	String get privacyAndSecurity => 'Privacy and security';
	String get twoStepVerification => 'Two step verification';
	late final TranslationsSettingsPrivacyAndSecurityPasscodeEn passcode = TranslationsSettingsPrivacyAndSecurityPasscodeEn.internal(_root);
}

// Path: settings.appearance
class TranslationsSettingsAppearanceEn {
	TranslationsSettingsAppearanceEn.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations
	String get appearance => 'Appearance';
	String get back => 'Back';
	late final TranslationsSettingsAppearanceDarkModeEn darkMode = TranslationsSettingsAppearanceDarkModeEn.internal(_root);
	late final TranslationsSettingsAppearanceColorSchemeEn colorScheme = TranslationsSettingsAppearanceColorSchemeEn.internal(_root);
}

// Path: settings.language
class TranslationsSettingsLanguageEn {
	TranslationsSettingsLanguageEn.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations
	String get language => 'Language';
	String get back => 'Back';
	String get interfaceLanguage => 'Interface language';
}

// Path: settings.privacyAndSecurity.passcode
class TranslationsSettingsPrivacyAndSecurityPasscodeEn {
	TranslationsSettingsPrivacyAndSecurityPasscodeEn.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations
	String get passcode => 'Passcode';
	String get setPasscode => 'Set a passcode';
	String get importantDescription => 'Important: If you forget your passcode, you will need to reinstall the application.';
	String get newPasscode => 'New passcode';
	String get confirmNewPasscode => 'Confirm the passcode';
	String get cancel => 'Cancel';
	String get disable_passcode => 'Disable passcode';
	String get change_passcode => 'Change passcode';
}

// Path: settings.appearance.darkMode
class TranslationsSettingsAppearanceDarkModeEn {
	TranslationsSettingsAppearanceDarkModeEn.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations
	String get darkMode => 'Dark mode';
	String get system => 'System';
	String get disabled => 'Disabled';
	String get alwaysOn => 'Always on';
}

// Path: settings.appearance.colorScheme
class TranslationsSettingsAppearanceColorSchemeEn {
	TranslationsSettingsAppearanceColorSchemeEn.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations
	String get colorScheme => 'Color scheme';
	String get system => 'System';
	String get green => 'Green';
	String get purple => 'Purple';
}

/// Flat map(s) containing all translations.
/// Only for edge cases! For simple maps, use the map function of this library.
extension on Translations {
	dynamic _flatMapFunction(String path) {
		switch (path) {
			case 'notImplementedScreen': return 'Not implemented screen';
			case 'ui.settings': return 'Settings';
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

