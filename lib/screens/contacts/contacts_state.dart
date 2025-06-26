part of 'contacts_cubit.dart';

@freezed
abstract class ContactsState with _$ContactsState {
    const ContactsState._();

  const factory ContactsState({
    @Default(Status.initial) Status status,
    @Default("") String errorMessage,
  }) = _ContactsState;
}
