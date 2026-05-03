import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:messenger/utils.dart';

import '../../di.dart';
import '../../logger.dart';
import 'auth_confirmation_cubit.dart';

class AuthConfirmationMaterialScreen extends StatefulWidget {
  final String confirmationSession;

  const AuthConfirmationMaterialScreen({
    super.key,
    required this.confirmationSession,
  });

  @override
  State<AuthConfirmationMaterialScreen> createState() => _AuthConfirmationMaterialScreen();
}

class _AuthConfirmationMaterialScreen extends State<AuthConfirmationMaterialScreen> {
  final logger = getIt.get<Logger>();
  final utils = getIt.get<Utils>();

  @override
  void initState() {
    super.initState();
    context.read<AuthConfirmationCubit>().initialization(confirmationSession: widget.confirmationSession);
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.surface,
        leading: BackButton(
          color: Theme.of(context).colorScheme.onSurface,
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(25, 40, 25, 50),
          child: Center(
            child: Column(
              spacing: 30,
              children: [
                SvgPicture.asset(Theme.of(context).brightness == Brightness.light ? 'assets/images/logo_light.svg' : 'assets/images/logo_dark.svg'),
                // CircularProgressIndicator(strokeWidth: 3, color: Theme.of(context).colorScheme.primary),
              ],
            ),
          ),
        )
      ),
    );
  }

}
