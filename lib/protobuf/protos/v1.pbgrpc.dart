// This is a generated file - do not edit.
//
// Generated from protos/v1.proto.

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

import 'v1.pb.dart' as $0;

export 'v1.pb.dart';

@$pb.GrpcServiceName('v1.Iperon')
class IperonClient extends $grpc.Client {
  /// The hostname for this service.
  static const $core.String defaultHost = '';

  /// OAuth scopes needed for the client.
  static const $core.List<$core.String> oauthScopes = [
    '',
  ];

  IperonClient(super.channel, {super.options, super.interceptors});

  $grpc.ResponseFuture<$0.Message> unary(
    $0.Message request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$unary, request, options: options);
  }

  $grpc.ResponseStream<$0.Message> stream(
    $async.Stream<$0.Message> request, {
    $grpc.CallOptions? options,
  }) {
    return $createStreamingCall(_$stream, request, options: options);
  }

  // method descriptors

  static final _$unary = $grpc.ClientMethod<$0.Message, $0.Message>(
      '/v1.Iperon/Unary',
      ($0.Message value) => value.writeToBuffer(),
      $0.Message.fromBuffer);
  static final _$stream = $grpc.ClientMethod<$0.Message, $0.Message>(
      '/v1.Iperon/Stream',
      ($0.Message value) => value.writeToBuffer(),
      $0.Message.fromBuffer);
}

@$pb.GrpcServiceName('v1.Iperon')
abstract class IperonServiceBase extends $grpc.Service {
  $core.String get $name => 'v1.Iperon';

  IperonServiceBase() {
    $addMethod($grpc.ServiceMethod<$0.Message, $0.Message>(
        'Unary',
        unary_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $0.Message.fromBuffer(value),
        ($0.Message value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.Message, $0.Message>(
        'Stream',
        stream,
        true,
        true,
        ($core.List<$core.int> value) => $0.Message.fromBuffer(value),
        ($0.Message value) => value.writeToBuffer()));
  }

  $async.Future<$0.Message> unary_Pre(
      $grpc.ServiceCall $call, $async.Future<$0.Message> $request) async {
    return unary($call, await $request);
  }

  $async.Future<$0.Message> unary($grpc.ServiceCall call, $0.Message request);

  $async.Stream<$0.Message> stream(
      $grpc.ServiceCall call, $async.Stream<$0.Message> request);
}
