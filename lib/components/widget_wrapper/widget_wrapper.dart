import 'dart:ui';

import 'package:blur/blur.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';


class BlurOverlay extends StatelessWidget {
  const BlurOverlay({super.key});

  @override
  Widget build(BuildContext context) {
    return Positioned.fill(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: ColoredBox(color: Colors.transparent.withValues(alpha: 0.1)),
      ),
    );
  }
}

class WidgetWrapper extends StatefulWidget {
  final Widget child;

  const WidgetWrapper({super.key, required this.child});

  @override
  State<WidgetWrapper> createState() =>  _WidgetWrapperState();
}

class _WidgetWrapperState extends State<WidgetWrapper> with WidgetsBindingObserver {
  bool _isBlurred = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    setState(() {
      _isBlurred = state == AppLifecycleState.inactive || state == AppLifecycleState.paused;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_isBlurred){
      return Blur(
        blur: 8,
        blurColor: CupertinoColors.transparent,
        colorOpacity: 0.1,
        child: widget.child,
      );
    }
    return widget.child;
  }
}

