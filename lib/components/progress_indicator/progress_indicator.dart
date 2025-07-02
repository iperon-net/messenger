import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ProgressIndicatorComponent extends StatelessWidget {
  const ProgressIndicatorComponent({super.key});

  @override
  Widget build(BuildContext context) {
    if (Platform.isIOS) return CupertinoActivityIndicator();

    return SizedBox(
      height: 16,
      width: 16,
      child: Center(
        child: CircularProgressIndicator(
            strokeWidth: 1.5
        ),
      ),
    );
  }
}
