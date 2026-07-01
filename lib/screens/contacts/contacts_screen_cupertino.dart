import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:messenger/cubit/contacts/contacts_state.dart';
import 'package:messenger/cubit/main_cubit.dart';
import 'package:messenger/cubit/main_state.dart';

import '../../cubit/contacts/contacts_cubit.dart';
import '../../i18n/translations.g.dart';

class ContactsScreenCupertino extends StatefulWidget {
  const ContactsScreenCupertino({super.key});

  @override
  State<ContactsScreenCupertino> createState() => _ContactsScreenCupertino();
}

class _ContactsScreenCupertino extends State<ContactsScreenCupertino> {
  final _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    context.read<ContactsCubit>().initialization();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  final List<Color> _colors = [
    Colors.red,
    Colors.redAccent,
    Colors.deepOrange,
    Colors.deepOrangeAccent,
    Colors.orange,
    Colors.pink,
    Colors.pinkAccent,
    Colors.deepPurple,
    Colors.deepPurpleAccent,
    Colors.purple,
    Colors.purpleAccent,
    Colors.blue,
    Colors.blueAccent,
    Colors.lightBlue,
    Colors.lightBlueAccent,
    Colors.indigo,
    Colors.indigoAccent,
    Colors.blueGrey,
    Colors.green,
    Colors.lightGreen,
    Colors.teal,
    Colors.amber,
    Colors.purple,
    Colors.purpleAccent,
    Colors.deepPurple,
    Colors.deepPurpleAccent,
    Colors.brown,
    Colors.brown.shade400,
    Colors.brown.shade600,
    Colors.grey,
    Colors.grey.shade400,
    Colors.grey.shade600,
    Colors.amber,
    Colors.orange,
    Colors.orangeAccent,
    Colors.deepOrange,
    Colors.deepOrangeAccent,
    Colors.red.shade300,
    Colors.red.shade700,
    Colors.blue.shade300,
    Colors.blue.shade700,
    Colors.green.shade300,
    Colors.green.shade700,
    Colors.purple.shade300,
    Colors.purple.shade700,
    Colors.orange.shade300,
    Colors.orange.shade700,
    Colors.teal.shade700,
    Colors.pink.shade300,
    Colors.pink.shade700,
    Colors.indigo.shade300,
    Colors.indigo.shade700,
    Colors.cyan.shade700,
  ];

  final Random _random = Random();

  Color randomColor() {
    final cl = _colors[_random.nextInt(_colors.length)];

    cl.toARGB32();

    Color;
    return cl;
  }


  Widget bannerAccessDisabled(BuildContext context) {
    return BlocBuilder<MainCubit, MainState>(
      builder: (context, state) {

        if (state.permissionStatusContacts.name == "denied" || state.permissionStatusContacts.name == "permanentlyDenied") {
          return Padding(
            padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  width: double.infinity,
                  child: CupertinoListTile(
                    leading: FaIcon(FontAwesomeIcons.circleExclamation, color: Colors.red),
                    title: Text(context.t.accessToContacts),
                    trailing: FaIcon(FontAwesomeIcons.xmark, size: 14),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                  child: Text(
                    context.t.pleaseAllowAccessPhoneSeamlesslyFindYourFriends,
                    style: TextStyle(fontSize: MediaQuery.of(context).textScaler.scale(14.5)),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 10, 20, 5),
                  child: CupertinoButton(
                    padding: EdgeInsets.zero,
                    onPressed: () async => await context.read<ContactsCubit>().openSettings(),
                    sizeStyle: CupertinoButtonSize.small,
                    alignment: Alignment.topLeft,
                    child: Text(context.t.allowInSettings),
                  ),
                ),
              ],
            ),
          );
        } else if (state.permissionStatusContacts.name == "limited") {
          return Padding(
            padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  width: double.infinity,
                  child: CupertinoListTile(
                    leading: FaIcon(FontAwesomeIcons.circleInfo),
                    title: Text(context.t.limitedAccessToContacts),
                    trailing: FaIcon(FontAwesomeIcons.xmark, size: 14),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                  child: Text(
                    context.t.appDoesNotHavePermissionAccessAllContacts,
                    style: TextStyle(fontSize: MediaQuery.of(context).textScaler.scale(14.5)),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 10, 20, 5),
                  child: CupertinoButton(
                    padding: EdgeInsets.zero,
                    onPressed: () async => await context.read<ContactsCubit>().openSettings(),
                    sizeStyle: CupertinoButtonSize.small,
                    alignment: Alignment.topLeft,
                    child: Text(context.t.allowInSettings),
                  ),
                ),
              ],
            ),
          );
        } else {
          return Container();
        }


      },
    );
  }

  @override
  Widget build(BuildContext context) {
    // final grouped = _grouped;

    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        automaticBackgroundVisibility: false,
        middle: Text(context.t.contacts),
        trailing: TextButton.icon(
          onPressed: () {},
          label: FaIcon(
            FontAwesomeIcons.plus,
            color: CupertinoDynamicColor.resolve(
              CupertinoDynamicColor.withBrightness(
                color: CupertinoColors.darkBackgroundGray,
                darkColor: CupertinoColors.systemGroupedBackground,
              ),
              context,
            ),
          ),
        ),
      ),
      child: SafeArea(
        child: Container(
          decoration: BoxDecoration(
            color: CupertinoDynamicColor.resolve(
              CupertinoDynamicColor.withBrightness(
                color: CupertinoColors.systemGroupedBackground,
                darkColor: CupertinoColors.darkBackgroundGray,
              ),
              context,
            ),
          ),
          child: BlocBuilder<ContactsCubit, ContactsState>(
            builder: (context, state) {
              return ListView(
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20, 15, 20, 0),
                    child: SizedBox(
                      width: double.infinity,
                      child: CupertinoSearchTextField(
                        placeholder: context.t.search,
                        itemSize: 25,
                      ),
                    ),
                  ),
                  bannerAccessDisabled(context),

                  CupertinoListSection(
                    backgroundColor: CupertinoDynamicColor.resolve(
                      CupertinoDynamicColor.withBrightness(
                        color: CupertinoColors.systemGroupedBackground,
                        darkColor: CupertinoColors.darkBackgroundGray,
                      ),
                      context,
                    ),
                    children: [
                      for (int i = 0; i < 20; i++)
                        CupertinoListTile(
                          backgroundColor: CupertinoDynamicColor.resolve(
                            CupertinoDynamicColor.withBrightness(
                              color: CupertinoColors.systemGroupedBackground,
                              darkColor: CupertinoColors.darkBackgroundGray,
                            ),
                            context,
                          ),
                          leading: CircleAvatar(
                            child: const Text("D"),
                            backgroundColor: randomColor(),
                            foregroundColor: Colors.white,
                          ),
                          subtitle: Text("онлайн"),
                          title: Text("Donald Trump"),
                        ),
                    ],
                  ),
                ],

              );
            },
          ),
        ),
      ),
    );
  }
}
