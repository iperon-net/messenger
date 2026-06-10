// This is a generated file - do not edit.
//
// Generated from protos/syncer_v1.proto.

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

import 'syncer_v1.pb.dart' as $0;

export 'syncer_v1.pb.dart';

@$pb.GrpcServiceName('iperon.v1.Syncer')
class SyncerClient extends $grpc.Client {
  /// The hostname for this service.
  static const $core.String defaultHost = '';

  /// OAuth scopes needed for the client.
  static const $core.List<$core.String> oauthScopes = [
    '',
  ];

  SyncerClient(super.channel, {super.options, super.interceptors});

  $grpc.ResponseStream<$0.SyncerMessageResponse> messages(
    $async.Stream<$0.SyncerMessageRequest> request, {
    $grpc.CallOptions? options,
  }) {
    return $createStreamingCall(_$messages, request, options: options);
  }

  // method descriptors

  static final _$messages =
      $grpc.ClientMethod<$0.SyncerMessageRequest, $0.SyncerMessageResponse>(
          '/iperon.v1.Syncer/Messages',
          ($0.SyncerMessageRequest value) => value.writeToBuffer(),
          $0.SyncerMessageResponse.fromBuffer);
}

@$pb.GrpcServiceName('iperon.v1.Syncer')
abstract class SyncerServiceBase extends $grpc.Service {
  $core.String get $name => 'iperon.v1.Syncer';

  SyncerServiceBase() {
    $addMethod(
        $grpc.ServiceMethod<$0.SyncerMessageRequest, $0.SyncerMessageResponse>(
            'Messages',
            messages,
            true,
            true,
            ($core.List<$core.int> value) =>
                $0.SyncerMessageRequest.fromBuffer(value),
            ($0.SyncerMessageResponse value) => value.writeToBuffer()));
  }

  $async.Stream<$0.SyncerMessageResponse> messages(
      $grpc.ServiceCall call, $async.Stream<$0.SyncerMessageRequest> request);
}
