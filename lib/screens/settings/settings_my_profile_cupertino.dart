import 'package:cupertino_ui/cupertino_ui.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
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
      listener: (context, state) {},
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
                onPressed: () {
                  if (formKey.currentState!.validate()) {
                    logger.debug("validate ok!");

                    logger.debug("birthDate = ${birthDateController.value}");
                    logger.debug("firstName = ${firstNameController.value}");
                    logger.debug("lastName = ${lastNameController.value}");
                  }
                },
                child: Text(context.t.common.save),
              ),
            ),
          ),
          child: Form(
            key: formKey,
            child: SafeArea(
              child: ListView(
                children: [
                  // const SizedBox(height: 12),
                  // // Аватарка с кнопкой выбора фото.
                  // Center(
                  //   child: GestureDetector(
                  //     onTap: _pickPhoto,
                  //     behavior: HitTestBehavior.opaque,
                  //     child: Column(
                  //       children: [
                  //         Stack(
                  //           children: [
                  //             SizedBox(
                  //               width: 96,
                  //               height: 96,
                  //               child: AnimatedBoringAvatar(
                  //                 name: state.boringAvatarHash,
                  //                 type: state.boringAvatarType,
                  //                 shape: const CircleBorder(),
                  //                 curve: Curves.bounceIn,
                  //                 duration: const Duration(seconds: 1),
                  //               ),
                  //             ),
                  //           ],
                  //         ),
                  //         const SizedBox(height: 8),
                  //         Text(
                  //           "Изменить фото",
                  //           style: TextStyle(
                  //             fontSize: 16,
                  //             color: CupertinoDynamicColor.withBrightness(
                  //               color: CupertinoTheme.of(context).primaryColor,
                  //               darkColor: CupertinoColors.white,
                  //             ).resolveFrom(context),
                  //           ),
                  //         ),
                  //       ],
                  //     ),
                  //   ),
                  // ),
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
                        validator: (value) {
                          final error = switch (context.read<SettingsMyProfileCubit>().validateFirstName(value)) {
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
                        validator: (value) {
                          final error = switch (context.read<SettingsMyProfileCubit>().validateFirstName(value)) {
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
                          final cubit = context.read<SettingsMyProfileCubit>();
                          // Пикер по умолчанию показывает эту дату. Держим выбор в
                          // переменной, а не в контроллере: onDateTimeChanged
                          // срабатывает только при прокрутке, и без него «Готово»
                          // читало бы пустую строку → FormatException.
                          DateTime selectedBirthDate = state.birthDate ?? DateTime.now();
                          showCupertinoModalPopup<void>(
                            context: context,
                            builder: (BuildContext context) => Container(
                              height: 250,
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
                                        onDateTimeChanged: (DateTime birthDate) {
                                          selectedBirthDate = birthDate;
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      ),
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
                    children: [
                      CupertinoTextFormFieldRow(
                        placeholder: context.t.screenMyProfile.tellUsAboutYourself,
                        maxLines: 2,
                        maxLength: 140,
                        validator: (value) {
                          final error = switch (context.read<SettingsMyProfileCubit>().validateAboutMe(value)) {
                            AboutMeValidationError.maxLength => context.t.screenMyProfile.validationAboutMeMaxLength,
                            null => null,
                          };
                          return error;
                        },
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
                        title: Text(context.t.screenMyProfile.username),
                        color: Color(0xFF3B74BF),
                        icon: FontAwesomeIcons.at,
                        onTab: () async {},
                        additionalInfo: Text(context.t.screenMyProfile.add),
                        isTrailing: true,
                      ),
                      // CupertinoListTileIcon(
                      //   title: const Text("Номер"),
                      //   color: Color(0xFF049A40),
                      //   icon: FontAwesomeIcons.phone,
                      //   onTab: () async => _pickBirthDate,
                      //   additionalInfo: Text("+7 909 160-00-44"),
                      //   isTrailing: true,
                      // ),
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
