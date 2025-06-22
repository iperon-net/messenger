import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../i18n/translations.g.dart';

class NotImplementedComponent extends StatelessWidget {
  const NotImplementedComponent({super.key});

  @override
  Widget build(BuildContext context) {
    if (Platform.isIOS) {
      return CupertinoPageScaffold(
        child: Center(child: Text(context.t.notImplementedScreen)),
      );
    }

    return Scaffold(
      body: Center(child: Text(context.t.notImplementedScreen)),
    );
  }
}
