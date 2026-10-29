// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
// ignore_for_file: type=lint
// ignore_for_file: invalid_use_of_protected_member
// ignore_for_file: unused_element, unnecessary_cast, override_on_non_overriding_member
// ignore_for_file: strict_raw_type, inference_failure_on_untyped_parameter

part of 'profile_state.dart';

class ProfileStateMapper extends ClassMapperBase<ProfileState> {
  ProfileStateMapper._();

  static ProfileStateMapper? _instance;
  static ProfileStateMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = ProfileStateMapper._());
      MapperContainer.globals.useAll([Uint8ListMapper()]);
    }
    return _instance!;
  }

  @override
  final String id = 'ProfileState';

  static Status _$status(ProfileState v) => v.status;
  static const Field<ProfileState, Status> _f$status = Field(
    'status',
    _$status,
    opt: true,
    def: Status.initialization,
  );
  static String _$error(ProfileState v) => v.error;
  static const Field<ProfileState, String> _f$error = Field(
    'error',
    _$error,
    opt: true,
    def: "",
  );
  static AppLocale _$locale(ProfileState v) => v.locale;
  static const Field<ProfileState, AppLocale> _f$locale = Field(
    'locale',
    _$locale,
    opt: true,
    def: AppLocale.en,
  );
  static List<int> _$userID(ProfileState v) => v.userID;
  static const Field<ProfileState, List<int>> _f$userID = Field(
    'userID',
    _$userID,
    opt: true,
    def: const [],
  );
  static String _$displayName(ProfileState v) => v.displayName;
  static const Field<ProfileState, String> _f$displayName = Field(
    'displayName',
    _$displayName,
    opt: true,
    def: "",
  );
  static String _$firstName(ProfileState v) => v.firstName;
  static const Field<ProfileState, String> _f$firstName = Field(
    'firstName',
    _$firstName,
    opt: true,
    def: "",
  );
  static String _$lastName(ProfileState v) => v.lastName;
  static const Field<ProfileState, String> _f$lastName = Field(
    'lastName',
    _$lastName,
    opt: true,
    def: "",
  );
  static String _$aboutMe(ProfileState v) => v.aboutMe;
  static const Field<ProfileState, String> _f$aboutMe = Field(
    'aboutMe',
    _$aboutMe,
    opt: true,
    def: "",
  );
  static DateTime? _$birthDate(ProfileState v) => v.birthDate;
  static const Field<ProfileState, DateTime> _f$birthDate = Field(
    'birthDate',
    _$birthDate,
    opt: true,
  );
  static bool _$hideBirthYear(ProfileState v) => v.hideBirthYear;
  static const Field<ProfileState, bool> _f$hideBirthYear = Field(
    'hideBirthYear',
    _$hideBirthYear,
    opt: true,
    def: false,
  );
  static String _$username(ProfileState v) => v.username;
  static const Field<ProfileState, String> _f$username = Field(
    'username',
    _$username,
    opt: true,
    def: "",
  );
  static String _$phoneNumber(ProfileState v) => v.phoneNumber;
  static const Field<ProfileState, String> _f$phoneNumber = Field(
    'phoneNumber',
    _$phoneNumber,
    opt: true,
    def: "",
  );
  static String _$boringAvatarHash(ProfileState v) => v.boringAvatarHash;
  static const Field<ProfileState, String> _f$boringAvatarHash = Field(
    'boringAvatarHash',
    _$boringAvatarHash,
    opt: true,
    def: "",
  );
  static BoringAvatarType _$boringAvatarType(ProfileState v) =>
      v.boringAvatarType;
  static const Field<ProfileState, BoringAvatarType> _f$boringAvatarType =
      Field(
        'boringAvatarType',
        _$boringAvatarType,
        opt: true,
        def: BoringAvatarType.ring,
      );
  static Uint8List? _$avatarBytes(ProfileState v) => v.avatarBytes;
  static const Field<ProfileState, Uint8List> _f$avatarBytes = Field(
    'avatarBytes',
    _$avatarBytes,
    opt: true,
  );
  static String _$avatarThumbhash(ProfileState v) => v.avatarThumbhash;
  static const Field<ProfileState, String> _f$avatarThumbhash = Field(
    'avatarThumbhash',
    _$avatarThumbhash,
    opt: true,
    def: "",
  );
  static bool _$online(ProfileState v) => v.online;
  static const Field<ProfileState, bool> _f$online = Field(
    'online',
    _$online,
    opt: true,
    def: false,
  );
  static DateTime? _$lastSeen(ProfileState v) => v.lastSeen;
  static const Field<ProfileState, DateTime> _f$lastSeen = Field(
    'lastSeen',
    _$lastSeen,
    opt: true,
  );
  static String _$chatID(ProfileState v) => v.chatID;
  static const Field<ProfileState, String> _f$chatID = Field(
    'chatID',
    _$chatID,
    opt: true,
    def: "",
  );
  static bool _$chatResolved(ProfileState v) => v.chatResolved;
  static const Field<ProfileState, bool> _f$chatResolved = Field(
    'chatResolved',
    _$chatResolved,
    opt: true,
    def: false,
  );
  static String _$contactPhoneE164(ProfileState v) => v.contactPhoneE164;
  static const Field<ProfileState, String> _f$contactPhoneE164 = Field(
    'contactPhoneE164',
    _$contactPhoneE164,
    opt: true,
    def: "",
  );
  static String _$contactName(ProfileState v) => v.contactName;
  static const Field<ProfileState, String> _f$contactName = Field(
    'contactName',
    _$contactName,
    opt: true,
    def: "",
  );
  static bool _$contactCloud(ProfileState v) => v.contactCloud;
  static const Field<ProfileState, bool> _f$contactCloud = Field(
    'contactCloud',
    _$contactCloud,
    opt: true,
    def: false,
  );
  static bool _$blocked(ProfileState v) => v.blocked;
  static const Field<ProfileState, bool> _f$blocked = Field(
    'blocked',
    _$blocked,
    opt: true,
    def: false,
  );
  static bool _$accountBlocked(ProfileState v) => v.accountBlocked;
  static const Field<ProfileState, bool> _f$accountBlocked = Field(
    'accountBlocked',
    _$accountBlocked,
    opt: true,
    def: false,
  );

  @override
  final MappableFields<ProfileState> fields = const {
    #status: _f$status,
    #error: _f$error,
    #locale: _f$locale,
    #userID: _f$userID,
    #displayName: _f$displayName,
    #firstName: _f$firstName,
    #lastName: _f$lastName,
    #aboutMe: _f$aboutMe,
    #birthDate: _f$birthDate,
    #hideBirthYear: _f$hideBirthYear,
    #username: _f$username,
    #phoneNumber: _f$phoneNumber,
    #boringAvatarHash: _f$boringAvatarHash,
    #boringAvatarType: _f$boringAvatarType,
    #avatarBytes: _f$avatarBytes,
    #avatarThumbhash: _f$avatarThumbhash,
    #online: _f$online,
    #lastSeen: _f$lastSeen,
    #chatID: _f$chatID,
    #chatResolved: _f$chatResolved,
    #contactPhoneE164: _f$contactPhoneE164,
    #contactName: _f$contactName,
    #contactCloud: _f$contactCloud,
    #blocked: _f$blocked,
    #accountBlocked: _f$accountBlocked,
  };

  static ProfileState _instantiate(DecodingData data) {
    return ProfileState(
      status: data.dec(_f$status),
      error: data.dec(_f$error),
      locale: data.dec(_f$locale),
      userID: data.dec(_f$userID),
      displayName: data.dec(_f$displayName),
      firstName: data.dec(_f$firstName),
      lastName: data.dec(_f$lastName),
      aboutMe: data.dec(_f$aboutMe),
      birthDate: data.dec(_f$birthDate),
      hideBirthYear: data.dec(_f$hideBirthYear),
      username: data.dec(_f$username),
      phoneNumber: data.dec(_f$phoneNumber),
      boringAvatarHash: data.dec(_f$boringAvatarHash),
      boringAvatarType: data.dec(_f$boringAvatarType),
      avatarBytes: data.dec(_f$avatarBytes),
      avatarThumbhash: data.dec(_f$avatarThumbhash),
      online: data.dec(_f$online),
      lastSeen: data.dec(_f$lastSeen),
      chatID: data.dec(_f$chatID),
      chatResolved: data.dec(_f$chatResolved),
      contactPhoneE164: data.dec(_f$contactPhoneE164),
      contactName: data.dec(_f$contactName),
      contactCloud: data.dec(_f$contactCloud),
      blocked: data.dec(_f$blocked),
      accountBlocked: data.dec(_f$accountBlocked),
    );
  }

  @override
  final Function instantiate = _instantiate;

  static ProfileState fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<ProfileState>(map);
  }

  static ProfileState fromJson(String json) {
    return ensureInitialized().decodeJson<ProfileState>(json);
  }
}

mixin ProfileStateMappable {
  String toJson() {
    return ProfileStateMapper.ensureInitialized().encodeJson<ProfileState>(
      this as ProfileState,
    );
  }

  Map<String, dynamic> toMap() {
    return ProfileStateMapper.ensureInitialized().encodeMap<ProfileState>(
      this as ProfileState,
    );
  }

  ProfileStateCopyWith<ProfileState, ProfileState, ProfileState> get copyWith =>
      _ProfileStateCopyWithImpl<ProfileState, ProfileState>(
        this as ProfileState,
        $identity,
        $identity,
      );
  @override
  String toString() {
    return ProfileStateMapper.ensureInitialized().stringifyValue(
      this as ProfileState,
    );
  }

  @override
  bool operator ==(Object other) {
    return ProfileStateMapper.ensureInitialized().equalsValue(
      this as ProfileState,
      other,
    );
  }

  @override
  int get hashCode {
    return ProfileStateMapper.ensureInitialized().hashValue(
      this as ProfileState,
    );
  }
}

extension ProfileStateValueCopy<$R, $Out>
    on ObjectCopyWith<$R, ProfileState, $Out> {
  ProfileStateCopyWith<$R, ProfileState, $Out> get $asProfileState =>
      $base.as((v, t, t2) => _ProfileStateCopyWithImpl<$R, $Out>(v, t, t2));
}

abstract class ProfileStateCopyWith<$R, $In extends ProfileState, $Out>
    implements ClassCopyWith<$R, $In, $Out> {
  ListCopyWith<$R, int, ObjectCopyWith<$R, int, int>> get userID;
  $R call({
    Status? status,
    String? error,
    AppLocale? locale,
    List<int>? userID,
    String? displayName,
    String? firstName,
    String? lastName,
    String? aboutMe,
    DateTime? birthDate,
    bool? hideBirthYear,
    String? username,
    String? phoneNumber,
    String? boringAvatarHash,
    BoringAvatarType? boringAvatarType,
    Uint8List? avatarBytes,
    String? avatarThumbhash,
    bool? online,
    DateTime? lastSeen,
    String? chatID,
    bool? chatResolved,
    String? contactPhoneE164,
    String? contactName,
    bool? contactCloud,
    bool? blocked,
    bool? accountBlocked,
  });
  ProfileStateCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(Then<$Out2, $R2> t);
}

class _ProfileStateCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, ProfileState, $Out>
    implements ProfileStateCopyWith<$R, ProfileState, $Out> {
  _ProfileStateCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<ProfileState> $mapper =
      ProfileStateMapper.ensureInitialized();
  @override
  ListCopyWith<$R, int, ObjectCopyWith<$R, int, int>> get userID =>
      ListCopyWith(
        $value.userID,
        (v, t) => ObjectCopyWith(v, $identity, t),
        (v) => call(userID: v),
      );
  @override
  $R call({
    Status? status,
    String? error,
    AppLocale? locale,
    List<int>? userID,
    String? displayName,
    String? firstName,
    String? lastName,
    String? aboutMe,
    Object? birthDate = $none,
    bool? hideBirthYear,
    String? username,
    String? phoneNumber,
    String? boringAvatarHash,
    BoringAvatarType? boringAvatarType,
    Object? avatarBytes = $none,
    String? avatarThumbhash,
    bool? online,
    Object? lastSeen = $none,
    String? chatID,
    bool? chatResolved,
    String? contactPhoneE164,
    String? contactName,
    bool? contactCloud,
    bool? blocked,
    bool? accountBlocked,
  }) => $apply(
    FieldCopyWithData({
      if (status != null) #status: status,
      if (error != null) #error: error,
      if (locale != null) #locale: locale,
      if (userID != null) #userID: userID,
      if (displayName != null) #displayName: displayName,
      if (firstName != null) #firstName: firstName,
      if (lastName != null) #lastName: lastName,
      if (aboutMe != null) #aboutMe: aboutMe,
      if (birthDate != $none) #birthDate: birthDate,
      if (hideBirthYear != null) #hideBirthYear: hideBirthYear,
      if (username != null) #username: username,
      if (phoneNumber != null) #phoneNumber: phoneNumber,
      if (boringAvatarHash != null) #boringAvatarHash: boringAvatarHash,
      if (boringAvatarType != null) #boringAvatarType: boringAvatarType,
      if (avatarBytes != $none) #avatarBytes: avatarBytes,
      if (avatarThumbhash != null) #avatarThumbhash: avatarThumbhash,
      if (online != null) #online: online,
      if (lastSeen != $none) #lastSeen: lastSeen,
      if (chatID != null) #chatID: chatID,
      if (chatResolved != null) #chatResolved: chatResolved,
      if (contactPhoneE164 != null) #contactPhoneE164: contactPhoneE164,
      if (contactName != null) #contactName: contactName,
      if (contactCloud != null) #contactCloud: contactCloud,
      if (blocked != null) #blocked: blocked,
      if (accountBlocked != null) #accountBlocked: accountBlocked,
    }),
  );
  @override
  ProfileState $make(CopyWithData data) => ProfileState(
    status: data.get(#status, or: $value.status),
    error: data.get(#error, or: $value.error),
    locale: data.get(#locale, or: $value.locale),
    userID: data.get(#userID, or: $value.userID),
    displayName: data.get(#displayName, or: $value.displayName),
    firstName: data.get(#firstName, or: $value.firstName),
    lastName: data.get(#lastName, or: $value.lastName),
    aboutMe: data.get(#aboutMe, or: $value.aboutMe),
    birthDate: data.get(#birthDate, or: $value.birthDate),
    hideBirthYear: data.get(#hideBirthYear, or: $value.hideBirthYear),
    username: data.get(#username, or: $value.username),
    phoneNumber: data.get(#phoneNumber, or: $value.phoneNumber),
    boringAvatarHash: data.get(#boringAvatarHash, or: $value.boringAvatarHash),
    boringAvatarType: data.get(#boringAvatarType, or: $value.boringAvatarType),
    avatarBytes: data.get(#avatarBytes, or: $value.avatarBytes),
    avatarThumbhash: data.get(#avatarThumbhash, or: $value.avatarThumbhash),
    online: data.get(#online, or: $value.online),
    lastSeen: data.get(#lastSeen, or: $value.lastSeen),
    chatID: data.get(#chatID, or: $value.chatID),
    chatResolved: data.get(#chatResolved, or: $value.chatResolved),
    contactPhoneE164: data.get(#contactPhoneE164, or: $value.contactPhoneE164),
    contactName: data.get(#contactName, or: $value.contactName),
    contactCloud: data.get(#contactCloud, or: $value.contactCloud),
    blocked: data.get(#blocked, or: $value.blocked),
    accountBlocked: data.get(#accountBlocked, or: $value.accountBlocked),
  );

  @override
  ProfileStateCopyWith<$R2, ProfileState, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  ) => _ProfileStateCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

