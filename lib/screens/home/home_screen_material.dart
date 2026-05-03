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
          appBar: AppBar(),
          bottomNavigationBar: NavigationBar(
            onDestinationSelected: (int index) => context.read<HomeCubit>().setDestinationSelectedIndex(index),
            selectedIndex: state.destinationSelectedIndex,
            destinations: const <Widget>[
              NavigationDestination(
                icon: FaIcon(FontAwesomeIcons.comments),
                label: 'Чаты',
              ),
              NavigationDestination(
                icon: FaIcon(FontAwesomeIcons.circleUser),
                label: 'Контакты',
              ),
              NavigationDestination(
                icon: FaIcon(FontAwesomeIcons.gear),
                label: 'Настройки',
              ),
              NavigationDestination(
                icon: FaIcon(FontAwesomeIcons.user),
                label: 'Профиль',
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
      return SettingsMaterialScreen();
    } else {
      return Text(state.destinationSelectedIndex.toString());
    }
  }

}
