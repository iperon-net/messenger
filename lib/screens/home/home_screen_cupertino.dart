import 'package:flutter/cupertino.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../di.dart';
import '../../i18n/translations.g.dart';
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
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoTabScaffold(
      tabBar: CupertinoTabBar(
        height: 56,
        iconSize: 24,
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: FaIcon(FontAwesomeIcons.solidCircleUser),
            label: context.t.contacts,
          ),
          BottomNavigationBarItem(
            icon: FaIcon(FontAwesomeIcons.phoneFlip),
            label: context.t.calls,
          ),
          BottomNavigationBarItem(
            icon: FaIcon(FontAwesomeIcons.solidComments),
            label: context.t.chats,
          ),
          BottomNavigationBarItem(
            icon: FaIcon(FontAwesomeIcons.gear),
            label: context.t.settings,
          ),
        ],
      ),
      tabBuilder: (BuildContext context, int index) {
        return CupertinoTabView(
          builder: (BuildContext context) {
            return CupertinoPageScaffold(
              navigationBar: CupertinoNavigationBar(
                middle: Text('Page 1 of tab $index'),
              ),
              child: Center(
                child: CupertinoButton(
                  child: const Text('Next page'),
                  onPressed: () {
                    Navigator.of(context).push(
                      CupertinoPageRoute<void>(
                        builder: (BuildContext context) {
                          return CupertinoPageScaffold(
                            navigationBar: CupertinoNavigationBar(
                              middle: Text('Page 2 of tab $index'),
                            ),
                            child: Center(
                              child: CupertinoButton(
                                child: const Text('Back'),
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                              ),
                            ),
                          );
                        },
                      ),
                    );
                  },
                ),
              ),
            );
          },
        );
      },
    );
  }

}
