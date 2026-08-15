import 'package:dart_mappable/dart_mappable.dart';

part 'package_info.mapper.dart';

@MappableClass()
class PackageInfoModel with PackageInfoModelMappable {
  final String appBuildNumber;
  final String appVersion;

  const PackageInfoModel({
    required this.appBuildNumber,
    required this.appVersion,
  });
}
