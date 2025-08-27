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
      onPause: () {
        _logger.debug("onPause");
      },
      onDetach: () {
        _logger.debug("onPause");
      },
      onRestart: () {
        _logger.debug("onRestart");
      },
    );
  }

}
