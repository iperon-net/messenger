import 'package:flutter/cupertino.dart';
import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';
import 'package:messenger/screens/home/home_screen.dart';
import 'package:talker_flutter/talker_flutter.dart';

import 'di.dart';
import 'logger.dart';

class Routers {
  final GlobalKey<NavigatorState> navigatorGoRouterKey = GlobalKey<NavigatorState>();
  final logger = getIt.get<Logger>();

  GoRouter router() {
    return GoRouter(
      navigatorKey: navigatorGoRouterKey,
      initialLocation: "/auth",
      observers: <NavigatorObserver>[
        TalkerRouteObserver(logger.getTalker()),
      ],
      routes: <RouteBase>[
        GoRoute(
          path: "/auth",
          name: "auth",
          builder: (BuildContext context, GoRouterState state) => HomeScreen(),
          // routes: [
          //   GoRoute(
          //     path: "/confirmation/:signInToken",
          //     name: "authConfirmation",
          //     builder: (BuildContext context, GoRouterState state) {
          //       return BlocProvider(
          //         create: (BuildContext context) => AuthConfirmationCubit(),
          //         child: const AuthConfirmationScreen(),
          //       );
          //     },
          //   ),
          // ],
        ),
      ]
    );
  }
}
