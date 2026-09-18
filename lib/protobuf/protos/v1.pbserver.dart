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

import 'package:protobuf/protobuf.dart' as $pb;

import 'v1.pb.dart' as $1;
import 'v1.pbjson.dart';

export 'v1.pb.dart';

abstract class IperonServiceBase extends $pb.GeneratedService {
  $async.Future<$1.Message> unary($pb.ServerContext ctx, $1.Message request);
  $async.Future<$1.Message> stream($pb.ServerContext ctx, $1.Message request);
  $async.Future<$1.Upload_Response> upload($pb.ServerContext ctx, $1.Upload_Request request);

  $pb.GeneratedMessage createRequest($core.String methodName) {
    switch (methodName) {
      case 'Unary':
        return $1.Message();
      case 'Stream':
        return $1.Message();
      case 'Upload':
        return $1.Upload_Request();
      default:
        throw $core.ArgumentError('Unknown method: $methodName');
    }
  }

  $async.Future<$pb.GeneratedMessage> handleCall($pb.ServerContext ctx, $core.String methodName, $pb.GeneratedMessage request) {
    switch (methodName) {
      case 'Unary':
        return unary(ctx, request as $1.Message);
      case 'Stream':
        return stream(ctx, request as $1.Message);
      case 'Upload':
        return upload(ctx, request as $1.Upload_Request);
      default:
        throw $core.ArgumentError('Unknown method: $methodName');
    }
  }

  $core.Map<$core.String, $core.dynamic> get $json => IperonServiceBase$json;
  $core.Map<$core.String, $core.Map<$core.String, $core.dynamic>> get $messageJson => IperonServiceBase$messageJson;
}
