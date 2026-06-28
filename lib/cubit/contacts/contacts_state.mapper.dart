// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
// ignore_for_file: type=lint
// ignore_for_file: invalid_use_of_protected_member
// ignore_for_file: unused_element, unnecessary_cast, override_on_non_overriding_member
// ignore_for_file: strict_raw_type, inference_failure_on_untyped_parameter

part of 'contacts_state.dart';

class ContactsStateMapper extends ClassMapperBase<ContactsState> {
  ContactsStateMapper._();

  static ContactsStateMapper? _instance;
  static ContactsStateMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = ContactsStateMapper._());
    }
    return _instance!;
  }

  @override
  final String id = 'ContactsState';

  static Status _$status(ContactsState v) => v.status;
  static const Field<ContactsState, Status> _f$status = Field(
    'status',
    _$status,
    opt: true,
    def: Status.initialization,
  );
  static PermissionStatus _$permissionStatus(ContactsState v) =>
      v.permissionStatus;
  static const Field<ContactsState, PermissionStatus> _f$permissionStatus =
      Field(
        'permissionStatus',
        _$permissionStatus,
        opt: true,
        def: PermissionStatus.granted,
      );

  @override
  final MappableFields<ContactsState> fields = const {
    #status: _f$status,
    #permissionStatus: _f$permissionStatus,
  };

  static ContactsState _instantiate(DecodingData data) {
    return ContactsState(
      status: data.dec(_f$status),
      permissionStatus: data.dec(_f$permissionStatus),
    );
  }

  @override
  final Function instantiate = _instantiate;

  static ContactsState fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<ContactsState>(map);
  }

  static ContactsState fromJson(String json) {
    return ensureInitialized().decodeJson<ContactsState>(json);
  }
}

mixin ContactsStateMappable {
  String toJson() {
    return ContactsStateMapper.ensureInitialized().encodeJson<ContactsState>(
      this as ContactsState,
    );
  }

  Map<String, dynamic> toMap() {
    return ContactsStateMapper.ensureInitialized().encodeMap<ContactsState>(
      this as ContactsState,
    );
  }

  ContactsStateCopyWith<ContactsState, ContactsState, ContactsState>
  get copyWith => _ContactsStateCopyWithImpl<ContactsState, ContactsState>(
    this as ContactsState,
    $identity,
    $identity,
  );
  @override
  String toString() {
    return ContactsStateMapper.ensureInitialized().stringifyValue(
      this as ContactsState,
    );
  }

  @override
  bool operator ==(Object other) {
    return ContactsStateMapper.ensureInitialized().equalsValue(
      this as ContactsState,
      other,
    );
  }

  @override
  int get hashCode {
    return ContactsStateMapper.ensureInitialized().hashValue(
      this as ContactsState,
    );
  }
}

extension ContactsStateValueCopy<$R, $Out>
    on ObjectCopyWith<$R, ContactsState, $Out> {
  ContactsStateCopyWith<$R, ContactsState, $Out> get $asContactsState =>
      $base.as((v, t, t2) => _ContactsStateCopyWithImpl<$R, $Out>(v, t, t2));
}

abstract class ContactsStateCopyWith<$R, $In extends ContactsState, $Out>
    implements ClassCopyWith<$R, $In, $Out> {
  $R call({Status? status, PermissionStatus? permissionStatus});
  ContactsStateCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(Then<$Out2, $R2> t);
}

class _ContactsStateCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, ContactsState, $Out>
    implements ContactsStateCopyWith<$R, ContactsState, $Out> {
  _ContactsStateCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<ContactsState> $mapper =
      ContactsStateMapper.ensureInitialized();
  @override
  $R call({Status? status, PermissionStatus? permissionStatus}) => $apply(
    FieldCopyWithData({
      if (status != null) #status: status,
      if (permissionStatus != null) #permissionStatus: permissionStatus,
    }),
  );
  @override
  ContactsState $make(CopyWithData data) => ContactsState(
    status: data.get(#status, or: $value.status),
    permissionStatus: data.get(#permissionStatus, or: $value.permissionStatus),
  );

  @override
  ContactsStateCopyWith<$R2, ContactsState, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  ) => _ContactsStateCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

