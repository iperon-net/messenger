import 'dart:math';

import 'package:grpc/grpc.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:uuid/uuid.dart';

import 'di.dart';
import 'logger.dart';
import 'protobuf/protos/auth_v1.pbgrpc.dart';
import 'protobuf/protos/metadata_v1.pbgrpc.dart';
import 'protobuf/protos/syncer_v1.pbgrpc.dart';
import 'settings.dart';

class API {
  final _logger = getIt.get<Logger>();

  late ClientChannel _clientChannel;
  late AuthClient auth;
  late MetadataClient metadata;
  late SyncerClient syncer;
  late String version;

  final uuid = Uuid();
  final _backoffRandom = Random();
  API() {
    _clientChannel = ClientChannel(
      Settings.apiHost,
      port: 443,
      options: ChannelOptions(
        connectionTimeout: const Duration(seconds: 30),
        connectTimeout:  const Duration(seconds: 30), // The maximum allowed time to wait for a connection to be established
        userAgent: "Iperon/0.0.1",
        idleTimeout: const Duration(minutes: 5),
        // Экспоненциальный backoff с джиттером и потолком ~30с.
        // Фиксированный интервал без джиттера давал «thundering herd»:
        // сервер по MaxConnectionAge (30 мин) разом рассылает GOAWAY всем,
        // и клиенты переподключались синхронно.
        backoffStrategy: (lastBackoff) {
          final base = lastBackoff == null
              ? const Duration(seconds: 1)
              : lastBackoff * 1.6;
          final capped = base > const Duration(seconds: 30) ? const Duration(seconds: 30) : base;
          return capped + Duration(milliseconds: _backoffRandom.nextInt(1000));
        },
        keepAlive: const ClientKeepAliveOptions(
          // pingInterval < серверного MaxConnectionIdle (15 мин) и > MinTime (5с),
          // permitWithoutCalls в тон серверному PermitWithoutStream=true.
          pingInterval: Duration(seconds: 30),
          timeout: Duration(seconds: 5),
          permitWithoutCalls: true,
        ),
        codecRegistry: CodecRegistry(
          codecs: const [
            GzipCodec(),
            IdentityCodec(),
          ],
        ),
      ),
      channelShutdownHandler: () {
        _logger.debug('channelShutdownHandler');
      },
    );

    auth = AuthClient(_clientChannel);
    metadata = MetadataClient(_clientChannel);
    syncer = SyncerClient(_clientChannel);

    _logger.info("api initialization");
  }


  // Initialization
  Future<void> initialization() async {
    final packageInfo = await PackageInfo.fromPlatform();
    version = packageInfo.version;
  }

  Future<String> call(Function() func) async {
    Logger logger = getIt.get<Logger>();

    try {
      await func();
    } on GrpcError catch(err) {
      logger.error(err.toString());

      if ([StatusCode.unknown, StatusCode.unavailable].contains(err.code)) {
        return "errorConnectingToTheServer";
      } else if ([StatusCode.deadlineExceeded].contains(err.code)) {
        return "unableToConnectToTheServer";
      } else if ([StatusCode.cancelled, StatusCode.invalidArgument].contains(err.code)) {
        return err.message.toString();
      } else if ([StatusCode.internal].contains(err.code)) {
        return "internalServerError";
      }

    } catch (err) {
      rethrow;
    }

    return "";

  }

  Future<CallOptions> callOptions({double timeout = 30}) async {
    return CallOptions(
      // timeout <= 0 — без дедлайна (для долгоживущих стримов: рвёт сервер по GOAWAY)
      timeout: timeout <= 0 ? null : Duration(seconds: timeout.toInt()),
      metadata: {
        "x-app-version": "v$version",
        "x-request-id": uuid.v4(),
      },
    );
  }

}
