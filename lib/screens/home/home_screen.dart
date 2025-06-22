import 'dart:io';

import 'package:flutter/widgets.dart';

import '../../components/not_implemented/not_implemented_component.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {

    Widget widget = NotImplementedComponent();
    // if (Platform.isIOS) {
    //   widget = HomeScreenIOS();
    // }
    return widget;
  }

}
