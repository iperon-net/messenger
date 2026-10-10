///
/// Generated file. Do not edit.
///
// coverage:ignore-file
// ignore_for_file: type=lint, unused_import
// dart format off

import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';
import 'package:slang/generated.dart';
import 'translations.g.dart';

// Path: <root>
class TranslationsRu extends Translations with BaseTranslations<AppLocale, Translations> {
	/// You can call this constructor and build your own translation instance of this locale.
	/// Constructing via the enum [AppLocale.build] is preferred.
	TranslationsRu({Map<String, Node>? overrides, PluralResolver? cardinalResolver, PluralResolver? ordinalResolver, TranslationMetadata<AppLocale, Translations>? meta})
		: assert(overrides == null, 'Set "translation_overrides: true" in order to enable this feature.'),
		  _meta = meta ?? TranslationMetadata(
		    locale: AppLocale.ru,
		    overrides: overrides ?? {},
		    cardinalResolver: cardinalResolver,
		    ordinalResolver: ordinalResolver,
		  ),
		  super(cardinalResolver: cardinalResolver, ordinalResolver: ordinalResolver) {
		_meta.setFlatMapFunction(_flatMapFunction);
	}

	/// Metadata for the translations of <ru>.
	final TranslationMetadata<AppLocale, Translations> _meta;
	@override TranslationMetadata<AppLocale, Translations> get $meta => _meta;

	/// Access flat map
	@override dynamic operator[](String key) => _meta.getTranslation(key) ?? super[key];

	late final TranslationsRu _root = this; // ignore: unused_field

	@override 
	TranslationsRu $copyWith({TranslationMetadata<AppLocale, Translations>? meta}) => TranslationsRu(meta: meta ?? this.$meta);

	// Translations
	@override late final _Translations$common$ru common = _Translations$common$ru._(_root);
	@override late final _Translations$componentsConnectionTitle$ru componentsConnectionTitle = _Translations$componentsConnectionTitle$ru._(_root);
	@override late final _Translations$componentsCamera$ru componentsCamera = _Translations$componentsCamera$ru._(_root);
	@override late final _Translations$screenHome$ru screenHome = _Translations$screenHome$ru._(_root);
	@override late final _Translations$screenChats$ru screenChats = _Translations$screenChats$ru._(_root);
	@override late final _Translations$screenChatFolders$ru screenChatFolders = _Translations$screenChatFolders$ru._(_root);
	@override late final _Translations$screenNewChat$ru screenNewChat = _Translations$screenNewChat$ru._(_root);
	@override late final _Translations$screenChatInvites$ru screenChatInvites = _Translations$screenChatInvites$ru._(_root);
	@override late final _Translations$screenChatAdmins$ru screenChatAdmins = _Translations$screenChatAdmins$ru._(_root);
	@override late final _Translations$screenPoll$ru screenPoll = _Translations$screenPoll$ru._(_root);
	@override late final _Translations$screenChat$ru screenChat = _Translations$screenChat$ru._(_root);
	@override late final _Translations$screenSettings$ru screenSettings = _Translations$screenSettings$ru._(_root);
	@override late final _Translations$screenSettingsNotifications$ru screenSettingsNotifications = _Translations$screenSettingsNotifications$ru._(_root);
	@override late final _Translations$screenDeveloper$ru screenDeveloper = _Translations$screenDeveloper$ru._(_root);
	@override late final _Translations$screenSettingsAppearance$ru screenSettingsAppearance = _Translations$screenSettingsAppearance$ru._(_root);
	@override late final _Translations$screenChatInfo$ru screenChatInfo = _Translations$screenChatInfo$ru._(_root);
	@override late final _Translations$screenChatThemes$ru screenChatThemes = _Translations$screenChatThemes$ru._(_root);
	@override late final _Translations$screenSettingsDevices$ru screenSettingsDevices = _Translations$screenSettingsDevices$ru._(_root);
	@override late final _Translations$screenSettingsAboutApplication$ru screenSettingsAboutApplication = _Translations$screenSettingsAboutApplication$ru._(_root);
	@override late final _Translations$screenSettingsLanguage$ru screenSettingsLanguage = _Translations$screenSettingsLanguage$ru._(_root);
	@override late final _Translations$screenSettingsPasscode$ru screenSettingsPasscode = _Translations$screenSettingsPasscode$ru._(_root);
	@override late final _Translations$settingsPasscodeCreate$ru settingsPasscodeCreate = _Translations$settingsPasscodeCreate$ru._(_root);
	@override late final _Translations$sessionsPrivacyAndSecurity$ru sessionsPrivacyAndSecurity = _Translations$sessionsPrivacyAndSecurity$ru._(_root);
	@override late final _Translations$cloudPassword$ru cloudPassword = _Translations$cloudPassword$ru._(_root);
	@override late final _Translations$screenMyProfile$ru screenMyProfile = _Translations$screenMyProfile$ru._(_root);
	@override late final _Translations$screenProfile$ru screenProfile = _Translations$screenProfile$ru._(_root);
	@override late final _Translations$screenHideProfile$ru screenHideProfile = _Translations$screenHideProfile$ru._(_root);
	@override late final _Translations$screenContacts$ru screenContacts = _Translations$screenContacts$ru._(_root);
	@override late final _Translations$screenCalls$ru screenCalls = _Translations$screenCalls$ru._(_root);
	@override late final _Translations$screenAuth$ru screenAuth = _Translations$screenAuth$ru._(_root);
	@override late final _Translations$screenAuthModerationApplicationStore$ru screenAuthModerationApplicationStore = _Translations$screenAuthModerationApplicationStore$ru._(_root);
	@override late final _Translations$screenAuthCallpasswordConfirmation$ru screenAuthCallpasswordConfirmation = _Translations$screenAuthCallpasswordConfirmation$ru._(_root);
	@override late final _Translations$grpcError$ru grpcError = _Translations$grpcError$ru._(_root);
	@override late final _Translations$dateTime$ru dateTime = _Translations$dateTime$ru._(_root);
	@override late final _Translations$screenCall$ru screenCall = _Translations$screenCall$ru._(_root);
	@override late final _Translations$passkey$ru passkey = _Translations$passkey$ru._(_root);
	@override late final _Translations$yandex$ru yandex = _Translations$yandex$ru._(_root);
}

// Path: common
class _Translations$common$ru extends Translations$common$en {
	_Translations$common$ru._(TranslationsRu root) : this._root = root, super.internal(root);

	final TranslationsRu _root; // ignore: unused_field

	// Translations
	@override String get mobilePhone => 'Номер мобильного телефона';
	@override String get kContinue => 'Продолжить';
	@override String get ok => 'ОК';
	@override String get cancel => 'Отмена';
	@override String get notNow => 'Не сейчас';
	@override String get back => 'Назад';
	@override String get save => 'Сохранить';
	@override String get online => 'В сети';
	@override String get done => 'Готово';
	@override String get close => 'Закрыть';
	@override String get error => 'Ошибка';
	@override String get noConnectionTitle => 'Нет соединения с интернетом';
	@override String get noConnectionMessage => 'Проверьте подключение и попробуйте снова.';
	@override String get biometricAuthenticateReason => 'Пройдите аутентификацию для разблокировки';
	@override String get biometricPleaseEnterPasscode => 'Введите код-пароль';
	@override String get edit => 'Изменить';
}

// Path: componentsConnectionTitle
class _Translations$componentsConnectionTitle$ru extends Translations$componentsConnectionTitle$en {
	_Translations$componentsConnectionTitle$ru._(TranslationsRu root) : this._root = root, super.internal(root);

	final TranslationsRu _root; // ignore: unused_field

	// Translations
	@override String get waitingForNetwork => 'Ожидание сети';
	@override String get connecting => 'Подключение';
	@override String get updating => 'Обновление';
}

// Path: componentsCamera
class _Translations$componentsCamera$ru extends Translations$componentsCamera$en {
	_Translations$componentsCamera$ru._(TranslationsRu root) : this._root = root, super.internal(root);

	final TranslationsRu _root; // ignore: unused_field

	// Translations
	@override String get unavailable => 'Камера недоступна';
	@override String get accessDenied => 'Нет доступа к камере';
	@override String get openSettings => 'Открыть настройки';
	@override String get photo => 'Фото';
	@override String get video => 'Видео';
}

// Path: screenHome
class _Translations$screenHome$ru extends Translations$screenHome$en {
	_Translations$screenHome$ru._(TranslationsRu root) : this._root = root, super.internal(root);

	final TranslationsRu _root; // ignore: unused_field

	// Translations
	@override String get contacts => 'Контакты';
	@override String get calls => 'Звонки';
	@override String get chats => _root.screenChats.chats;
	@override String get settings => _root.screenSettings.settings;
}

// Path: screenChats
class _Translations$screenChats$ru extends Translations$screenChats$en {
	_Translations$screenChats$ru._(TranslationsRu root) : this._root = root, super.internal(root);

	final TranslationsRu _root; // ignore: unused_field

	// Translations
	@override String get chats => 'Чаты';
	@override String get notificationPermissionTitle => 'Включите уведомления';
	@override String get notificationPermissionMessage => 'Разрешите уведомления, чтобы узнавать о новых сообщениях и контактах, даже когда Iperon свёрнут.';
	@override String get allowAccess => 'Разрешить';
	@override String get allFolder => 'Все чаты';
	@override String get search => 'Поиск';
	@override String get empty => 'Чатов пока нет';
	@override String get emptyFolder => 'В этой папке пока нет чатов';
	@override String get emptyArchive => 'Архив пуст';
	@override String get archive => 'Архив';
	@override String get savedMessages => 'Избранное';
	@override String get draft => 'Черновик:';
	@override String get typing => 'печатает…';
	@override String typingName({required Object name}) => '${name} печатает…';
	@override String get photo => 'Фото';
	@override String get video => 'Видео';
	@override String get file => 'Файл';
	@override String get voice => 'Голосовое сообщение';
	@override String get pin => 'Закрепить';
	@override String get unpin => 'Открепить';
	@override String get markRead => 'Прочитано';
	@override String get markUnread => 'Непрочитано';
	@override String get mute => 'Выключить уведомления';
	@override String get unmute => 'Включить уведомления';
	@override String get muteTitle => 'Выключить уведомления';
	@override String get muteHour => 'На 1 час';
	@override String get mute8Hours => 'На 8 часов';
	@override String get mute2Days => 'На 2 дня';
	@override String get muteForever => 'Навсегда';
	@override String mutedUntil({required Object time}) => 'до ${time}';
	@override String get toArchive => 'В архив';
	@override String get fromArchive => 'Из архива';
	@override String get delete => 'Удалить';
	@override String get swipeRead => 'Прочитано';
	@override String get swipeUnread => 'Непрочитано';
	@override String get swipeMute => 'Выкл. звук';
	@override String get swipeUnmute => 'Вкл. звук';
	@override String get swipeArchive => 'Архив';
	@override String get swipeUnarchive => 'Вернуть';
	@override String get deleteChatTitle => 'Удалить чат?';
	@override String deleteChatMessage({required Object title}) => 'Чат «${title}» будет удалён из списка.';
	@override String get readAll => 'Прочитать все';
	@override String get deleteFolder => 'Удалить папку';
	@override String deleteFolderTitle({required Object title}) => 'Удалить папку «${title}»?';
	@override String get deleteFolderMessage => 'Чаты из папки не удаляются.';
	@override String get editFolder => 'Изменить папку';
	@override String get editFolders => 'Изменить папки';
	@override String get reorderFolders => 'Изменить порядок';
}

// Path: screenChatFolders
class _Translations$screenChatFolders$ru extends Translations$screenChatFolders$en {
	_Translations$screenChatFolders$ru._(TranslationsRu root) : this._root = root, super.internal(root);

	final TranslationsRu _root; // ignore: unused_field

	// Translations
	@override String get folders => 'Папки';
	@override String get intro => 'Создавайте папки для разных групп чатов и быстро переключайтесь между ними свайпом по списку.';
	@override String get myFolders => 'Мои папки';
	@override String get createFolder => 'Создать папку';
	@override String get allChatsSubtitle => 'Все ваши чаты';
	@override String reorderFooter({required Object n}) => 'Чтобы изменить порядок, перетащите папку за ≡. Можно создать до ${n} папок вместе с «Все чаты».';
	@override String limitReached({required Object n}) => 'Создано максимальное число папок — ${n}, вместе с «Все чаты». Удалите ненужную, чтобы добавить новую.';
	@override String get recommended => 'Рекомендованные папки';
	@override String get add => 'Добавить';
	@override String chatsCount({required num n}) => (_root.$meta.cardinalResolver ?? PluralResolvers.cardinal('ru'))(n,
		one: '${n} чат',
		few: '${n} чата',
		many: '${n} чатов',
		other: '${n} чата',
	);
	@override String get noChats => 'Нет чатов';
	@override String get presetUnread => 'Непрочитанные';
	@override String get presetUnreadAbout => 'Новые сообщения из всех чатов';
	@override String get presetPersonal => 'Личные';
	@override String get presetPersonalAbout => 'Сообщения только из личных чатов';
	@override String get presetGroups => 'Группы';
	@override String get presetGroupsAbout => 'Сообщения только из групп';
	@override String get presetChannels => 'Каналы';
	@override String get presetChannelsAbout => 'Сообщения только из каналов';
	@override String get newFolder => 'Новая папка';
	@override String get editFolder => 'Изменить папку';
	@override String get create => 'Создать';
	@override String get name => 'Название папки';
	@override String get included => 'Включённые чаты';
	@override String get includedFooter => 'Выберите чаты и типы чатов, которые будут в этой папке.';
	@override String get addChats => 'Добавить чаты';
	@override String get excluded => 'Исключённые чаты';
	@override String get excludedFooter => 'Выберите чаты и типы чатов, которые никогда не попадут в эту папку.';
	@override String get excludeChats => 'Исключить чаты';
	@override String get deleteFolder => 'Удалить папку';
	@override String get chatTypes => 'Типы чатов';
	@override String get chats => 'Чаты';
	@override String get contacts => 'Контакты';
	@override String get nonContacts => 'Не контакты';
	@override String get groups => 'Группы';
	@override String get channels => 'Каналы';
	@override String get communities => 'Сообщества';
	@override String get muted => 'Без уведомлений';
	@override String get read => 'Прочитанные';
	@override String get search => 'Поиск';
	@override String get nothingFound => 'Чатов не найдено';
	@override String selected({required Object n}) => 'Выбрано: ${n}';
	@override String get nameRequired => 'Введите название папки.';
	@override String get chatsRequired => 'Добавьте в папку хотя бы один чат или тип чатов.';
	@override String get discardTitle => 'Не сохранять изменения?';
	@override String get discardMessage => 'Изменения папки будут потеряны.';
	@override String get discard => 'Не сохранять';
}

// Path: screenNewChat
class _Translations$screenNewChat$ru extends Translations$screenNewChat$en {
	_Translations$screenNewChat$ru._(TranslationsRu root) : this._root = root, super.internal(root);

	final TranslationsRu _root; // ignore: unused_field

	// Translations
	@override String get title => 'Новое сообщение';
	@override String get search => 'Поиск';
	@override String get newGroup => 'Новая группа';
	@override String get newChannel => 'Новый канал';
	@override String get newCommunity => 'Новое сообщество';
	@override String get contacts => 'Контакты';
	@override String get noContacts => 'Контакты не найдены';
	@override String get addMembers => 'Добавить участников';
	@override String get next => 'Далее';
	@override String selected({required Object n}) => 'Выбрано: ${n}';
	@override String get noMembersHint => 'Группу можно создать без участников и пригласить их позже.';
	@override String get groupTitle => 'Новая группа';
	@override String get channelTitle => 'Новый канал';
	@override String get communityTitle => 'Новое сообщество';
	@override String get create => 'Создать';
	@override String get groupName => 'Название группы';
	@override String get channelName => 'Название канала';
	@override String get communityName => 'Название сообщества';
	@override String get description => 'Описание';
	@override String get descriptionHint => 'Необязательно';
	@override String get channelDescriptionFooter => 'Расскажите подписчикам, о чём канал.';
	@override String get communityDescriptionFooter => 'Расскажите об организации: чем занимаетесь, адрес, часы работы. Внутри сообщества будут канал объявлений и группы по темам.';
	@override String get members => 'Участники';
	@override String get setPhoto => 'Выбрать фото';
	@override String get changePhoto => 'Изменить фото';
	@override String get removePhoto => 'Удалить фото';
	@override String get cover => 'Обложка';
	@override String get setCover => 'Выбрать обложку';
	@override String get changeCover => 'Изменить обложку';
	@override String get removeCover => 'Удалить обложку';
	@override String get coverFooter => 'Фон шапки страницы сообщества — например, фото зала или витрины.';
	@override String get contactsHeader => 'Контакты';
	@override String get phone => 'Телефон';
	@override String get address => 'Адрес';
	@override String get latitude => 'Широта';
	@override String get latitudeHint => '55.650088';
	@override String get longitude => 'Долгота';
	@override String get longitudeHint => '37.606609';
	@override String get coordinatesFooter => 'По широте и долготе строится маршрут в Яндекс Картах и 2ГИС. В картах их можно скопировать, удерживая точку.';
	@override String get coordinatesInvalid => 'Нужны обе координаты числами: широта от −90 до 90, долгота от −180 до 180.';
	@override String get editPhoto => 'Фото';
	@override String get type => 'Тип';
	@override String get typePublic => 'Публичный';
	@override String get typePrivate => 'Частный';
	@override String get channelPublicFooter => 'Публичный канал можно найти в поиске, подписаться на него может любой.';
	@override String get channelPrivateFooter => 'На частный канал можно подписаться только по ссылке-приглашению.';
	@override String get communityPublicFooter => 'Публичное сообщество можно найти в поиске, вступить в него может любой.';
	@override String get communityPrivateFooter => 'В частное сообщество можно вступить только по ссылке-приглашению.';
	@override String get link => 'Ссылка';
	@override String get usernameHint => 'имя';
	@override String get usernameChecking => 'Проверка…';
	@override String get usernameAvailable => 'Ссылка свободна.';
	@override String get usernameTaken => 'Эта ссылка уже занята.';
	@override String get usernameInvalid => 'От 5 до 24 символов: латинские буквы a–z, цифры и _.';
	@override String get usernameEmpty => 'Придумайте ссылку, по которой его будут находить.';
	@override String get inviteLink => 'Ссылка-приглашение';
	@override String get inviteLinkFooter => 'По этой ссылке можно присоединиться. Нажмите, чтобы скопировать.';
	@override String get copied => 'Ссылка скопирована';
	@override String get commentsSwitch => 'Комментарии';
	@override String get commentsFooter => 'Подписчики смогут обсуждать каждый пост в комментариях.';
	@override String get commentsLimit => 'Срок комментирования';
	@override String get commentsLimitFooter => 'Сколько времени после публикации можно комментировать пост — дальше комментарии только читают. Действует на новые посты.';
	@override String get commentsLimitOff => 'Без ограничения';
	@override String commentsLimitHours({required num n}) => (_root.$meta.cardinalResolver ?? PluralResolvers.cardinal('ru'))(n,
		one: '${n} час',
		few: '${n} часа',
		many: '${n} часов',
		other: '${n} часа',
	);
	@override String commentsLimitDays({required num n}) => (_root.$meta.cardinalResolver ?? PluralResolvers.cardinal('ru'))(n,
		one: '${n} день',
		few: '${n} дня',
		many: '${n} дней',
		other: '${n} дня',
	);
	@override String get commentsLimitWeek => '1 неделя';
	@override String get commentsLimitMonth => '1 месяц';
	@override String get commentsLimitYear => '1 год';
	@override String get commentsWho => 'Кто может комментировать';
	@override String get commentsWhoAll => 'Все';
	@override String get commentsWhoSubscribers => 'Только подписчики';
	@override String get commentsMinSubscription => 'Подписка не менее';
	@override String get commentsWhoFooter => 'Не подписанные читают комментарии, но не пишут. Срок подписки защищает от спама: только что подписавшийся сможет комментировать, когда пройдёт выбранное время.';
	@override String get newcomerMedia => 'Новичкам — без ссылок и медиа';
	@override String get newcomerMediaOff => 'Выкл.';
	@override String get newcomerMediaFooterGroup => 'Вступившие меньше выбранного срока назад пишут только текст — без ссылок, фото, видео, файлов, голосовых и опросов: так спам-боты не сразу смогут рекламировать. На админов не действует.';
	@override String get newcomerMediaFooterChannel => 'Новички — не подписанные или подписанные меньше выбранного срока назад — пишут в комментариях только текст, без ссылок, фото, видео, файлов, голосовых и опросов.';
	@override String get signSwitch => 'Подписывать сообщения';
	@override String get signFooter => 'С подписями под постом видно имя админа, который его опубликовал.';
	@override String get hideMembers => 'Скрыть участников';
	@override String get hideSubscribers => 'Скрыть подписчиков';
	@override String get hideMembersFooter => 'Список будут видеть только админы.';
	@override String get joinHeader => 'Вступление';
	@override String get joinOpen => 'Открытое';
	@override String get joinLink => 'По ссылке';
	@override String get joinRequest => 'По заявке';
	@override String get joinAdmins => 'Добавляют админы';
	@override String get joinOpenFooter => 'Найти можно в поиске, вступить может любой.';
	@override String get joinLinkFooter => 'Вступить можно только по ссылке-приглашению.';
	@override String get joinRequestFooter => 'По ссылке-приглашению подаётся заявка — вступление после одобрения админом.';
	@override String get joinAdminsFooter => 'Вступить самостоятельно нельзя — участников добавляют админы.';
	@override String get defaultRoleHeader => 'Новые участники';
	@override String get roleReader => 'Только чтение';
	@override String get roleWriter => 'Чтение и сообщения';
	@override String get roleReaderFooter => 'Вступившие читают, но не могут писать.';
	@override String get roleWriterFooter => 'Вступившие могут читать и писать сообщения.';
	@override String get topicJoinOpen => 'Одним нажатием';
	@override String get topicJoinRequest => 'По заявке';
	@override String get topicJoinOpenFooter => 'Любой участник сообщества вступает одним нажатием.';
	@override String get topicJoinRequestFooter => 'Закрытая тема: участник сообщества подаёт заявку, вступление — после одобрения админом.';
	@override String get topicJoinHidden => 'Скрытая';
	@override String get topicJoinHiddenFooter => 'Группу видят только её участники и админы сообщества. Вступить самостоятельно нельзя — участников добавляют админы.';
}

// Path: screenChatInvites
class _Translations$screenChatInvites$ru extends Translations$screenChatInvites$en {
	_Translations$screenChatInvites$ru._(TranslationsRu root) : this._root = root, super.internal(root);

	final TranslationsRu _root; // ignore: unused_field

	// Translations
	@override String get inviteLinks => 'Ссылки-приглашения';
	@override String get joinRequests => 'Заявки на вступление';
	@override String get primaryLink => 'Основная ссылка';
	@override String get publicLink => 'Публичная ссылка';
	@override String get publicLinkFooter => 'Публичная ссылка меняется в «Изменить». Дополнительные ссылки ниже работают как приглашения.';
	@override String get primaryFooter => 'Любой, у кого есть ссылка, может вступить.';
	@override String get primaryFooterChannel => 'Любой, у кого есть ссылка, может подписаться.';
	@override String get primaryFooterRequest => 'По ссылке подаётся заявка на вступление — её одобряет админ.';
	@override String get adminsOnlyNote => 'Сейчас участников добавляют только админы — по ссылкам вступить нельзя. Способ вступления меняется в «Изменить».';
	@override String get copy => 'Копировать';
	@override String get share => 'Поделиться';
	@override String get replace => 'Заменить ссылку';
	@override String get replaceTitle => 'Заменить ссылку?';
	@override String get replaceMessage => 'Текущая ссылка перестанет работать, вместо неё появится новая.';
	@override String get copied => 'Ссылка скопирована';
	@override String get createLink => 'Создать ссылку';
	@override String get additionalHeader => 'Дополнительные ссылки';
	@override String get additionalFooter => 'Можно создать ссылки со сроком действия, лимитом вступлений или одобрением заявок.';
	@override String get revokedHeader => 'Отозванные ссылки';
	@override String get deleteAllRevoked => 'Удалить все отозванные';
	@override String joined({required Object n}) => 'Вступили: ${n}';
	@override String left({required Object n}) => 'осталось ${n}';
	@override String until({required Object date}) => 'до ${date}';
	@override String get expired => 'истекла';
	@override String get exhausted => 'лимит исчерпан';
	@override String get approval => 'по заявке';
	@override String get edit => 'Изменить';
	@override String get revoke => 'Отозвать';
	@override String get revokeTitle => 'Отозвать ссылку?';
	@override String get revokeMessage => 'По ней больше нельзя будет вступить.';
	@override String get delete => 'Удалить';
	@override String get newLink => 'Новая ссылка';
	@override String get editLink => 'Изменить ссылку';
	@override String get create => 'Создать';
	@override String get name => 'Название ссылки';
	@override String get nameHint => 'Необязательно';
	@override String get nameFooter => 'Название видно только админам.';
	@override String get approvalTitle => 'Одобрение админом';
	@override String get approvalFooter => 'Перешедшие по ссылке подают заявку, админ её принимает или отклоняет.';
	@override String get expireHeader => 'Срок действия';
	@override String get expireNever => 'Без ограничений';
	@override String get expireHour => '1 час';
	@override String get expireDay => '1 день';
	@override String get expireWeek => '1 неделя';
	@override String expireCurrent({required Object date}) => 'До ${date}';
	@override String get limitHeader => 'Лимит вступлений';
	@override String get limitNone => 'Без ограничений';
	@override String get limitFooter => 'Сколько человек может вступить по этой ссылке.';
	@override String get requestsEmpty => 'Заявок нет';
	@override String get requestsEmptyHint => 'Когда кто-то попросится вступить, заявка появится здесь.';
	@override String get approve => 'Принять';
	@override String get decline => 'Отклонить';
	@override String get approveAll => 'Принять все';
	@override String get declineAll => 'Отклонить все';
	@override String get all => 'Все';
	@override String viaLink({required Object title}) => 'по ссылке «${title}»';
	@override String get requestsOffHint => 'Заявки приходят, когда вступление «По заявке» или по ссылкам с одобрением админом.';
}

// Path: screenChatAdmins
class _Translations$screenChatAdmins$ru extends Translations$screenChatAdmins$en {
	_Translations$screenChatAdmins$ru._(TranslationsRu root) : this._root = root, super.internal(root);

	final TranslationsRu _root; // ignore: unused_field

	// Translations
	@override String get admins => 'Администраторы';
	@override String get addAdmin => 'Добавить админа';
	@override String get adminsFooter => 'Админы помогают управлять чатом. Права каждого настраиваются отдельно.';
	@override String get adminsFooterOfCommunity => 'Админы сообщества — админы и во всех его группах и каналах, с теми же правами.';
	@override String get addModerator => 'Добавить модератора';
	@override String get promoteModerator => 'Назначить модератором';
	@override String get moderatorRights => 'Права модератора';
	@override String get newModerator => 'Новый модератор';
	@override String get moderatorRankHint => 'модератор';
	@override String get moderatorRightsFooter => 'Модератор управляет только этим чатом: может ограничить или исключить участника, но блокировать в сообществе и назначать модераторов могут только админы сообщества.';
	@override String get dismissModerator => 'Снять модератора';
	@override String dismissModeratorTitle({required Object name}) => 'Снять ${name} с модераторов?';
	@override String get dismissModeratorMessage => 'Участник останется в чате без прав модератора.';
	@override String get adminsFooterCommunity => 'Владелец и админы сообщества управляют всеми его чатами — их права меняются в сообществе. Здесь можно назначить модераторов только этого чата.';
	@override String get promote => 'Назначить админом';
	@override String get adminRights => 'Права админа';
	@override String get newAdmin => 'Новый админ';
	@override String get rightsHeader => 'Что может этот админ';
	@override String get rightsFooterLimited => 'Можно выдать только те права, которые есть у вас.';
	@override String get changeInfo => 'Изменять профиль и настройки';
	@override String get postMessages => 'Публиковать посты';
	@override String get editMessages => 'Изменять чужие посты';
	@override String get deleteMessages => 'Удалять чужие сообщения';
	@override String get banUsers => 'Блокировать участников';
	@override String get inviteUsers => 'Приглашать по ссылкам';
	@override String get pinMessages => 'Закреплять сообщения';
	@override String get manageCalls => 'Управлять звонками';
	@override String get anonymous => 'Анонимность';
	@override String get addAdmins => 'Назначать админов';
	@override String get anonymousFooter => 'Сообщения анонимного админа подписываются названием группы.';
	@override String get rankHeader => 'Звание';
	@override String get rankHint => 'админ';
	@override String get rankFooter => 'Показывается в списке участников вместо «админ».';
	@override String get dismiss => 'Снять админа';
	@override String dismissTitle({required Object name}) => 'Снять ${name} с админов?';
	@override String get dismissMessage => 'Участник останется в чате без прав админа.';
	@override String get transfer => 'Передать владение';
	@override String transferTitle({required Object name}) => 'Передать владение ${name}?';
	@override String transferMessage({required Object name}) => '${name} станет владельцем, а вы — админом со всеми правами. Отменить это сможет только новый владелец.';
	@override String get pickMember => 'Выберите участника';
	@override String get noCandidates => 'Некого назначить — все участники уже админы.';
}

// Path: screenPoll
class _Translations$screenPoll$ru extends Translations$screenPoll$en {
	_Translations$screenPoll$ru._(TranslationsRu root) : this._root = root, super.internal(root);

	final TranslationsRu _root; // ignore: unused_field

	// Translations
	@override String get newPoll => 'Новый опрос';
	@override String get question => 'Вопрос';
	@override String get questionHint => 'Задайте вопрос';
	@override String get options => 'Варианты ответа';
	@override String get optionHint => 'Вариант';
	@override String get addOption => 'Добавить вариант';
	@override String get optionsFooter => 'Можно добавить до 10 вариантов.';
	@override String get quizOptionsFooter => 'Нажмите на кружок, чтобы отметить верный ответ.';
	@override String get settings => 'Настройки';
	@override String get anonymous => 'Анонимное голосование';
	@override String get multiple => 'Несколько ответов';
	@override String get quiz => 'Режим викторины';
	@override String get quizFooter => 'У викторины один верный ответ. После ответа участник увидит пояснение.';
	@override String get channelFooter => 'В канале голосование всегда анонимное.';
	@override String get explanation => 'Пояснение';
	@override String get explanationHint => 'Покажется после ответа (необязательно)';
	@override String get create => 'Создать';
}

// Path: screenChat
class _Translations$screenChat$ru extends Translations$screenChat$en {
	_Translations$screenChat$ru._(TranslationsRu root) : this._root = root, super.internal(root);

	final TranslationsRu _root; // ignore: unused_field

	// Translations
	@override String get today => 'Сегодня';
	@override String get yesterday => 'Вчера';
	@override String get online => 'в сети';
	@override String get lastSeenRecently => 'был(а) недавно';
	@override String members({required num n, required Object count}) => (_root.$meta.cardinalResolver ?? PluralResolvers.cardinal('ru'))(n,
		one: '${count} участник',
		few: '${count} участника',
		many: '${count} участников',
		other: '${count} участника',
	);
	@override String subscribers({required num n, required Object count}) => (_root.$meta.cardinalResolver ?? PluralResolvers.cardinal('ru'))(n,
		one: '${count} подписчик',
		few: '${count} подписчика',
		many: '${count} подписчиков',
		other: '${count} подписчика',
	);
	@override String comments({required num n, required Object count}) => (_root.$meta.cardinalResolver ?? PluralResolvers.cardinal('ru'))(n,
		one: '${count} комментарий',
		few: '${count} комментария',
		many: '${count} комментариев',
		other: '${count} комментария',
	);
	@override String get leaveComment => 'Прокомментировать';
	@override String get commentsTitle => 'Комментарии';
	@override String get commentsClosed => 'Комментарии закрыты';
	@override String get commentsSubscribe => 'Подписаться, чтобы комментировать';
	@override String commentsWaitUntil({required Object time}) => 'Комментировать можно с ${time}';
	@override String get newcomerTitle => 'Только текст';
	@override String newcomerWaitUntil({required Object time}) => 'Ссылки, медиа, файлы и голосовые новичкам можно отправлять с ${time}.';
	@override String get newcomerSubscribe => 'Ссылки, медиа, файлы и голосовые в комментариях могут отправлять только подписчики.';
	@override String get closeComments => 'Закрыть комментарии';
	@override String get openComments => 'Открыть комментарии';
	@override String get closeCommentsTitle => 'Закрыть комментарии?';
	@override String get closeCommentsMessage => 'Комментировать пост больше будет нельзя, оставленные комментарии останутся.';
	@override String get subscribe => 'Подписаться';
	@override String get joinGroup => 'Вступить в группу';
	@override String get requestJoin => 'Подать заявку';
	@override String get requestSent => 'Заявка отправлена';
	@override String get linkInvalid => 'Ссылка недействительна или устарела.';
	@override String get poll => 'Опрос';
	@override String get quiz => 'Викторина';
	@override String get anonymousPoll => 'Анонимный опрос';
	@override String get publicPoll => 'Открытый опрос';
	@override String get anonymousQuiz => 'Анонимная викторина';
	@override String get publicQuiz => 'Викторина';
	@override String votes({required num n, required Object count}) => (_root.$meta.cardinalResolver ?? PluralResolvers.cardinal('ru'))(n,
		one: '${count} голос',
		few: '${count} голоса',
		many: '${count} голосов',
		other: '${count} голоса',
	);
	@override String get noVotes => 'Голосов пока нет';
	@override String get vote => 'Голосовать';
	@override String get pollClosed => 'Итоги';
	@override String get retractVote => 'Отменить голос';
	@override String get closePoll => 'Завершить опрос';
	@override String get closePollTitle => 'Завершить опрос?';
	@override String get closePollMessage => 'Голосовать больше будет нельзя, все увидят итоги.';
	@override String get pollVoters => 'Голоса';
	@override String get read => 'Прочитано';
	@override String readAt({required Object date}) => 'Прочитано ${date}';
	@override String readBy({required Object count}) => 'Прочитали: ${count}';
	@override String get readByTitle => 'Прочитали';
	@override String get message => 'Сообщение';
	@override String get empty => 'Сообщений пока нет';
	@override String get notFound => 'Чат не найден';
	@override String get reply => 'Ответить';
	@override String get quote => 'Цитировать';
	@override String replyQuoteTo({required Object name}) => 'Цитата · ${name}';
	@override String get copy => 'Копировать';
	@override String get copied => 'Скопировано';
	@override String get edit => 'Изменить';
	@override String get editing => 'Редактирование';
	@override String get edited => 'изм.';
	@override String get delete => 'Удалить';
	@override String get deleteTitle => 'Удалить сообщение?';
	@override String get deleteMessage => 'Сообщение будет удалено у всех участников чата.';
	@override String get you => 'Вы';
	@override String get mute => 'Выключить звук';
	@override String get unmute => 'Включить звук';
	@override String get photo => _root.screenChats.photo;
	@override String get video => _root.screenChats.video;
	@override String get file => _root.screenChats.file;
	@override String get voice => _root.screenChats.voice;
	@override String selected({required Object n}) => 'Выбрано: ${n}';
	@override String get search => 'Поиск';
	@override String get searchNoResults => 'Нет результатов';
	@override String get unreadMessages => 'Непрочитанные сообщения';
	@override String get select => 'Выбрать';
	@override String get videoCompressing => 'Сжатие видео';
	@override String get pin => 'Закрепить';
	@override String get unpin => 'Открепить';
	@override String get pinnedTitle => 'Закреплённое сообщение';
	@override String pinnedNumber({required Object n}) => 'Закреплённое сообщение #${n}';
	@override String get unpinTitle => 'Открепить сообщение?';
	@override String pinnedServiceYou({required Object text}) => 'Вы закрепили «${text}»';
	@override String get pinnedServiceYouMessage => 'Вы закрепили сообщение';
	@override String pinnedService({required Object name, required Object text}) => '${name} закрепил(а) «${text}»';
	@override String pinnedServiceMessage({required Object name}) => '${name} закрепил(а) сообщение';
	@override String pinnedList({required num n}) => (_root.$meta.cardinalResolver ?? PluralResolvers.cardinal('ru'))(n,
		one: '${n} закреплённое сообщение',
		few: '${n} закреплённых сообщения',
		many: '${n} закреплённых сообщений',
		other: '${n} закреплённых сообщения',
	);
	@override String get pinnedAll => 'Все закреплённые';
	@override String get unpinAll => 'Открепить все сообщения';
	@override String unpinAllTitle({required num n}) => (_root.$meta.cardinalResolver ?? PluralResolvers.cardinal('ru'))(n,
		one: 'Открепить ${n} сообщение?',
		few: 'Открепить все ${n} сообщения?',
		many: 'Открепить все ${n} сообщений?',
		other: 'Открепить все ${n} сообщения?',
	);
	@override String get goToMessage => 'Перейти к сообщению';
	@override String get sendSilent => 'Отправить без звука';
	@override String get sendLater => 'Отправить позже';
	@override String get slowMode => 'Медленный режим';
	@override String slowModeWait({required Object time}) => 'В этом чате включён медленный режим. Следующее сообщение можно отправить через ${time}.';
	@override String get floodTitle => 'Слишком часто';
	@override String floodWait({required Object time}) => 'Вы отправляете сообщения слишком часто. Следующее можно отправить через ${time}.';
	@override String floodNewChats({required Object time}) => 'Вы начинаете новые чаты слишком часто. Попробуйте через ${time}.';
	@override String get slowModeOneMessage => 'В медленном режиме можно отправить только одно сообщение за раз.';
	@override String get scheduledTitle => 'Отложенные сообщения';
	@override String get schedule => 'Запланировать';
	@override String get sendNow => 'Отправить сейчас';
	@override String get reschedule => 'Изменить время';
	@override String get deleteScheduledTitle => 'Удалить отложенное сообщение?';
	@override String get scheduledHint => 'Отложенные сообщения';
	@override String get linkPreview => 'Предпросмотр ссылки';
	@override String get forward => 'Переслать';
	@override String get forwardTo => 'Переслать в…';
	@override String forwardedFrom({required Object name}) => 'Переслано от ${name}';
	@override String forwardFrom({required Object names}) => 'От: ${names}';
	@override String forwardMessages({required num n}) => (_root.$meta.cardinalResolver ?? PluralResolvers.cardinal('ru'))(n,
		one: 'Переслать ${n} сообщение',
		few: 'Переслать ${n} сообщения',
		many: 'Переслать ${n} сообщений',
		other: 'Переслать ${n} сообщения',
	);
	@override String deleteSelectedTitle({required num n}) => (_root.$meta.cardinalResolver ?? PluralResolvers.cardinal('ru'))(n,
		one: 'Удалить ${n} сообщение?',
		few: 'Удалить ${n} сообщения?',
		many: 'Удалить ${n} сообщений?',
		other: 'Удалить ${n} сообщения?',
	);
	@override String get deleteSelectedMessage => 'Сообщения будут удалены у всех участников чата.';
	@override String deleteForBoth({required Object name}) => 'Удалить у меня и у ${name}';
	@override String get deleteForMe => 'Удалить только у меня';
	@override String deleteAlsoFor({required Object name}) => 'Также удалить для ${name}';
	@override String get deleteMessageSelf => 'Сообщение будет удалено из «Избранного».';
	@override String get deleteSelectedMessageSelf => 'Сообщения будут удалены из «Избранного».';
	@override String get voiceSlideToCancel => 'Влево — отмена';
	@override String get voiceHoldHint => 'Удерживайте, чтобы записать';
	@override String get micDeniedTitle => 'Нет доступа к микрофону';
	@override String get micDeniedMessage => 'Разрешите доступ к микрофону в настройках, чтобы записывать голосовые сообщения.';
	@override String get openSettings => 'Настройки';
	@override String get hideWithSpoiler => 'Скрыть под спойлер';
	@override String get removeSpoiler => 'Убрать спойлер';
	@override String get videoHdOn => 'Видео в HD: 1080p';
	@override String get videoHdOff => 'Стандартное качество: 720p';
	@override String get videoSound => 'Звук';
	@override String get videoMuted => 'Без звука';
	@override String get videoCover => 'Обложка';
	@override String get videoCoverSet => 'Обложка выбрана';
	@override String get videoReset => 'Сбросить';
	@override String get videoCrop => 'Кадрировать';
	@override String get videoRotate => 'Повернуть';
	@override String get videoAspectFree => 'Свободно';
	@override String get videoAspectOriginal => 'Исходное';
	@override String get videoAspectSquare => 'Квадрат';
	@override String get videoEditFailed => 'Не удалось открыть видео';
	@override String get format => 'Форматирование';
	@override String get formatBold => 'Жирный';
	@override String get formatItalic => 'Курсив';
	@override String get formatStrike => 'Зачёркнутый';
	@override String get formatSpoiler => 'Спойлер';
	@override String get formatCode => 'Моноширинный';
	@override String get formatLink => 'Ссылка';
	@override String get formatQuote => 'Цитата';
	@override String get formatPlain => 'Обычный';
	@override String get formatUnderline => 'Подчёркнутый';
	@override String get formatPre => 'Блок кода';
	@override String get formatMention => 'Упомянуть';
	@override String get formatQuoteExpandable => 'Сворачиваемая цитата';
	@override String get mentionPickTitle => 'Кого упомянуть';
	@override String get linkTitle => 'Добавить ссылку';
	@override String get linkAdd => 'Добавить';
	@override String uploadProgress({required Object done, required Object total}) => '${done} из ${total}';
	@override String get kb => 'КБ';
	@override String get mb => 'МБ';
	@override String get gb => 'ГБ';
	@override String mediaCounter({required Object current, required Object total}) => '${current} из ${total}';
	@override String get addCaption => 'Добавить подпись…';
}

// Path: screenSettings
class _Translations$screenSettings$ru extends Translations$screenSettings$en {
	_Translations$screenSettings$ru._(TranslationsRu root) : this._root = root, super.internal(root);

	final TranslationsRu _root; // ignore: unused_field

	// Translations
	@override String get settings => 'Настройки';
	@override String get myProfile => 'Мой профиль';
	@override String get devices => _root.screenSettingsDevices.devices;
	@override String get language => 'Язык';
	@override String get appearance => _root.screenSettingsAppearance.appearance;
	@override String get folders => _root.screenChatFolders.folders;
	@override String get notifications => _root.screenSettingsNotifications.notifications;
	@override String get privacyAndSecurity => 'Конфиденциальность';
	@override String get aboutApplication => 'О приложении';
	@override String get logs => 'Логи';
	@override String get logout => 'Выйти';
}

// Path: screenSettingsNotifications
class _Translations$screenSettingsNotifications$ru extends Translations$screenSettingsNotifications$en {
	_Translations$screenSettingsNotifications$ru._(TranslationsRu root) : this._root = root, super.internal(root);

	final TranslationsRu _root; // ignore: unused_field

	// Translations
	@override String get notifications => 'Уведомления и звуки';
	@override String get messageNotifications => 'Уведомления о сообщениях';
	@override String get privateChats => 'Личные чаты';
	@override String get groups => 'Группы';
	@override String get channels => 'Каналы';
	@override String get on => 'Вкл.';
	@override String get off => 'Выкл.';
	@override String get events => 'События';
	@override String get contactJoined => 'Контакт присоединился к Iperon';
	@override String get missedCalls => 'Пропущенные звонки';
	@override String get reactions => 'Реакции';
	@override String get reactionsPrivate => 'В личных чатах';
	@override String get reactionsGroups => 'В группах';
	@override String get reactionsFrom => 'Уведомлять о реакциях от';
	@override String get reactionsFromShort => 'От кого';
	@override String get reactionsFromAll => 'Всех';
	@override String get reactionsFromContacts => 'Моих контактов';
	@override String get reactionsNote => 'Уведомления о реакциях на ваши сообщения. В каналах реакции анонимные — о них не уведомляем.';
	@override String get showNotifications => 'Показывать уведомления';
	@override String get messagePreview => 'Предпросмотр сообщений';
	@override String get sound => 'Звук';
	@override String get messagePreviewNote => 'Без предпросмотра в уведомлении видно только, от кого сообщение.';
	@override String get settingsSyncNote => 'Настройки действуют на всех ваших устройствах.';
	@override String get permissionMissingTitle => 'Уведомления выключены';
	@override String get permissionMissingMessage => 'Iperon не может показывать уведомления на этом устройстве — настройки ниже не сработают.';
	@override String get enable => 'Включить';
	@override String get loadError => 'Не удалось загрузить настройки';
	@override String get offlineNote => 'Нет соединения. Изменение станет доступно, когда появится сеть.';
	@override String get retry => 'Повторить';
}

// Path: screenDeveloper
class _Translations$screenDeveloper$ru extends Translations$screenDeveloper$en {
	_Translations$screenDeveloper$ru._(TranslationsRu root) : this._root = root, super.internal(root);

	final TranslationsRu _root; // ignore: unused_field

	// Translations
	@override String get developer => 'Разработчик';
	@override String get logs => _root.screenSettings.logs;
	@override String get exportLogs => 'Экспорт логов';
	@override String get callPreview => 'Превью экрана звонка';
	@override String get chatsDemo => 'Демо чатов';
	@override String get chatsServer => 'Серверные чаты';
	@override String get testPush => 'Тестовое уведомление';
	@override String testPushSent({required Object apns, required Object fcm, required Object failed}) => 'Отправлено: APNs — ${apns}, FCM — ${fcm}, ошибок — ${failed}. Сверните приложение или заблокируйте экран, чтобы проверить доставку в фоне.';
	@override String get testPushNoTokens => 'Ни у одного вашего устройства нет push-токена. Проверьте, что уведомления разрешены, и перезапустите приложение.';
	@override String testPushError({required Object error}) => 'Не удалось отправить: ${error}';
	@override String get testPushEncrypted => 'Тестовое уведомление (шифрованное)';
	@override String get testPushQueued => 'Поставлено в очередь сервера. На Android придёт «Шифрованное тестовое уведомление: расшифровка работает», на iPhone пока — «Новое уведомление» (расшифровка на iOS появится позже).';
}

// Path: screenSettingsAppearance
class _Translations$screenSettingsAppearance$ru extends Translations$screenSettingsAppearance$en {
	_Translations$screenSettingsAppearance$ru._(TranslationsRu root) : this._root = root, super.internal(root);

	final TranslationsRu _root; // ignore: unused_field

	// Translations
	@override String get appearance => 'Оформление';
	@override String get colorTheme => 'Цветовая тема';
	@override String get colorThemeDefault => 'По умолчанию';
	@override String get colorThemeGreen => 'Зелёная';
	@override String get colorThemePurple => 'Фиолетовая';
	@override String get colorThemeOrange => 'Оранжевая';
	@override String get darkMode => 'Тёмная тема';
	@override String get darkModeSystem => 'Системная';
	@override String get darkModeAlwaysOn => 'Всегда включена';
	@override String get darkModeDisabled => 'Отключена';
	@override String get darkModeSystemDescription => 'Как в настройках устройства';
	@override String get darkModeAlwaysOnDescription => 'Тёмная тема всегда включена';
	@override String get darkModeDisabledDescription => 'Тёмная тема отключена';
	@override String get blurOnInactive => 'Размытие в неактивном состоянии';
	@override String get blurOnInactiveDescription => 'Приложение отображается размытым в списке открытых приложений';
	@override String get chatThemes => 'Темы для чатов';
	@override String get quickReaction => 'Быстрая реакция';
	@override String get quickReactionDescription => 'Ставится двойным тапом по сообщению';
}

// Path: screenChatInfo
class _Translations$screenChatInfo$ru extends Translations$screenChatInfo$en {
	_Translations$screenChatInfo$ru._(TranslationsRu root) : this._root = root, super.internal(root);

	final TranslationsRu _root; // ignore: unused_field

	// Translations
	@override String get call => 'Звонок';
	@override String get video => 'Видео';
	@override String get mute => 'Выкл. звук';
	@override String get unmute => 'Вкл. звук';
	@override String get sound => 'Звук';
	@override String get search => 'Поиск';
	@override String get about => 'О себе';
	@override String get description => 'Описание';
	@override String get username => 'Имя пользователя';
	@override String get link => 'Ссылка';
	@override String get tabMembers => 'Участники';
	@override String get tabSubscribers => 'Подписчики';
	@override String get tabMedia => 'Медиа';
	@override String get tabFiles => 'Файлы';
	@override String get tabLinks => 'Ссылки';
	@override String get tabVoice => 'Голосовые';
	@override String get emptyMedia => 'Здесь будут фото и видео из чата';
	@override String get emptyFiles => 'Здесь будут файлы из чата';
	@override String get emptyLinks => 'Здесь будут ссылки из чата';
	@override String get emptyVoice => 'Здесь будут голосовые сообщения';
	@override String get roleOwner => 'владелец';
	@override String get roleAdmin => 'админ';
	@override String get roleReader => 'только чтение';
	@override String get roleCommunityOwner => 'владелец сообщества';
	@override String get roleCommunityAdmin => 'админ сообщества';
	@override String get roleModerator => 'модератор';
	@override String get membersSearch => 'Имя или @username';
	@override String get membersNotFound => 'Никого не найдено';
	@override String get membersSearchNote => 'По имени ищутся админы, недавно активные и ваши контакты, остальные — по @username.';
	@override String get membersHiddenNote => 'Список участников видят только админы.';
	@override String get communityDefaults => 'Как в сообществе';
	@override String communityDefaultsOwn({required Object list}) => 'Свои: ${list}';
	@override String get communityDefaultsTitle => 'Вернуть настройки сообщества?';
	@override String get communityDefaultsMessage => 'Права новых участников, медленный режим, реакции и ограничения для новичков снова будут как в сообществе и будут меняться вместе с ним.';
	@override String get communityDefaultsReset => 'Вернуть';
	@override String get inheritedDefaultRole => 'права новых участников';
	@override String get inheritedSlowMode => 'медленный режим';
	@override String get inheritedReactions => 'реакции';
	@override String get inheritedNewcomer => 'ограничения для новичков';
	@override String get you => 'Вы';
	@override String get addMembers => 'Добавить участников';
	@override String get add => 'Добавить';
	@override String get sendMessage => 'Написать сообщение';
	@override String get allowWriting => 'Разрешить писать';
	@override String get makeReadOnly => 'Только чтение';
	@override String get removeMember => 'Исключить';
	@override String removeMemberTitle({required Object name}) => 'Исключить ${name}?';
	@override String get removeMemberMessage => 'Вернуться можно будет по ссылке-приглашению.';
	@override String get banMember => 'Заблокировать';
	@override String banMemberTitle({required Object name}) => 'Заблокировать ${name}?';
	@override String get banMemberMessage => 'Участник будет исключён и не сможет вернуться по ссылкам-приглашениям, пока его не разблокируют.';
	@override String get removeInCommunityMessage => 'Участник останется в сообществе и сможет вступить в чат снова.';
	@override String banInCommunityTitle({required Object name}) => 'Заблокировать ${name} в сообществе?';
	@override String get banInCommunityMessage => 'Участник будет исключён из сообщества и всех его чатов и не сможет вернуться, пока его не разблокируют.';
	@override String get banned => 'Заблокированные';
	@override String get bannedEmpty => 'Заблокированных нет';
	@override String get bannedFooter => 'Заблокированные не могут вступить по ссылкам-приглашениям. Если добавить вручную — блокировка снимется.';
	@override String get unban => 'Разблокировать';
	@override String get reactions => 'Реакции';
	@override String get reactionsAll => 'Все реакции';
	@override String get reactionsSome => 'Некоторые';
	@override String get reactionsNone => 'Нет реакций';
	@override String get reactionsAllShort => 'Все';
	@override String get reactionsNoneShort => 'Выкл.';
	@override String get reactionsFooter => 'Какие реакции участники могут ставить на сообщения. Уже поставленные реакции останутся.';
	@override String get reactionsPick => 'Разрешённые реакции';
	@override String get maxReactions => 'Максимум реакций под постом';
	@override String get maxReactionsFooter => 'Сколько разных реакций может быть под одним постом, в том числе под уже опубликованными. Когда лимит набран, можно ставить только те реакции, что уже есть под постом.';
	@override String get slowMode => 'Медленный режим';
	@override String get slowModeOff => 'Выкл.';
	@override String slowModeSeconds({required Object n}) => '${n} с';
	@override String slowModeMinutes({required Object n}) => '${n} мин';
	@override String slowModeHours({required Object n}) => '${n} ч';
	@override String get slowModeFooter => 'Участники смогут отправлять не больше одного сообщения за выбранный интервал. На админов ограничение не действует.';
	@override String get deleteChat => 'Удалить чат';
	@override String get leaveGroup => 'Покинуть группу';
	@override String get leaveChannel => 'Покинуть канал';
	@override String get leaveCommunity => 'Покинуть сообщество';
	@override String get leaveShort => 'Покинуть';
	@override String deleteChatTitle({required Object name}) => 'Удалить чат с ${name}?';
	@override String leaveGroupTitle({required Object name}) => 'Покинуть «${name}»?';
	@override String get deleteGroup => 'Удалить группу';
	@override String get deleteChannel => 'Удалить канал';
	@override String get deleteCommunity => 'Удалить сообщество';
	@override String get deleteShort => 'Удалить';
	@override String deleteInCommunityTitle({required Object name}) => 'Удалить «${name}»?';
	@override String get deleteInCommunityMessage => 'Чат удалится у всех участников сообщества.';
	@override String get deleteCommunityMessage => 'Сообщество удалится вместе со всеми его группами и каналами.';
	@override String get communityChats => 'Чаты';
	@override String get communityChatsFooter => 'Участники сообщества вступают в группы и каналы одним нажатием, в закрытые темы — по заявке.';
	@override String get announcements => 'Объявления';
	@override String get closedTopic => 'По заявке';
	@override String get hiddenTopic => 'Скрытая';
	@override String get createGroup => 'Создать группу';
	@override String get createChannel => 'Создать канал';
	@override String get join => 'Вступить';
	@override String get requestPending => 'Ждёт';
	@override String get joinCommunity => 'Вступить в сообщество';
	@override String get phone => 'Телефон';
	@override String get address => 'Адрес';
	@override String get route => 'Маршрут';
	@override String get routeYandex => 'Яндекс Карты';
	@override String get route2gis => '2ГИС';
	@override String lastSeenMinutes({required Object n}) => 'был(а) ${n} мин. назад';
	@override String lastSeenAt({required Object time}) => 'был(а) в ${time}';
	@override String lastSeenYesterday({required Object time}) => 'был(а) вчера в ${time}';
	@override String lastSeenDate({required Object date}) => 'был(а) ${date}';
}

// Path: screenChatThemes
class _Translations$screenChatThemes$ru extends Translations$screenChatThemes$en {
	_Translations$screenChatThemes$ru._(TranslationsRu root) : this._root = root, super.internal(root);

	final TranslationsRu _root; // ignore: unused_field

	// Translations
	@override String get title => _root.screenSettingsAppearance.chatThemes;
	@override String get pattern => 'Узор';
	@override String get intensity => 'Интенсивность узора';
	@override String get color => 'Цвет';
	@override String get footer => 'Обои показываются во всех чатах на этом устройстве и сами подстраиваются под светлую и тёмную тему.';
	@override String get previewName => 'Анна';
	@override String get previewIncoming => 'Привет! Как тебе новые обои? 🎨';
	@override String get previewOutgoing => 'Отлично смотрятся, оставлю эти 😍';
	@override String get patternChat => 'Общение';
	@override String get patternSpace => 'Космос';
	@override String get patternNature => 'Природа';
	@override String get patternMusic => 'Музыка';
	@override String get patternGeometry => 'Геометрия';
	@override String get patternFood => 'Еда';
}

// Path: screenSettingsDevices
class _Translations$screenSettingsDevices$ru extends Translations$screenSettingsDevices$en {
	_Translations$screenSettingsDevices$ru._(TranslationsRu root) : this._root = root, super.internal(root);

	final TranslationsRu _root; // ignore: unused_field

	// Translations
	@override String get devices => 'Устройства';
	@override String get thisDevice => 'Это устройство';
	@override String deviceSessionListTileSubtitle({required Object location, required Object updateAt}) => '${location} · ${updateAt}';
	@override String get terminateAllOtherDeviceSessions => 'Завершить все другие сеансы';
	@override String get activeDeviceSession => 'Активные сеансы';
	@override String get terminateDeviceSession => 'Завершить сеанс';
	@override String get areYouSureYouLogOutFromThisDevice => 'Вы уверены, что хотите выйти на этом устройстве?';
	@override String get cancel => _root.common.cancel;
	@override String get online => _root.common.online;
	@override String get terminate => 'Завершить';
}

// Path: screenSettingsAboutApplication
class _Translations$screenSettingsAboutApplication$ru extends Translations$screenSettingsAboutApplication$en {
	_Translations$screenSettingsAboutApplication$ru._(TranslationsRu root) : this._root = root, super.internal(root);

	final TranslationsRu _root; // ignore: unused_field

	// Translations
	@override String get aboutApplication => _root.screenSettings.aboutApplication;
	@override String version({required Object version, required Object build}) => 'Версия ${version} (${build})';
	@override String get licenses => 'Лицензии';
	@override String licensesCount({required Object n}) => 'Лицензий: ${n}';
	@override String get noLicenses => 'Лицензии не найдены';
}

// Path: screenSettingsLanguage
class _Translations$screenSettingsLanguage$ru extends Translations$screenSettingsLanguage$en {
	_Translations$screenSettingsLanguage$ru._(TranslationsRu root) : this._root = root, super.internal(root);

	final TranslationsRu _root; // ignore: unused_field

	// Translations
	@override String get language => 'Язык';
}

// Path: screenSettingsPasscode
class _Translations$screenSettingsPasscode$ru extends Translations$screenSettingsPasscode$en {
	_Translations$screenSettingsPasscode$ru._(TranslationsRu root) : this._root = root, super.internal(root);

	final TranslationsRu _root; // ignore: unused_field

	// Translations
	@override String get passcode => 'Код-пароль';
	@override String get passcodeAndFaceID => 'Код-пароль и Face ID';
	@override String get passcodeAndBiometric => 'Код-пароль и биометрия';
	@override String get note => 'Примечание: если вы забудете код-пароль, потребуется переустановить приложение';
	@override String get turnOn => 'Включить код-пароль';
	@override String get turnOff => 'Отключить код-пароль';
	@override String get change => 'Изменить код-пароль';
	@override String get autoLock => 'Автоблокировка';
	@override String get faceIDUnlock => 'Разблокировка с Face ID';
	@override String get biometricUnlock => 'Разблокировка по биометрии';
	@override String get autoLockOff => 'Выключена';
	@override String autoLockMinutes({required num n}) => (_root.$meta.cardinalResolver ?? PluralResolvers.cardinal('ru'))(n,
		one: 'Через ${n} минуту',
		other: 'Через ${n} минут',
	);
	@override String autoLockHours({required num n}) => (_root.$meta.cardinalResolver ?? PluralResolvers.cardinal('ru'))(n,
		one: 'Через ${n} час',
		other: 'Через ${n} часов',
	);
	@override String get pleaseEnterPasscode => 'Введите код-пароль';
	@override String get cancel => _root.common.cancel;
}

// Path: settingsPasscodeCreate
class _Translations$settingsPasscodeCreate$ru extends Translations$settingsPasscodeCreate$en {
	_Translations$settingsPasscodeCreate$ru._(TranslationsRu root) : this._root = root, super.internal(root);

	final TranslationsRu _root; // ignore: unused_field

	// Translations
	@override String get pleaseEnterNewPasscode => 'Введите новый код-пароль';
	@override String get pleaseEnterNewPasscodeAgain => 'Введите новый код-пароль ещё раз';
	@override String get cancel => _root.common.cancel;
}

// Path: sessionsPrivacyAndSecurity
class _Translations$sessionsPrivacyAndSecurity$ru extends Translations$sessionsPrivacyAndSecurity$en {
	_Translations$sessionsPrivacyAndSecurity$ru._(TranslationsRu root) : this._root = root, super.internal(root);

	final TranslationsRu _root; // ignore: unused_field

	// Translations
	@override String get privacyAndSecurity => 'Конфиденциальность';
	@override String get passcodeAndFaceID => 'Код-пароль и Face ID';
	@override String get passcodeAndBiometric => 'Код-пароль и биометрия';
	@override String get passcode => 'Код-пароль';
	@override String get cloudPassword => 'Облачный пароль';
	@override String get passkeys => 'Ключи доступа';
	@override String get whoCanCall => 'Кто может звонить';
	@override String get calls => 'Звонки';
	@override String get callsEverybody => 'Все';
	@override String get callsContacts => 'Мои контакты';
	@override String get callsNobody => 'Никто';
	@override String get callsLoadError => 'Не удалось загрузить настройку';
	@override String get callsOfflineNote => 'Нет соединения. Изменение станет доступно, когда появится сеть.';
	@override String get retry => 'Повторить';
	@override String get exceptions => 'Исключения';
	@override String get callsAlwaysAllow => 'Всегда разрешать';
	@override String get callsAlwaysDeny => 'Всегда запрещать';
	@override String get callsAllowEmpty => 'Нет контактов, зарегистрированных в Iperon';
	@override String get callsEncryption => 'Сквозное шифрование';
	@override String get callsEncryptionNote => 'Голос и видео шифруются на устройствах собеседников — сервер не может их расшифровать. Работает, если сквозное шифрование включено у обоих; иначе звонок идёт без него.';
	@override String get birthday => 'День рождения';
	@override String get whoCanSeeBirthday => 'Кто может видеть мой день рождения';
	@override String get hideBirthYear => 'Скрывать год рождения';
	@override String get hideBirthYearNote => 'Контакты увидят только день и месяц — без года рождения и возраста.';
	@override String get aboutMe => 'О себе';
	@override String get whoCanSeeAboutMe => 'Кто может видеть моё «О себе»';
	@override String get lastSeen => 'Время захода';
	@override String get whoCanSeeLastSeen => 'Кто может видеть время моего захода';
	@override String get lastSeenReciprocityNote => 'Если выбрано «Никто», вы тоже не будете видеть время захода и статус других.';
}

// Path: cloudPassword
class _Translations$cloudPassword$ru extends Translations$cloudPassword$en {
	_Translations$cloudPassword$ru._(TranslationsRu root) : this._root = root, super.internal(root);

	final TranslationsRu _root; // ignore: unused_field

	// Translations
	@override String get title => 'Облачный пароль';
	@override String get description => 'Дополнительный пароль, будет запрашивается при входе с нового устройства. Укажите email чтобы восстановить доступ, если забудете пароль.';
	@override String get enterPasswordHint => 'Введите облачный пароль';
	@override String get unlockInfo => 'Включена двухэтапная авторизация. Ваш аккаунт защищён дополнительным паролем.';
	@override String get setupEmailHint => 'Укажите email, чтобы восстановить доступ, если забудете облачный пароль.';
	@override String get setupPasswordHint => 'Теперь задайте облачный пароль. Его спросят при входе на новом устройстве.';
	@override String get changePasswordHint => 'Введите новый облачный пароль.';
	@override String get enableButton => 'Включить';
	@override String get passwordPlaceholder => 'Облачный пароль';
	@override String get continueButton => 'Продолжить';
	@override String get next => 'Далее';
	@override String get forgotPassword => 'Забыли пароль?';
	@override String recoveryHint({required Object email}) => 'Мы отправили код восстановления на ${email}';
	@override String get recoveryEmailHint => 'Укажите email, привязанный к аккаунту. Если он совпадёт, мы отправим на него код восстановления.';
	@override String get codePlaceholder => 'Код из письма';
	@override String get newPasswordPlaceholder => 'Новый пароль';
	@override String get repeatPasswordPlaceholder => 'Повторите пароль';
	@override String get currentPasswordPlaceholder => 'Текущий пароль';
	@override String get resetPassword => 'Сбросить пароль';
	@override String get reset => 'Сбросить';
	@override String attemptsLeft({required Object count}) => 'Осталось попыток: ${count}';
	@override String attemptsLeftInline({required num n}) => (_root.$meta.cardinalResolver ?? PluralResolvers.cardinal('ru'))(n,
		one: 'осталось ${n} попытка',
		few: 'осталось ${n} попытки',
		many: 'осталось ${n} попыток',
	);
	@override String get setPassword => 'Установить пароль';
	@override String get newPasswordTitle => 'Новый пароль';
	@override String get newPasswordDescription => 'Задайте облачный пароль. Его запросят при входе с нового устройства.';
	@override String get changePassword => 'Изменить пароль';
	@override String get email => 'Email';
	@override String get emailPlaceholder => 'Email';
	@override String get emailNotSet => 'Не задан';
	@override String get emailCodeSent => 'Мы отправили код подтверждения на ваш email.';
	@override String get verifyEmail => 'Подтвердить email';
	@override String get disable => 'Отключить пароль';
	@override String get loadError => 'Не удалось загрузить настройки облачного пароля';
	@override String get retry => 'Повторить';
	@override String get emailRequired => 'Введите email';
	@override String get passwordRequired => 'Введите пароль';
	@override String get passwordTooShort => 'Пароль должен быть не короче 5 символов';
	@override String get codeRequired => 'Введите код';
	@override String get passwordsDoNotMatch => 'Пароли не совпадают';
	@override String get wrongPassword => 'Неверный пароль';
	@override String get tooManyAttempts => 'Слишком много попыток. Начните заново.';
	@override String get codeMismatch => 'Неверный код';
	@override String get notSet => 'Облачный пароль не установлен';
	@override String get invalidEmail => 'Некорректный email';
	@override String get sessionExpired => 'Сессия истекла. Начните заново.';
}

// Path: screenMyProfile
class _Translations$screenMyProfile$ru extends Translations$screenMyProfile$en {
	_Translations$screenMyProfile$ru._(TranslationsRu root) : this._root = root, super.internal(root);

	final TranslationsRu _root; // ignore: unused_field

	// Translations
	@override String get myprofile => 'Мой профиль';
	@override String get firstName => 'Имя';
	@override String get lastName => 'Фамилия';
	@override String get aboutMe => 'О себе';
	@override String get tellUsAboutYourself => 'Расскажите о себе';
	@override String get add => 'Указать';
	@override String get birthDate => 'Дата рождения';
	@override String get username => 'Имя пользователя';
	@override String get validationFirstNameMaxLength => 'Должно содержать не более 25 символов';
	@override String get validationLastNameMaxLength => 'Должно содержать не более 25 символов';
	@override String get validationAboutMeMaxLength => 'Должно содержать не более 140 символов';
	@override String get cancel => _root.common.cancel;
	@override String get done => _root.common.done;
	@override String get edit => _root.common.edit;
	@override String get close => _root.common.close;
	@override String get error => _root.common.error;
	@override String get errorSavingProfile => 'Сохранение профиля';
	@override String get errorSavingAvatar => 'Сохранение аватара';
	@override String birthDayFormat({required Object date}) => '${date}';
	@override String get birthDayRemove => 'Удалить дату рождения';
	@override String get editPhoto => 'Изменить фото';
	@override String get takePhoto => 'Сделать фото';
	@override String get chooseFromGallery => 'Выбрать из галереи';
	@override String get chooseFile => 'Файл';
	@override String get pickDocument => 'Выбрать файл';
	@override String get pickDocumentHint => 'Документы, архивы и любые другие файлы';
	@override String get pickMediaAsFile => 'Фото или видео без сжатия';
	@override String get pickMediaAsFileHint => 'Отправятся файлом, в исходном качестве';
	@override String get chooseEmoji => 'Эмодзи';
	@override String get chooseLink => 'Ссылка';
	@override String get galleryEmpty => 'Нет фотографий';
	@override String get galleryAccessDenied => 'Нет доступа к фото';
	@override String get galleryOpenSettings => 'Открыть настройки';
	@override String get galleryManageAccess => 'Управлять доступом';
	@override String get mobilePhone => 'Номер телефона';
	@override String get number => 'Номер';
	@override String get copy => 'Скопировать';
	@override String get copied => 'Скопировано';
	@override String get usernameHint => 'имя пользователя';
	@override String get usernameDescription => 'Вы можете выбрать имя пользователя. Используйте 5–24 символа: строчные латинские буквы, цифры и подчёркивания';
	@override String get usernameInvalid => 'Имя пользователя должно содержать 5–24 символа:\nстрочные латинские буквы, цифры и подчёркивания';
	@override String get usernameTaken => 'Это имя пользователя уже занято';
	@override String get errorSavingUsername => 'Сохранение имени пользователя';
}

// Path: screenProfile
class _Translations$screenProfile$ru extends Translations$screenProfile$en {
	_Translations$screenProfile$ru._(TranslationsRu root) : this._root = root, super.internal(root);

	final TranslationsRu _root; // ignore: unused_field

	// Translations
	@override String get profile => 'Профиль';
	@override String get firstName => _root.screenMyProfile.firstName;
	@override String get lastName => _root.screenMyProfile.lastName;
	@override String get mobilePhone => _root.screenMyProfile.mobilePhone;
	@override String get username => _root.screenMyProfile.username;
	@override String get aboutMe => _root.screenMyProfile.aboutMe;
	@override String get birthDate => _root.screenMyProfile.birthDate;
	@override String age({required num n}) => (_root.$meta.cardinalResolver ?? PluralResolvers.cardinal('ru'))(n,
		one: '${n} год',
		few: '${n} года',
		many: '${n} лет',
		other: '${n} года',
	);
	@override String get copy => _root.screenMyProfile.copy;
	@override String get hideProfile => 'Скрыть профиль';
}

// Path: screenHideProfile
class _Translations$screenHideProfile$ru extends Translations$screenHideProfile$en {
	_Translations$screenHideProfile$ru._(TranslationsRu root) : this._root = root, super.internal(root);

	final TranslationsRu _root; // ignore: unused_field

	// Translations
	@override String get title => 'Скрыть профиль';
	@override String get description => 'Собеседник исчезнет из ваших Контактов, Звонков и Чатов на этом устройстве. Чтобы снова показать его, введите в поиске «/код-фразу». Код-фраза хранится только в виде хеша и не покидает устройство.';
	@override String get phrasePlaceholder => 'Код-фраза';
	@override String get hideAction => 'Скрыть';
	@override String get resetAction => 'Сбросить код-фразу';
	@override String get errorEmptyPhrase => 'Введите код-фразу, чтобы скрыть профиль.';
}

// Path: screenContacts
class _Translations$screenContacts$ru extends Translations$screenContacts$en {
	_Translations$screenContacts$ru._(TranslationsRu root) : this._root = root, super.internal(root);

	final TranslationsRu _root; // ignore: unused_field

	// Translations
	@override String get title => 'Контакты';
	@override String get onIperon => 'В Iperon';
	@override String get onContacts => 'В контактах';
	@override String get cloudContacts => 'Облачные контакты';
	@override String get invite => 'Пригласить';
	@override String get inviteAction => 'Пригласить';
	@override String get search => 'Поиск';
	@override String get permissionTitle => 'Нужен доступ к контактам';
	@override String get permissionMessage => 'Разрешите доступ к контактам, чтобы найти друзей, которые уже в Iperon. Ваши номера сверяются приватно и не раскрываются серверу.';
	@override String get allowAccess => 'Разрешить доступ';
	@override String get openSettings => 'Открыть настройки';
	@override String get empty => 'Контакты не найдены';
	@override String get inviteMessage => 'Давай общаться в Iperon';
	@override String get statusOnline => 'в сети';
	@override String get statusLastSeenRecently => 'был(а) недавно';
	@override String statusLastSeen({required Object date}) => 'был(а) ${date}';
	@override String get addByNumber => 'Добавить по номеру';
	@override String get addContact => 'Добавить контакт';
	@override String get addByNumberHint => 'Номер телефона';
	@override String get addFirstName => 'Имя';
	@override String get addLastName => 'Фамилия';
	@override String get add => 'Добавить';
	@override String get addInvalidNumber => 'Неверный номер телефона';
	@override String get addFailed => 'Не удалось добавить контакт';
	@override String get validationCloudLimitReached => 'Достигнут лимит облачных контактов';
	@override String get addSyncHint => 'Контакт будет доступен на всех ваших устройствах';
	@override String get remove => 'Удалить';
	@override String get removeTitle => 'Удалить контакт?';
	@override String get removeMessage => 'Он больше не сможет вам звонить, если в настройках приватности не разрешены звонки от всех.';
}

// Path: screenCalls
class _Translations$screenCalls$ru extends Translations$screenCalls$en {
	_Translations$screenCalls$ru._(TranslationsRu root) : this._root = root, super.internal(root);

	final TranslationsRu _root; // ignore: unused_field

	// Translations
	@override String get title => 'Звонки';
	@override String get empty => 'Здесь появятся ваши звонки';
	@override String get emptyMissed => 'Нет пропущенных звонков';
	@override String get permissionTitle => 'Нужен доступ к микрофону';
	@override String get permissionMessage => 'Разрешите доступ к микрофону, чтобы совершать и принимать звонки в Iperon.';
	@override String get notificationPermissionTitle => 'Включите уведомления о звонках';
	@override String get notificationPermissionMessage => 'Разрешите уведомления, чтобы видеть входящие звонки, даже когда Iperon свёрнут.';
	@override String get permissionsTitle => 'Настройка звонков';
	@override String get permissionsMessage => 'Разрешите доступ к микрофону и уведомлениям, чтобы совершать звонки и видеть входящие в Iperon.';
	@override String get pipPermissionTitle => 'Мини-окно во время звонка';
	@override String get pipPermissionMessage => 'Разрешите «Картинку в картинке», чтобы видеозвонок продолжался в маленьком окне поверх экрана, когда вы сворачиваете Iperon.';
	@override String get allowAccess => 'Разрешить доступ';
	@override String get openSettings => 'Открыть настройки';
	@override String get search => 'Поиск';
	@override String get filterAll => 'Все';
	@override String get filterMissed => 'Пропущенные';
	@override String get incoming => 'Входящий';
	@override String get outgoing => 'Исходящий';
	@override String get missed => 'Пропущенный';
	@override String get cancelled => 'Отменённый';
	@override String durationSec({required Object s}) => '${s} сек';
	@override String durationMin({required Object m}) => '${m} мин';
	@override String durationHour({required Object h}) => '${h} час';
	@override String durationHourMin({required Object h, required Object m}) => '${h} час ${m} мин';
	@override String get unknown => 'Неизвестный';
	@override String get delete => 'Удалить';
	@override String get clear => 'Очистить';
	@override String get clearTitle => 'Очистить историю звонков?';
	@override String get clearMessage => 'Все записи о звонках будут удалены. Это действие необратимо.';
}

// Path: screenAuth
class _Translations$screenAuth$ru extends Translations$screenAuth$en {
	_Translations$screenAuth$ru._(TranslationsRu root) : this._root = root, super.internal(root);

	final TranslationsRu _root; // ignore: unused_field

	// Translations
	@override String get enterYourMobilePhoneNumber => 'Введите номер мобильного телефона';
	@override String get currentlyWeOnlySupportPhoneNumbersFromRussianMobileOperators => 'Сейчас мы поддерживаем только номера российских мобильных операторов';
	@override String get insertDebugPhone => 'Вставить тестовый номер';
	@override String get callForFree => 'Позвонить бесплатно';
	@override String weAreExpectingYourCallWithin({required Object duration}) => 'Мы ждём вашего звонка в течение ${duration}';
	@override String get signInWith => 'Войти через';
	@override String get kContinue => _root.common.kContinue;
	@override String get invalidPhoneNumber => 'Неверный номер телефона';
}

// Path: screenAuthModerationApplicationStore
class _Translations$screenAuthModerationApplicationStore$ru extends Translations$screenAuthModerationApplicationStore$en {
	_Translations$screenAuthModerationApplicationStore$ru._(TranslationsRu root) : this._root = root, super.internal(root);

	final TranslationsRu _root; // ignore: unused_field

	// Translations
	@override String get verificationCodeMismatch => 'Неверный код подтверждения';
	@override String get moderationApplicationStoreSessionNotFound => 'Сессия не найдена';
	@override String get invalidPublicSharedKey => 'Неверный публичный общий ключ';
	@override String get invalidPublicSaltKey => 'Неверный публичный ключ соли';
	@override String get enterTheCode => 'Введите код';
	@override String sentConfirmationCodeToNumber({required Object phoneNumber}) => 'Мы отправили код подтверждения на номер ${phoneNumber}';
	@override String get signatureVerificationFailed => 'Не удалось проверить подпись';
}

// Path: screenAuthCallpasswordConfirmation
class _Translations$screenAuthCallpasswordConfirmation$ru extends Translations$screenAuthCallpasswordConfirmation$en {
	_Translations$screenAuthCallpasswordConfirmation$ru._(TranslationsRu root) : this._root = root, super.internal(root);

	final TranslationsRu _root; // ignore: unused_field

	// Translations
	@override String weAreExpectingYourCallWithin({required Object duration}) => 'Мы ждём вашего звонка в течение ${duration}';
	@override String confirmYourNumberDetail({required Object confirmationPhoneNumberRu}) => 'Позвоните на номер ${confirmationPhoneNumberRu} с указанного вами номера телефона и дождитесь сброса вызова.';
	@override String get callForFree => 'Позвонить бесплатно';
	@override String get signatureVerificationFailed => 'Не удалось проверить подпись';
}

// Path: grpcError
class _Translations$grpcError$ru extends Translations$grpcError$en {
	_Translations$grpcError$ru._(TranslationsRu root) : this._root = root, super.internal(root);

	final TranslationsRu _root; // ignore: unused_field

	// Translations
	@override String get errorConnectingServer => 'Ошибка подключения к серверу';
	@override String get unauthenticated => 'Неавторизован';
	@override String get unableConnectServer => 'Не удалось подключиться к серверу';
	@override String get internalServerError => 'Внутренняя ошибка сервера';
	@override String get unknownError => 'Unknown error';
}

// Path: dateTime
class _Translations$dateTime$ru extends Translations$dateTime$en {
	_Translations$dateTime$ru._(TranslationsRu root) : this._root = root, super.internal(root);

	final TranslationsRu _root; // ignore: unused_field

	// Translations
	@override String relativeDateTimeToday({required Object time}) => 'сегодня в ${time}';
	@override String relativeDateTimeYesterday({required Object time}) => 'вчера в ${time}';
	@override String relativeDateTimeOther({required Object date, required Object time}) => '${date} в ${time}';
}

// Path: screenCall
class _Translations$screenCall$ru extends Translations$screenCall$en {
	_Translations$screenCall$ru._(TranslationsRu root) : this._root = root, super.internal(root);

	final TranslationsRu _root; // ignore: unused_field

	// Translations
	@override String get title => 'Звонок';
	@override String get returnToCall => 'Коснитесь, чтобы вернуться к звонку';
	@override String get bannerRinging => 'Вызов';
	@override String get bannerActive => 'Идёт разговор';
	@override String get incomingAudio => 'Входящий звонок';
	@override String get incomingVideo => 'Входящий видеозвонок';
	@override String get calling => 'Вызов…';
	@override String get connecting => 'Соединение…';
	@override String get talking => 'Идёт разговор';
	@override String get endedRejected => 'Звонок отклонён';
	@override String get endedFailed => 'Не удалось соединиться';
	@override String get endedBusy => 'Занято';
	@override String get endedNotAllowed => 'Нельзя позвонить этому пользователю';
	@override String get notAllowedTitle => 'Звонок недоступен';
	@override String get notAllowedMessage => 'Этот пользователь принимает звонки только от своих контактов. Чтобы вы могли позвонить, он должен добавить вас в контакты.';
	@override String get deviceBusyTitle => 'Вы уже в звонке';
	@override String get deviceBusyMessage => 'Телефон занят другим звонком. Завершите текущий звонок, чтобы позвонить.';
	@override String get endedNoConnection => 'Нет соединения с интернетом';
	@override String get endedUnavailable => 'Абонент недоступен';
	@override String get ended => 'Звонок завершён';
	@override String get decline => 'Отклонить';
	@override String get accept => 'Принять';
	@override String get hangup => 'Завершить';
	@override String get micOn => 'Вкл. звук';
	@override String get micOff => 'Выкл. звук';
	@override String get speakerOn => 'Вкл. динамик';
	@override String get speakerOff => 'Выкл. динамик';
	@override String get audioOutput => 'Динамик';
	@override String get audioOutputTitle => 'Вывод звука';
	@override String get routeEarpiece => 'Телефон';
	@override String get routeSpeaker => 'Динамик';
	@override String get routeWiredHeadset => 'Наушники';
	@override String get routeBluetooth => 'Bluetooth';
	@override String get routeHearingAid => 'Слуховой аппарат';
	@override String get routeCar => 'Автомобиль';
	@override String get routeUnknown => 'Другое';
	@override String get routeUnavailable => 'Нет доступных аудиовыходов';
	@override String get cameraOn => 'Вкл. камеру';
	@override String get cameraOff => 'Выкл. камеру';
	@override String get startVideo => 'Видео';
	@override String get switchCamera => 'Сменить камеру';
	@override String get qualityPoor => 'Слабый сигнал';
	@override String get qualityGood => 'Хорошее соединение';
	@override String get qualityExcellent => 'Отличное соединение';
	@override String get remoteMicMuted => 'Микрофон собеседника выключен';
	@override String get encrypted => 'Сквозное шифрование';
	@override String get notEncrypted => 'Без сквозного шифрования';
	@override String get verifyEmoji => 'Сверьте эмодзи с собеседником';
}

// Path: passkey
class _Translations$passkey$ru extends Translations$passkey$en {
	_Translations$passkey$ru._(TranslationsRu root) : this._root = root, super.internal(root);

	final TranslationsRu _root; // ignore: unused_field

	// Translations
	@override String get title => 'Ключи доступа';
	@override String get description => 'Ключи доступа надёжно хранятся в вашем менеджере паролей.';
	@override String get add => 'Добавить ключ';
	@override String get genericName => 'Ключ доступа';
	@override String created({required Object date}) => 'Добавлен ${date}';
	@override String lastUsed({required Object date}) => 'Вход ${date}';
	@override String get alreadyOnThisDevice => 'На этом устройстве уже есть ключ доступа для этого аккаунта. Добавьте ключ на другом устройстве или в другом менеджере паролей.';
	@override String get delete => 'Удалить';
	@override String get deleteConfirmTitle => 'Удалить ключ доступа?';
	@override String get deleteConfirmMessage => 'Войти с помощью этого ключа больше не получится.';
	@override String get loadError => 'Не удалось загрузить ключи';
	@override String get retry => 'Повторить';
	@override String get verificationFailed => 'Не удалось проверить ключ. Попробуйте ещё раз.';
	@override String get ceremonyExpired => 'Срок запроса истёк. Попробуйте ещё раз.';
	@override String get unknownCredential => 'Этот ключ не распознан.';
	@override String get alreadyRegistered => 'Этот ключ уже зарегистрирован.';
	@override String get notFound => 'Ключ не найден.';
}

// Path: yandex
class _Translations$yandex$ru extends Translations$yandex$en {
	_Translations$yandex$ru._(TranslationsRu root) : this._root = root, super.internal(root);

	final TranslationsRu _root; // ignore: unused_field

	// Translations
	@override String get failed => 'Не удалось войти через Яндекс. Попробуйте ещё раз.';
	@override String get invalidToken => 'Не удалось подтвердить вход через Яндекс. Попробуйте ещё раз.';
	@override String get phoneMissing => 'К аккаунту Яндекс ID не привязан номер телефона. Добавьте его в Яндекс ID или войдите по номеру.';
	@override String get invalidPhone => 'Номер телефона в Яндекс ID не подходит для входа. Войдите по номеру.';
	@override String get unavailable => 'Яндекс ID сейчас недоступен. Попробуйте позже.';
}

/// The flat map containing all translations for locale <ru>.
/// Only for edge cases! For simple maps, use the map function of this library.
///
/// The Dart AOT compiler has issues with very large switch statements,
/// so the map is split into smaller functions (512 entries each).
extension on TranslationsRu {
	dynamic _flatMapFunction(String path) {
		return switch (path) {
			'common.mobilePhone' => 'Номер мобильного телефона',
			'common.kContinue' => 'Продолжить',
			'common.ok' => 'ОК',
			'common.cancel' => 'Отмена',
			'common.notNow' => 'Не сейчас',
			'common.back' => 'Назад',
			'common.save' => 'Сохранить',
			'common.online' => 'В сети',
			'common.done' => 'Готово',
			'common.close' => 'Закрыть',
			'common.error' => 'Ошибка',
			'common.noConnectionTitle' => 'Нет соединения с интернетом',
			'common.noConnectionMessage' => 'Проверьте подключение и попробуйте снова.',
			'common.biometricAuthenticateReason' => 'Пройдите аутентификацию для разблокировки',
			'common.biometricPleaseEnterPasscode' => 'Введите код-пароль',
			'common.edit' => 'Изменить',
			'componentsConnectionTitle.waitingForNetwork' => 'Ожидание сети',
			'componentsConnectionTitle.connecting' => 'Подключение',
			'componentsConnectionTitle.updating' => 'Обновление',
			'componentsCamera.unavailable' => 'Камера недоступна',
			'componentsCamera.accessDenied' => 'Нет доступа к камере',
			'componentsCamera.openSettings' => 'Открыть настройки',
			'componentsCamera.photo' => 'Фото',
			'componentsCamera.video' => 'Видео',
			'screenHome.contacts' => 'Контакты',
			'screenHome.calls' => 'Звонки',
			'screenHome.chats' => _root.screenChats.chats,
			'screenHome.settings' => _root.screenSettings.settings,
			'screenChats.chats' => 'Чаты',
			'screenChats.notificationPermissionTitle' => 'Включите уведомления',
			'screenChats.notificationPermissionMessage' => 'Разрешите уведомления, чтобы узнавать о новых сообщениях и контактах, даже когда Iperon свёрнут.',
			'screenChats.allowAccess' => 'Разрешить',
			'screenChats.allFolder' => 'Все чаты',
			'screenChats.search' => 'Поиск',
			'screenChats.empty' => 'Чатов пока нет',
			'screenChats.emptyFolder' => 'В этой папке пока нет чатов',
			'screenChats.emptyArchive' => 'Архив пуст',
			'screenChats.archive' => 'Архив',
			'screenChats.savedMessages' => 'Избранное',
			'screenChats.draft' => 'Черновик:',
			'screenChats.typing' => 'печатает…',
			'screenChats.typingName' => ({required Object name}) => '${name} печатает…',
			'screenChats.photo' => 'Фото',
			'screenChats.video' => 'Видео',
			'screenChats.file' => 'Файл',
			'screenChats.voice' => 'Голосовое сообщение',
			'screenChats.pin' => 'Закрепить',
			'screenChats.unpin' => 'Открепить',
			'screenChats.markRead' => 'Прочитано',
			'screenChats.markUnread' => 'Непрочитано',
			'screenChats.mute' => 'Выключить уведомления',
			'screenChats.unmute' => 'Включить уведомления',
			'screenChats.muteTitle' => 'Выключить уведомления',
			'screenChats.muteHour' => 'На 1 час',
			'screenChats.mute8Hours' => 'На 8 часов',
			'screenChats.mute2Days' => 'На 2 дня',
			'screenChats.muteForever' => 'Навсегда',
			'screenChats.mutedUntil' => ({required Object time}) => 'до ${time}',
			'screenChats.toArchive' => 'В архив',
			'screenChats.fromArchive' => 'Из архива',
			'screenChats.delete' => 'Удалить',
			'screenChats.swipeRead' => 'Прочитано',
			'screenChats.swipeUnread' => 'Непрочитано',
			'screenChats.swipeMute' => 'Выкл. звук',
			'screenChats.swipeUnmute' => 'Вкл. звук',
			'screenChats.swipeArchive' => 'Архив',
			'screenChats.swipeUnarchive' => 'Вернуть',
			'screenChats.deleteChatTitle' => 'Удалить чат?',
			'screenChats.deleteChatMessage' => ({required Object title}) => 'Чат «${title}» будет удалён из списка.',
			'screenChats.readAll' => 'Прочитать все',
			'screenChats.deleteFolder' => 'Удалить папку',
			'screenChats.deleteFolderTitle' => ({required Object title}) => 'Удалить папку «${title}»?',
			'screenChats.deleteFolderMessage' => 'Чаты из папки не удаляются.',
			'screenChats.editFolder' => 'Изменить папку',
			'screenChats.editFolders' => 'Изменить папки',
			'screenChats.reorderFolders' => 'Изменить порядок',
			'screenChatFolders.folders' => 'Папки',
			'screenChatFolders.intro' => 'Создавайте папки для разных групп чатов и быстро переключайтесь между ними свайпом по списку.',
			'screenChatFolders.myFolders' => 'Мои папки',
			'screenChatFolders.createFolder' => 'Создать папку',
			'screenChatFolders.allChatsSubtitle' => 'Все ваши чаты',
			'screenChatFolders.reorderFooter' => ({required Object n}) => 'Чтобы изменить порядок, перетащите папку за ≡. Можно создать до ${n} папок вместе с «Все чаты».',
			'screenChatFolders.limitReached' => ({required Object n}) => 'Создано максимальное число папок — ${n}, вместе с «Все чаты». Удалите ненужную, чтобы добавить новую.',
			'screenChatFolders.recommended' => 'Рекомендованные папки',
			'screenChatFolders.add' => 'Добавить',
			'screenChatFolders.chatsCount' => ({required num n}) => (_root.$meta.cardinalResolver ?? PluralResolvers.cardinal('ru'))(n, one: '${n} чат', few: '${n} чата', many: '${n} чатов', other: '${n} чата', ), 
			'screenChatFolders.noChats' => 'Нет чатов',
			'screenChatFolders.presetUnread' => 'Непрочитанные',
			'screenChatFolders.presetUnreadAbout' => 'Новые сообщения из всех чатов',
			'screenChatFolders.presetPersonal' => 'Личные',
			'screenChatFolders.presetPersonalAbout' => 'Сообщения только из личных чатов',
			'screenChatFolders.presetGroups' => 'Группы',
			'screenChatFolders.presetGroupsAbout' => 'Сообщения только из групп',
			'screenChatFolders.presetChannels' => 'Каналы',
			'screenChatFolders.presetChannelsAbout' => 'Сообщения только из каналов',
			'screenChatFolders.newFolder' => 'Новая папка',
			'screenChatFolders.editFolder' => 'Изменить папку',
			'screenChatFolders.create' => 'Создать',
			'screenChatFolders.name' => 'Название папки',
			'screenChatFolders.included' => 'Включённые чаты',
			'screenChatFolders.includedFooter' => 'Выберите чаты и типы чатов, которые будут в этой папке.',
			'screenChatFolders.addChats' => 'Добавить чаты',
			'screenChatFolders.excluded' => 'Исключённые чаты',
			'screenChatFolders.excludedFooter' => 'Выберите чаты и типы чатов, которые никогда не попадут в эту папку.',
			'screenChatFolders.excludeChats' => 'Исключить чаты',
			'screenChatFolders.deleteFolder' => 'Удалить папку',
			'screenChatFolders.chatTypes' => 'Типы чатов',
			'screenChatFolders.chats' => 'Чаты',
			'screenChatFolders.contacts' => 'Контакты',
			'screenChatFolders.nonContacts' => 'Не контакты',
			'screenChatFolders.groups' => 'Группы',
			'screenChatFolders.channels' => 'Каналы',
			'screenChatFolders.communities' => 'Сообщества',
			'screenChatFolders.muted' => 'Без уведомлений',
			'screenChatFolders.read' => 'Прочитанные',
			'screenChatFolders.search' => 'Поиск',
			'screenChatFolders.nothingFound' => 'Чатов не найдено',
			'screenChatFolders.selected' => ({required Object n}) => 'Выбрано: ${n}',
			'screenChatFolders.nameRequired' => 'Введите название папки.',
			'screenChatFolders.chatsRequired' => 'Добавьте в папку хотя бы один чат или тип чатов.',
			'screenChatFolders.discardTitle' => 'Не сохранять изменения?',
			'screenChatFolders.discardMessage' => 'Изменения папки будут потеряны.',
			'screenChatFolders.discard' => 'Не сохранять',
			'screenNewChat.title' => 'Новое сообщение',
			'screenNewChat.search' => 'Поиск',
			'screenNewChat.newGroup' => 'Новая группа',
			'screenNewChat.newChannel' => 'Новый канал',
			'screenNewChat.newCommunity' => 'Новое сообщество',
			'screenNewChat.contacts' => 'Контакты',
			'screenNewChat.noContacts' => 'Контакты не найдены',
			'screenNewChat.addMembers' => 'Добавить участников',
			'screenNewChat.next' => 'Далее',
			'screenNewChat.selected' => ({required Object n}) => 'Выбрано: ${n}',
			'screenNewChat.noMembersHint' => 'Группу можно создать без участников и пригласить их позже.',
			'screenNewChat.groupTitle' => 'Новая группа',
			'screenNewChat.channelTitle' => 'Новый канал',
			'screenNewChat.communityTitle' => 'Новое сообщество',
			'screenNewChat.create' => 'Создать',
			'screenNewChat.groupName' => 'Название группы',
			'screenNewChat.channelName' => 'Название канала',
			'screenNewChat.communityName' => 'Название сообщества',
			'screenNewChat.description' => 'Описание',
			'screenNewChat.descriptionHint' => 'Необязательно',
			'screenNewChat.channelDescriptionFooter' => 'Расскажите подписчикам, о чём канал.',
			'screenNewChat.communityDescriptionFooter' => 'Расскажите об организации: чем занимаетесь, адрес, часы работы. Внутри сообщества будут канал объявлений и группы по темам.',
			'screenNewChat.members' => 'Участники',
			'screenNewChat.setPhoto' => 'Выбрать фото',
			'screenNewChat.changePhoto' => 'Изменить фото',
			'screenNewChat.removePhoto' => 'Удалить фото',
			'screenNewChat.cover' => 'Обложка',
			'screenNewChat.setCover' => 'Выбрать обложку',
			'screenNewChat.changeCover' => 'Изменить обложку',
			'screenNewChat.removeCover' => 'Удалить обложку',
			'screenNewChat.coverFooter' => 'Фон шапки страницы сообщества — например, фото зала или витрины.',
			'screenNewChat.contactsHeader' => 'Контакты',
			'screenNewChat.phone' => 'Телефон',
			'screenNewChat.address' => 'Адрес',
			'screenNewChat.latitude' => 'Широта',
			'screenNewChat.latitudeHint' => '55.650088',
			'screenNewChat.longitude' => 'Долгота',
			'screenNewChat.longitudeHint' => '37.606609',
			'screenNewChat.coordinatesFooter' => 'По широте и долготе строится маршрут в Яндекс Картах и 2ГИС. В картах их можно скопировать, удерживая точку.',
			'screenNewChat.coordinatesInvalid' => 'Нужны обе координаты числами: широта от −90 до 90, долгота от −180 до 180.',
			'screenNewChat.editPhoto' => 'Фото',
			'screenNewChat.type' => 'Тип',
			'screenNewChat.typePublic' => 'Публичный',
			'screenNewChat.typePrivate' => 'Частный',
			'screenNewChat.channelPublicFooter' => 'Публичный канал можно найти в поиске, подписаться на него может любой.',
			'screenNewChat.channelPrivateFooter' => 'На частный канал можно подписаться только по ссылке-приглашению.',
			'screenNewChat.communityPublicFooter' => 'Публичное сообщество можно найти в поиске, вступить в него может любой.',
			'screenNewChat.communityPrivateFooter' => 'В частное сообщество можно вступить только по ссылке-приглашению.',
			'screenNewChat.link' => 'Ссылка',
			'screenNewChat.usernameHint' => 'имя',
			'screenNewChat.usernameChecking' => 'Проверка…',
			'screenNewChat.usernameAvailable' => 'Ссылка свободна.',
			'screenNewChat.usernameTaken' => 'Эта ссылка уже занята.',
			'screenNewChat.usernameInvalid' => 'От 5 до 24 символов: латинские буквы a–z, цифры и _.',
			'screenNewChat.usernameEmpty' => 'Придумайте ссылку, по которой его будут находить.',
			'screenNewChat.inviteLink' => 'Ссылка-приглашение',
			'screenNewChat.inviteLinkFooter' => 'По этой ссылке можно присоединиться. Нажмите, чтобы скопировать.',
			'screenNewChat.copied' => 'Ссылка скопирована',
			'screenNewChat.commentsSwitch' => 'Комментарии',
			'screenNewChat.commentsFooter' => 'Подписчики смогут обсуждать каждый пост в комментариях.',
			'screenNewChat.commentsLimit' => 'Срок комментирования',
			'screenNewChat.commentsLimitFooter' => 'Сколько времени после публикации можно комментировать пост — дальше комментарии только читают. Действует на новые посты.',
			'screenNewChat.commentsLimitOff' => 'Без ограничения',
			'screenNewChat.commentsLimitHours' => ({required num n}) => (_root.$meta.cardinalResolver ?? PluralResolvers.cardinal('ru'))(n, one: '${n} час', few: '${n} часа', many: '${n} часов', other: '${n} часа', ), 
			'screenNewChat.commentsLimitDays' => ({required num n}) => (_root.$meta.cardinalResolver ?? PluralResolvers.cardinal('ru'))(n, one: '${n} день', few: '${n} дня', many: '${n} дней', other: '${n} дня', ), 
			'screenNewChat.commentsLimitWeek' => '1 неделя',
			'screenNewChat.commentsLimitMonth' => '1 месяц',
			'screenNewChat.commentsLimitYear' => '1 год',
			'screenNewChat.commentsWho' => 'Кто может комментировать',
			'screenNewChat.commentsWhoAll' => 'Все',
			'screenNewChat.commentsWhoSubscribers' => 'Только подписчики',
			'screenNewChat.commentsMinSubscription' => 'Подписка не менее',
			'screenNewChat.commentsWhoFooter' => 'Не подписанные читают комментарии, но не пишут. Срок подписки защищает от спама: только что подписавшийся сможет комментировать, когда пройдёт выбранное время.',
			'screenNewChat.newcomerMedia' => 'Новичкам — без ссылок и медиа',
			'screenNewChat.newcomerMediaOff' => 'Выкл.',
			'screenNewChat.newcomerMediaFooterGroup' => 'Вступившие меньше выбранного срока назад пишут только текст — без ссылок, фото, видео, файлов, голосовых и опросов: так спам-боты не сразу смогут рекламировать. На админов не действует.',
			'screenNewChat.newcomerMediaFooterChannel' => 'Новички — не подписанные или подписанные меньше выбранного срока назад — пишут в комментариях только текст, без ссылок, фото, видео, файлов, голосовых и опросов.',
			'screenNewChat.signSwitch' => 'Подписывать сообщения',
			'screenNewChat.signFooter' => 'С подписями под постом видно имя админа, который его опубликовал.',
			'screenNewChat.hideMembers' => 'Скрыть участников',
			'screenNewChat.hideSubscribers' => 'Скрыть подписчиков',
			'screenNewChat.hideMembersFooter' => 'Список будут видеть только админы.',
			'screenNewChat.joinHeader' => 'Вступление',
			'screenNewChat.joinOpen' => 'Открытое',
			'screenNewChat.joinLink' => 'По ссылке',
			'screenNewChat.joinRequest' => 'По заявке',
			'screenNewChat.joinAdmins' => 'Добавляют админы',
			'screenNewChat.joinOpenFooter' => 'Найти можно в поиске, вступить может любой.',
			'screenNewChat.joinLinkFooter' => 'Вступить можно только по ссылке-приглашению.',
			'screenNewChat.joinRequestFooter' => 'По ссылке-приглашению подаётся заявка — вступление после одобрения админом.',
			'screenNewChat.joinAdminsFooter' => 'Вступить самостоятельно нельзя — участников добавляют админы.',
			'screenNewChat.defaultRoleHeader' => 'Новые участники',
			'screenNewChat.roleReader' => 'Только чтение',
			'screenNewChat.roleWriter' => 'Чтение и сообщения',
			'screenNewChat.roleReaderFooter' => 'Вступившие читают, но не могут писать.',
			'screenNewChat.roleWriterFooter' => 'Вступившие могут читать и писать сообщения.',
			'screenNewChat.topicJoinOpen' => 'Одним нажатием',
			'screenNewChat.topicJoinRequest' => 'По заявке',
			'screenNewChat.topicJoinOpenFooter' => 'Любой участник сообщества вступает одним нажатием.',
			'screenNewChat.topicJoinRequestFooter' => 'Закрытая тема: участник сообщества подаёт заявку, вступление — после одобрения админом.',
			'screenNewChat.topicJoinHidden' => 'Скрытая',
			'screenNewChat.topicJoinHiddenFooter' => 'Группу видят только её участники и админы сообщества. Вступить самостоятельно нельзя — участников добавляют админы.',
			'screenChatInvites.inviteLinks' => 'Ссылки-приглашения',
			'screenChatInvites.joinRequests' => 'Заявки на вступление',
			'screenChatInvites.primaryLink' => 'Основная ссылка',
			'screenChatInvites.publicLink' => 'Публичная ссылка',
			'screenChatInvites.publicLinkFooter' => 'Публичная ссылка меняется в «Изменить». Дополнительные ссылки ниже работают как приглашения.',
			'screenChatInvites.primaryFooter' => 'Любой, у кого есть ссылка, может вступить.',
			'screenChatInvites.primaryFooterChannel' => 'Любой, у кого есть ссылка, может подписаться.',
			'screenChatInvites.primaryFooterRequest' => 'По ссылке подаётся заявка на вступление — её одобряет админ.',
			'screenChatInvites.adminsOnlyNote' => 'Сейчас участников добавляют только админы — по ссылкам вступить нельзя. Способ вступления меняется в «Изменить».',
			'screenChatInvites.copy' => 'Копировать',
			'screenChatInvites.share' => 'Поделиться',
			'screenChatInvites.replace' => 'Заменить ссылку',
			'screenChatInvites.replaceTitle' => 'Заменить ссылку?',
			'screenChatInvites.replaceMessage' => 'Текущая ссылка перестанет работать, вместо неё появится новая.',
			'screenChatInvites.copied' => 'Ссылка скопирована',
			'screenChatInvites.createLink' => 'Создать ссылку',
			'screenChatInvites.additionalHeader' => 'Дополнительные ссылки',
			'screenChatInvites.additionalFooter' => 'Можно создать ссылки со сроком действия, лимитом вступлений или одобрением заявок.',
			'screenChatInvites.revokedHeader' => 'Отозванные ссылки',
			'screenChatInvites.deleteAllRevoked' => 'Удалить все отозванные',
			'screenChatInvites.joined' => ({required Object n}) => 'Вступили: ${n}',
			'screenChatInvites.left' => ({required Object n}) => 'осталось ${n}',
			'screenChatInvites.until' => ({required Object date}) => 'до ${date}',
			'screenChatInvites.expired' => 'истекла',
			'screenChatInvites.exhausted' => 'лимит исчерпан',
			'screenChatInvites.approval' => 'по заявке',
			'screenChatInvites.edit' => 'Изменить',
			'screenChatInvites.revoke' => 'Отозвать',
			'screenChatInvites.revokeTitle' => 'Отозвать ссылку?',
			'screenChatInvites.revokeMessage' => 'По ней больше нельзя будет вступить.',
			'screenChatInvites.delete' => 'Удалить',
			'screenChatInvites.newLink' => 'Новая ссылка',
			'screenChatInvites.editLink' => 'Изменить ссылку',
			'screenChatInvites.create' => 'Создать',
			'screenChatInvites.name' => 'Название ссылки',
			'screenChatInvites.nameHint' => 'Необязательно',
			'screenChatInvites.nameFooter' => 'Название видно только админам.',
			'screenChatInvites.approvalTitle' => 'Одобрение админом',
			'screenChatInvites.approvalFooter' => 'Перешедшие по ссылке подают заявку, админ её принимает или отклоняет.',
			'screenChatInvites.expireHeader' => 'Срок действия',
			'screenChatInvites.expireNever' => 'Без ограничений',
			'screenChatInvites.expireHour' => '1 час',
			'screenChatInvites.expireDay' => '1 день',
			'screenChatInvites.expireWeek' => '1 неделя',
			'screenChatInvites.expireCurrent' => ({required Object date}) => 'До ${date}',
			'screenChatInvites.limitHeader' => 'Лимит вступлений',
			'screenChatInvites.limitNone' => 'Без ограничений',
			'screenChatInvites.limitFooter' => 'Сколько человек может вступить по этой ссылке.',
			'screenChatInvites.requestsEmpty' => 'Заявок нет',
			'screenChatInvites.requestsEmptyHint' => 'Когда кто-то попросится вступить, заявка появится здесь.',
			'screenChatInvites.approve' => 'Принять',
			'screenChatInvites.decline' => 'Отклонить',
			'screenChatInvites.approveAll' => 'Принять все',
			'screenChatInvites.declineAll' => 'Отклонить все',
			'screenChatInvites.all' => 'Все',
			'screenChatInvites.viaLink' => ({required Object title}) => 'по ссылке «${title}»',
			'screenChatInvites.requestsOffHint' => 'Заявки приходят, когда вступление «По заявке» или по ссылкам с одобрением админом.',
			'screenChatAdmins.admins' => 'Администраторы',
			'screenChatAdmins.addAdmin' => 'Добавить админа',
			'screenChatAdmins.adminsFooter' => 'Админы помогают управлять чатом. Права каждого настраиваются отдельно.',
			'screenChatAdmins.adminsFooterOfCommunity' => 'Админы сообщества — админы и во всех его группах и каналах, с теми же правами.',
			'screenChatAdmins.addModerator' => 'Добавить модератора',
			'screenChatAdmins.promoteModerator' => 'Назначить модератором',
			'screenChatAdmins.moderatorRights' => 'Права модератора',
			'screenChatAdmins.newModerator' => 'Новый модератор',
			'screenChatAdmins.moderatorRankHint' => 'модератор',
			'screenChatAdmins.moderatorRightsFooter' => 'Модератор управляет только этим чатом: может ограничить или исключить участника, но блокировать в сообществе и назначать модераторов могут только админы сообщества.',
			'screenChatAdmins.dismissModerator' => 'Снять модератора',
			'screenChatAdmins.dismissModeratorTitle' => ({required Object name}) => 'Снять ${name} с модераторов?',
			'screenChatAdmins.dismissModeratorMessage' => 'Участник останется в чате без прав модератора.',
			'screenChatAdmins.adminsFooterCommunity' => 'Владелец и админы сообщества управляют всеми его чатами — их права меняются в сообществе. Здесь можно назначить модераторов только этого чата.',
			'screenChatAdmins.promote' => 'Назначить админом',
			'screenChatAdmins.adminRights' => 'Права админа',
			'screenChatAdmins.newAdmin' => 'Новый админ',
			'screenChatAdmins.rightsHeader' => 'Что может этот админ',
			'screenChatAdmins.rightsFooterLimited' => 'Можно выдать только те права, которые есть у вас.',
			'screenChatAdmins.changeInfo' => 'Изменять профиль и настройки',
			'screenChatAdmins.postMessages' => 'Публиковать посты',
			'screenChatAdmins.editMessages' => 'Изменять чужие посты',
			'screenChatAdmins.deleteMessages' => 'Удалять чужие сообщения',
			'screenChatAdmins.banUsers' => 'Блокировать участников',
			'screenChatAdmins.inviteUsers' => 'Приглашать по ссылкам',
			'screenChatAdmins.pinMessages' => 'Закреплять сообщения',
			'screenChatAdmins.manageCalls' => 'Управлять звонками',
			'screenChatAdmins.anonymous' => 'Анонимность',
			'screenChatAdmins.addAdmins' => 'Назначать админов',
			'screenChatAdmins.anonymousFooter' => 'Сообщения анонимного админа подписываются названием группы.',
			'screenChatAdmins.rankHeader' => 'Звание',
			'screenChatAdmins.rankHint' => 'админ',
			'screenChatAdmins.rankFooter' => 'Показывается в списке участников вместо «админ».',
			'screenChatAdmins.dismiss' => 'Снять админа',
			'screenChatAdmins.dismissTitle' => ({required Object name}) => 'Снять ${name} с админов?',
			'screenChatAdmins.dismissMessage' => 'Участник останется в чате без прав админа.',
			'screenChatAdmins.transfer' => 'Передать владение',
			'screenChatAdmins.transferTitle' => ({required Object name}) => 'Передать владение ${name}?',
			'screenChatAdmins.transferMessage' => ({required Object name}) => '${name} станет владельцем, а вы — админом со всеми правами. Отменить это сможет только новый владелец.',
			'screenChatAdmins.pickMember' => 'Выберите участника',
			'screenChatAdmins.noCandidates' => 'Некого назначить — все участники уже админы.',
			'screenPoll.newPoll' => 'Новый опрос',
			'screenPoll.question' => 'Вопрос',
			'screenPoll.questionHint' => 'Задайте вопрос',
			'screenPoll.options' => 'Варианты ответа',
			'screenPoll.optionHint' => 'Вариант',
			'screenPoll.addOption' => 'Добавить вариант',
			'screenPoll.optionsFooter' => 'Можно добавить до 10 вариантов.',
			'screenPoll.quizOptionsFooter' => 'Нажмите на кружок, чтобы отметить верный ответ.',
			'screenPoll.settings' => 'Настройки',
			'screenPoll.anonymous' => 'Анонимное голосование',
			'screenPoll.multiple' => 'Несколько ответов',
			'screenPoll.quiz' => 'Режим викторины',
			'screenPoll.quizFooter' => 'У викторины один верный ответ. После ответа участник увидит пояснение.',
			'screenPoll.channelFooter' => 'В канале голосование всегда анонимное.',
			'screenPoll.explanation' => 'Пояснение',
			'screenPoll.explanationHint' => 'Покажется после ответа (необязательно)',
			'screenPoll.create' => 'Создать',
			'screenChat.today' => 'Сегодня',
			'screenChat.yesterday' => 'Вчера',
			'screenChat.online' => 'в сети',
			'screenChat.lastSeenRecently' => 'был(а) недавно',
			'screenChat.members' => ({required num n, required Object count}) => (_root.$meta.cardinalResolver ?? PluralResolvers.cardinal('ru'))(n, one: '${count} участник', few: '${count} участника', many: '${count} участников', other: '${count} участника', ), 
			'screenChat.subscribers' => ({required num n, required Object count}) => (_root.$meta.cardinalResolver ?? PluralResolvers.cardinal('ru'))(n, one: '${count} подписчик', few: '${count} подписчика', many: '${count} подписчиков', other: '${count} подписчика', ), 
			'screenChat.comments' => ({required num n, required Object count}) => (_root.$meta.cardinalResolver ?? PluralResolvers.cardinal('ru'))(n, one: '${count} комментарий', few: '${count} комментария', many: '${count} комментариев', other: '${count} комментария', ), 
			'screenChat.leaveComment' => 'Прокомментировать',
			'screenChat.commentsTitle' => 'Комментарии',
			'screenChat.commentsClosed' => 'Комментарии закрыты',
			'screenChat.commentsSubscribe' => 'Подписаться, чтобы комментировать',
			'screenChat.commentsWaitUntil' => ({required Object time}) => 'Комментировать можно с ${time}',
			'screenChat.newcomerTitle' => 'Только текст',
			'screenChat.newcomerWaitUntil' => ({required Object time}) => 'Ссылки, медиа, файлы и голосовые новичкам можно отправлять с ${time}.',
			'screenChat.newcomerSubscribe' => 'Ссылки, медиа, файлы и голосовые в комментариях могут отправлять только подписчики.',
			'screenChat.closeComments' => 'Закрыть комментарии',
			'screenChat.openComments' => 'Открыть комментарии',
			'screenChat.closeCommentsTitle' => 'Закрыть комментарии?',
			'screenChat.closeCommentsMessage' => 'Комментировать пост больше будет нельзя, оставленные комментарии останутся.',
			'screenChat.subscribe' => 'Подписаться',
			'screenChat.joinGroup' => 'Вступить в группу',
			'screenChat.requestJoin' => 'Подать заявку',
			'screenChat.requestSent' => 'Заявка отправлена',
			'screenChat.linkInvalid' => 'Ссылка недействительна или устарела.',
			'screenChat.poll' => 'Опрос',
			'screenChat.quiz' => 'Викторина',
			'screenChat.anonymousPoll' => 'Анонимный опрос',
			'screenChat.publicPoll' => 'Открытый опрос',
			'screenChat.anonymousQuiz' => 'Анонимная викторина',
			'screenChat.publicQuiz' => 'Викторина',
			'screenChat.votes' => ({required num n, required Object count}) => (_root.$meta.cardinalResolver ?? PluralResolvers.cardinal('ru'))(n, one: '${count} голос', few: '${count} голоса', many: '${count} голосов', other: '${count} голоса', ), 
			'screenChat.noVotes' => 'Голосов пока нет',
			'screenChat.vote' => 'Голосовать',
			'screenChat.pollClosed' => 'Итоги',
			'screenChat.retractVote' => 'Отменить голос',
			'screenChat.closePoll' => 'Завершить опрос',
			'screenChat.closePollTitle' => 'Завершить опрос?',
			'screenChat.closePollMessage' => 'Голосовать больше будет нельзя, все увидят итоги.',
			'screenChat.pollVoters' => 'Голоса',
			'screenChat.read' => 'Прочитано',
			'screenChat.readAt' => ({required Object date}) => 'Прочитано ${date}',
			'screenChat.readBy' => ({required Object count}) => 'Прочитали: ${count}',
			'screenChat.readByTitle' => 'Прочитали',
			'screenChat.message' => 'Сообщение',
			'screenChat.empty' => 'Сообщений пока нет',
			'screenChat.notFound' => 'Чат не найден',
			'screenChat.reply' => 'Ответить',
			'screenChat.quote' => 'Цитировать',
			'screenChat.replyQuoteTo' => ({required Object name}) => 'Цитата · ${name}',
			'screenChat.copy' => 'Копировать',
			'screenChat.copied' => 'Скопировано',
			'screenChat.edit' => 'Изменить',
			'screenChat.editing' => 'Редактирование',
			'screenChat.edited' => 'изм.',
			'screenChat.delete' => 'Удалить',
			'screenChat.deleteTitle' => 'Удалить сообщение?',
			'screenChat.deleteMessage' => 'Сообщение будет удалено у всех участников чата.',
			'screenChat.you' => 'Вы',
			'screenChat.mute' => 'Выключить звук',
			'screenChat.unmute' => 'Включить звук',
			'screenChat.photo' => _root.screenChats.photo,
			'screenChat.video' => _root.screenChats.video,
			'screenChat.file' => _root.screenChats.file,
			'screenChat.voice' => _root.screenChats.voice,
			'screenChat.selected' => ({required Object n}) => 'Выбрано: ${n}',
			'screenChat.search' => 'Поиск',
			'screenChat.searchNoResults' => 'Нет результатов',
			'screenChat.unreadMessages' => 'Непрочитанные сообщения',
			'screenChat.select' => 'Выбрать',
			'screenChat.videoCompressing' => 'Сжатие видео',
			'screenChat.pin' => 'Закрепить',
			'screenChat.unpin' => 'Открепить',
			'screenChat.pinnedTitle' => 'Закреплённое сообщение',
			'screenChat.pinnedNumber' => ({required Object n}) => 'Закреплённое сообщение #${n}',
			'screenChat.unpinTitle' => 'Открепить сообщение?',
			'screenChat.pinnedServiceYou' => ({required Object text}) => 'Вы закрепили «${text}»',
			'screenChat.pinnedServiceYouMessage' => 'Вы закрепили сообщение',
			'screenChat.pinnedService' => ({required Object name, required Object text}) => '${name} закрепил(а) «${text}»',
			'screenChat.pinnedServiceMessage' => ({required Object name}) => '${name} закрепил(а) сообщение',
			'screenChat.pinnedList' => ({required num n}) => (_root.$meta.cardinalResolver ?? PluralResolvers.cardinal('ru'))(n, one: '${n} закреплённое сообщение', few: '${n} закреплённых сообщения', many: '${n} закреплённых сообщений', other: '${n} закреплённых сообщения', ), 
			'screenChat.pinnedAll' => 'Все закреплённые',
			'screenChat.unpinAll' => 'Открепить все сообщения',
			'screenChat.unpinAllTitle' => ({required num n}) => (_root.$meta.cardinalResolver ?? PluralResolvers.cardinal('ru'))(n, one: 'Открепить ${n} сообщение?', few: 'Открепить все ${n} сообщения?', many: 'Открепить все ${n} сообщений?', other: 'Открепить все ${n} сообщения?', ), 
			'screenChat.goToMessage' => 'Перейти к сообщению',
			'screenChat.sendSilent' => 'Отправить без звука',
			'screenChat.sendLater' => 'Отправить позже',
			'screenChat.slowMode' => 'Медленный режим',
			'screenChat.slowModeWait' => ({required Object time}) => 'В этом чате включён медленный режим. Следующее сообщение можно отправить через ${time}.',
			'screenChat.floodTitle' => 'Слишком часто',
			'screenChat.floodWait' => ({required Object time}) => 'Вы отправляете сообщения слишком часто. Следующее можно отправить через ${time}.',
			'screenChat.floodNewChats' => ({required Object time}) => 'Вы начинаете новые чаты слишком часто. Попробуйте через ${time}.',
			'screenChat.slowModeOneMessage' => 'В медленном режиме можно отправить только одно сообщение за раз.',
			'screenChat.scheduledTitle' => 'Отложенные сообщения',
			'screenChat.schedule' => 'Запланировать',
			'screenChat.sendNow' => 'Отправить сейчас',
			'screenChat.reschedule' => 'Изменить время',
			'screenChat.deleteScheduledTitle' => 'Удалить отложенное сообщение?',
			'screenChat.scheduledHint' => 'Отложенные сообщения',
			'screenChat.linkPreview' => 'Предпросмотр ссылки',
			'screenChat.forward' => 'Переслать',
			'screenChat.forwardTo' => 'Переслать в…',
			'screenChat.forwardedFrom' => ({required Object name}) => 'Переслано от ${name}',
			'screenChat.forwardFrom' => ({required Object names}) => 'От: ${names}',
			'screenChat.forwardMessages' => ({required num n}) => (_root.$meta.cardinalResolver ?? PluralResolvers.cardinal('ru'))(n, one: 'Переслать ${n} сообщение', few: 'Переслать ${n} сообщения', many: 'Переслать ${n} сообщений', other: 'Переслать ${n} сообщения', ), 
			'screenChat.deleteSelectedTitle' => ({required num n}) => (_root.$meta.cardinalResolver ?? PluralResolvers.cardinal('ru'))(n, one: 'Удалить ${n} сообщение?', few: 'Удалить ${n} сообщения?', many: 'Удалить ${n} сообщений?', other: 'Удалить ${n} сообщения?', ), 
			'screenChat.deleteSelectedMessage' => 'Сообщения будут удалены у всех участников чата.',
			'screenChat.deleteForBoth' => ({required Object name}) => 'Удалить у меня и у ${name}',
			'screenChat.deleteForMe' => 'Удалить только у меня',
			'screenChat.deleteAlsoFor' => ({required Object name}) => 'Также удалить для ${name}',
			'screenChat.deleteMessageSelf' => 'Сообщение будет удалено из «Избранного».',
			'screenChat.deleteSelectedMessageSelf' => 'Сообщения будут удалены из «Избранного».',
			'screenChat.voiceSlideToCancel' => 'Влево — отмена',
			'screenChat.voiceHoldHint' => 'Удерживайте, чтобы записать',
			'screenChat.micDeniedTitle' => 'Нет доступа к микрофону',
			'screenChat.micDeniedMessage' => 'Разрешите доступ к микрофону в настройках, чтобы записывать голосовые сообщения.',
			'screenChat.openSettings' => 'Настройки',
			'screenChat.hideWithSpoiler' => 'Скрыть под спойлер',
			'screenChat.removeSpoiler' => 'Убрать спойлер',
			'screenChat.videoHdOn' => 'Видео в HD: 1080p',
			'screenChat.videoHdOff' => 'Стандартное качество: 720p',
			'screenChat.videoSound' => 'Звук',
			'screenChat.videoMuted' => 'Без звука',
			'screenChat.videoCover' => 'Обложка',
			'screenChat.videoCoverSet' => 'Обложка выбрана',
			'screenChat.videoReset' => 'Сбросить',
			'screenChat.videoCrop' => 'Кадрировать',
			'screenChat.videoRotate' => 'Повернуть',
			'screenChat.videoAspectFree' => 'Свободно',
			'screenChat.videoAspectOriginal' => 'Исходное',
			'screenChat.videoAspectSquare' => 'Квадрат',
			'screenChat.videoEditFailed' => 'Не удалось открыть видео',
			'screenChat.format' => 'Форматирование',
			'screenChat.formatBold' => 'Жирный',
			'screenChat.formatItalic' => 'Курсив',
			'screenChat.formatStrike' => 'Зачёркнутый',
			'screenChat.formatSpoiler' => 'Спойлер',
			'screenChat.formatCode' => 'Моноширинный',
			'screenChat.formatLink' => 'Ссылка',
			'screenChat.formatQuote' => 'Цитата',
			'screenChat.formatPlain' => 'Обычный',
			'screenChat.formatUnderline' => 'Подчёркнутый',
			'screenChat.formatPre' => 'Блок кода',
			'screenChat.formatMention' => 'Упомянуть',
			'screenChat.formatQuoteExpandable' => 'Сворачиваемая цитата',
			'screenChat.mentionPickTitle' => 'Кого упомянуть',
			'screenChat.linkTitle' => 'Добавить ссылку',
			'screenChat.linkAdd' => 'Добавить',
			'screenChat.uploadProgress' => ({required Object done, required Object total}) => '${done} из ${total}',
			'screenChat.kb' => 'КБ',
			'screenChat.mb' => 'МБ',
			'screenChat.gb' => 'ГБ',
			'screenChat.mediaCounter' => ({required Object current, required Object total}) => '${current} из ${total}',
			'screenChat.addCaption' => 'Добавить подпись…',
			'screenSettings.settings' => 'Настройки',
			'screenSettings.myProfile' => 'Мой профиль',
			'screenSettings.devices' => _root.screenSettingsDevices.devices,
			'screenSettings.language' => 'Язык',
			'screenSettings.appearance' => _root.screenSettingsAppearance.appearance,
			'screenSettings.folders' => _root.screenChatFolders.folders,
			'screenSettings.notifications' => _root.screenSettingsNotifications.notifications,
			'screenSettings.privacyAndSecurity' => 'Конфиденциальность',
			'screenSettings.aboutApplication' => 'О приложении',
			'screenSettings.logs' => 'Логи',
			'screenSettings.logout' => 'Выйти',
			'screenSettingsNotifications.notifications' => 'Уведомления и звуки',
			'screenSettingsNotifications.messageNotifications' => 'Уведомления о сообщениях',
			'screenSettingsNotifications.privateChats' => 'Личные чаты',
			'screenSettingsNotifications.groups' => 'Группы',
			'screenSettingsNotifications.channels' => 'Каналы',
			'screenSettingsNotifications.on' => 'Вкл.',
			'screenSettingsNotifications.off' => 'Выкл.',
			'screenSettingsNotifications.events' => 'События',
			_ => null,
		} ?? switch (path) {
			'screenSettingsNotifications.contactJoined' => 'Контакт присоединился к Iperon',
			'screenSettingsNotifications.missedCalls' => 'Пропущенные звонки',
			'screenSettingsNotifications.reactions' => 'Реакции',
			'screenSettingsNotifications.reactionsPrivate' => 'В личных чатах',
			'screenSettingsNotifications.reactionsGroups' => 'В группах',
			'screenSettingsNotifications.reactionsFrom' => 'Уведомлять о реакциях от',
			'screenSettingsNotifications.reactionsFromShort' => 'От кого',
			'screenSettingsNotifications.reactionsFromAll' => 'Всех',
			'screenSettingsNotifications.reactionsFromContacts' => 'Моих контактов',
			'screenSettingsNotifications.reactionsNote' => 'Уведомления о реакциях на ваши сообщения. В каналах реакции анонимные — о них не уведомляем.',
			'screenSettingsNotifications.showNotifications' => 'Показывать уведомления',
			'screenSettingsNotifications.messagePreview' => 'Предпросмотр сообщений',
			'screenSettingsNotifications.sound' => 'Звук',
			'screenSettingsNotifications.messagePreviewNote' => 'Без предпросмотра в уведомлении видно только, от кого сообщение.',
			'screenSettingsNotifications.settingsSyncNote' => 'Настройки действуют на всех ваших устройствах.',
			'screenSettingsNotifications.permissionMissingTitle' => 'Уведомления выключены',
			'screenSettingsNotifications.permissionMissingMessage' => 'Iperon не может показывать уведомления на этом устройстве — настройки ниже не сработают.',
			'screenSettingsNotifications.enable' => 'Включить',
			'screenSettingsNotifications.loadError' => 'Не удалось загрузить настройки',
			'screenSettingsNotifications.offlineNote' => 'Нет соединения. Изменение станет доступно, когда появится сеть.',
			'screenSettingsNotifications.retry' => 'Повторить',
			'screenDeveloper.developer' => 'Разработчик',
			'screenDeveloper.logs' => _root.screenSettings.logs,
			'screenDeveloper.exportLogs' => 'Экспорт логов',
			'screenDeveloper.callPreview' => 'Превью экрана звонка',
			'screenDeveloper.chatsDemo' => 'Демо чатов',
			'screenDeveloper.chatsServer' => 'Серверные чаты',
			'screenDeveloper.testPush' => 'Тестовое уведомление',
			'screenDeveloper.testPushSent' => ({required Object apns, required Object fcm, required Object failed}) => 'Отправлено: APNs — ${apns}, FCM — ${fcm}, ошибок — ${failed}. Сверните приложение или заблокируйте экран, чтобы проверить доставку в фоне.',
			'screenDeveloper.testPushNoTokens' => 'Ни у одного вашего устройства нет push-токена. Проверьте, что уведомления разрешены, и перезапустите приложение.',
			'screenDeveloper.testPushError' => ({required Object error}) => 'Не удалось отправить: ${error}',
			'screenDeveloper.testPushEncrypted' => 'Тестовое уведомление (шифрованное)',
			'screenDeveloper.testPushQueued' => 'Поставлено в очередь сервера. На Android придёт «Шифрованное тестовое уведомление: расшифровка работает», на iPhone пока — «Новое уведомление» (расшифровка на iOS появится позже).',
			'screenSettingsAppearance.appearance' => 'Оформление',
			'screenSettingsAppearance.colorTheme' => 'Цветовая тема',
			'screenSettingsAppearance.colorThemeDefault' => 'По умолчанию',
			'screenSettingsAppearance.colorThemeGreen' => 'Зелёная',
			'screenSettingsAppearance.colorThemePurple' => 'Фиолетовая',
			'screenSettingsAppearance.colorThemeOrange' => 'Оранжевая',
			'screenSettingsAppearance.darkMode' => 'Тёмная тема',
			'screenSettingsAppearance.darkModeSystem' => 'Системная',
			'screenSettingsAppearance.darkModeAlwaysOn' => 'Всегда включена',
			'screenSettingsAppearance.darkModeDisabled' => 'Отключена',
			'screenSettingsAppearance.darkModeSystemDescription' => 'Как в настройках устройства',
			'screenSettingsAppearance.darkModeAlwaysOnDescription' => 'Тёмная тема всегда включена',
			'screenSettingsAppearance.darkModeDisabledDescription' => 'Тёмная тема отключена',
			'screenSettingsAppearance.blurOnInactive' => 'Размытие в неактивном состоянии',
			'screenSettingsAppearance.blurOnInactiveDescription' => 'Приложение отображается размытым в списке открытых приложений',
			'screenSettingsAppearance.chatThemes' => 'Темы для чатов',
			'screenSettingsAppearance.quickReaction' => 'Быстрая реакция',
			'screenSettingsAppearance.quickReactionDescription' => 'Ставится двойным тапом по сообщению',
			'screenChatInfo.call' => 'Звонок',
			'screenChatInfo.video' => 'Видео',
			'screenChatInfo.mute' => 'Выкл. звук',
			'screenChatInfo.unmute' => 'Вкл. звук',
			'screenChatInfo.sound' => 'Звук',
			'screenChatInfo.search' => 'Поиск',
			'screenChatInfo.about' => 'О себе',
			'screenChatInfo.description' => 'Описание',
			'screenChatInfo.username' => 'Имя пользователя',
			'screenChatInfo.link' => 'Ссылка',
			'screenChatInfo.tabMembers' => 'Участники',
			'screenChatInfo.tabSubscribers' => 'Подписчики',
			'screenChatInfo.tabMedia' => 'Медиа',
			'screenChatInfo.tabFiles' => 'Файлы',
			'screenChatInfo.tabLinks' => 'Ссылки',
			'screenChatInfo.tabVoice' => 'Голосовые',
			'screenChatInfo.emptyMedia' => 'Здесь будут фото и видео из чата',
			'screenChatInfo.emptyFiles' => 'Здесь будут файлы из чата',
			'screenChatInfo.emptyLinks' => 'Здесь будут ссылки из чата',
			'screenChatInfo.emptyVoice' => 'Здесь будут голосовые сообщения',
			'screenChatInfo.roleOwner' => 'владелец',
			'screenChatInfo.roleAdmin' => 'админ',
			'screenChatInfo.roleReader' => 'только чтение',
			'screenChatInfo.roleCommunityOwner' => 'владелец сообщества',
			'screenChatInfo.roleCommunityAdmin' => 'админ сообщества',
			'screenChatInfo.roleModerator' => 'модератор',
			'screenChatInfo.membersSearch' => 'Имя или @username',
			'screenChatInfo.membersNotFound' => 'Никого не найдено',
			'screenChatInfo.membersSearchNote' => 'По имени ищутся админы, недавно активные и ваши контакты, остальные — по @username.',
			'screenChatInfo.membersHiddenNote' => 'Список участников видят только админы.',
			'screenChatInfo.communityDefaults' => 'Как в сообществе',
			'screenChatInfo.communityDefaultsOwn' => ({required Object list}) => 'Свои: ${list}',
			'screenChatInfo.communityDefaultsTitle' => 'Вернуть настройки сообщества?',
			'screenChatInfo.communityDefaultsMessage' => 'Права новых участников, медленный режим, реакции и ограничения для новичков снова будут как в сообществе и будут меняться вместе с ним.',
			'screenChatInfo.communityDefaultsReset' => 'Вернуть',
			'screenChatInfo.inheritedDefaultRole' => 'права новых участников',
			'screenChatInfo.inheritedSlowMode' => 'медленный режим',
			'screenChatInfo.inheritedReactions' => 'реакции',
			'screenChatInfo.inheritedNewcomer' => 'ограничения для новичков',
			'screenChatInfo.you' => 'Вы',
			'screenChatInfo.addMembers' => 'Добавить участников',
			'screenChatInfo.add' => 'Добавить',
			'screenChatInfo.sendMessage' => 'Написать сообщение',
			'screenChatInfo.allowWriting' => 'Разрешить писать',
			'screenChatInfo.makeReadOnly' => 'Только чтение',
			'screenChatInfo.removeMember' => 'Исключить',
			'screenChatInfo.removeMemberTitle' => ({required Object name}) => 'Исключить ${name}?',
			'screenChatInfo.removeMemberMessage' => 'Вернуться можно будет по ссылке-приглашению.',
			'screenChatInfo.banMember' => 'Заблокировать',
			'screenChatInfo.banMemberTitle' => ({required Object name}) => 'Заблокировать ${name}?',
			'screenChatInfo.banMemberMessage' => 'Участник будет исключён и не сможет вернуться по ссылкам-приглашениям, пока его не разблокируют.',
			'screenChatInfo.removeInCommunityMessage' => 'Участник останется в сообществе и сможет вступить в чат снова.',
			'screenChatInfo.banInCommunityTitle' => ({required Object name}) => 'Заблокировать ${name} в сообществе?',
			'screenChatInfo.banInCommunityMessage' => 'Участник будет исключён из сообщества и всех его чатов и не сможет вернуться, пока его не разблокируют.',
			'screenChatInfo.banned' => 'Заблокированные',
			'screenChatInfo.bannedEmpty' => 'Заблокированных нет',
			'screenChatInfo.bannedFooter' => 'Заблокированные не могут вступить по ссылкам-приглашениям. Если добавить вручную — блокировка снимется.',
			'screenChatInfo.unban' => 'Разблокировать',
			'screenChatInfo.reactions' => 'Реакции',
			'screenChatInfo.reactionsAll' => 'Все реакции',
			'screenChatInfo.reactionsSome' => 'Некоторые',
			'screenChatInfo.reactionsNone' => 'Нет реакций',
			'screenChatInfo.reactionsAllShort' => 'Все',
			'screenChatInfo.reactionsNoneShort' => 'Выкл.',
			'screenChatInfo.reactionsFooter' => 'Какие реакции участники могут ставить на сообщения. Уже поставленные реакции останутся.',
			'screenChatInfo.reactionsPick' => 'Разрешённые реакции',
			'screenChatInfo.maxReactions' => 'Максимум реакций под постом',
			'screenChatInfo.maxReactionsFooter' => 'Сколько разных реакций может быть под одним постом, в том числе под уже опубликованными. Когда лимит набран, можно ставить только те реакции, что уже есть под постом.',
			'screenChatInfo.slowMode' => 'Медленный режим',
			'screenChatInfo.slowModeOff' => 'Выкл.',
			'screenChatInfo.slowModeSeconds' => ({required Object n}) => '${n} с',
			'screenChatInfo.slowModeMinutes' => ({required Object n}) => '${n} мин',
			'screenChatInfo.slowModeHours' => ({required Object n}) => '${n} ч',
			'screenChatInfo.slowModeFooter' => 'Участники смогут отправлять не больше одного сообщения за выбранный интервал. На админов ограничение не действует.',
			'screenChatInfo.deleteChat' => 'Удалить чат',
			'screenChatInfo.leaveGroup' => 'Покинуть группу',
			'screenChatInfo.leaveChannel' => 'Покинуть канал',
			'screenChatInfo.leaveCommunity' => 'Покинуть сообщество',
			'screenChatInfo.leaveShort' => 'Покинуть',
			'screenChatInfo.deleteChatTitle' => ({required Object name}) => 'Удалить чат с ${name}?',
			'screenChatInfo.leaveGroupTitle' => ({required Object name}) => 'Покинуть «${name}»?',
			'screenChatInfo.deleteGroup' => 'Удалить группу',
			'screenChatInfo.deleteChannel' => 'Удалить канал',
			'screenChatInfo.deleteCommunity' => 'Удалить сообщество',
			'screenChatInfo.deleteShort' => 'Удалить',
			'screenChatInfo.deleteInCommunityTitle' => ({required Object name}) => 'Удалить «${name}»?',
			'screenChatInfo.deleteInCommunityMessage' => 'Чат удалится у всех участников сообщества.',
			'screenChatInfo.deleteCommunityMessage' => 'Сообщество удалится вместе со всеми его группами и каналами.',
			'screenChatInfo.communityChats' => 'Чаты',
			'screenChatInfo.communityChatsFooter' => 'Участники сообщества вступают в группы и каналы одним нажатием, в закрытые темы — по заявке.',
			'screenChatInfo.announcements' => 'Объявления',
			'screenChatInfo.closedTopic' => 'По заявке',
			'screenChatInfo.hiddenTopic' => 'Скрытая',
			'screenChatInfo.createGroup' => 'Создать группу',
			'screenChatInfo.createChannel' => 'Создать канал',
			'screenChatInfo.join' => 'Вступить',
			'screenChatInfo.requestPending' => 'Ждёт',
			'screenChatInfo.joinCommunity' => 'Вступить в сообщество',
			'screenChatInfo.phone' => 'Телефон',
			'screenChatInfo.address' => 'Адрес',
			'screenChatInfo.route' => 'Маршрут',
			'screenChatInfo.routeYandex' => 'Яндекс Карты',
			'screenChatInfo.route2gis' => '2ГИС',
			'screenChatInfo.lastSeenMinutes' => ({required Object n}) => 'был(а) ${n} мин. назад',
			'screenChatInfo.lastSeenAt' => ({required Object time}) => 'был(а) в ${time}',
			'screenChatInfo.lastSeenYesterday' => ({required Object time}) => 'был(а) вчера в ${time}',
			'screenChatInfo.lastSeenDate' => ({required Object date}) => 'был(а) ${date}',
			'screenChatThemes.title' => _root.screenSettingsAppearance.chatThemes,
			'screenChatThemes.pattern' => 'Узор',
			'screenChatThemes.intensity' => 'Интенсивность узора',
			'screenChatThemes.color' => 'Цвет',
			'screenChatThemes.footer' => 'Обои показываются во всех чатах на этом устройстве и сами подстраиваются под светлую и тёмную тему.',
			'screenChatThemes.previewName' => 'Анна',
			'screenChatThemes.previewIncoming' => 'Привет! Как тебе новые обои? 🎨',
			'screenChatThemes.previewOutgoing' => 'Отлично смотрятся, оставлю эти 😍',
			'screenChatThemes.patternChat' => 'Общение',
			'screenChatThemes.patternSpace' => 'Космос',
			'screenChatThemes.patternNature' => 'Природа',
			'screenChatThemes.patternMusic' => 'Музыка',
			'screenChatThemes.patternGeometry' => 'Геометрия',
			'screenChatThemes.patternFood' => 'Еда',
			'screenSettingsDevices.devices' => 'Устройства',
			'screenSettingsDevices.thisDevice' => 'Это устройство',
			'screenSettingsDevices.deviceSessionListTileSubtitle' => ({required Object location, required Object updateAt}) => '${location} · ${updateAt}',
			'screenSettingsDevices.terminateAllOtherDeviceSessions' => 'Завершить все другие сеансы',
			'screenSettingsDevices.activeDeviceSession' => 'Активные сеансы',
			'screenSettingsDevices.terminateDeviceSession' => 'Завершить сеанс',
			'screenSettingsDevices.areYouSureYouLogOutFromThisDevice' => 'Вы уверены, что хотите выйти на этом устройстве?',
			'screenSettingsDevices.cancel' => _root.common.cancel,
			'screenSettingsDevices.online' => _root.common.online,
			'screenSettingsDevices.terminate' => 'Завершить',
			'screenSettingsAboutApplication.aboutApplication' => _root.screenSettings.aboutApplication,
			'screenSettingsAboutApplication.version' => ({required Object version, required Object build}) => 'Версия ${version} (${build})',
			'screenSettingsAboutApplication.licenses' => 'Лицензии',
			'screenSettingsAboutApplication.licensesCount' => ({required Object n}) => 'Лицензий: ${n}',
			'screenSettingsAboutApplication.noLicenses' => 'Лицензии не найдены',
			'screenSettingsLanguage.language' => 'Язык',
			'screenSettingsPasscode.passcode' => 'Код-пароль',
			'screenSettingsPasscode.passcodeAndFaceID' => 'Код-пароль и Face ID',
			'screenSettingsPasscode.passcodeAndBiometric' => 'Код-пароль и биометрия',
			'screenSettingsPasscode.note' => 'Примечание: если вы забудете код-пароль, потребуется переустановить приложение',
			'screenSettingsPasscode.turnOn' => 'Включить код-пароль',
			'screenSettingsPasscode.turnOff' => 'Отключить код-пароль',
			'screenSettingsPasscode.change' => 'Изменить код-пароль',
			'screenSettingsPasscode.autoLock' => 'Автоблокировка',
			'screenSettingsPasscode.faceIDUnlock' => 'Разблокировка с Face ID',
			'screenSettingsPasscode.biometricUnlock' => 'Разблокировка по биометрии',
			'screenSettingsPasscode.autoLockOff' => 'Выключена',
			'screenSettingsPasscode.autoLockMinutes' => ({required num n}) => (_root.$meta.cardinalResolver ?? PluralResolvers.cardinal('ru'))(n, one: 'Через ${n} минуту', other: 'Через ${n} минут', ), 
			'screenSettingsPasscode.autoLockHours' => ({required num n}) => (_root.$meta.cardinalResolver ?? PluralResolvers.cardinal('ru'))(n, one: 'Через ${n} час', other: 'Через ${n} часов', ), 
			'screenSettingsPasscode.pleaseEnterPasscode' => 'Введите код-пароль',
			'screenSettingsPasscode.cancel' => _root.common.cancel,
			'settingsPasscodeCreate.pleaseEnterNewPasscode' => 'Введите новый код-пароль',
			'settingsPasscodeCreate.pleaseEnterNewPasscodeAgain' => 'Введите новый код-пароль ещё раз',
			'settingsPasscodeCreate.cancel' => _root.common.cancel,
			'sessionsPrivacyAndSecurity.privacyAndSecurity' => 'Конфиденциальность',
			'sessionsPrivacyAndSecurity.passcodeAndFaceID' => 'Код-пароль и Face ID',
			'sessionsPrivacyAndSecurity.passcodeAndBiometric' => 'Код-пароль и биометрия',
			'sessionsPrivacyAndSecurity.passcode' => 'Код-пароль',
			'sessionsPrivacyAndSecurity.cloudPassword' => 'Облачный пароль',
			'sessionsPrivacyAndSecurity.passkeys' => 'Ключи доступа',
			'sessionsPrivacyAndSecurity.whoCanCall' => 'Кто может звонить',
			'sessionsPrivacyAndSecurity.calls' => 'Звонки',
			'sessionsPrivacyAndSecurity.callsEverybody' => 'Все',
			'sessionsPrivacyAndSecurity.callsContacts' => 'Мои контакты',
			'sessionsPrivacyAndSecurity.callsNobody' => 'Никто',
			'sessionsPrivacyAndSecurity.callsLoadError' => 'Не удалось загрузить настройку',
			'sessionsPrivacyAndSecurity.callsOfflineNote' => 'Нет соединения. Изменение станет доступно, когда появится сеть.',
			'sessionsPrivacyAndSecurity.retry' => 'Повторить',
			'sessionsPrivacyAndSecurity.exceptions' => 'Исключения',
			'sessionsPrivacyAndSecurity.callsAlwaysAllow' => 'Всегда разрешать',
			'sessionsPrivacyAndSecurity.callsAlwaysDeny' => 'Всегда запрещать',
			'sessionsPrivacyAndSecurity.callsAllowEmpty' => 'Нет контактов, зарегистрированных в Iperon',
			'sessionsPrivacyAndSecurity.callsEncryption' => 'Сквозное шифрование',
			'sessionsPrivacyAndSecurity.callsEncryptionNote' => 'Голос и видео шифруются на устройствах собеседников — сервер не может их расшифровать. Работает, если сквозное шифрование включено у обоих; иначе звонок идёт без него.',
			'sessionsPrivacyAndSecurity.birthday' => 'День рождения',
			'sessionsPrivacyAndSecurity.whoCanSeeBirthday' => 'Кто может видеть мой день рождения',
			'sessionsPrivacyAndSecurity.hideBirthYear' => 'Скрывать год рождения',
			'sessionsPrivacyAndSecurity.hideBirthYearNote' => 'Контакты увидят только день и месяц — без года рождения и возраста.',
			'sessionsPrivacyAndSecurity.aboutMe' => 'О себе',
			'sessionsPrivacyAndSecurity.whoCanSeeAboutMe' => 'Кто может видеть моё «О себе»',
			'sessionsPrivacyAndSecurity.lastSeen' => 'Время захода',
			'sessionsPrivacyAndSecurity.whoCanSeeLastSeen' => 'Кто может видеть время моего захода',
			'sessionsPrivacyAndSecurity.lastSeenReciprocityNote' => 'Если выбрано «Никто», вы тоже не будете видеть время захода и статус других.',
			'cloudPassword.title' => 'Облачный пароль',
			'cloudPassword.description' => 'Дополнительный пароль, будет запрашивается при входе с нового устройства. Укажите email чтобы восстановить доступ, если забудете пароль.',
			'cloudPassword.enterPasswordHint' => 'Введите облачный пароль',
			'cloudPassword.unlockInfo' => 'Включена двухэтапная авторизация. Ваш аккаунт защищён дополнительным паролем.',
			'cloudPassword.setupEmailHint' => 'Укажите email, чтобы восстановить доступ, если забудете облачный пароль.',
			'cloudPassword.setupPasswordHint' => 'Теперь задайте облачный пароль. Его спросят при входе на новом устройстве.',
			'cloudPassword.changePasswordHint' => 'Введите новый облачный пароль.',
			'cloudPassword.enableButton' => 'Включить',
			'cloudPassword.passwordPlaceholder' => 'Облачный пароль',
			'cloudPassword.continueButton' => 'Продолжить',
			'cloudPassword.next' => 'Далее',
			'cloudPassword.forgotPassword' => 'Забыли пароль?',
			'cloudPassword.recoveryHint' => ({required Object email}) => 'Мы отправили код восстановления на ${email}',
			'cloudPassword.recoveryEmailHint' => 'Укажите email, привязанный к аккаунту. Если он совпадёт, мы отправим на него код восстановления.',
			'cloudPassword.codePlaceholder' => 'Код из письма',
			'cloudPassword.newPasswordPlaceholder' => 'Новый пароль',
			'cloudPassword.repeatPasswordPlaceholder' => 'Повторите пароль',
			'cloudPassword.currentPasswordPlaceholder' => 'Текущий пароль',
			'cloudPassword.resetPassword' => 'Сбросить пароль',
			'cloudPassword.reset' => 'Сбросить',
			'cloudPassword.attemptsLeft' => ({required Object count}) => 'Осталось попыток: ${count}',
			'cloudPassword.attemptsLeftInline' => ({required num n}) => (_root.$meta.cardinalResolver ?? PluralResolvers.cardinal('ru'))(n, one: 'осталось ${n} попытка', few: 'осталось ${n} попытки', many: 'осталось ${n} попыток', ), 
			'cloudPassword.setPassword' => 'Установить пароль',
			'cloudPassword.newPasswordTitle' => 'Новый пароль',
			'cloudPassword.newPasswordDescription' => 'Задайте облачный пароль. Его запросят при входе с нового устройства.',
			'cloudPassword.changePassword' => 'Изменить пароль',
			'cloudPassword.email' => 'Email',
			'cloudPassword.emailPlaceholder' => 'Email',
			'cloudPassword.emailNotSet' => 'Не задан',
			'cloudPassword.emailCodeSent' => 'Мы отправили код подтверждения на ваш email.',
			'cloudPassword.verifyEmail' => 'Подтвердить email',
			'cloudPassword.disable' => 'Отключить пароль',
			'cloudPassword.loadError' => 'Не удалось загрузить настройки облачного пароля',
			'cloudPassword.retry' => 'Повторить',
			'cloudPassword.emailRequired' => 'Введите email',
			'cloudPassword.passwordRequired' => 'Введите пароль',
			'cloudPassword.passwordTooShort' => 'Пароль должен быть не короче 5 символов',
			'cloudPassword.codeRequired' => 'Введите код',
			'cloudPassword.passwordsDoNotMatch' => 'Пароли не совпадают',
			'cloudPassword.wrongPassword' => 'Неверный пароль',
			'cloudPassword.tooManyAttempts' => 'Слишком много попыток. Начните заново.',
			'cloudPassword.codeMismatch' => 'Неверный код',
			'cloudPassword.notSet' => 'Облачный пароль не установлен',
			'cloudPassword.invalidEmail' => 'Некорректный email',
			'cloudPassword.sessionExpired' => 'Сессия истекла. Начните заново.',
			'screenMyProfile.myprofile' => 'Мой профиль',
			'screenMyProfile.firstName' => 'Имя',
			'screenMyProfile.lastName' => 'Фамилия',
			'screenMyProfile.aboutMe' => 'О себе',
			'screenMyProfile.tellUsAboutYourself' => 'Расскажите о себе',
			'screenMyProfile.add' => 'Указать',
			'screenMyProfile.birthDate' => 'Дата рождения',
			'screenMyProfile.username' => 'Имя пользователя',
			'screenMyProfile.validationFirstNameMaxLength' => 'Должно содержать не более 25 символов',
			'screenMyProfile.validationLastNameMaxLength' => 'Должно содержать не более 25 символов',
			'screenMyProfile.validationAboutMeMaxLength' => 'Должно содержать не более 140 символов',
			'screenMyProfile.cancel' => _root.common.cancel,
			'screenMyProfile.done' => _root.common.done,
			'screenMyProfile.edit' => _root.common.edit,
			'screenMyProfile.close' => _root.common.close,
			'screenMyProfile.error' => _root.common.error,
			'screenMyProfile.errorSavingProfile' => 'Сохранение профиля',
			'screenMyProfile.errorSavingAvatar' => 'Сохранение аватара',
			'screenMyProfile.birthDayFormat' => ({required Object date}) => '${date}',
			'screenMyProfile.birthDayRemove' => 'Удалить дату рождения',
			'screenMyProfile.editPhoto' => 'Изменить фото',
			'screenMyProfile.takePhoto' => 'Сделать фото',
			'screenMyProfile.chooseFromGallery' => 'Выбрать из галереи',
			'screenMyProfile.chooseFile' => 'Файл',
			'screenMyProfile.pickDocument' => 'Выбрать файл',
			'screenMyProfile.pickDocumentHint' => 'Документы, архивы и любые другие файлы',
			'screenMyProfile.pickMediaAsFile' => 'Фото или видео без сжатия',
			'screenMyProfile.pickMediaAsFileHint' => 'Отправятся файлом, в исходном качестве',
			'screenMyProfile.chooseEmoji' => 'Эмодзи',
			'screenMyProfile.chooseLink' => 'Ссылка',
			'screenMyProfile.galleryEmpty' => 'Нет фотографий',
			'screenMyProfile.galleryAccessDenied' => 'Нет доступа к фото',
			'screenMyProfile.galleryOpenSettings' => 'Открыть настройки',
			'screenMyProfile.galleryManageAccess' => 'Управлять доступом',
			'screenMyProfile.mobilePhone' => 'Номер телефона',
			'screenMyProfile.number' => 'Номер',
			'screenMyProfile.copy' => 'Скопировать',
			'screenMyProfile.copied' => 'Скопировано',
			'screenMyProfile.usernameHint' => 'имя пользователя',
			'screenMyProfile.usernameDescription' => 'Вы можете выбрать имя пользователя. Используйте 5–24 символа: строчные латинские буквы, цифры и подчёркивания',
			'screenMyProfile.usernameInvalid' => 'Имя пользователя должно содержать 5–24 символа:\nстрочные латинские буквы, цифры и подчёркивания',
			'screenMyProfile.usernameTaken' => 'Это имя пользователя уже занято',
			'screenMyProfile.errorSavingUsername' => 'Сохранение имени пользователя',
			'screenProfile.profile' => 'Профиль',
			'screenProfile.firstName' => _root.screenMyProfile.firstName,
			'screenProfile.lastName' => _root.screenMyProfile.lastName,
			'screenProfile.mobilePhone' => _root.screenMyProfile.mobilePhone,
			'screenProfile.username' => _root.screenMyProfile.username,
			'screenProfile.aboutMe' => _root.screenMyProfile.aboutMe,
			'screenProfile.birthDate' => _root.screenMyProfile.birthDate,
			'screenProfile.age' => ({required num n}) => (_root.$meta.cardinalResolver ?? PluralResolvers.cardinal('ru'))(n, one: '${n} год', few: '${n} года', many: '${n} лет', other: '${n} года', ), 
			'screenProfile.copy' => _root.screenMyProfile.copy,
			'screenProfile.hideProfile' => 'Скрыть профиль',
			'screenHideProfile.title' => 'Скрыть профиль',
			'screenHideProfile.description' => 'Собеседник исчезнет из ваших Контактов, Звонков и Чатов на этом устройстве. Чтобы снова показать его, введите в поиске «/код-фразу». Код-фраза хранится только в виде хеша и не покидает устройство.',
			'screenHideProfile.phrasePlaceholder' => 'Код-фраза',
			'screenHideProfile.hideAction' => 'Скрыть',
			'screenHideProfile.resetAction' => 'Сбросить код-фразу',
			'screenHideProfile.errorEmptyPhrase' => 'Введите код-фразу, чтобы скрыть профиль.',
			'screenContacts.title' => 'Контакты',
			'screenContacts.onIperon' => 'В Iperon',
			'screenContacts.onContacts' => 'В контактах',
			'screenContacts.cloudContacts' => 'Облачные контакты',
			'screenContacts.invite' => 'Пригласить',
			'screenContacts.inviteAction' => 'Пригласить',
			'screenContacts.search' => 'Поиск',
			'screenContacts.permissionTitle' => 'Нужен доступ к контактам',
			'screenContacts.permissionMessage' => 'Разрешите доступ к контактам, чтобы найти друзей, которые уже в Iperon. Ваши номера сверяются приватно и не раскрываются серверу.',
			'screenContacts.allowAccess' => 'Разрешить доступ',
			'screenContacts.openSettings' => 'Открыть настройки',
			'screenContacts.empty' => 'Контакты не найдены',
			'screenContacts.inviteMessage' => 'Давай общаться в Iperon',
			'screenContacts.statusOnline' => 'в сети',
			'screenContacts.statusLastSeenRecently' => 'был(а) недавно',
			'screenContacts.statusLastSeen' => ({required Object date}) => 'был(а) ${date}',
			'screenContacts.addByNumber' => 'Добавить по номеру',
			'screenContacts.addContact' => 'Добавить контакт',
			'screenContacts.addByNumberHint' => 'Номер телефона',
			'screenContacts.addFirstName' => 'Имя',
			'screenContacts.addLastName' => 'Фамилия',
			'screenContacts.add' => 'Добавить',
			'screenContacts.addInvalidNumber' => 'Неверный номер телефона',
			'screenContacts.addFailed' => 'Не удалось добавить контакт',
			'screenContacts.validationCloudLimitReached' => 'Достигнут лимит облачных контактов',
			'screenContacts.addSyncHint' => 'Контакт будет доступен на всех ваших устройствах',
			'screenContacts.remove' => 'Удалить',
			'screenContacts.removeTitle' => 'Удалить контакт?',
			'screenContacts.removeMessage' => 'Он больше не сможет вам звонить, если в настройках приватности не разрешены звонки от всех.',
			'screenCalls.title' => 'Звонки',
			'screenCalls.empty' => 'Здесь появятся ваши звонки',
			'screenCalls.emptyMissed' => 'Нет пропущенных звонков',
			'screenCalls.permissionTitle' => 'Нужен доступ к микрофону',
			'screenCalls.permissionMessage' => 'Разрешите доступ к микрофону, чтобы совершать и принимать звонки в Iperon.',
			'screenCalls.notificationPermissionTitle' => 'Включите уведомления о звонках',
			'screenCalls.notificationPermissionMessage' => 'Разрешите уведомления, чтобы видеть входящие звонки, даже когда Iperon свёрнут.',
			'screenCalls.permissionsTitle' => 'Настройка звонков',
			'screenCalls.permissionsMessage' => 'Разрешите доступ к микрофону и уведомлениям, чтобы совершать звонки и видеть входящие в Iperon.',
			'screenCalls.pipPermissionTitle' => 'Мини-окно во время звонка',
			'screenCalls.pipPermissionMessage' => 'Разрешите «Картинку в картинке», чтобы видеозвонок продолжался в маленьком окне поверх экрана, когда вы сворачиваете Iperon.',
			'screenCalls.allowAccess' => 'Разрешить доступ',
			'screenCalls.openSettings' => 'Открыть настройки',
			'screenCalls.search' => 'Поиск',
			'screenCalls.filterAll' => 'Все',
			'screenCalls.filterMissed' => 'Пропущенные',
			'screenCalls.incoming' => 'Входящий',
			'screenCalls.outgoing' => 'Исходящий',
			'screenCalls.missed' => 'Пропущенный',
			'screenCalls.cancelled' => 'Отменённый',
			'screenCalls.durationSec' => ({required Object s}) => '${s} сек',
			'screenCalls.durationMin' => ({required Object m}) => '${m} мин',
			'screenCalls.durationHour' => ({required Object h}) => '${h} час',
			'screenCalls.durationHourMin' => ({required Object h, required Object m}) => '${h} час ${m} мин',
			'screenCalls.unknown' => 'Неизвестный',
			'screenCalls.delete' => 'Удалить',
			'screenCalls.clear' => 'Очистить',
			'screenCalls.clearTitle' => 'Очистить историю звонков?',
			'screenCalls.clearMessage' => 'Все записи о звонках будут удалены. Это действие необратимо.',
			'screenAuth.enterYourMobilePhoneNumber' => 'Введите номер мобильного телефона',
			'screenAuth.currentlyWeOnlySupportPhoneNumbersFromRussianMobileOperators' => 'Сейчас мы поддерживаем только номера российских мобильных операторов',
			'screenAuth.insertDebugPhone' => 'Вставить тестовый номер',
			'screenAuth.callForFree' => 'Позвонить бесплатно',
			'screenAuth.weAreExpectingYourCallWithin' => ({required Object duration}) => 'Мы ждём вашего звонка в течение ${duration}',
			'screenAuth.signInWith' => 'Войти через',
			'screenAuth.kContinue' => _root.common.kContinue,
			'screenAuth.invalidPhoneNumber' => 'Неверный номер телефона',
			'screenAuthModerationApplicationStore.verificationCodeMismatch' => 'Неверный код подтверждения',
			'screenAuthModerationApplicationStore.moderationApplicationStoreSessionNotFound' => 'Сессия не найдена',
			'screenAuthModerationApplicationStore.invalidPublicSharedKey' => 'Неверный публичный общий ключ',
			'screenAuthModerationApplicationStore.invalidPublicSaltKey' => 'Неверный публичный ключ соли',
			'screenAuthModerationApplicationStore.enterTheCode' => 'Введите код',
			'screenAuthModerationApplicationStore.sentConfirmationCodeToNumber' => ({required Object phoneNumber}) => 'Мы отправили код подтверждения на номер ${phoneNumber}',
			'screenAuthModerationApplicationStore.signatureVerificationFailed' => 'Не удалось проверить подпись',
			'screenAuthCallpasswordConfirmation.weAreExpectingYourCallWithin' => ({required Object duration}) => 'Мы ждём вашего звонка в течение ${duration}',
			'screenAuthCallpasswordConfirmation.confirmYourNumberDetail' => ({required Object confirmationPhoneNumberRu}) => 'Позвоните на номер ${confirmationPhoneNumberRu} с указанного вами номера телефона и дождитесь сброса вызова.',
			'screenAuthCallpasswordConfirmation.callForFree' => 'Позвонить бесплатно',
			'screenAuthCallpasswordConfirmation.signatureVerificationFailed' => 'Не удалось проверить подпись',
			'grpcError.errorConnectingServer' => 'Ошибка подключения к серверу',
			'grpcError.unauthenticated' => 'Неавторизован',
			'grpcError.unableConnectServer' => 'Не удалось подключиться к серверу',
			'grpcError.internalServerError' => 'Внутренняя ошибка сервера',
			'grpcError.unknownError' => 'Unknown error',
			'dateTime.relativeDateTimeToday' => ({required Object time}) => 'сегодня в ${time}',
			'dateTime.relativeDateTimeYesterday' => ({required Object time}) => 'вчера в ${time}',
			'dateTime.relativeDateTimeOther' => ({required Object date, required Object time}) => '${date} в ${time}',
			'screenCall.title' => 'Звонок',
			'screenCall.returnToCall' => 'Коснитесь, чтобы вернуться к звонку',
			'screenCall.bannerRinging' => 'Вызов',
			'screenCall.bannerActive' => 'Идёт разговор',
			'screenCall.incomingAudio' => 'Входящий звонок',
			'screenCall.incomingVideo' => 'Входящий видеозвонок',
			'screenCall.calling' => 'Вызов…',
			'screenCall.connecting' => 'Соединение…',
			'screenCall.talking' => 'Идёт разговор',
			'screenCall.endedRejected' => 'Звонок отклонён',
			'screenCall.endedFailed' => 'Не удалось соединиться',
			'screenCall.endedBusy' => 'Занято',
			'screenCall.endedNotAllowed' => 'Нельзя позвонить этому пользователю',
			'screenCall.notAllowedTitle' => 'Звонок недоступен',
			'screenCall.notAllowedMessage' => 'Этот пользователь принимает звонки только от своих контактов. Чтобы вы могли позвонить, он должен добавить вас в контакты.',
			'screenCall.deviceBusyTitle' => 'Вы уже в звонке',
			'screenCall.deviceBusyMessage' => 'Телефон занят другим звонком. Завершите текущий звонок, чтобы позвонить.',
			'screenCall.endedNoConnection' => 'Нет соединения с интернетом',
			'screenCall.endedUnavailable' => 'Абонент недоступен',
			'screenCall.ended' => 'Звонок завершён',
			'screenCall.decline' => 'Отклонить',
			'screenCall.accept' => 'Принять',
			'screenCall.hangup' => 'Завершить',
			'screenCall.micOn' => 'Вкл. звук',
			'screenCall.micOff' => 'Выкл. звук',
			'screenCall.speakerOn' => 'Вкл. динамик',
			'screenCall.speakerOff' => 'Выкл. динамик',
			'screenCall.audioOutput' => 'Динамик',
			'screenCall.audioOutputTitle' => 'Вывод звука',
			'screenCall.routeEarpiece' => 'Телефон',
			'screenCall.routeSpeaker' => 'Динамик',
			'screenCall.routeWiredHeadset' => 'Наушники',
			'screenCall.routeBluetooth' => 'Bluetooth',
			'screenCall.routeHearingAid' => 'Слуховой аппарат',
			'screenCall.routeCar' => 'Автомобиль',
			'screenCall.routeUnknown' => 'Другое',
			'screenCall.routeUnavailable' => 'Нет доступных аудиовыходов',
			'screenCall.cameraOn' => 'Вкл. камеру',
			'screenCall.cameraOff' => 'Выкл. камеру',
			'screenCall.startVideo' => 'Видео',
			'screenCall.switchCamera' => 'Сменить камеру',
			'screenCall.qualityPoor' => 'Слабый сигнал',
			'screenCall.qualityGood' => 'Хорошее соединение',
			'screenCall.qualityExcellent' => 'Отличное соединение',
			'screenCall.remoteMicMuted' => 'Микрофон собеседника выключен',
			'screenCall.encrypted' => 'Сквозное шифрование',
			'screenCall.notEncrypted' => 'Без сквозного шифрования',
			'screenCall.verifyEmoji' => 'Сверьте эмодзи с собеседником',
			'passkey.title' => 'Ключи доступа',
			'passkey.description' => 'Ключи доступа надёжно хранятся в вашем менеджере паролей.',
			'passkey.add' => 'Добавить ключ',
			'passkey.genericName' => 'Ключ доступа',
			'passkey.created' => ({required Object date}) => 'Добавлен ${date}',
			'passkey.lastUsed' => ({required Object date}) => 'Вход ${date}',
			'passkey.alreadyOnThisDevice' => 'На этом устройстве уже есть ключ доступа для этого аккаунта. Добавьте ключ на другом устройстве или в другом менеджере паролей.',
			'passkey.delete' => 'Удалить',
			'passkey.deleteConfirmTitle' => 'Удалить ключ доступа?',
			'passkey.deleteConfirmMessage' => 'Войти с помощью этого ключа больше не получится.',
			'passkey.loadError' => 'Не удалось загрузить ключи',
			'passkey.retry' => 'Повторить',
			'passkey.verificationFailed' => 'Не удалось проверить ключ. Попробуйте ещё раз.',
			'passkey.ceremonyExpired' => 'Срок запроса истёк. Попробуйте ещё раз.',
			'passkey.unknownCredential' => 'Этот ключ не распознан.',
			'passkey.alreadyRegistered' => 'Этот ключ уже зарегистрирован.',
			'passkey.notFound' => 'Ключ не найден.',
			'yandex.failed' => 'Не удалось войти через Яндекс. Попробуйте ещё раз.',
			'yandex.invalidToken' => 'Не удалось подтвердить вход через Яндекс. Попробуйте ещё раз.',
			'yandex.phoneMissing' => 'К аккаунту Яндекс ID не привязан номер телефона. Добавьте его в Яндекс ID или войдите по номеру.',
			'yandex.invalidPhone' => 'Номер телефона в Яндекс ID не подходит для входа. Войдите по номеру.',
			'yandex.unavailable' => 'Яндекс ID сейчас недоступен. Попробуйте позже.',
			_ => null,
		};
	}
}
