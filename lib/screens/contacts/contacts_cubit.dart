import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../cubit/constants.dart';
import '../../models/contacts.dart';

part 'contacts_cubit.freezed.dart';
part 'contacts_state.dart';

class ContactsCubit extends Cubit<ContactsState> {
  ContactsCubit() : super(const ContactsState());

  Future<void> initialization() async {
    emit(state.copyWith(status: Status.loading));

    // emit(state.copyWith(permissionStatusContact: await Permission.contacts.status));

    final contacts = <Contact>[];
    contacts.add(Contact(
      contactId: "507f191e810c19729de860ea",
      accountId: "5099803df3f4948bd2f98391",
      userId: null,
      firstName: "Lilu",
      lastName: "Kazerogova",
      phone: 79090000000,
      lastVisitAt: 0
    ));

    contacts.add(Contact(
      contactId: "507f191e810c19729de861ea",
      accountId: "5099803df3f4948bd2f98391",
      userId: null,
      firstName: "Lilu2",
      lastName: "Kazerogova2",
      phone: 790900000001,
      lastVisitAt: 0
    ));

    final contactTabs = <ContactTabs>[];

    contactTabs.add(ContactTabs(
      contactTabsId: '507f191e810c19729de861ea',
      name: 'all',
      sort: 10,
      isSystem: true,
      systemName: "all"
    ));

    contactTabs.add(ContactTabs(
        contactTabsId: '507f191e810c19729de861e1',
        name: 'favorites',
        sort: 20,
        isSystem: true,
        systemName: "favorites"
    ));

    contactTabs.add(ContactTabs(
        contactTabsId: '507f191e810c19729de861ea',
        name: 'Моя семья',
        sort: 50,
    ));

    contactTabs.add(ContactTabs(
      contactTabsId: '507f191e810c19729de861ea',
      name: 'Моя семья',
      sort: 60,
    ));

    contactTabs.sort((a, b) => a.sort.compareTo(b.sort));

    emit(state.copyWith(status: Status.success, contacts: contacts, contactTabs: contactTabs));

    // await Future.delayed(Duration(seconds: 1));
    //
    // final contactsLastVisitAt = <Contact>[];
    //
    // contactsLastVisitAt.add(Contact(
    //     contactId: "507f191e810c19729de860ea",
    //     accountId: "5099803df3f4948bd2f98391",
    //     userId: null,
    //     firstName: "Lilu",
    //     lastName: "Kazerogova",
    //     phone: 79090000000,
    //     lastVisitAt: 1,
    // ));
    //
    // contactsLastVisitAt.add(Contact(
    //     contactId: "507f191e810c19729de861ea",
    //     accountId: "5099803df3f4948bd2f98391",
    //     userId: null,
    //     firstName: "Lilu2",
    //     lastName: "Kazerogova2",
    //     phone: 790900000001,
    //     lastVisitAt: 1,
    // ));
    //
    // emit(state.copyWith(contacts: contactsLastVisitAt));
  }


}
