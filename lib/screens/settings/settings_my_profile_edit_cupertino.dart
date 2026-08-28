import 'package:cupertino_ui/cupertino_ui.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../components.dart';
import '../../constants.dart';
import '../../cubit.dart';
import '../../di.dart';
import '../../i18n/translations.g.dart';
import '../../logger.dart';
import '../../themes.dart';

class SettingsMyProfileEditCupertino extends StatefulWidget {
  const SettingsMyProfileEditCupertino({super.key});

  @override
  State<SettingsMyProfileEditCupertino> createState() => _SettingsMyProfileEditCupertino();
}

class _SettingsMyProfileEditCupertino extends State<SettingsMyProfileEditCupertino> {
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

  // Последние значения профиля, проброшенные в контроллеры. Нужны, чтобы в
  // listener синхронизировать только реально изменившееся поле и не затирать
  // текст, набранный пользователем, при изменении соседнего поля (напр. даты).
  String? _syncedFirstName;
  String? _syncedLastName;
  String? _syncedAboutMe;
  DateTime? _syncedBirthDate;
  bool _syncedBirthDateSet = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    firstNameController.dispose();
    firstNameFocus.dispose();
    lastNameController.dispose();
    lastNameFocus.dispose();
    birthDateController.dispose();
    birthDateFocus.dispose();
    aboutMeController.dispose();
    aboutMeFocus.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SettingsMyProfileEditCubit, SettingsMyProfileEditState>(
      // Пробрасываем данные профиля в контроллеры только когда сам профиль
      // изменился (загрузка / обновление из MY_PROFILE), а не на каждый emit.
      // Ввод пользователя не меняет эти поля состояния, поэтому набранный текст
      // не затирается.
      listenWhen: (previous, current) =>
          previous.firstName != current.firstName ||
          previous.lastName != current.lastName ||
          previous.aboutMe != current.aboutMe ||
          previous.birthDate != current.birthDate ||
          previous.redirectURI != current.redirectURI ||
          previous.error != current.error,
      listener: (context, state) {
        if (state.error.isNotEmpty) {
          showCupertinoDialog<void>(
            context: context,
            builder: (BuildContext context) => CupertinoAlertDialog(
              title: Text(context.t.screenMyProfile.error),
              content: Text(context.t[state.error]),
              actions: <CupertinoDialogAction>[
                CupertinoDialogAction(
                  isDefaultAction: true,
                  onPressed: () => Navigator.pop(context),
                  child: Text(context.t.screenMyProfile.close),
                ),
              ],
            ),
          );
          return;
        }

        if (state.redirectURI.isNotEmpty && state.redirectURI == "/settings/profile") return context.pop();

        // Синхронизируем только те поля, что реально изменились с прошлой
        // синхронизации (загрузка профиля / обновление из MY_PROFILE). Иначе
        // изменение одного поля в state (напр. birthDate) затирало бы текст,
        // который пользователь уже набрал в других контроллерах.
        if (state.firstName != _syncedFirstName) {
          firstNameController.text = state.firstName;
          _syncedFirstName = state.firstName;
        }
        if (state.lastName != _syncedLastName) {
          lastNameController.text = state.lastName;
          _syncedLastName = state.lastName;
        }
        if (state.aboutMe != _syncedAboutMe) {
          aboutMeController.text = state.aboutMe;
          _syncedAboutMe = state.aboutMe;
        }
        if (!_syncedBirthDateSet || state.birthDate != _syncedBirthDate) {
          birthDateController.text = state.birthDate?.toIso8601String() ?? "";
          _syncedBirthDate = state.birthDate;
          _syncedBirthDateSet = true;
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
              leading: CupertinoButton(
                padding: EdgeInsets.zero,
                onPressed: () => context.pop(),
                child: Text(context.t.common.cancel, style: TextStyle(color: ThemesCupertino.navActionColor(context))),
              ),
              trailing: CupertinoButton(
                padding: EdgeInsets.zero,
                onPressed: () async {
                  if (formKey.currentState!.validate()) {
                    logger.debug(birthDateController.text);

                    await context.read<SettingsMyProfileEditCubit>().setProfile(
                      birthDate: birthDateController.text,
                      firstName: firstNameController.text,
                      lastName: lastNameController.text,
                      aboutMe: aboutMeController.text,
                    );
                  }
                },
                child: state.networkStatus == Status.loading
                    ? CupertinoActivityIndicator()
                    : Text(context.t.common.save, style: TextStyle(color: ThemesCupertino.navActionColor(context))),
              ),
            ),
          ),
          child: Form(
            key: formKey,
            child: SafeArea(
              child: ListView(
                children: [
                  const SizedBox(height: 20),
                  CupertinoFormSection.insetGrouped(
                    clipBehavior: Clip.antiAlias,
                    backgroundColor: ThemesCupertino.groupedBackground.resolveFrom(context),
                    decoration: BoxDecoration(
                      color: ThemesCupertino.groupedCard.resolveFrom(context),
                      borderRadius: const BorderRadius.all(Radius.circular(18)),
                    ),
                    children: [
                      CupertinoTextFormFieldRow(
                        placeholder: context.t.screenMyProfile.firstName,
                        controller: firstNameController,
                        focusNode: firstNameFocus,
                        autofillHints: [AutofillHints.givenName],
                        validator: (value) {
                          final error = switch (context.read<SettingsMyProfileEditCubit>().validateFirstName(value)) {
                            FirstNameValidationError.maxLength => context.t.screenMyProfile.validationFirstNameMaxLength,
                            null => null,
                          };
                          return error;
                        },
                      ),
                      CupertinoTextFormFieldRow(
                        placeholder: context.t.screenMyProfile.lastName,
                        controller: lastNameController,
                        focusNode: lastNameFocus,
                        autofillHints: [AutofillHints.familyName],
                        validator: (value) {
                          final error = switch (context.read<SettingsMyProfileEditCubit>().validateFirstName(value)) {
                            FirstNameValidationError.maxLength => context.t.screenMyProfile.validationLastNameMaxLength,
                            null => null,
                          };
                          return error;
                        },
                      ),
                    ],
                  ),

                  // Дата рождения.
                  CupertinoListSection.insetGrouped(
                    clipBehavior: Clip.antiAlias,
                    backgroundColor: ThemesCupertino.groupedBackground.resolveFrom(context),
                    decoration: BoxDecoration(
                      color: ThemesCupertino.groupedCard.resolveFrom(context),
                      borderRadius: const BorderRadius.all(Radius.circular(18)),
                    ),
                    // footer: Text("Удалить"),
                    children: [
                      CupertinoListTileIcon(
                        title: Text(context.t.screenMyProfile.birthDate),
                        color: Color(0xFFC50CA9),
                        icon: FontAwesomeIcons.cakeCandles,
                        additionalInfo: state.birthDate != null
                            // Дату форматирует intl (DateFormat без локали → Intl.defaultLocale,
                            // напр. en_GB → 22/08/2026), а slang лишь вставляет готовую строку.
                            // Формат `{date: yMd}` в slang не годится: он зашивает локаль
                            // перевода ('en'/'ru') и игнорирует регион.
                            ? Text(
                                context.t.screenMyProfile.birthDayFormat(date: DateFormat.yMd().format(state.birthDate ?? DateTime.now())),
                              )
                            : Text(context.t.screenMyProfile.add),
                        isTrailing: state.birthDate != null ? true : false,
                        onTab: () async {
                          final cubit = context.read<SettingsMyProfileEditCubit>();
                          // Пикер по умолчанию показывает эту дату. Держим выбор в
                          // переменной, а не в контроллере: onDateTimeChanged
                          // срабатывает только при прокрутке, и без него «Готово»
                          // читало бы пустую строку → FormatException.
                          DateTime selectedBirthDate = state.birthDate ?? DateTime.now();
                          showCupertinoModalPopup<void>(
                            context: context,
                            builder: (BuildContext context) => Container(
                              height: 350,
                              padding: const .only(top: 6.0),
                              margin: .only(bottom: MediaQuery.of(context).viewInsets.bottom),
                              color: CupertinoColors.systemBackground.resolveFrom(context),
                              child: SafeArea(
                                top: false,
                                child: Column(
                                  children: [
                                    SizedBox(
                                      height: 50,
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          CupertinoButton(
                                            onPressed: () => Navigator.pop(context),
                                            child: Text(
                                              context.t.screenMyProfile.cancel,
                                              style: TextStyle(
                                                color: CupertinoDynamicColor.withBrightness(
                                                  color: CupertinoTheme.of(context).primaryColor,
                                                  darkColor: CupertinoColors.white,
                                                ).resolveFrom(context),
                                              ),
                                            ),
                                          ),
                                          CupertinoButton(
                                            onPressed: () {
                                              cubit.setBirthDate(selectedBirthDate);
                                              birthDateController.text = selectedBirthDate.toIso8601String();
                                              Navigator.pop(context);
                                            },
                                            child: Text(
                                              context.t.screenMyProfile.done,
                                              style: TextStyle(
                                                color: CupertinoDynamicColor.withBrightness(
                                                  color: CupertinoTheme.of(context).primaryColor,
                                                  darkColor: CupertinoColors.white,
                                                ).resolveFrom(context),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Expanded(
                                      child: CupertinoDatePicker(
                                        initialDateTime: state.birthDate ?? DateTime.now(),
                                        mode: CupertinoDatePickerMode.date,
                                        minimumDate: DateTime(DateTime.now().year - 100, DateTime.now().month, DateTime.now().day),
                                        maximumDate: DateTime.now(),
                                        showDayOfWeek: false,
                                        onDateTimeChanged: (DateTime birthDate) => selectedBirthDate = birthDate,
                                      ),
                                    ),
                                    if (state.birthDate != null) ...[
                                      SizedBox(height: 10),
                                      CupertinoButton(
                                        onPressed: () {
                                          cubit.clearBirthDate();
                                          birthDateController.text = "";
                                          Navigator.pop(context);
                                        },
                                        child: Text(
                                          context.t.screenMyProfile.birthDayRemove,
                                          style: TextStyle(color: CupertinoColors.systemRed),
                                        ),
                                      ),
                                    ],
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                      // CupertinoButton(padding: EdgeInsetsGeometry.zero, child: Text("dddd"), onPressed: () {}),
                      // CupertinoListTile(
                      //   padding: EdgeInsets.only(left: 18),
                      //   title: Text(
                      //     "Удалить",
                      //     style: TextStyle(fontWeight: FontWeight.normal, color: CupertinoColors.destructiveRed),
                      //   ),
                      //   onTap: () async => null,
                      // ),
                    ],
                  ),
                  CupertinoFormSection.insetGrouped(
                    header: Text(context.t.screenMyProfile.aboutMe.toUpperCase()),
                    clipBehavior: Clip.antiAlias,
                    backgroundColor: ThemesCupertino.groupedBackground.resolveFrom(context),
                    decoration: BoxDecoration(
                      color: ThemesCupertino.groupedCard.resolveFrom(context),
                      borderRadius: const BorderRadius.all(Radius.circular(18)),
                    ),
                    footer: state.aboutMeLength > 0 ? Text("${state.aboutMeLength}/70") : null,
                    children: [
                      CupertinoTextFormFieldRow(
                        controller: aboutMeController,
                        focusNode: aboutMeFocus,
                        placeholder: context.t.screenMyProfile.tellUsAboutYourself,
                        maxLines: 2,
                        maxLength: 70,
                        validator: (value) {
                          final error = switch (context.read<SettingsMyProfileEditCubit>().validateAboutMe(value)) {
                            AboutMeValidationError.maxLength => context.t.screenMyProfile.validationAboutMeMaxLength,
                            null => null,
                          };
                          return error;
                        },
                        onChanged: (value) => context.read<SettingsMyProfileEditCubit>().setAboutMeLength(value.length),
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
