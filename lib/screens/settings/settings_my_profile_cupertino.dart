import 'package:cupertino_ui/cupertino_ui.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_boring_avatars/flutter_boring_avatars.dart';
import 'package:messenger/constants.dart';
import '../../cubit.dart';
import '../../di.dart';
import '../../logger.dart';
import '../../themes.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';

import '../../components.dart';
import '../../i18n/translations.g.dart';

class SettingsMyProfileCupertino extends StatefulWidget {
  const SettingsMyProfileCupertino({super.key});

  @override
  State<SettingsMyProfileCupertino> createState() => _SettingsMyProfileCupertino();
}

class _SettingsMyProfileCupertino extends State<SettingsMyProfileCupertino> {
  final formKey = GlobalKey<FormState>();
  final firstNameController = TextEditingController();
  final firstNameFocus = FocusNode();
  final lastNameController = TextEditingController();
  final lastNameFocus = FocusNode();

  final birthDateController = TextEditingController();
  final birthDateFocus = FocusNode();

  final aboutMeController = TextEditingController();
  final aboutMeFocus = FocusNode();

  final logger = getIt.get<Logger>();

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
    return BlocConsumer<SettingsMyProfileCubit, SettingsMyProfileState>(
      listener: (context, state) {
        if (state.firstName.isNotEmpty) {
          firstNameController.text = state.firstName;
        }

        if (state.lastName.isNotEmpty) {
          lastNameController.text = state.lastName;
        }

        if (state.aboutMe.isNotEmpty) {
          aboutMeController.text = state.aboutMe;
        }

        if (state.birthDate != null) {
          birthDateController.text = state.birthDate!.toIso8601String();
        }
      },
      builder: (context, state) {
        return CupertinoPageScaffold(
          backgroundColor: ThemesCupertino.groupedBackground,
          navigationBar: AppCupertinoNavigationBar(
            child: CupertinoNavigationBar(
              automaticBackgroundVisibility: false,
              backgroundColor: ThemesCupertino.groupedBackground,
              middle: Text(context.t.screenMyProfile.myprofile),
              leading: CupertinoButton(padding: EdgeInsets.zero, onPressed: () => context.pop(), child: Text(context.t.common.cancel)),
              trailing: CupertinoButton(
                padding: EdgeInsets.zero,
                onPressed: () async {},
                child: state.networkStatus == Status.loading ? CupertinoActivityIndicator() : Text(context.t.common.edit),
              ),
            ),
          ),
          child: Form(
            key: formKey,
            child: SafeArea(
              child: ListView(
                children: [
                  const SizedBox(height: 12),
                  // Аватарка с кнопкой выбора фото.
                  Center(
                    child: GestureDetector(
                      onTap: () {},
                      behavior: HitTestBehavior.opaque,
                      child: Column(
                        children: [
                          Stack(
                            children: [
                              SizedBox(
                                width: 96,
                                height: 96,
                                child: AnimatedBoringAvatar(
                                  name: state.boringAvatarHash,
                                  type: state.boringAvatarType,
                                  shape: const CircleBorder(),
                                  curve: Curves.bounceIn,
                                  duration: const Duration(seconds: 1),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Text(
                            "Изменить фото",
                            style: TextStyle(
                              fontSize: 16,
                              color: CupertinoDynamicColor.withBrightness(
                                color: CupertinoTheme.of(context).primaryColor,
                                darkColor: CupertinoColors.white,
                              ).resolveFrom(context),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  CupertinoListSection.insetGrouped(
                    clipBehavior: Clip.antiAlias,
                    backgroundColor: ThemesCupertino.groupedBackground.resolveFrom(context),
                    decoration: BoxDecoration(
                      color: ThemesCupertino.groupedCard.resolveFrom(context),
                      borderRadius: const BorderRadius.all(Radius.circular(18)),
                    ),
                    // footer: Text("Удалить"),
                    children: [
                      CupertinoListTile(
                        title: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Фамилия', style: TextStyle(fontSize: MediaQuery.textScalerOf(context).scale(16))),
                            Text(
                              'Тен',
                              style: TextStyle(
                                fontSize: MediaQuery.textScalerOf(context).scale(17),
                                color: CupertinoDynamicColor.withBrightness(
                                  color: CupertinoTheme.of(context).primaryColor,
                                  darkColor: CupertinoColors.white.withValues(alpha: 0.5),
                                ).resolveFrom(context),
                              ),
                            ),
                          ],
                        ),
                        padding: EdgeInsets.all(10),
                        onTap: () {},
                      ),
                      CupertinoListTile(
                        title: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Имя', style: TextStyle(fontSize: MediaQuery.textScalerOf(context).scale(16))),
                            Text(
                              'Костя',
                              style: TextStyle(
                                fontSize: MediaQuery.textScalerOf(context).scale(17),
                                color: CupertinoDynamicColor.withBrightness(
                                  color: CupertinoTheme.of(context).primaryColor,
                                  darkColor: CupertinoColors.white.withValues(alpha: 0.5),
                                ).resolveFrom(context),
                              ),
                            ),
                          ],
                        ),
                        padding: EdgeInsets.all(10),
                        onTap: () {},
                      ),

                      CupertinoListTile(
                        title: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Мобильный', style: TextStyle(fontSize: MediaQuery.textScalerOf(context).scale(16))),
                            Text(
                              '+7 909 160 00 44',
                              style: TextStyle(
                                fontSize: MediaQuery.textScalerOf(context).scale(17),
                                color: CupertinoDynamicColor.withBrightness(
                                  color: CupertinoTheme.of(context).primaryColor,
                                  darkColor: CupertinoColors.white.withValues(alpha: 0.5),
                                ).resolveFrom(context),
                              ),
                            ),
                          ],
                        ),
                        padding: EdgeInsets.all(10),
                        onTap: () {},
                      ),
                      CupertinoListTile(
                        title: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Имя пользователя', style: TextStyle(fontSize: MediaQuery.textScalerOf(context).scale(16))),
                            Text(
                              '@kostya',
                              style: TextStyle(
                                fontSize: MediaQuery.textScalerOf(context).scale(17),
                                color: CupertinoDynamicColor.withBrightness(
                                  color: CupertinoTheme.of(context).primaryColor,
                                  darkColor: CupertinoColors.white.withValues(alpha: 0.5),
                                ).resolveFrom(context),
                              ),
                            ),
                          ],
                        ),
                        padding: EdgeInsets.all(10),
                        onTap: () {},
                      ),
                    ],
                  ),

                  CupertinoListSection.insetGrouped(
                    clipBehavior: Clip.antiAlias,
                    backgroundColor: ThemesCupertino.groupedBackground.resolveFrom(context),
                    decoration: BoxDecoration(
                      color: ThemesCupertino.groupedCard.resolveFrom(context),
                      borderRadius: const BorderRadius.all(Radius.circular(18)),
                    ),
                    children: [
                      CupertinoListTileIcon(
                        title: const Text("Номер"),
                        color: Color(0xFF049A40),
                        icon: FontAwesomeIcons.phone,
                        onTab: () async {},
                        additionalInfo: Text("+7 909 160-00-44"),
                        isTrailing: true,
                      ),
                      CupertinoListTileIcon(
                        title: Text(context.t.screenMyProfile.username),
                        color: Color(0xFF3B74BF),
                        icon: FontAwesomeIcons.at,
                        onTab: () async {},
                        additionalInfo: Text(context.t.screenMyProfile.add),
                        isTrailing: true,
                      ),
                    ],
                  ),

                  CupertinoListSection.insetGrouped(
                    clipBehavior: Clip.antiAlias,
                    backgroundColor: ThemesCupertino.groupedBackground.resolveFrom(context),
                    decoration: BoxDecoration(
                      color: ThemesCupertino.groupedCard.resolveFrom(context),
                      borderRadius: const BorderRadius.all(Radius.circular(18)),
                    ),
                    children: [
                      SizedBox(
                        width: double.infinity,
                        child: CupertinoButton.filled(
                          onPressed: () {},
                          color: CupertinoColors.systemRed.withValues(alpha: 0.7),
                          foregroundColor: CupertinoColors.white,
                          child: Text("Удалить аккаунт"),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
