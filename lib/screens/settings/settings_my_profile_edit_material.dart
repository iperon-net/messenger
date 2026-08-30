import 'package:material_ui/material_ui.dart';
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

class SettingsMyProfileEditMaterial extends StatefulWidget {
  const SettingsMyProfileEditMaterial({super.key});

  @override
  State<SettingsMyProfileEditMaterial> createState() => _SettingsMyProfileEditMaterial();
}

class _SettingsMyProfileEditMaterial extends State<SettingsMyProfileEditMaterial> {
  final formKey = GlobalKey<FormState>();
  final firstNameController = TextEditingController();
  final firstNameFocus = FocusNode();
  final lastNameController = TextEditingController();
  final lastNameFocus = FocusNode();

  final birthDateController = TextEditingController();

  final aboutMeController = TextEditingController();
  final aboutMeFocus = FocusNode();

  final logger = getIt.get<Logger>();

  // Последние значения профиля, проброшенные в контроллеры (см. Cupertino-версию).
  String? _syncedFirstName;
  String? _syncedLastName;
  String? _syncedAboutMe;
  DateTime? _syncedBirthDate;
  bool _syncedBirthDateSet = false;

  @override
  void dispose() {
    firstNameController.dispose();
    firstNameFocus.dispose();
    lastNameController.dispose();
    lastNameFocus.dispose();
    birthDateController.dispose();
    aboutMeController.dispose();
    aboutMeFocus.dispose();
    super.dispose();
  }

  Future<void> _pickBirthDate(BuildContext context, DateTime? current) async {
    final cubit = context.read<SettingsMyProfileEditCubit>();
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: current ?? now,
      firstDate: DateTime(now.year - 100, now.month, now.day),
      lastDate: now,
    );
    if (picked == null) return;
    cubit.setBirthDate(picked);
    birthDateController.text = picked.toIso8601String();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SettingsMyProfileEditCubit, SettingsMyProfileEditState>(
      listenWhen: (previous, current) =>
          previous.firstName != current.firstName ||
          previous.lastName != current.lastName ||
          previous.aboutMe != current.aboutMe ||
          previous.birthDate != current.birthDate ||
          previous.redirectURI != current.redirectURI ||
          previous.error != current.error,
      listener: (context, state) {
        if (state.error.isNotEmpty) {
          showDialog<void>(
            context: context,
            builder: (BuildContext context) => AlertDialog(
              title: Text(context.t.screenMyProfile.error),
              content: Text(context.t[state.error]),
              actions: <Widget>[TextButton(onPressed: () => Navigator.pop(context), child: Text(context.t.screenMyProfile.close))],
            ),
          );
          return;
        }

        if (state.redirectURI.isNotEmpty && state.redirectURI == "/settings/profile") return context.pop();

        // Синхронизируем только реально изменившиеся поля (см. Cupertino-версию).
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
        final firstNameField = TextFormField(
          controller: firstNameController,
          focusNode: firstNameFocus,
          autofillHints: const [AutofillHints.givenName],
          decoration: InputDecoration(labelText: context.t.screenMyProfile.firstName, border: const OutlineInputBorder()),
          validator: (value) => switch (context.read<SettingsMyProfileEditCubit>().validateFirstName(value)) {
            FirstNameValidationError.maxLength => context.t.screenMyProfile.validationFirstNameMaxLength,
            null => null,
          },
        );
        final lastNameField = TextFormField(
          controller: lastNameController,
          focusNode: lastNameFocus,
          autofillHints: const [AutofillHints.familyName],
          decoration: InputDecoration(labelText: context.t.screenMyProfile.lastName, border: const OutlineInputBorder()),
          validator: (value) => switch (context.read<SettingsMyProfileEditCubit>().validateFirstName(value)) {
            FirstNameValidationError.maxLength => context.t.screenMyProfile.validationLastNameMaxLength,
            null => null,
          },
        );
        // Для русской локали фамилия выше имени, в остальных — имя, затем фамилия.
        final nameFields = LocaleSettings.currentLocale == AppLocale.ru ? [lastNameField, firstNameField] : [firstNameField, lastNameField];

        return Scaffold(
          appBar: AppBar(
            title: Text(context.t.screenMyProfile.myprofile),
            leadingWidth: 100,
            leading: TextButton(onPressed: () => context.pop(), child: Text(context.t.common.cancel)),
            actions: [
              state.networkStatus == Status.loading
                  ? const Padding(
                      padding: EdgeInsets.only(right: 16),
                      child: Center(child: SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2))),
                    )
                  : TextButton(
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
                      child: Text(context.t.common.save),
                    ),
            ],
          ),
          body: Form(
            key: formKey,
            child: SafeArea(
              child: ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  ...nameFields.expand((field) => [field, const SizedBox(height: 16)]),
                  Card(
                    clipBehavior: Clip.antiAlias,
                    child: Column(
                      children: [
                        MaterialListTileIcon(
                          title: Text(context.t.screenMyProfile.birthDate),
                          color: const Color(0xFFC50CA9),
                          icon: FontAwesomeIcons.cakeCandles,
                          // Дату форматирует intl (DateFormat без локали → Intl.defaultLocale),
                          // а slang лишь вставляет готовую строку.
                          additionalInfo: state.birthDate != null
                              ? Text(
                                  context.t.screenMyProfile.birthDayFormat(
                                    date: DateFormat.yMd().format(state.birthDate ?? DateTime.now()),
                                  ),
                                )
                              : Text(context.t.screenMyProfile.add),
                          isTrailing: state.birthDate != null,
                          onTab: () async => await _pickBirthDate(context, state.birthDate),
                        ),
                        if (state.birthDate != null)
                          ListTile(
                            title: Text(
                              context.t.screenMyProfile.birthDayRemove,
                              style: TextStyle(color: Theme.of(context).colorScheme.error),
                            ),
                            onTap: () {
                              context.read<SettingsMyProfileEditCubit>().clearBirthDate();
                              birthDateController.text = "";
                            },
                          ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: aboutMeController,
                    focusNode: aboutMeFocus,
                    maxLines: 2,
                    maxLength: 70,
                    decoration: InputDecoration(
                      labelText: context.t.screenMyProfile.aboutMe,
                      hintText: context.t.screenMyProfile.tellUsAboutYourself,
                      border: const OutlineInputBorder(),
                    ),
                    validator: (value) => switch (context.read<SettingsMyProfileEditCubit>().validateAboutMe(value)) {
                      AboutMeValidationError.maxLength => context.t.screenMyProfile.validationAboutMeMaxLength,
                      null => null,
                    },
                    onChanged: (value) => context.read<SettingsMyProfileEditCubit>().setAboutMeLength(value.length),
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
