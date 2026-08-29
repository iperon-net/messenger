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
  final logger = getIt.get<Logger>();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  /// Открывает лист выбора источника аватара (камера / галерея / файл / эмодзи).
  Future<void> _pickAvatar(BuildContext context) async {
    final result = await showMediaSourceSheet(
      context,
      tabs: const [
        // MediaSourceTabKind.camera,
        MediaSourceTabKind.gallery,
        MediaSourceTabKind.file,
        MediaSourceTabKind.emoji,
        MediaSourceTabKind.link,
      ],
    );
    if (result == null) return; // лист закрыт без выбора

    switch (result) {
      case MediaImageResult(:final file):
        logger.debug('Выбран аватар: ${file.path}');
      case MediaEmojiResult(:final emoji):
        logger.debug('Выбран эмодзи-аватар: $emoji');
      case MediaLinkResult(:final url):
        logger.debug('Выбран аватар по ссылке: $url');
    }
  }

  Widget _lastNameTile(BuildContext context, String lastName) {
    return CupertinoListTile(
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(context.t.screenMyProfile.lastName, style: TextStyle(fontSize: MediaQuery.textScalerOf(context).scale(16))),
          Text(
            lastName,
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
    );
  }

  Widget _firstNameTile(BuildContext context, String firstName) {
    return CupertinoListTile(
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(context.t.screenMyProfile.firstName, style: TextStyle(fontSize: MediaQuery.textScalerOf(context).scale(16))),
          Text(
            firstName,
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
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SettingsMyProfileCubit, SettingsMyProfileState>(
      listener: (context, state) {},
      builder: (context, state) {
        return CupertinoPageScaffold(
          backgroundColor: ThemesCupertino.groupedBackground,
          navigationBar: AppCupertinoNavigationBar(
            child: CupertinoNavigationBar(
              automaticBackgroundVisibility: false,
              backgroundColor: ThemesCupertino.groupedBackground,
              middle: Text(context.t.screenMyProfile.myprofile),
              leading: CupertinoButton(
                padding: EdgeInsets.zero,
                onPressed: () => context.pop(),
                child: Text(context.t.screenMyProfile.cancel, style: TextStyle(color: ThemesCupertino.navActionColor(context))),
              ),
              trailing: CupertinoButton(
                padding: EdgeInsets.zero,
                // push (а не go): дожидаемся закрытия экрана правки и перечитываем
                // профиль из локальной БД — экран профиля не пересоздаётся при
                // возврате, поэтому обновляем его вручную.
                onPressed: () async {
                  final cubit = context.read<SettingsMyProfileCubit>();
                  await context.push("/settings/profile/edit");
                  await cubit.reload();
                },
                child: state.networkStatus == Status.loading
                    ? CupertinoActivityIndicator()
                    : Text(context.t.screenMyProfile.edit, style: TextStyle(color: ThemesCupertino.navActionColor(context))),
              ),
            ),
          ),
          child: SafeArea(
            child: ListView(
              children: [
                const SizedBox(height: 12),
                Center(
                  child: GestureDetector(
                    onTap: () => _pickAvatar(context),
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
                          context.t.screenMyProfile.editPhoto,
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
                    // В русской локали принят порядок «фамилия, имя», в остальных — «имя, фамилия».
                    // Плитку показываем только если соответствующее поле заполнено.
                    ...(state.locale == AppLocale.ru
                        ? [
                            if (state.lastName.isNotEmpty) _lastNameTile(context, state.lastName),
                            if (state.firstName.isNotEmpty) _firstNameTile(context, state.firstName),
                          ]
                        : [
                            if (state.firstName.isNotEmpty) _firstNameTile(context, state.firstName),
                            if (state.lastName.isNotEmpty) _lastNameTile(context, state.lastName),
                          ]),

                    CopyTooltip(
                      value: state.phoneNumber,
                      label: context.t.screenMyProfile.copy,
                      child: CupertinoListTile(
                        title: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              context.t.screenMyProfile.mobilePhone,
                              style: TextStyle(fontSize: MediaQuery.textScalerOf(context).scale(16)),
                            ),
                            Text(
                              state.phoneNumber,
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
                      ),
                    ),
                    if (state.username.isNotEmpty) ...[
                      CopyTooltip(
                        value: '@${state.username}',
                        label: context.t.screenMyProfile.copy,
                        child: CupertinoListTile(
                          title: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                context.t.screenMyProfile.username,
                                style: TextStyle(fontSize: MediaQuery.textScalerOf(context).scale(16)),
                              ),
                              Text(
                                '@${state.username}',
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
                        ),
                      ),
                    ],
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
                    // CupertinoListTileIcon(
                    //   title: Text(context.t.screenMyProfile.number),
                    //   color: Color(0xFF049A40),
                    //   icon: FontAwesomeIcons.phone,
                    //   onTab: () async {},
                    //   additionalInfo: Text("+7 909 160-00-44"),
                    //   isTrailing: true,
                    // ),
                    CupertinoListTileIcon(
                      title: Text(context.t.screenMyProfile.username),
                      color: Color(0xFF3B74BF),
                      icon: FontAwesomeIcons.at,
                      onTab: () async {},
                      additionalInfo: Text(state.username.isNotEmpty ? context.t.screenMyProfile.edit : context.t.screenMyProfile.add),
                      isTrailing: true,
                    ),
                  ],
                ),

                // CupertinoListSection.insetGrouped(
                //   clipBehavior: Clip.antiAlias,
                //   backgroundColor: ThemesCupertino.groupedBackground.resolveFrom(context),
                //   decoration: BoxDecoration(
                //     color: ThemesCupertino.groupedCard.resolveFrom(context),
                //     borderRadius: const BorderRadius.all(Radius.circular(18)),
                //   ),
                //   children: [
                //     SizedBox(
                //       width: double.infinity,
                //       child: CupertinoButton.filled(
                //         onPressed: () {},
                //         color: CupertinoColors.systemRed.withValues(alpha: 0.7),
                //         foregroundColor: CupertinoColors.white,
                //         child: Text("Удалить аккаунт"),
                //       ),
                //     ),
                //   ],
                // ),
              ],
            ),
          ),
        );
      },
    );
  }
}
