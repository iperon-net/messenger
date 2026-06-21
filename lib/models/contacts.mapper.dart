// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
// ignore_for_file: type=lint
// ignore_for_file: invalid_use_of_protected_member
// ignore_for_file: unused_element, unnecessary_cast, override_on_non_overriding_member
// ignore_for_file: strict_raw_type, inference_failure_on_untyped_parameter

part of 'contacts.dart';

class ContactPhoneNumberMapper extends ClassMapperBase<ContactPhoneNumber> {
  ContactPhoneNumberMapper._();

  static ContactPhoneNumberMapper? _instance;
  static ContactPhoneNumberMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = ContactPhoneNumberMapper._());
      MapperContainer.globals.useAll([BoolMapper()]);
    }
    return _instance!;
  }

  @override
  final String id = 'ContactPhoneNumber';

  static String _$international(ContactPhoneNumber v) => v.international;
  static const Field<ContactPhoneNumber, String> _f$international = Field(
    'international',
    _$international,
  );
  static String _$national(ContactPhoneNumber v) => v.national;
  static const Field<ContactPhoneNumber, String> _f$national = Field(
    'national',
    _$national,
  );
  static String _$e164(ContactPhoneNumber v) => v.e164;
  static const Field<ContactPhoneNumber, String> _f$e164 = Field(
    'e164',
    _$e164,
  );
  static String _$rfc3966(ContactPhoneNumber v) => v.rfc3966;
  static const Field<ContactPhoneNumber, String> _f$rfc3966 = Field(
    'rfc3966',
    _$rfc3966,
  );

  @override
  final MappableFields<ContactPhoneNumber> fields = const {
    #international: _f$international,
    #national: _f$national,
    #e164: _f$e164,
    #rfc3966: _f$rfc3966,
  };

  static ContactPhoneNumber _instantiate(DecodingData data) {
    return ContactPhoneNumber(
      international: data.dec(_f$international),
      national: data.dec(_f$national),
      e164: data.dec(_f$e164),
      rfc3966: data.dec(_f$rfc3966),
    );
  }

  @override
  final Function instantiate = _instantiate;

  static ContactPhoneNumber fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<ContactPhoneNumber>(map);
  }

  static ContactPhoneNumber fromJson(String json) {
    return ensureInitialized().decodeJson<ContactPhoneNumber>(json);
  }
}

mixin ContactPhoneNumberMappable {
  String toJson() {
    return ContactPhoneNumberMapper.ensureInitialized()
        .encodeJson<ContactPhoneNumber>(this as ContactPhoneNumber);
  }

  Map<String, dynamic> toMap() {
    return ContactPhoneNumberMapper.ensureInitialized()
        .encodeMap<ContactPhoneNumber>(this as ContactPhoneNumber);
  }

  ContactPhoneNumberCopyWith<
    ContactPhoneNumber,
    ContactPhoneNumber,
    ContactPhoneNumber
  >
  get copyWith =>
      _ContactPhoneNumberCopyWithImpl<ContactPhoneNumber, ContactPhoneNumber>(
        this as ContactPhoneNumber,
        $identity,
        $identity,
      );
  @override
  String toString() {
    return ContactPhoneNumberMapper.ensureInitialized().stringifyValue(
      this as ContactPhoneNumber,
    );
  }

  @override
  bool operator ==(Object other) {
    return ContactPhoneNumberMapper.ensureInitialized().equalsValue(
      this as ContactPhoneNumber,
      other,
    );
  }

  @override
  int get hashCode {
    return ContactPhoneNumberMapper.ensureInitialized().hashValue(
      this as ContactPhoneNumber,
    );
  }
}

extension ContactPhoneNumberValueCopy<$R, $Out>
    on ObjectCopyWith<$R, ContactPhoneNumber, $Out> {
  ContactPhoneNumberCopyWith<$R, ContactPhoneNumber, $Out>
  get $asContactPhoneNumber => $base.as(
    (v, t, t2) => _ContactPhoneNumberCopyWithImpl<$R, $Out>(v, t, t2),
  );
}

abstract class ContactPhoneNumberCopyWith<
  $R,
  $In extends ContactPhoneNumber,
  $Out
>
    implements ClassCopyWith<$R, $In, $Out> {
  $R call({
    String? international,
    String? national,
    String? e164,
    String? rfc3966,
  });
  ContactPhoneNumberCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  );
}

class _ContactPhoneNumberCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, ContactPhoneNumber, $Out>
    implements ContactPhoneNumberCopyWith<$R, ContactPhoneNumber, $Out> {
  _ContactPhoneNumberCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<ContactPhoneNumber> $mapper =
      ContactPhoneNumberMapper.ensureInitialized();
  @override
  $R call({
    String? international,
    String? national,
    String? e164,
    String? rfc3966,
  }) => $apply(
    FieldCopyWithData({
      if (international != null) #international: international,
      if (national != null) #national: national,
      if (e164 != null) #e164: e164,
      if (rfc3966 != null) #rfc3966: rfc3966,
    }),
  );
  @override
  ContactPhoneNumber $make(CopyWithData data) => ContactPhoneNumber(
    international: data.get(#international, or: $value.international),
    national: data.get(#national, or: $value.national),
    e164: data.get(#e164, or: $value.e164),
    rfc3966: data.get(#rfc3966, or: $value.rfc3966),
  );

  @override
  ContactPhoneNumberCopyWith<$R2, ContactPhoneNumber, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  ) => _ContactPhoneNumberCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

class ContactMapper extends ClassMapperBase<Contact> {
  ContactMapper._();

  static ContactMapper? _instance;
  static ContactMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = ContactMapper._());
      MapperContainer.globals.useAll([BoolMapper()]);
      ContactPhoneNumberMapper.ensureInitialized();
    }
    return _instance!;
  }

  @override
  final String id = 'Contact';

  static String _$contactID(Contact v) => v.contactID;
  static const Field<Contact, String> _f$contactID = Field(
    'contactID',
    _$contactID,
    opt: true,
    def: "",
  );
  static List<int> _$userID(Contact v) => v.userID;
  static const Field<Contact, List<int>> _f$userID = Field(
    'userID',
    _$userID,
    opt: true,
    def: const [],
  );
  static String _$firstName(Contact v) => v.firstName;
  static const Field<Contact, String> _f$firstName = Field(
    'firstName',
    _$firstName,
    opt: true,
    def: "",
  );
  static String _$lastName(Contact v) => v.lastName;
  static const Field<Contact, String> _f$lastName = Field(
    'lastName',
    _$lastName,
    opt: true,
    def: "",
  );
  static DateTime _$lastSeenAt(Contact v) => v.lastSeenAt;
  static const Field<Contact, DateTime> _f$lastSeenAt = Field(
    'lastSeenAt',
    _$lastSeenAt,
    opt: true,
  );
  static bool _$isOnline(Contact v) => v.isOnline;
  static const Field<Contact, bool> _f$isOnline = Field(
    'isOnline',
    _$isOnline,
    opt: true,
    def: false,
  );
  static List<ContactPhoneNumber> _$phoneNumbers(Contact v) => v.phoneNumbers;
  static const Field<Contact, List<ContactPhoneNumber>> _f$phoneNumbers = Field(
    'phoneNumbers',
    _$phoneNumbers,
    opt: true,
    def: const [],
  );
  static String _$username(Contact v) => v.username;
  static const Field<Contact, String> _f$username = Field(
    'username',
    _$username,
    opt: true,
    def: "",
  );
  static DateTime _$birthDate(Contact v) => v.birthDate;
  static const Field<Contact, DateTime> _f$birthDate = Field(
    'birthDate',
    _$birthDate,
    opt: true,
  );
  static int _$avatarColor(Contact v) => v.avatarColor;
  static const Field<Contact, int> _f$avatarColor = Field(
    'avatarColor',
    _$avatarColor,
    opt: true,
    def: 0,
  );

  @override
  final MappableFields<Contact> fields = const {
    #contactID: _f$contactID,
    #userID: _f$userID,
    #firstName: _f$firstName,
    #lastName: _f$lastName,
    #lastSeenAt: _f$lastSeenAt,
    #isOnline: _f$isOnline,
    #phoneNumbers: _f$phoneNumbers,
    #username: _f$username,
    #birthDate: _f$birthDate,
    #avatarColor: _f$avatarColor,
  };

  static Contact _instantiate(DecodingData data) {
    return Contact(
      contactID: data.dec(_f$contactID),
      userID: data.dec(_f$userID),
      firstName: data.dec(_f$firstName),
      lastName: data.dec(_f$lastName),
      lastSeenAt: data.dec(_f$lastSeenAt),
      isOnline: data.dec(_f$isOnline),
      phoneNumbers: data.dec(_f$phoneNumbers),
      username: data.dec(_f$username),
      birthDate: data.dec(_f$birthDate),
      avatarColor: data.dec(_f$avatarColor),
    );
  }

  @override
  final Function instantiate = _instantiate;

  static Contact fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<Contact>(map);
  }

  static Contact fromJson(String json) {
    return ensureInitialized().decodeJson<Contact>(json);
  }
}

mixin ContactMappable {
  String toJson() {
    return ContactMapper.ensureInitialized().encodeJson<Contact>(
      this as Contact,
    );
  }

  Map<String, dynamic> toMap() {
    return ContactMapper.ensureInitialized().encodeMap<Contact>(
      this as Contact,
    );
  }

  ContactCopyWith<Contact, Contact, Contact> get copyWith =>
      _ContactCopyWithImpl<Contact, Contact>(
        this as Contact,
        $identity,
        $identity,
      );
  @override
  String toString() {
    return ContactMapper.ensureInitialized().stringifyValue(this as Contact);
  }

  @override
  bool operator ==(Object other) {
    return ContactMapper.ensureInitialized().equalsValue(
      this as Contact,
      other,
    );
  }

  @override
  int get hashCode {
    return ContactMapper.ensureInitialized().hashValue(this as Contact);
  }
}

extension ContactValueCopy<$R, $Out> on ObjectCopyWith<$R, Contact, $Out> {
  ContactCopyWith<$R, Contact, $Out> get $asContact =>
      $base.as((v, t, t2) => _ContactCopyWithImpl<$R, $Out>(v, t, t2));
}

abstract class ContactCopyWith<$R, $In extends Contact, $Out>
    implements ClassCopyWith<$R, $In, $Out> {
  ListCopyWith<$R, int, ObjectCopyWith<$R, int, int>> get userID;
  ListCopyWith<
    $R,
    ContactPhoneNumber,
    ContactPhoneNumberCopyWith<$R, ContactPhoneNumber, ContactPhoneNumber>
  >
  get phoneNumbers;
  $R call({
    String? contactID,
    List<int>? userID,
    String? firstName,
    String? lastName,
    DateTime? lastSeenAt,
    bool? isOnline,
    List<ContactPhoneNumber>? phoneNumbers,
    String? username,
    DateTime? birthDate,
    int? avatarColor,
  });
  ContactCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(Then<$Out2, $R2> t);
}

class _ContactCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, Contact, $Out>
    implements ContactCopyWith<$R, Contact, $Out> {
  _ContactCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<Contact> $mapper =
      ContactMapper.ensureInitialized();
  @override
  ListCopyWith<$R, int, ObjectCopyWith<$R, int, int>> get userID =>
      ListCopyWith(
        $value.userID,
        (v, t) => ObjectCopyWith(v, $identity, t),
        (v) => call(userID: v),
      );
  @override
  ListCopyWith<
    $R,
    ContactPhoneNumber,
    ContactPhoneNumberCopyWith<$R, ContactPhoneNumber, ContactPhoneNumber>
  >
  get phoneNumbers => ListCopyWith(
    $value.phoneNumbers,
    (v, t) => v.copyWith.$chain(t),
    (v) => call(phoneNumbers: v),
  );
  @override
  $R call({
    String? contactID,
    List<int>? userID,
    String? firstName,
    String? lastName,
    Object? lastSeenAt = $none,
    bool? isOnline,
    List<ContactPhoneNumber>? phoneNumbers,
    String? username,
    Object? birthDate = $none,
    int? avatarColor,
  }) => $apply(
    FieldCopyWithData({
      if (contactID != null) #contactID: contactID,
      if (userID != null) #userID: userID,
      if (firstName != null) #firstName: firstName,
      if (lastName != null) #lastName: lastName,
      if (lastSeenAt != $none) #lastSeenAt: lastSeenAt,
      if (isOnline != null) #isOnline: isOnline,
      if (phoneNumbers != null) #phoneNumbers: phoneNumbers,
      if (username != null) #username: username,
      if (birthDate != $none) #birthDate: birthDate,
      if (avatarColor != null) #avatarColor: avatarColor,
    }),
  );
  @override
  Contact $make(CopyWithData data) => Contact(
    contactID: data.get(#contactID, or: $value.contactID),
    userID: data.get(#userID, or: $value.userID),
    firstName: data.get(#firstName, or: $value.firstName),
    lastName: data.get(#lastName, or: $value.lastName),
    lastSeenAt: data.get(#lastSeenAt, or: $value.lastSeenAt),
    isOnline: data.get(#isOnline, or: $value.isOnline),
    phoneNumbers: data.get(#phoneNumbers, or: $value.phoneNumbers),
    username: data.get(#username, or: $value.username),
    birthDate: data.get(#birthDate, or: $value.birthDate),
    avatarColor: data.get(#avatarColor, or: $value.avatarColor),
  );

  @override
  ContactCopyWith<$R2, Contact, $Out2> $chain<$R2, $Out2>(Then<$Out2, $R2> t) =>
      _ContactCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

