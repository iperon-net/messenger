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
	late final Translations$screenNewChat$en screenNewChat = Translations$screenNewChat$en.internal(_root);
	late final Translations$screenChatInvites$en screenChatInvites = Translations$screenChatInvites$en.internal(_root);
	late final Translations$screenChatAdmins$en screenChatAdmins = Translations$screenChatAdmins$en.internal(_root);
	late final Translations$screenChat$en screenChat = Translations$screenChat$en.internal(_root);
	late final Translations$screenSettings$en screenSettings = Translations$screenSettings$en.internal(_root);
	late final Translations$screenSettingsNotifications$en screenSettingsNotifications = Translations$screenSettingsNotifications$en.internal(_root);
	late final Translations$screenDeveloper$en screenDeveloper = Translations$screenDeveloper$en.internal(_root);
	late final Translations$screenSettingsAppearance$en screenSettingsAppearance = Translations$screenSettingsAppearance$en.internal(_root);
	late final Translations$screenChatInfo$en screenChatInfo = Translations$screenChatInfo$en.internal(_root);
	late final Translations$screenChatThemes$en screenChatThemes = Translations$screenChatThemes$en.internal(_root);
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

	/// en: 'Photo'
	String get photo => 'Photo';

	/// en: 'Video'
	String get video => 'Video';
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

	/// en: 'Read'
	String get swipeRead => 'Read';

	/// en: 'Unread'
	String get swipeUnread => 'Unread';

	/// en: 'Mute'
	String get swipeMute => 'Mute';

	/// en: 'Unmute'
	String get swipeUnmute => 'Unmute';

	/// en: 'Archive'
	String get swipeArchive => 'Archive';

	/// en: 'Unarchive'
	String get swipeUnarchive => 'Unarchive';

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

// Path: screenNewChat
class Translations$screenNewChat$en {
	Translations$screenNewChat$en.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'New Message'
	String get title => 'New Message';

	/// en: 'Search'
	String get search => 'Search';

	/// en: 'New Group'
	String get newGroup => 'New Group';

	/// en: 'New Channel'
	String get newChannel => 'New Channel';

	/// en: 'New Community'
	String get newCommunity => 'New Community';

	/// en: 'Contacts'
	String get contacts => 'Contacts';

	/// en: 'No contacts found'
	String get noContacts => 'No contacts found';

	/// en: 'Add Members'
	String get addMembers => 'Add Members';

	/// en: 'Next'
	String get next => 'Next';

	/// en: 'Selected: {n}'
	String selected({required Object n}) => 'Selected: ${n}';

	/// en: 'You can create a group without members and invite them later.'
	String get noMembersHint => 'You can create a group without members and invite them later.';

	/// en: 'New Group'
	String get groupTitle => 'New Group';

	/// en: 'New Channel'
	String get channelTitle => 'New Channel';

	/// en: 'New Community'
	String get communityTitle => 'New Community';

	/// en: 'Create'
	String get create => 'Create';

	/// en: 'Group Name'
	String get groupName => 'Group Name';

	/// en: 'Channel Name'
	String get channelName => 'Channel Name';

	/// en: 'Community Name'
	String get communityName => 'Community Name';

	/// en: 'Description'
	String get description => 'Description';

	/// en: 'Optional'
	String get descriptionHint => 'Optional';

	/// en: 'Tell subscribers what the channel is about.'
	String get channelDescriptionFooter => 'Tell subscribers what the channel is about.';

	/// en: 'A community brings together your groups and channels.'
	String get communityDescriptionFooter => 'A community brings together your groups and channels.';

	/// en: 'Members'
	String get members => 'Members';

	/// en: 'Set Photo'
	String get setPhoto => 'Set Photo';

	/// en: 'Change Photo'
	String get changePhoto => 'Change Photo';

	/// en: 'Remove Photo'
	String get removePhoto => 'Remove Photo';

	/// en: 'Edit Photo'
	String get editPhoto => 'Edit Photo';

	/// en: 'Type'
	String get type => 'Type';

	/// en: 'Public'
	String get typePublic => 'Public';

	/// en: 'Private'
	String get typePrivate => 'Private';

	/// en: 'Anyone can find a public channel in search and subscribe.'
	String get channelPublicFooter => 'Anyone can find a public channel in search and subscribe.';

	/// en: 'Private channels can only be joined via an invite link.'
	String get channelPrivateFooter => 'Private channels can only be joined via an invite link.';

	/// en: 'Anyone can find a public community in search and join it.'
	String get communityPublicFooter => 'Anyone can find a public community in search and join it.';

	/// en: 'Private communities can only be joined via an invite link.'
	String get communityPrivateFooter => 'Private communities can only be joined via an invite link.';

	/// en: 'Link'
	String get link => 'Link';

	/// en: 'name'
	String get usernameHint => 'name';

	/// en: 'Checking…'
	String get usernameChecking => 'Checking…';

	/// en: 'This link is available.'
	String get usernameAvailable => 'This link is available.';

	/// en: 'This link is already taken.'
	String get usernameTaken => 'This link is already taken.';

	/// en: '5–24 characters: Latin letters a–z, digits and _.'
	String get usernameInvalid => '5–24 characters: Latin letters a–z, digits and _.';

	/// en: 'Pick a link people will use to find it.'
	String get usernameEmpty => 'Pick a link people will use to find it.';

	/// en: 'Invite Link'
	String get inviteLink => 'Invite Link';

	/// en: 'Anyone with this link can join. Tap to copy.'
	String get inviteLinkFooter => 'Anyone with this link can join. Tap to copy.';

	/// en: 'Link copied'
	String get copied => 'Link copied';

	/// en: 'Joining'
	String get joinHeader => 'Joining';

	/// en: 'Open'
	String get joinOpen => 'Open';

	/// en: 'By Invite Link'
	String get joinLink => 'By Invite Link';

	/// en: 'By Request'
	String get joinRequest => 'By Request';

	/// en: 'Added by Admins'
	String get joinAdmins => 'Added by Admins';

	/// en: 'Anyone can find it in search and join.'
	String get joinOpenFooter => 'Anyone can find it in search and join.';

	/// en: 'Only people with the invite link can join.'
	String get joinLinkFooter => 'Only people with the invite link can join.';

	/// en: 'People with the invite link send a request; they join after an admin approves it.'
	String get joinRequestFooter => 'People with the invite link send a request; they join after an admin approves it.';

	/// en: 'Nobody can join on their own — admins add members.'
	String get joinAdminsFooter => 'Nobody can join on their own — admins add members.';

	/// en: 'New Members'
	String get defaultRoleHeader => 'New Members';

	/// en: 'Read Only'
	String get roleReader => 'Read Only';

	/// en: 'Can Send Messages'
	String get roleWriter => 'Can Send Messages';

	/// en: 'New members can read but not send messages.'
	String get roleReaderFooter => 'New members can read but not send messages.';

	/// en: 'New members can read and send messages.'
	String get roleWriterFooter => 'New members can read and send messages.';
}

// Path: screenChatInvites
class Translations$screenChatInvites$en {
	Translations$screenChatInvites$en.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Invite Links'
	String get inviteLinks => 'Invite Links';

	/// en: 'Join Requests'
	String get joinRequests => 'Join Requests';

	/// en: 'Primary Link'
	String get primaryLink => 'Primary Link';

	/// en: 'Public Link'
	String get publicLink => 'Public Link';

	/// en: 'The public link is changed in Edit. Additional links below work as invitations.'
	String get publicLinkFooter => 'The public link is changed in Edit. Additional links below work as invitations.';

	/// en: 'Anyone with the link can join.'
	String get primaryFooter => 'Anyone with the link can join.';

	/// en: 'Anyone with the link can subscribe.'
	String get primaryFooterChannel => 'Anyone with the link can subscribe.';

	/// en: 'People with the link send a join request that an admin approves.'
	String get primaryFooterRequest => 'People with the link send a join request that an admin approves.';

	/// en: 'Members are currently added by admins only — nobody can join via links. Change the joining method in Edit.'
	String get adminsOnlyNote => 'Members are currently added by admins only — nobody can join via links. Change the joining method in Edit.';

	/// en: 'Copy'
	String get copy => 'Copy';

	/// en: 'Share'
	String get share => 'Share';

	/// en: 'Replace Link'
	String get replace => 'Replace Link';

	/// en: 'Replace the link?'
	String get replaceTitle => 'Replace the link?';

	/// en: 'The current link will stop working, and a new one will be created.'
	String get replaceMessage => 'The current link will stop working, and a new one will be created.';

	/// en: 'Link copied'
	String get copied => 'Link copied';

	/// en: 'Create a New Link'
	String get createLink => 'Create a New Link';

	/// en: 'Additional Links'
	String get additionalHeader => 'Additional Links';

	/// en: 'Create links with an expiry date, a member limit or admin approval.'
	String get additionalFooter => 'Create links with an expiry date, a member limit or admin approval.';

	/// en: 'Revoked Links'
	String get revokedHeader => 'Revoked Links';

	/// en: 'Delete All Revoked Links'
	String get deleteAllRevoked => 'Delete All Revoked Links';

	/// en: 'Joined: {n}'
	String joined({required Object n}) => 'Joined: ${n}';

	/// en: '{n} left'
	String left({required Object n}) => '${n} left';

	/// en: 'until {date}'
	String until({required Object date}) => 'until ${date}';

	/// en: 'expired'
	String get expired => 'expired';

	/// en: 'limit reached'
	String get exhausted => 'limit reached';

	/// en: 'by request'
	String get approval => 'by request';

	/// en: 'Edit'
	String get edit => 'Edit';

	/// en: 'Revoke'
	String get revoke => 'Revoke';

	/// en: 'Revoke the link?'
	String get revokeTitle => 'Revoke the link?';

	/// en: 'Nobody will be able to join via this link.'
	String get revokeMessage => 'Nobody will be able to join via this link.';

	/// en: 'Delete'
	String get delete => 'Delete';

	/// en: 'New Link'
	String get newLink => 'New Link';

	/// en: 'Edit Link'
	String get editLink => 'Edit Link';

	/// en: 'Create'
	String get create => 'Create';

	/// en: 'Link Name'
	String get name => 'Link Name';

	/// en: 'Optional'
	String get nameHint => 'Optional';

	/// en: 'Only admins see the link name.'
	String get nameFooter => 'Only admins see the link name.';

	/// en: 'Request Admin Approval'
	String get approvalTitle => 'Request Admin Approval';

	/// en: 'People who follow the link send a request; an admin approves or declines it.'
	String get approvalFooter => 'People who follow the link send a request; an admin approves or declines it.';

	/// en: 'Expires'
	String get expireHeader => 'Expires';

	/// en: 'Never'
	String get expireNever => 'Never';

	/// en: 'In 1 hour'
	String get expireHour => 'In 1 hour';

	/// en: 'In 1 day'
	String get expireDay => 'In 1 day';

	/// en: 'In 1 week'
	String get expireWeek => 'In 1 week';

	/// en: 'Until {date}'
	String expireCurrent({required Object date}) => 'Until ${date}';

	/// en: 'Member Limit'
	String get limitHeader => 'Member Limit';

	/// en: 'No limit'
	String get limitNone => 'No limit';

	/// en: 'How many people can join via this link.'
	String get limitFooter => 'How many people can join via this link.';

	/// en: 'No join requests'
	String get requestsEmpty => 'No join requests';

	/// en: 'When someone asks to join, the request will appear here.'
	String get requestsEmptyHint => 'When someone asks to join, the request will appear here.';

	/// en: 'Accept'
	String get approve => 'Accept';

	/// en: 'Decline'
	String get decline => 'Decline';

	/// en: 'Accept All'
	String get approveAll => 'Accept All';

	/// en: 'Decline All'
	String get declineAll => 'Decline All';

	/// en: 'All'
	String get all => 'All';

	/// en: 'via “{title}”'
	String viaLink({required Object title}) => 'via “${title}”';

	/// en: 'Requests come when joining is set to “By Request” or via links with admin approval.'
	String get requestsOffHint => 'Requests come when joining is set to “By Request” or via links with admin approval.';
}

// Path: screenChatAdmins
class Translations$screenChatAdmins$en {
	Translations$screenChatAdmins$en.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Administrators'
	String get admins => 'Administrators';

	/// en: 'Add Admin'
	String get addAdmin => 'Add Admin';

	/// en: 'Admins help manage the chat. Each admin's rights are set separately.'
	String get adminsFooter => 'Admins help manage the chat. Each admin\'s rights are set separately.';

	/// en: 'Make Admin'
	String get promote => 'Make Admin';

	/// en: 'Admin Rights'
	String get adminRights => 'Admin Rights';

	/// en: 'New Admin'
	String get newAdmin => 'New Admin';

	/// en: 'What can this admin do?'
	String get rightsHeader => 'What can this admin do?';

	/// en: 'You can only grant the rights you have yourself.'
	String get rightsFooterLimited => 'You can only grant the rights you have yourself.';

	/// en: 'Change Info and Settings'
	String get changeInfo => 'Change Info and Settings';

	/// en: 'Post Messages'
	String get postMessages => 'Post Messages';

	/// en: 'Edit Others' Posts'
	String get editMessages => 'Edit Others\' Posts';

	/// en: 'Delete Others' Messages'
	String get deleteMessages => 'Delete Others\' Messages';

	/// en: 'Ban Users'
	String get banUsers => 'Ban Users';

	/// en: 'Invite Users via Link'
	String get inviteUsers => 'Invite Users via Link';

	/// en: 'Pin Messages'
	String get pinMessages => 'Pin Messages';

	/// en: 'Manage Voice Chats'
	String get manageCalls => 'Manage Voice Chats';

	/// en: 'Remain Anonymous'
	String get anonymous => 'Remain Anonymous';

	/// en: 'Add New Admins'
	String get addAdmins => 'Add New Admins';

	/// en: 'An anonymous admin's messages are signed with the group name.'
	String get anonymousFooter => 'An anonymous admin\'s messages are signed with the group name.';

	/// en: 'Custom Title'
	String get rankHeader => 'Custom Title';

	/// en: 'admin'
	String get rankHint => 'admin';

	/// en: 'Shown instead of “admin” in the member list.'
	String get rankFooter => 'Shown instead of “admin” in the member list.';

	/// en: 'Dismiss Admin'
	String get dismiss => 'Dismiss Admin';

	/// en: 'Dismiss {name}?'
	String dismissTitle({required Object name}) => 'Dismiss ${name}?';

	/// en: 'They will stay in the chat without admin rights.'
	String get dismissMessage => 'They will stay in the chat without admin rights.';

	/// en: 'Transfer Ownership'
	String get transfer => 'Transfer Ownership';

	/// en: 'Transfer ownership to {name}?'
	String transferTitle({required Object name}) => 'Transfer ownership to ${name}?';

	/// en: '{name} will become the owner and you will remain an admin with all rights. Only the new owner can undo this.'
	String transferMessage({required Object name}) => '${name} will become the owner and you will remain an admin with all rights. Only the new owner can undo this.';

	/// en: 'Choose a Member'
	String get pickMember => 'Choose a Member';

	/// en: 'Nobody to promote — everyone is already an admin.'
	String get noCandidates => 'Nobody to promote — everyone is already an admin.';
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

	/// en: 'Selected: {n}'
	String selected({required Object n}) => 'Selected: ${n}';

	/// en: 'Search'
	String get search => 'Search';

	/// en: 'No results'
	String get searchNoResults => 'No results';

	/// en: 'Unread messages'
	String get unreadMessages => 'Unread messages';

	/// en: 'Select'
	String get select => 'Select';

	/// en: 'Compressing video'
	String get videoCompressing => 'Compressing video';

	/// en: 'Pin'
	String get pin => 'Pin';

	/// en: 'Unpin'
	String get unpin => 'Unpin';

	/// en: 'Pinned message'
	String get pinnedTitle => 'Pinned message';

	/// en: 'Pinned message #{n}'
	String pinnedNumber({required Object n}) => 'Pinned message #${n}';

	/// en: 'Unpin message?'
	String get unpinTitle => 'Unpin message?';

	/// en: 'You pinned «{text}»'
	String pinnedServiceYou({required Object text}) => 'You pinned «${text}»';

	/// en: 'You pinned a message'
	String get pinnedServiceYouMessage => 'You pinned a message';

	/// en: '{name} pinned «{text}»'
	String pinnedService({required Object name, required Object text}) => '${name} pinned «${text}»';

	/// en: '{name} pinned a message'
	String pinnedServiceMessage({required Object name}) => '${name} pinned a message';

	/// en: '(one) {{n} pinned message} (other) {{n} pinned messages}'
	String pinnedList({required num n}) => (_root.$meta.cardinalResolver ?? PluralResolvers.cardinal('en'))(n,
		one: '${n} pinned message',
		other: '${n} pinned messages',
	);

	/// en: 'All pinned messages'
	String get pinnedAll => 'All pinned messages';

	/// en: 'Unpin all messages'
	String get unpinAll => 'Unpin all messages';

	/// en: '(one) {Unpin {n} message?} (other) {Unpin all {n} messages?}'
	String unpinAllTitle({required num n}) => (_root.$meta.cardinalResolver ?? PluralResolvers.cardinal('en'))(n,
		one: 'Unpin ${n} message?',
		other: 'Unpin all ${n} messages?',
	);

	/// en: 'Go to message'
	String get goToMessage => 'Go to message';

	/// en: 'Send without sound'
	String get sendSilent => 'Send without sound';

	/// en: 'Schedule message'
	String get sendLater => 'Schedule message';

	/// en: 'Scheduled messages'
	String get scheduledTitle => 'Scheduled messages';

	/// en: 'Schedule'
	String get schedule => 'Schedule';

	/// en: 'Send now'
	String get sendNow => 'Send now';

	/// en: 'Reschedule'
	String get reschedule => 'Reschedule';

	/// en: 'Delete scheduled message?'
	String get deleteScheduledTitle => 'Delete scheduled message?';

	/// en: 'Scheduled messages'
	String get scheduledHint => 'Scheduled messages';

	/// en: 'Link preview'
	String get linkPreview => 'Link preview';

	/// en: 'Forward'
	String get forward => 'Forward';

	/// en: 'Forward to…'
	String get forwardTo => 'Forward to…';

	/// en: 'Forwarded from {name}'
	String forwardedFrom({required Object name}) => 'Forwarded from ${name}';

	/// en: 'From: {names}'
	String forwardFrom({required Object names}) => 'From: ${names}';

	/// en: '(one) {Forward {n} message} (other) {Forward {n} messages}'
	String forwardMessages({required num n}) => (_root.$meta.cardinalResolver ?? PluralResolvers.cardinal('en'))(n,
		one: 'Forward ${n} message',
		other: 'Forward ${n} messages',
	);

	/// en: '(one) {Delete {n} message?} (other) {Delete {n} messages?}'
	String deleteSelectedTitle({required num n}) => (_root.$meta.cardinalResolver ?? PluralResolvers.cardinal('en'))(n,
		one: 'Delete ${n} message?',
		other: 'Delete ${n} messages?',
	);

	/// en: 'Messages will be deleted for everyone in the chat.'
	String get deleteSelectedMessage => 'Messages will be deleted for everyone in the chat.';

	/// en: 'Delete for me and {name}'
	String deleteForBoth({required Object name}) => 'Delete for me and ${name}';

	/// en: 'Delete for me'
	String get deleteForMe => 'Delete for me';

	/// en: 'Also delete for {name}'
	String deleteAlsoFor({required Object name}) => 'Also delete for ${name}';

	/// en: 'The message will be deleted from Saved Messages.'
	String get deleteMessageSelf => 'The message will be deleted from Saved Messages.';

	/// en: 'The messages will be deleted from Saved Messages.'
	String get deleteSelectedMessageSelf => 'The messages will be deleted from Saved Messages.';

	/// en: 'Slide to cancel'
	String get voiceSlideToCancel => 'Slide to cancel';

	/// en: 'Hold to record'
	String get voiceHoldHint => 'Hold to record';

	/// en: 'No microphone access'
	String get micDeniedTitle => 'No microphone access';

	/// en: 'Allow microphone access in Settings to record voice messages.'
	String get micDeniedMessage => 'Allow microphone access in Settings to record voice messages.';

	/// en: 'Settings'
	String get openSettings => 'Settings';

	/// en: 'Hide with spoiler'
	String get hideWithSpoiler => 'Hide with spoiler';

	/// en: 'Remove spoiler'
	String get removeSpoiler => 'Remove spoiler';

	/// en: 'HD video: 1080p'
	String get videoHdOn => 'HD video: 1080p';

	/// en: 'Standard quality: 720p'
	String get videoHdOff => 'Standard quality: 720p';

	/// en: 'Sound'
	String get videoSound => 'Sound';

	/// en: 'Muted'
	String get videoMuted => 'Muted';

	/// en: 'Cover'
	String get videoCover => 'Cover';

	/// en: 'Cover set'
	String get videoCoverSet => 'Cover set';

	/// en: 'Reset'
	String get videoReset => 'Reset';

	/// en: 'Crop'
	String get videoCrop => 'Crop';

	/// en: 'Rotate'
	String get videoRotate => 'Rotate';

	/// en: 'Free'
	String get videoAspectFree => 'Free';

	/// en: 'Original'
	String get videoAspectOriginal => 'Original';

	/// en: 'Square'
	String get videoAspectSquare => 'Square';

	/// en: 'Couldn't open the video'
	String get videoEditFailed => 'Couldn\'t open the video';

	/// en: 'Formatting'
	String get format => 'Formatting';

	/// en: 'Bold'
	String get formatBold => 'Bold';

	/// en: 'Italic'
	String get formatItalic => 'Italic';

	/// en: 'Strikethrough'
	String get formatStrike => 'Strikethrough';

	/// en: 'Spoiler'
	String get formatSpoiler => 'Spoiler';

	/// en: 'Monospace'
	String get formatCode => 'Monospace';

	/// en: 'Link'
	String get formatLink => 'Link';

	/// en: 'Quote'
	String get formatQuote => 'Quote';

	/// en: 'Regular'
	String get formatPlain => 'Regular';

	/// en: 'Add link'
	String get linkTitle => 'Add link';

	/// en: 'Add'
	String get linkAdd => 'Add';

	/// en: '{done} of {total}'
	String uploadProgress({required Object done, required Object total}) => '${done} of ${total}';

	/// en: 'KB'
	String get kb => 'KB';

	/// en: 'MB'
	String get mb => 'MB';

	/// en: 'GB'
	String get gb => 'GB';

	/// en: '{current} of {total}'
	String mediaCounter({required Object current, required Object total}) => '${current} of ${total}';

	/// en: 'Add a caption…'
	String get addCaption => 'Add a caption…';
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

	/// en: 'Chat themes'
	String get chatThemes => 'Chat themes';

	/// en: 'Quick reaction'
	String get quickReaction => 'Quick reaction';

	/// en: 'Set by double-tapping a message'
	String get quickReactionDescription => 'Set by double-tapping a message';
}

// Path: screenChatInfo
class Translations$screenChatInfo$en {
	Translations$screenChatInfo$en.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Mute'
	String get mute => 'Mute';

	/// en: 'Unmute'
	String get unmute => 'Unmute';

	/// en: 'Sound'
	String get sound => 'Sound';

	/// en: 'Search'
	String get search => 'Search';

	/// en: 'Bio'
	String get about => 'Bio';

	/// en: 'Description'
	String get description => 'Description';

	/// en: 'Username'
	String get username => 'Username';

	/// en: 'Link'
	String get link => 'Link';

	/// en: 'Members'
	String get tabMembers => 'Members';

	/// en: 'Media'
	String get tabMedia => 'Media';

	/// en: 'Files'
	String get tabFiles => 'Files';

	/// en: 'Links'
	String get tabLinks => 'Links';

	/// en: 'Voice'
	String get tabVoice => 'Voice';

	/// en: 'Photos and videos from this chat will appear here'
	String get emptyMedia => 'Photos and videos from this chat will appear here';

	/// en: 'Files from this chat will appear here'
	String get emptyFiles => 'Files from this chat will appear here';

	/// en: 'Links from this chat will appear here'
	String get emptyLinks => 'Links from this chat will appear here';

	/// en: 'Voice messages will appear here'
	String get emptyVoice => 'Voice messages will appear here';

	/// en: 'owner'
	String get roleOwner => 'owner';

	/// en: 'admin'
	String get roleAdmin => 'admin';

	/// en: 'read only'
	String get roleReader => 'read only';

	/// en: 'You'
	String get you => 'You';

	/// en: 'Add Members'
	String get addMembers => 'Add Members';

	/// en: 'Add'
	String get add => 'Add';

	/// en: 'Send Message'
	String get sendMessage => 'Send Message';

	/// en: 'Allow Sending Messages'
	String get allowWriting => 'Allow Sending Messages';

	/// en: 'Make Read Only'
	String get makeReadOnly => 'Make Read Only';

	/// en: 'Remove'
	String get removeMember => 'Remove';

	/// en: 'Remove {name}?'
	String removeMemberTitle({required Object name}) => 'Remove ${name}?';

	/// en: 'They can come back via an invite link.'
	String get removeMemberMessage => 'They can come back via an invite link.';

	/// en: 'Ban'
	String get banMember => 'Ban';

	/// en: 'Ban {name}?'
	String banMemberTitle({required Object name}) => 'Ban ${name}?';

	/// en: 'They will be removed and won't be able to come back via invite links until unbanned.'
	String get banMemberMessage => 'They will be removed and won\'t be able to come back via invite links until unbanned.';

	/// en: 'Banned'
	String get banned => 'Banned';

	/// en: 'No banned users'
	String get bannedEmpty => 'No banned users';

	/// en: 'Banned users can't join via invite links. Adding them manually unbans them.'
	String get bannedFooter => 'Banned users can\'t join via invite links. Adding them manually unbans them.';

	/// en: 'Unban'
	String get unban => 'Unban';

	/// en: 'Reactions'
	String get reactions => 'Reactions';

	/// en: 'All reactions'
	String get reactionsAll => 'All reactions';

	/// en: 'Some reactions'
	String get reactionsSome => 'Some reactions';

	/// en: 'No reactions'
	String get reactionsNone => 'No reactions';

	/// en: 'All'
	String get reactionsAllShort => 'All';

	/// en: 'Off'
	String get reactionsNoneShort => 'Off';

	/// en: 'Which reactions members can add to messages. Existing reactions stay.'
	String get reactionsFooter => 'Which reactions members can add to messages. Existing reactions stay.';

	/// en: 'Available reactions'
	String get reactionsPick => 'Available reactions';

	/// en: 'Delete chat'
	String get deleteChat => 'Delete chat';

	/// en: 'Leave group'
	String get leaveGroup => 'Leave group';

	/// en: 'Leave channel'
	String get leaveChannel => 'Leave channel';

	/// en: 'Leave community'
	String get leaveCommunity => 'Leave community';

	/// en: 'Leave'
	String get leaveShort => 'Leave';

	/// en: 'Delete chat with {name}?'
	String deleteChatTitle({required Object name}) => 'Delete chat with ${name}?';

	/// en: 'Leave «{name}»?'
	String leaveGroupTitle({required Object name}) => 'Leave «${name}»?';

	/// en: 'last seen {n} min ago'
	String lastSeenMinutes({required Object n}) => 'last seen ${n} min ago';

	/// en: 'last seen at {time}'
	String lastSeenAt({required Object time}) => 'last seen at ${time}';

	/// en: 'last seen yesterday at {time}'
	String lastSeenYesterday({required Object time}) => 'last seen yesterday at ${time}';

	/// en: 'last seen {date}'
	String lastSeenDate({required Object date}) => 'last seen ${date}';
}

// Path: screenChatThemes
class Translations$screenChatThemes$en {
	Translations$screenChatThemes$en.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Chat themes'
	String get title => _root.screenSettingsAppearance.chatThemes;

	/// en: 'Pattern'
	String get pattern => 'Pattern';

	/// en: 'Pattern intensity'
	String get intensity => 'Pattern intensity';

	/// en: 'Color'
	String get color => 'Color';

	/// en: 'The wallpaper is shown in all chats on this device and adapts to light and dark mode.'
	String get footer => 'The wallpaper is shown in all chats on this device and adapts to light and dark mode.';

	/// en: 'Anna'
	String get previewName => 'Anna';

	/// en: 'Hi! How do you like the new wallpaper? 🎨'
	String get previewIncoming => 'Hi! How do you like the new wallpaper? 🎨';

	/// en: 'Looks great, I'll keep this one 😍'
	String get previewOutgoing => 'Looks great, I\'ll keep this one 😍';

	/// en: 'Chat'
	String get patternChat => 'Chat';

	/// en: 'Space'
	String get patternSpace => 'Space';

	/// en: 'Nature'
	String get patternNature => 'Nature';

	/// en: 'Music'
	String get patternMusic => 'Music';

	/// en: 'Geometry'
	String get patternGeometry => 'Geometry';

	/// en: 'Food'
	String get patternFood => 'Food';
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

	/// en: 'Choose file'
	String get pickDocument => 'Choose file';

	/// en: 'Documents, archives and any other files'
	String get pickDocumentHint => 'Documents, archives and any other files';

	/// en: 'Photo or video without compression'
	String get pickMediaAsFile => 'Photo or video without compression';

	/// en: 'Sent as a file, in original quality'
	String get pickMediaAsFileHint => 'Sent as a file, in original quality';

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
			'componentsCamera.photo' => 'Photo',
			'componentsCamera.video' => 'Video',
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
			'screenChats.swipeRead' => 'Read',
			'screenChats.swipeUnread' => 'Unread',
			'screenChats.swipeMute' => 'Mute',
			'screenChats.swipeUnmute' => 'Unmute',
			'screenChats.swipeArchive' => 'Archive',
			'screenChats.swipeUnarchive' => 'Unarchive',
			'screenChats.deleteChatTitle' => 'Delete chat?',
			'screenChats.deleteChatMessage' => ({required Object title}) => 'Chat "${title}" will be removed from the list.',
			'screenChats.readAll' => 'Read all',
			'screenChats.deleteFolder' => 'Delete folder',
			'screenChats.deleteFolderTitle' => ({required Object title}) => 'Delete folder "${title}"?',
			'screenChats.deleteFolderMessage' => 'Chats in the folder are not deleted.',
			'screenNewChat.title' => 'New Message',
			'screenNewChat.search' => 'Search',
			'screenNewChat.newGroup' => 'New Group',
			'screenNewChat.newChannel' => 'New Channel',
			'screenNewChat.newCommunity' => 'New Community',
			'screenNewChat.contacts' => 'Contacts',
			'screenNewChat.noContacts' => 'No contacts found',
			'screenNewChat.addMembers' => 'Add Members',
			'screenNewChat.next' => 'Next',
			'screenNewChat.selected' => ({required Object n}) => 'Selected: ${n}',
			'screenNewChat.noMembersHint' => 'You can create a group without members and invite them later.',
			'screenNewChat.groupTitle' => 'New Group',
			'screenNewChat.channelTitle' => 'New Channel',
			'screenNewChat.communityTitle' => 'New Community',
			'screenNewChat.create' => 'Create',
			'screenNewChat.groupName' => 'Group Name',
			'screenNewChat.channelName' => 'Channel Name',
			'screenNewChat.communityName' => 'Community Name',
			'screenNewChat.description' => 'Description',
			'screenNewChat.descriptionHint' => 'Optional',
			'screenNewChat.channelDescriptionFooter' => 'Tell subscribers what the channel is about.',
			'screenNewChat.communityDescriptionFooter' => 'A community brings together your groups and channels.',
			'screenNewChat.members' => 'Members',
			'screenNewChat.setPhoto' => 'Set Photo',
			'screenNewChat.changePhoto' => 'Change Photo',
			'screenNewChat.removePhoto' => 'Remove Photo',
			'screenNewChat.editPhoto' => 'Edit Photo',
			'screenNewChat.type' => 'Type',
			'screenNewChat.typePublic' => 'Public',
			'screenNewChat.typePrivate' => 'Private',
			'screenNewChat.channelPublicFooter' => 'Anyone can find a public channel in search and subscribe.',
			'screenNewChat.channelPrivateFooter' => 'Private channels can only be joined via an invite link.',
			'screenNewChat.communityPublicFooter' => 'Anyone can find a public community in search and join it.',
			'screenNewChat.communityPrivateFooter' => 'Private communities can only be joined via an invite link.',
			'screenNewChat.link' => 'Link',
			'screenNewChat.usernameHint' => 'name',
			'screenNewChat.usernameChecking' => 'Checking…',
			'screenNewChat.usernameAvailable' => 'This link is available.',
			'screenNewChat.usernameTaken' => 'This link is already taken.',
			'screenNewChat.usernameInvalid' => '5–24 characters: Latin letters a–z, digits and _.',
			'screenNewChat.usernameEmpty' => 'Pick a link people will use to find it.',
			'screenNewChat.inviteLink' => 'Invite Link',
			'screenNewChat.inviteLinkFooter' => 'Anyone with this link can join. Tap to copy.',
			'screenNewChat.copied' => 'Link copied',
			'screenNewChat.joinHeader' => 'Joining',
			'screenNewChat.joinOpen' => 'Open',
			'screenNewChat.joinLink' => 'By Invite Link',
			'screenNewChat.joinRequest' => 'By Request',
			'screenNewChat.joinAdmins' => 'Added by Admins',
			'screenNewChat.joinOpenFooter' => 'Anyone can find it in search and join.',
			'screenNewChat.joinLinkFooter' => 'Only people with the invite link can join.',
			'screenNewChat.joinRequestFooter' => 'People with the invite link send a request; they join after an admin approves it.',
			'screenNewChat.joinAdminsFooter' => 'Nobody can join on their own — admins add members.',
			'screenNewChat.defaultRoleHeader' => 'New Members',
			'screenNewChat.roleReader' => 'Read Only',
			'screenNewChat.roleWriter' => 'Can Send Messages',
			'screenNewChat.roleReaderFooter' => 'New members can read but not send messages.',
			'screenNewChat.roleWriterFooter' => 'New members can read and send messages.',
			'screenChatInvites.inviteLinks' => 'Invite Links',
			'screenChatInvites.joinRequests' => 'Join Requests',
			'screenChatInvites.primaryLink' => 'Primary Link',
			'screenChatInvites.publicLink' => 'Public Link',
			'screenChatInvites.publicLinkFooter' => 'The public link is changed in Edit. Additional links below work as invitations.',
			'screenChatInvites.primaryFooter' => 'Anyone with the link can join.',
			'screenChatInvites.primaryFooterChannel' => 'Anyone with the link can subscribe.',
			'screenChatInvites.primaryFooterRequest' => 'People with the link send a join request that an admin approves.',
			'screenChatInvites.adminsOnlyNote' => 'Members are currently added by admins only — nobody can join via links. Change the joining method in Edit.',
			'screenChatInvites.copy' => 'Copy',
			'screenChatInvites.share' => 'Share',
			'screenChatInvites.replace' => 'Replace Link',
			'screenChatInvites.replaceTitle' => 'Replace the link?',
			'screenChatInvites.replaceMessage' => 'The current link will stop working, and a new one will be created.',
			'screenChatInvites.copied' => 'Link copied',
			'screenChatInvites.createLink' => 'Create a New Link',
			'screenChatInvites.additionalHeader' => 'Additional Links',
			'screenChatInvites.additionalFooter' => 'Create links with an expiry date, a member limit or admin approval.',
			'screenChatInvites.revokedHeader' => 'Revoked Links',
			'screenChatInvites.deleteAllRevoked' => 'Delete All Revoked Links',
			'screenChatInvites.joined' => ({required Object n}) => 'Joined: ${n}',
			'screenChatInvites.left' => ({required Object n}) => '${n} left',
			'screenChatInvites.until' => ({required Object date}) => 'until ${date}',
			'screenChatInvites.expired' => 'expired',
			'screenChatInvites.exhausted' => 'limit reached',
			'screenChatInvites.approval' => 'by request',
			'screenChatInvites.edit' => 'Edit',
			'screenChatInvites.revoke' => 'Revoke',
			'screenChatInvites.revokeTitle' => 'Revoke the link?',
			'screenChatInvites.revokeMessage' => 'Nobody will be able to join via this link.',
			'screenChatInvites.delete' => 'Delete',
			'screenChatInvites.newLink' => 'New Link',
			'screenChatInvites.editLink' => 'Edit Link',
			'screenChatInvites.create' => 'Create',
			'screenChatInvites.name' => 'Link Name',
			'screenChatInvites.nameHint' => 'Optional',
			'screenChatInvites.nameFooter' => 'Only admins see the link name.',
			'screenChatInvites.approvalTitle' => 'Request Admin Approval',
			'screenChatInvites.approvalFooter' => 'People who follow the link send a request; an admin approves or declines it.',
			'screenChatInvites.expireHeader' => 'Expires',
			'screenChatInvites.expireNever' => 'Never',
			'screenChatInvites.expireHour' => 'In 1 hour',
			'screenChatInvites.expireDay' => 'In 1 day',
			'screenChatInvites.expireWeek' => 'In 1 week',
			'screenChatInvites.expireCurrent' => ({required Object date}) => 'Until ${date}',
			'screenChatInvites.limitHeader' => 'Member Limit',
			'screenChatInvites.limitNone' => 'No limit',
			'screenChatInvites.limitFooter' => 'How many people can join via this link.',
			'screenChatInvites.requestsEmpty' => 'No join requests',
			'screenChatInvites.requestsEmptyHint' => 'When someone asks to join, the request will appear here.',
			'screenChatInvites.approve' => 'Accept',
			'screenChatInvites.decline' => 'Decline',
			'screenChatInvites.approveAll' => 'Accept All',
			'screenChatInvites.declineAll' => 'Decline All',
			'screenChatInvites.all' => 'All',
			'screenChatInvites.viaLink' => ({required Object title}) => 'via “${title}”',
			'screenChatInvites.requestsOffHint' => 'Requests come when joining is set to “By Request” or via links with admin approval.',
			'screenChatAdmins.admins' => 'Administrators',
			'screenChatAdmins.addAdmin' => 'Add Admin',
			'screenChatAdmins.adminsFooter' => 'Admins help manage the chat. Each admin\'s rights are set separately.',
			'screenChatAdmins.promote' => 'Make Admin',
			'screenChatAdmins.adminRights' => 'Admin Rights',
			'screenChatAdmins.newAdmin' => 'New Admin',
			'screenChatAdmins.rightsHeader' => 'What can this admin do?',
			'screenChatAdmins.rightsFooterLimited' => 'You can only grant the rights you have yourself.',
			'screenChatAdmins.changeInfo' => 'Change Info and Settings',
			'screenChatAdmins.postMessages' => 'Post Messages',
			'screenChatAdmins.editMessages' => 'Edit Others\' Posts',
			'screenChatAdmins.deleteMessages' => 'Delete Others\' Messages',
			'screenChatAdmins.banUsers' => 'Ban Users',
			'screenChatAdmins.inviteUsers' => 'Invite Users via Link',
			'screenChatAdmins.pinMessages' => 'Pin Messages',
			'screenChatAdmins.manageCalls' => 'Manage Voice Chats',
			'screenChatAdmins.anonymous' => 'Remain Anonymous',
			'screenChatAdmins.addAdmins' => 'Add New Admins',
			'screenChatAdmins.anonymousFooter' => 'An anonymous admin\'s messages are signed with the group name.',
			'screenChatAdmins.rankHeader' => 'Custom Title',
			'screenChatAdmins.rankHint' => 'admin',
			'screenChatAdmins.rankFooter' => 'Shown instead of “admin” in the member list.',
			'screenChatAdmins.dismiss' => 'Dismiss Admin',
			'screenChatAdmins.dismissTitle' => ({required Object name}) => 'Dismiss ${name}?',
			'screenChatAdmins.dismissMessage' => 'They will stay in the chat without admin rights.',
			'screenChatAdmins.transfer' => 'Transfer Ownership',
			'screenChatAdmins.transferTitle' => ({required Object name}) => 'Transfer ownership to ${name}?',
			'screenChatAdmins.transferMessage' => ({required Object name}) => '${name} will become the owner and you will remain an admin with all rights. Only the new owner can undo this.',
			'screenChatAdmins.pickMember' => 'Choose a Member',
			'screenChatAdmins.noCandidates' => 'Nobody to promote — everyone is already an admin.',
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
			'screenChat.selected' => ({required Object n}) => 'Selected: ${n}',
			'screenChat.search' => 'Search',
			'screenChat.searchNoResults' => 'No results',
			'screenChat.unreadMessages' => 'Unread messages',
			'screenChat.select' => 'Select',
			'screenChat.videoCompressing' => 'Compressing video',
			'screenChat.pin' => 'Pin',
			'screenChat.unpin' => 'Unpin',
			'screenChat.pinnedTitle' => 'Pinned message',
			'screenChat.pinnedNumber' => ({required Object n}) => 'Pinned message #${n}',
			'screenChat.unpinTitle' => 'Unpin message?',
			'screenChat.pinnedServiceYou' => ({required Object text}) => 'You pinned «${text}»',
			'screenChat.pinnedServiceYouMessage' => 'You pinned a message',
			'screenChat.pinnedService' => ({required Object name, required Object text}) => '${name} pinned «${text}»',
			'screenChat.pinnedServiceMessage' => ({required Object name}) => '${name} pinned a message',
			'screenChat.pinnedList' => ({required num n}) => (_root.$meta.cardinalResolver ?? PluralResolvers.cardinal('en'))(n, one: '${n} pinned message', other: '${n} pinned messages', ), 
			'screenChat.pinnedAll' => 'All pinned messages',
			'screenChat.unpinAll' => 'Unpin all messages',
			'screenChat.unpinAllTitle' => ({required num n}) => (_root.$meta.cardinalResolver ?? PluralResolvers.cardinal('en'))(n, one: 'Unpin ${n} message?', other: 'Unpin all ${n} messages?', ), 
			'screenChat.goToMessage' => 'Go to message',
			'screenChat.sendSilent' => 'Send without sound',
			'screenChat.sendLater' => 'Schedule message',
			'screenChat.scheduledTitle' => 'Scheduled messages',
			'screenChat.schedule' => 'Schedule',
			'screenChat.sendNow' => 'Send now',
			'screenChat.reschedule' => 'Reschedule',
			'screenChat.deleteScheduledTitle' => 'Delete scheduled message?',
			'screenChat.scheduledHint' => 'Scheduled messages',
			'screenChat.linkPreview' => 'Link preview',
			'screenChat.forward' => 'Forward',
			'screenChat.forwardTo' => 'Forward to…',
			'screenChat.forwardedFrom' => ({required Object name}) => 'Forwarded from ${name}',
			'screenChat.forwardFrom' => ({required Object names}) => 'From: ${names}',
			'screenChat.forwardMessages' => ({required num n}) => (_root.$meta.cardinalResolver ?? PluralResolvers.cardinal('en'))(n, one: 'Forward ${n} message', other: 'Forward ${n} messages', ), 
			'screenChat.deleteSelectedTitle' => ({required num n}) => (_root.$meta.cardinalResolver ?? PluralResolvers.cardinal('en'))(n, one: 'Delete ${n} message?', other: 'Delete ${n} messages?', ), 
			'screenChat.deleteSelectedMessage' => 'Messages will be deleted for everyone in the chat.',
			'screenChat.deleteForBoth' => ({required Object name}) => 'Delete for me and ${name}',
			'screenChat.deleteForMe' => 'Delete for me',
			'screenChat.deleteAlsoFor' => ({required Object name}) => 'Also delete for ${name}',
			'screenChat.deleteMessageSelf' => 'The message will be deleted from Saved Messages.',
			'screenChat.deleteSelectedMessageSelf' => 'The messages will be deleted from Saved Messages.',
			'screenChat.voiceSlideToCancel' => 'Slide to cancel',
			'screenChat.voiceHoldHint' => 'Hold to record',
			'screenChat.micDeniedTitle' => 'No microphone access',
			'screenChat.micDeniedMessage' => 'Allow microphone access in Settings to record voice messages.',
			'screenChat.openSettings' => 'Settings',
			'screenChat.hideWithSpoiler' => 'Hide with spoiler',
			'screenChat.removeSpoiler' => 'Remove spoiler',
			'screenChat.videoHdOn' => 'HD video: 1080p',
			'screenChat.videoHdOff' => 'Standard quality: 720p',
			'screenChat.videoSound' => 'Sound',
			'screenChat.videoMuted' => 'Muted',
			'screenChat.videoCover' => 'Cover',
			'screenChat.videoCoverSet' => 'Cover set',
			'screenChat.videoReset' => 'Reset',
			'screenChat.videoCrop' => 'Crop',
			'screenChat.videoRotate' => 'Rotate',
			'screenChat.videoAspectFree' => 'Free',
			'screenChat.videoAspectOriginal' => 'Original',
			'screenChat.videoAspectSquare' => 'Square',
			'screenChat.videoEditFailed' => 'Couldn\'t open the video',
			'screenChat.format' => 'Formatting',
			'screenChat.formatBold' => 'Bold',
			'screenChat.formatItalic' => 'Italic',
			'screenChat.formatStrike' => 'Strikethrough',
			'screenChat.formatSpoiler' => 'Spoiler',
			'screenChat.formatCode' => 'Monospace',
			'screenChat.formatLink' => 'Link',
			'screenChat.formatQuote' => 'Quote',
			'screenChat.formatPlain' => 'Regular',
			'screenChat.linkTitle' => 'Add link',
			'screenChat.linkAdd' => 'Add',
			'screenChat.uploadProgress' => ({required Object done, required Object total}) => '${done} of ${total}',
			'screenChat.kb' => 'KB',
			'screenChat.mb' => 'MB',
			'screenChat.gb' => 'GB',
			'screenChat.mediaCounter' => ({required Object current, required Object total}) => '${current} of ${total}',
			'screenChat.addCaption' => 'Add a caption…',
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
			'screenSettingsAppearance.chatThemes' => 'Chat themes',
			'screenSettingsAppearance.quickReaction' => 'Quick reaction',
			'screenSettingsAppearance.quickReactionDescription' => 'Set by double-tapping a message',
			'screenChatInfo.mute' => 'Mute',
			'screenChatInfo.unmute' => 'Unmute',
			'screenChatInfo.sound' => 'Sound',
			'screenChatInfo.search' => 'Search',
			'screenChatInfo.about' => 'Bio',
			'screenChatInfo.description' => 'Description',
			'screenChatInfo.username' => 'Username',
			'screenChatInfo.link' => 'Link',
			'screenChatInfo.tabMembers' => 'Members',
			'screenChatInfo.tabMedia' => 'Media',
			'screenChatInfo.tabFiles' => 'Files',
			'screenChatInfo.tabLinks' => 'Links',
			'screenChatInfo.tabVoice' => 'Voice',
			'screenChatInfo.emptyMedia' => 'Photos and videos from this chat will appear here',
			'screenChatInfo.emptyFiles' => 'Files from this chat will appear here',
			'screenChatInfo.emptyLinks' => 'Links from this chat will appear here',
			'screenChatInfo.emptyVoice' => 'Voice messages will appear here',
			'screenChatInfo.roleOwner' => 'owner',
			'screenChatInfo.roleAdmin' => 'admin',
			'screenChatInfo.roleReader' => 'read only',
			'screenChatInfo.you' => 'You',
			'screenChatInfo.addMembers' => 'Add Members',
			'screenChatInfo.add' => 'Add',
			'screenChatInfo.sendMessage' => 'Send Message',
			'screenChatInfo.allowWriting' => 'Allow Sending Messages',
			'screenChatInfo.makeReadOnly' => 'Make Read Only',
			'screenChatInfo.removeMember' => 'Remove',
			'screenChatInfo.removeMemberTitle' => ({required Object name}) => 'Remove ${name}?',
			'screenChatInfo.removeMemberMessage' => 'They can come back via an invite link.',
			'screenChatInfo.banMember' => 'Ban',
			'screenChatInfo.banMemberTitle' => ({required Object name}) => 'Ban ${name}?',
			'screenChatInfo.banMemberMessage' => 'They will be removed and won\'t be able to come back via invite links until unbanned.',
			'screenChatInfo.banned' => 'Banned',
			'screenChatInfo.bannedEmpty' => 'No banned users',
			'screenChatInfo.bannedFooter' => 'Banned users can\'t join via invite links. Adding them manually unbans them.',
			'screenChatInfo.unban' => 'Unban',
			'screenChatInfo.reactions' => 'Reactions',
			'screenChatInfo.reactionsAll' => 'All reactions',
			'screenChatInfo.reactionsSome' => 'Some reactions',
			'screenChatInfo.reactionsNone' => 'No reactions',
			'screenChatInfo.reactionsAllShort' => 'All',
			'screenChatInfo.reactionsNoneShort' => 'Off',
			'screenChatInfo.reactionsFooter' => 'Which reactions members can add to messages. Existing reactions stay.',
			'screenChatInfo.reactionsPick' => 'Available reactions',
			'screenChatInfo.deleteChat' => 'Delete chat',
			'screenChatInfo.leaveGroup' => 'Leave group',
			'screenChatInfo.leaveChannel' => 'Leave channel',
			'screenChatInfo.leaveCommunity' => 'Leave community',
			'screenChatInfo.leaveShort' => 'Leave',
			'screenChatInfo.deleteChatTitle' => ({required Object name}) => 'Delete chat with ${name}?',
			'screenChatInfo.leaveGroupTitle' => ({required Object name}) => 'Leave «${name}»?',
			'screenChatInfo.lastSeenMinutes' => ({required Object n}) => 'last seen ${n} min ago',
			'screenChatInfo.lastSeenAt' => ({required Object time}) => 'last seen at ${time}',
			'screenChatInfo.lastSeenYesterday' => ({required Object time}) => 'last seen yesterday at ${time}',
			'screenChatInfo.lastSeenDate' => ({required Object date}) => 'last seen ${date}',
			'screenChatThemes.title' => _root.screenSettingsAppearance.chatThemes,
			'screenChatThemes.pattern' => 'Pattern',
			'screenChatThemes.intensity' => 'Pattern intensity',
			'screenChatThemes.color' => 'Color',
			'screenChatThemes.footer' => 'The wallpaper is shown in all chats on this device and adapts to light and dark mode.',
			'screenChatThemes.previewName' => 'Anna',
			'screenChatThemes.previewIncoming' => 'Hi! How do you like the new wallpaper? 🎨',
			'screenChatThemes.previewOutgoing' => 'Looks great, I\'ll keep this one 😍',
			'screenChatThemes.patternChat' => 'Chat',
			'screenChatThemes.patternSpace' => 'Space',
			'screenChatThemes.patternNature' => 'Nature',
			'screenChatThemes.patternMusic' => 'Music',
			'screenChatThemes.patternGeometry' => 'Geometry',
			'screenChatThemes.patternFood' => 'Food',
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
			_ => null,
		} ?? switch (path) {
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
			'screenMyProfile.pickDocument' => 'Choose file',
			'screenMyProfile.pickDocumentHint' => 'Documents, archives and any other files',
			'screenMyProfile.pickMediaAsFile' => 'Photo or video without compression',
			'screenMyProfile.pickMediaAsFileHint' => 'Sent as a file, in original quality',
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
