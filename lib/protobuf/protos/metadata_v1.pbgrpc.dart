// This is a generated file - do not edit.
//
// Generated from protos/metadata_v1.proto.

// @dart = 3.3

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names
// ignore_for_file: curly_braces_in_flow_control_structures
// ignore_for_file: deprecated_member_use_from_same_package, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_relative_imports

import 'dart:async' as $async;
import 'dart:core' as $core;

import 'package:grpc/service_api.dart' as $grpc;
import 'package:protobuf/protobuf.dart' as $pb;

import 'metadata_v1.pb.dart' as $0;

export 'metadata_v1.pb.dart';

@$pb.GrpcServiceName('iperon.v1.Metadata')
class MetadataClient extends $grpc.Client {
  /// The hostname for this service.
  static const $core.String defaultHost = '';

  /// OAuth scopes needed for the client.
  static const $core.List<$core.String> oauthScopes = [
    '',
  ];

  MetadataClient(super.channel, {super.options, super.interceptors});

  $grpc.ResponseFuture<$0.MetadataInfoResponse> info(
    $0.MetadataInfoRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$info, request, options: options);
  }

  // method descriptors

  static final _$info =
      $grpc.ClientMethod<$0.MetadataInfoRequest, $0.MetadataInfoResponse>(
          '/iperon.v1.Metadata/Info',
          ($0.MetadataInfoRequest value) => value.writeToBuffer(),
          $0.MetadataInfoResponse.fromBuffer);
}

@$pb.GrpcServiceName('iperon.v1.Metadata')
abstract class MetadataServiceBase extends $grpc.Service {
  $core.String get $name => 'iperon.v1.Metadata';

  MetadataServiceBase() {
    $addMethod(
        $grpc.ServiceMethod<$0.MetadataInfoRequest, $0.MetadataInfoResponse>(
            'Info',
            info_Pre,
            false,
            false,
            ($core.List<$core.int> value) =>
                $0.MetadataInfoRequest.fromBuffer(value),
            ($0.MetadataInfoResponse value) => value.writeToBuffer()));
  }

  $async.Future<$0.MetadataInfoResponse> info_Pre($grpc.ServiceCall $call,
      $async.Future<$0.MetadataInfoRequest> $request) async {
    return info($call, await $request);
  }

  $async.Future<$0.MetadataInfoResponse> info(
      $grpc.ServiceCall call, $0.MetadataInfoRequest request);
}
