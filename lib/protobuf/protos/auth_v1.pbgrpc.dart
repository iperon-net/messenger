// This is a generated file - do not edit.
//
// Generated from protos/auth_v1.proto.

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

import 'auth_v1.pb.dart' as $0;

export 'auth_v1.pb.dart';

@$pb.GrpcServiceName('iperon.v1.Auth')
class AuthClient extends $grpc.Client {
  /// The hostname for this service.
  static const $core.String defaultHost = '';

  /// OAuth scopes needed for the client.
  static const $core.List<$core.String> oauthScopes = [
    '',
  ];

  AuthClient(super.channel, {super.options, super.interceptors});

  $grpc.ResponseFuture<$0.AuthCallPasswordResponse> callPassword(
    $0.AuthCallPasswordRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$callPassword, request, options: options);
  }

  $grpc.ResponseStream<$0.AuthCallPasswordCheckResponse> callPasswordCheck(
    $0.AuthCallPasswordCheckRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createStreamingCall(
        _$callPasswordCheck, $async.Stream.fromIterable([request]),
        options: options);
  }

  $grpc.ResponseFuture<$0.AuthConfirmationResponse> confirmation(
    $0.AuthConfirmationRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$confirmation, request, options: options);
  }

  // method descriptors

  static final _$callPassword = $grpc.ClientMethod<$0.AuthCallPasswordRequest,
          $0.AuthCallPasswordResponse>(
      '/iperon.v1.Auth/CallPassword',
      ($0.AuthCallPasswordRequest value) => value.writeToBuffer(),
      $0.AuthCallPasswordResponse.fromBuffer);
  static final _$callPasswordCheck = $grpc.ClientMethod<
          $0.AuthCallPasswordCheckRequest, $0.AuthCallPasswordCheckResponse>(
      '/iperon.v1.Auth/CallPasswordCheck',
      ($0.AuthCallPasswordCheckRequest value) => value.writeToBuffer(),
      $0.AuthCallPasswordCheckResponse.fromBuffer);
  static final _$confirmation = $grpc.ClientMethod<$0.AuthConfirmationRequest,
          $0.AuthConfirmationResponse>(
      '/iperon.v1.Auth/Confirmation',
      ($0.AuthConfirmationRequest value) => value.writeToBuffer(),
      $0.AuthConfirmationResponse.fromBuffer);
}

@$pb.GrpcServiceName('iperon.v1.Auth')
abstract class AuthServiceBase extends $grpc.Service {
  $core.String get $name => 'iperon.v1.Auth';

  AuthServiceBase() {
    $addMethod($grpc.ServiceMethod<$0.AuthCallPasswordRequest,
            $0.AuthCallPasswordResponse>(
        'CallPassword',
        callPassword_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $0.AuthCallPasswordRequest.fromBuffer(value),
        ($0.AuthCallPasswordResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.AuthCallPasswordCheckRequest,
            $0.AuthCallPasswordCheckResponse>(
        'CallPasswordCheck',
        callPasswordCheck_Pre,
        false,
        true,
        ($core.List<$core.int> value) =>
            $0.AuthCallPasswordCheckRequest.fromBuffer(value),
        ($0.AuthCallPasswordCheckResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.AuthConfirmationRequest,
            $0.AuthConfirmationResponse>(
        'Confirmation',
        confirmation_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $0.AuthConfirmationRequest.fromBuffer(value),
        ($0.AuthConfirmationResponse value) => value.writeToBuffer()));
  }

  $async.Future<$0.AuthCallPasswordResponse> callPassword_Pre(
      $grpc.ServiceCall $call,
      $async.Future<$0.AuthCallPasswordRequest> $request) async {
    return callPassword($call, await $request);
  }

  $async.Future<$0.AuthCallPasswordResponse> callPassword(
      $grpc.ServiceCall call, $0.AuthCallPasswordRequest request);

  $async.Stream<$0.AuthCallPasswordCheckResponse> callPasswordCheck_Pre(
      $grpc.ServiceCall $call,
      $async.Future<$0.AuthCallPasswordCheckRequest> $request) async* {
    yield* callPasswordCheck($call, await $request);
  }

  $async.Stream<$0.AuthCallPasswordCheckResponse> callPasswordCheck(
      $grpc.ServiceCall call, $0.AuthCallPasswordCheckRequest request);

  $async.Future<$0.AuthConfirmationResponse> confirmation_Pre(
      $grpc.ServiceCall $call,
      $async.Future<$0.AuthConfirmationRequest> $request) async {
    return confirmation($call, await $request);
  }

  $async.Future<$0.AuthConfirmationResponse> confirmation(
      $grpc.ServiceCall call, $0.AuthConfirmationRequest request);
}
