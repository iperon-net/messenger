import 'package:flutter/material.dart' hide LockState;
import 'package:flutter_bloc/flutter_bloc.dart';

import 'lock_cubit.dart';

class LockScreenMaterial extends StatefulWidget {
  const LockScreenMaterial({super.key});

  @override
  State<LockScreenMaterial> createState() => _LockScreenMaterial();
}

class _LockScreenMaterial extends State<LockScreenMaterial> {

  @override
  void initState() {
    super.initState();
    // context.read<LockCubit>().lock(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: BlocListener<LockCubit, LockState>(
          listener: (context, state) {
            context.read<LockCubit>().lock(context);
            // TODO: implement listener
          },
          child: Center(
            child: OutlinedButton(
              onPressed: () {},
              child: Text("dddd"),
            ),
          ),
        ));
  }

}
