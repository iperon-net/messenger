import 'package:avatar_plus/avatar_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:messenger/screens/contacts/contacts_cubit.dart';

import '../../di.dart';
import '../../i18n/translations.g.dart';
import '../../logger.dart';

class ContactsScreenCupertino extends StatefulWidget {
  const ContactsScreenCupertino({super.key});

  @override
  State<ContactsScreenCupertino> createState() => _ContactsScreenCupertino();
}

class _ContactsScreenCupertino extends State<ContactsScreenCupertino> {

  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    context.read<ContactsCubit>().initialization();
    super.initState();
  }


  Widget search(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
        child: CupertinoSearchTextField(placeholder: context.t.contacts.search),
      ),
    );
  }

  Widget tabs(BuildContext context) {
    return BlocBuilder<ContactsCubit, ContactsState>(
      builder: (context, state) {
        final tabs = <Widget>[];

        for (final tab in state.contactTabs) {
          if (tab == null) continue;

          String name = tab.name;

          if(tab.isSystem && tab.systemName == "all") {
            name = context.t.contacts.tabs.all;
          } else if (tab.isSystem && tab.systemName == "favorites") {
            name = context.t.contacts.tabs.favorites;
          }

          tabs.add(Padding(
            padding: const EdgeInsets.fromLTRB(15, 0, 0, 0),
            child: SizedBox(
              child: Center(
                child: Text(
                  name,
                  style: TextStyle(fontSize: 15),
                ),
              ),
            ),
          ));
        }

        return SizedBox(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.shortestSide * 0.08,
          child: ListView(
            scrollDirection: Axis.horizontal,
            children: tabs,

            // children: <Widget>[
            //   Padding(
            //     padding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
            //     child: SizedBox(
            //
            //       child: Center(
            //         child: Container(
            //           decoration: BoxDecoration(
            //             color: CupertinoTheme.of(context).primaryColor,
            //             border: Border.all(
            //               color: CupertinoTheme.of(context).primaryColor,
            //               width: 2,
            //               style: BorderStyle.solid,
            //             ),
            //             borderRadius: BorderRadius.circular(12),
            //           ),
            //           child: Row(
            //             children: [
            //               Padding(
            //                 padding: const EdgeInsets.all(5.0),
            //                 child: Text(
            //                   context.t.all_contacts,
            //                   style: TextStyle(
            //                     fontSize: 15.0,
            //                     color: CupertinoTheme.of(context).primaryContrastingColor,
            //                   ),
            //                 ),
            //               ),
            //             ],
            //           ),
            //         ),
            //       ),
            //     ),
            //   ),
            //   Padding(
            //     padding: const EdgeInsets.fromLTRB(15, 0, 0, 0),
            //     child: SizedBox(child: Center(child: Text(context.t.favorites, style: TextStyle(fontSize: 15),)),),
            //   ),
            //   Padding(
            //     padding: const EdgeInsets.fromLTRB(15, 0, 0, 0),
            //     child: SizedBox(child: Center(child: Text("Рабочие контакты", style: TextStyle(fontSize: 15),)),),
            //   ),
            //   Padding(
            //     padding: const EdgeInsets.fromLTRB(15, 0, 0, 0),
            //     child: SizedBox(
            //       child: Row(
            //         children: [
            //           Center(
            //             child: Text(
            //               "Моя семья",
            //               style: TextStyle(fontSize: 15),
            //             ),
            //           ),
            //         ],
            //       ),
            //     ),
            //   ),
            // ],
          ),
        );
      },
    );
  }

  Widget contacts(BuildContext context) {
    return BlocBuilder<ContactsCubit, ContactsState>(
      builder: (context, state) {

        final contacts = <CupertinoListTile>[];
        for (final contact in state.contacts) {
          if (contact == null) continue;

          contacts.add(CupertinoListTile(
            leading: AvatarPlus(contact.contactId.toString(), height: 32, width: 32),
            title: Text("${contact.firstName} ${contact.lastName}", style: TextStyle(fontSize: 15),),
            subtitle: Text("n/a"),
          ));

        }
        return CupertinoFormSection(
            children: contacts
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {

    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: Text(context.t.contacts.contacts),
      ),
      child: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              search(context),
              SizedBox(height: 15,),
              tabs(context),
              Dismissible(
                key: Key("d"),
                // crossAxisEndOffset: 1,
                secondaryBackground: contacts(context),
                background: contacts(context),
                direction: DismissDirection.endToStart,
                onDismissed: (direction) {
                  final logger = getIt.get<Logger>();
                  logger.debug(direction.name);
                  return;
                },
                onUpdate: (details) {
                  final logger = getIt.get<Logger>();
                  logger.debug(details.toString());
                },
                child: contacts(context),
              ),
            ],
          ),
        ),
      ),
    );
  }

}
