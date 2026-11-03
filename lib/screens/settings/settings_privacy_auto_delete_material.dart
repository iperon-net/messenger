import 'package:material_ui/material_ui.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../cubit.dart';
import '../../i18n/translations.g.dart';

class SettingsPrivacyAutoDeleteMaterial extends StatelessWidget {
  const SettingsPrivacyAutoDeleteMaterial({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => SettingsPrivacyAndSecurityCubit()..initialization(),
      child: BlocBuilder<SettingsPrivacyAndSecurityCubit, SettingsPrivacyAndSecurityState>(
        builder: (context, state) => Scaffold(
          appBar: AppBar(title: Text(context.t.accountDeletion.autoDeleteTitle)),
          body: ListView(
            children: [
              Card(
                margin: const EdgeInsets.all(12),
                child: Column(
                  children: [
                    for (final months in const [3, 6, 12])
                      ListTile(
                        title: Text(context.t.accountDeletion.months(count: months)),
                        trailing: state.autoDeletePeriodMonths == months ? const Icon(Icons.check) : null,
                        onTap: state.callsReadOnly || state.callsLoadError
                            ? null
                            : () async {
                                final ok = await context.read<SettingsPrivacyAndSecurityCubit>().setAutoDeletePeriod(months);
                                if (!ok && context.mounted) {
                                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(context.t.common.noConnectionMessage)));
                                }
                              },
                      ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Text(
                  context.t.accountDeletion.autoDeleteDescription,
                  style: TextStyle(color: Theme.of(context).colorScheme.onSurfaceVariant),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
