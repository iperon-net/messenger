// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
// ignore_for_file: type=lint
// ignore_for_file: invalid_use_of_protected_member
// ignore_for_file: unused_element, unnecessary_cast, override_on_non_overriding_member
// ignore_for_file: strict_raw_type, inference_failure_on_untyped_parameter

part of 'package_info.dart';

class PackageInfoModelMapper extends ClassMapperBase<PackageInfoModel> {
  PackageInfoModelMapper._();

  static PackageInfoModelMapper? _instance;
  static PackageInfoModelMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = PackageInfoModelMapper._());
    }
    return _instance!;
  }

  @override
  final String id = 'PackageInfoModel';

  static String _$appBuildNumber(PackageInfoModel v) => v.appBuildNumber;
  static const Field<PackageInfoModel, String> _f$appBuildNumber = Field(
    'appBuildNumber',
    _$appBuildNumber,
  );
  static String _$appVersion(PackageInfoModel v) => v.appVersion;
  static const Field<PackageInfoModel, String> _f$appVersion = Field(
    'appVersion',
    _$appVersion,
  );

  @override
  final MappableFields<PackageInfoModel> fields = const {
    #appBuildNumber: _f$appBuildNumber,
    #appVersion: _f$appVersion,
  };

  static PackageInfoModel _instantiate(DecodingData data) {
    return PackageInfoModel(
      appBuildNumber: data.dec(_f$appBuildNumber),
      appVersion: data.dec(_f$appVersion),
    );
  }

  @override
  final Function instantiate = _instantiate;

  static PackageInfoModel fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<PackageInfoModel>(map);
  }

  static PackageInfoModel fromJson(String json) {
    return ensureInitialized().decodeJson<PackageInfoModel>(json);
  }
}

mixin PackageInfoModelMappable {
  String toJson() {
    return PackageInfoModelMapper.ensureInitialized()
        .encodeJson<PackageInfoModel>(this as PackageInfoModel);
  }

  Map<String, dynamic> toMap() {
    return PackageInfoModelMapper.ensureInitialized()
        .encodeMap<PackageInfoModel>(this as PackageInfoModel);
  }

  PackageInfoModelCopyWith<PackageInfoModel, PackageInfoModel, PackageInfoModel>
  get copyWith =>
      _PackageInfoModelCopyWithImpl<PackageInfoModel, PackageInfoModel>(
        this as PackageInfoModel,
        $identity,
        $identity,
      );
  @override
  String toString() {
    return PackageInfoModelMapper.ensureInitialized().stringifyValue(
      this as PackageInfoModel,
    );
  }

  @override
  bool operator ==(Object other) {
    return PackageInfoModelMapper.ensureInitialized().equalsValue(
      this as PackageInfoModel,
      other,
    );
  }

  @override
  int get hashCode {
    return PackageInfoModelMapper.ensureInitialized().hashValue(
      this as PackageInfoModel,
    );
  }
}

extension PackageInfoModelValueCopy<$R, $Out>
    on ObjectCopyWith<$R, PackageInfoModel, $Out> {
  PackageInfoModelCopyWith<$R, PackageInfoModel, $Out>
  get $asPackageInfoModel =>
      $base.as((v, t, t2) => _PackageInfoModelCopyWithImpl<$R, $Out>(v, t, t2));
}

abstract class PackageInfoModelCopyWith<$R, $In extends PackageInfoModel, $Out>
    implements ClassCopyWith<$R, $In, $Out> {
  $R call({String? appBuildNumber, String? appVersion});
  PackageInfoModelCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  );
}

class _PackageInfoModelCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, PackageInfoModel, $Out>
    implements PackageInfoModelCopyWith<$R, PackageInfoModel, $Out> {
  _PackageInfoModelCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<PackageInfoModel> $mapper =
      PackageInfoModelMapper.ensureInitialized();
  @override
  $R call({String? appBuildNumber, String? appVersion}) => $apply(
    FieldCopyWithData({
      if (appBuildNumber != null) #appBuildNumber: appBuildNumber,
      if (appVersion != null) #appVersion: appVersion,
    }),
  );
  @override
  PackageInfoModel $make(CopyWithData data) => PackageInfoModel(
    appBuildNumber: data.get(#appBuildNumber, or: $value.appBuildNumber),
    appVersion: data.get(#appVersion, or: $value.appVersion),
  );

  @override
  PackageInfoModelCopyWith<$R2, PackageInfoModel, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  ) => _PackageInfoModelCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

