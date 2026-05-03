import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:messenger/screens/home/home_cubit.dart';

import '../../di.dart';
import '../../logger.dart';
import '../screens.dart';

class HomeMaterialScreen extends StatefulWidget {
  const HomeMaterialScreen({super.key});

  @override
  State<HomeMaterialScreen> createState() => _HomeMaterialScreen();
}

class _HomeMaterialScreen extends State<HomeMaterialScreen> {
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
    return BlocBuilder<HomeCubit, HomeState>(
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            title: appBarTitle(context, state),
            actions: [
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 0, 5, 0),
                child: PopupMenuButton<String>(
                  icon: Icon(Icons.more_vert),
                  offset: Offset(0.0, AppBar().preferredSize.height),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(8)),
                  ),
                  onSelected: (String value) {},
                  itemBuilder: (BuildContext context) => [
                    PopupMenuItem<String>(
                      value: 'logout',
                      child: Text('Выйти'),
                    ),
                  ],
                ),
              ),
            ],
          ),
          bottomNavigationBar: NavigationBar(
            onDestinationSelected: (int index) => context.read<HomeCubit>().setDestinationSelectedIndex(index),
            selectedIndex: state.destinationSelectedIndex,
            destinations: const <Widget>[
              NavigationDestination(
                icon: FaIcon(FontAwesomeIcons.comments),
                label: 'Чаты',
              ),
              NavigationDestination(
                icon: FaIcon(FontAwesomeIcons.phoneFlip),
                label: 'Звонки',
              ),
              NavigationDestination(
                icon: FaIcon(FontAwesomeIcons.circleUser),
                label: 'Контакты',
              ),
              NavigationDestination(
                icon: FaIcon(FontAwesomeIcons.gear),
                label: 'Настройки',
              ),
            ],
          ),
          body: Form(
            key: formKey,
            child: SafeArea(
              child: body(context, state),
            ),
          ),
        );
      },
    );
  }

  Widget body(BuildContext context, HomeState state) {
    if (state.destinationSelectedIndex == 0){
      return Text(state.destinationSelectedIndex.toString());
    }else if (state.destinationSelectedIndex == 1) {
      return Text(state.destinationSelectedIndex.toString());
    } else if (state.destinationSelectedIndex == 2){
      return Text(state.destinationSelectedIndex.toString());
    } else {
      return SettingsMaterialScreen();
    }
  }

  Widget appBarTitle(BuildContext context, HomeState state) {
    if (state.destinationSelectedIndex == 0){
      return Text("Чаты");
    }else if (state.destinationSelectedIndex == 1) {
      return Text("Звонки");
    } else if (state.destinationSelectedIndex == 2){
      return Text("Контакты");
    } else {
      return Text("Настройки");
    }
  }

}
