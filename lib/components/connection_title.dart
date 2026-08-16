import 'package:cupertino_ui/cupertino_ui.dart' hide ConnectionState;
import 'package:flutter_bloc/flutter_bloc.dart';

import '../cubit.dart';
import '../i18n/translations.g.dart';

class ConnectionTitle extends StatelessWidget {
  const ConnectionTitle({super.key, required this.title});

  /// Что показать, когда соединение в норме.
  final String title;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ConnectionCubit, ConnectionState>(
      buildWhen: (previous, current) => previous.connection != current.connection,
      builder: (context, state) {
        final (String label, bool spinner) = switch (state.connection) {
          ConnectionStatusModel.connected => (title, false),
          ConnectionStatusModel.connecting => (context.t.connection.connecting, true),
          ConnectionStatusModel.updating => (context.t.connection.updating, true),
          ConnectionStatusModel.waitingForNetwork => (context.t.connection.waitingForNetwork, false),
        };

        if (!spinner) {
          return Text(label);
        }

        return Row(
          mainAxisSize: MainAxisSize.min,
          children: [const CupertinoActivityIndicator(radius: 8), const SizedBox(width: 8), Text(label)],
        );
      },
    );
  }
}
