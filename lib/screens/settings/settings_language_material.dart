import 'package:material_ui/material_ui.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../cubit.dart';
import '../../i18n/translations.g.dart';

class SettingsLanguageMaterialScreen extends StatefulWidget {
  const SettingsLanguageMaterialScreen({super.key});

  @override
  State<SettingsLanguageMaterialScreen> createState() => _SettingsLanguageMaterialScreen();
}

class _SettingsLanguageMaterialScreen extends State<SettingsLanguageMaterialScreen> {
  @override
  Widget build(BuildContext context) {
    final check = Icon(Icons.check, size: 22, color: Theme.of(context).colorScheme.primary);

    return BlocConsumer<SettingsLanguageCubit, SettingsLanguageState>(
      listenWhen: (previousState, currentState) => previousState.locale != currentState.locale,
      listener: (context, state) => context.read<CommonCubit>().setLocale(locale: state.locale),
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(title: Text(context.t.screenSettingsLanguage.language)),
          body: SafeArea(
            child: ListView(
              children: [
                Card(
                  margin: const EdgeInsets.all(12),
                  child: Column(
                    children: [
                      ListTile(
                        title: const Text("English"),
                        subtitle: const Text("English"),
                        onTap: () async => await context.read<SettingsLanguageCubit>().setLocale(locale: AppLocale.en),
                        trailing: state.locale == AppLocale.en ? check : null,
                      ),
                      ListTile(
                        title: const Text("Russian"),
                        subtitle: const Text("Русский"),
                        onTap: () async => await context.read<SettingsLanguageCubit>().setLocale(locale: AppLocale.ru),
                        trailing: state.locale == AppLocale.ru ? check : null,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
