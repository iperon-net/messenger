import 'package:flutter/cupertino.dart';

import '../../di.dart';
import '../../logger.dart';

class HomeCupertinoScreen extends StatefulWidget {
  const HomeCupertinoScreen({super.key});

  @override
  State<HomeCupertinoScreen> createState() => _HomeCupertinoScreen();
}

class _HomeCupertinoScreen extends State<HomeCupertinoScreen> {
  final logger = getIt.get<Logger>();

  final formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    logger.debug("initState home");
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container();
  }

}
