import 'package:flutter/widgets.dart';
import 'package:messenger/repositories/repositories.dart';

import 'di.dart';
import 'logger.dart';

class Lifecycle {
  final _logger = getIt.get<Logger>();
  late AppLifecycleListener appLifecycleListener;

  final _repositories = getIt.get<Repositories>();

  Future<void> initialization() async {
    _logger.debug("lifecycle initialization");
    appLifecycleListener = AppLifecycleListener(
      onShow: () {
        _logger.debug("onShow");
      },
      onResume: () {
        _logger.debug("onResume");
      },
      onHide: ()  {
        _logger.debug("onHide");
      },
      onInactive: () {
        _logger.debug("onInactive");
      },
      onPause: () async {
        await _repositories.settingsDevice.setPassCodeTimer((DateTime.now().millisecondsSinceEpoch / 1000).toInt());
        _logger.debug("onPause");
      },
      onDetach: () {
        _logger.debug("onDetach");
      },
      onRestart: () async {
        final getAllSettings = await _repositories.settingsDevice.getAllSettings();
        final calculateTimer = (DateTime.now().millisecondsSinceEpoch / 1000).toInt() - (getAllSettings.passCodeTimer).toInt();

        if(getAllSettings.passCode.isNotEmpty && calculateTimer >= getAllSettings.passCodeTtl) {
          await _repositories.settingsDevice.setPassCodeLock(true);
          _logger.debug("Lock!");
        }

        _logger.debug("onRestart");
      },
    );
  }

}
