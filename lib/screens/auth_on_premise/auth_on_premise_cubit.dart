import 'dart:math';

import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:grpc/grpc.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:uuid/uuid.dart';

import '../../constants.dart';
import '../../di.dart';
import '../../i18n/translations.g.dart';
import '../../logger.dart';
import '../../protobuf/google/protobuf/empty.pb.dart';
import '../../protobuf/protos/metadata_v1.pbgrpc.dart';

part 'auth_on_premise_state.dart';
part 'auth_on_premise_cubit.freezed.dart';

class AuthOnPremiseCubit extends Cubit<AuthOnPremiseState> {
  AuthOnPremiseCubit() : super(AuthOnPremiseState());

  final formKey = GlobalKey<FormState>();
  final textControllerOrganizationServerUrl = TextEditingController();
  final textControllerOrganizationServerUrlKey = GlobalKey();

  final _logger = getIt.get<Logger>();

  String? validatorOrganizationServerUrl(BuildContext context, String? value) {
    emit(state.copyWith(errorFieldOrganizationServerUrl: ""));

    if (value == null || value.isEmpty) return context.t.invalidOrganizationServerUrl;

    Uri uri;
    try {
      uri = Uri.parse(value);
    } on FormatException catch (_) {
      return context.t.invalidOrganizationServerUrl;
    } catch (err) {
      return context.t.invalidOrganizationServerUrl;
    }

    if (!uri.isAbsolute || uri.scheme != "https") return context.t.invalidOrganizationServerUrl;

    return null;
  }

  Future<void> validator(BuildContext context) async {
    emit(state.copyWith(executeStatus: Status.loading));

    if (!formKey.currentState!.validate()) {
      emit(state.copyWith(errorFieldOrganizationServerUrl: "", executeStatus: Status.success));
      return;
    }

    Uri uri;
    try {
      uri = Uri.parse(textControllerOrganizationServerUrl.text);
    } on FormatException catch (err) {
      throw FormatException("$err");
    } catch (err) {
      rethrow;
    }

    final packageInfo = await PackageInfo.fromPlatform();

    final clientChannel = ClientChannel(
        uri.host,
        port: uri.port,
        options: ChannelOptions(
          connectionTimeout: const Duration(seconds: 10),
          connectTimeout:  const Duration(seconds: 10),
          userAgent: "${packageInfo.appName}/${packageInfo.version}",
          credentials: const ChannelCredentials.secure(),
          idleTimeout: const Duration(minutes: 60),
          backoffStrategy: (_) => const Duration(seconds: 60),
          keepAlive: const ClientKeepAliveOptions(
            pingInterval: Duration(seconds: 60),
            permitWithoutCalls: true,
          ),
          codecRegistry: CodecRegistry(codecs: const [GzipCodec(), IdentityCodec()]),
        ),
        channelShutdownHandler: () {
          _logger.debug('channelShutdownHandler');
        },
    );

    final uuid = Uuid();

    final metadata = MetadataClient(
      clientChannel,
      options: CallOptions(
        compression: GzipCodec(),
      ),
    );

    try {
      await metadata.info(
        MetadataInfoRequest(),
        options: CallOptions(metadata: {'x-request-id': uuid.v4(), "x-app-version": "v${packageInfo.version}"}),
      );
    } on GrpcError catch(err) {
      _logger.error(err);

      if (context.mounted && err.message != null && err.codeName == "CANCELLED"){
          emit(state.copyWith(errorFieldOrganizationServerUrl: context.t[err.message ?? "unknownError"], executeStatus: Status.success));
      }

      if (context.mounted) emit(state.copyWith(errorFieldOrganizationServerUrl: context.t.invalidOrganizationServerUrl, executeStatus: Status.success));
      return;
    } catch (e) {
      _logger.error(e);
    }

    // textControllerOrganizationServerUrl.clear();
    emit(state.copyWith(executeStatus: Status.success));
  }

  void switchDebugListServers() {
    if (state.debugListServers) {
      emit(state.copyWith(debugListServers: false));
    } else {
      emit(state.copyWith(debugListServers: true));
    }
  }

}
