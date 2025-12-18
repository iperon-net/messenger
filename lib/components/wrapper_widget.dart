import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../constants.dart';

class WrapperLoadingWidget extends StatelessWidget {
  final Status status;
  final Function() func;

  const WrapperLoadingWidget(this.func, {super.key, required this.status});

  @override
  Widget build(BuildContext context) {
    if (status == Status.loading) {
      return Center(
        child: Platform.isIOS ? CupertinoActivityIndicator(radius: 14.0) : CircularProgressIndicator(),
      );
    } else if (status == Status.success) {
      return func();
    }
    return Text("not found status");
  }
}

class WrapperErrorWidget {
  final BuildContext context;
  final String error;

  factory WrapperErrorWidget(BuildContext context, String error) {
    if (Platform.isIOS) {
      if (context.mounted && error.isNotEmpty) {
        showCupertinoDialog<void>(
          context: context,
          builder: (BuildContext context) =>
              CupertinoAlertDialog(
                title: const Text('Error'),
                content: Text(error),
                actions: <CupertinoDialogAction>[
                  CupertinoDialogAction(
                    isDefaultAction: true,
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: const Text('Закрыть'),
                  ),
                ],
              ),
        );
      }
    } else {
      ScaffoldMessenger.of(context).clearSnackBars();
      if (context.mounted && error.isNotEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(error),
          duration: Duration(seconds: 5),
          showCloseIcon: true,
        ));
      }
    }
    return WrapperErrorWidget._internal(context, error);
  }

  WrapperErrorWidget._internal(this.context, this.error);
}

// class WrapperNetworkWidget extends StatelessWidget {
//   final Function() func;
//
//   const WrapperNetworkWidget(this.func, {super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     final streams = getIt.get<Streams>();
//     final logger = getIt.get<Logger>();
//
//     // return StreamBuilder<models.NetworkState>(
//     //   stream: streams.streamControllerNetworkState.stream,
//     //   builder: (BuildContext context, AsyncSnapshot<models.NetworkState> snapshot) {
//     //     if (snapshot.data != null && snapshot.data!.message.isNotEmpty) {
//     //       return Text(snapshot.data!.message);
//     //     }
//     //     return Container();
//     //   }
//     // );
//
//     return BlocConsumer<WrapperWidgetCubit, WrapperWidgetState>(
//         listener: (context, state) {
//         },
//         builder: (context, state) {
//           return Text("data ${state.testMessage}");
//         }
//     );
//
//
//   }
//
// }
