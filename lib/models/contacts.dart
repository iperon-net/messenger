import 'package:freezed_annotation/freezed_annotation.dart';

part 'contacts.freezed.dart';
part 'contacts.g.dart';

@freezed
abstract class Contact with _$Contact {
  const Contact._();
  @JsonSerializable(explicitToJson: true)

  const factory Contact({
    required String contactId,
    required String accountId,
    required String? userId,
    required String lastName,
    required String firstName,
    required int phone,
    @Default(0) int lastVisitAt,
  }) = _Contact;

  factory Contact.fromJson(Map<String, dynamic> json) => _$ContactFromJson(json);

  Map<String, dynamic> toSqlite() => toJson();

  factory Contact.fromSqlite(Map<String, dynamic> data) {
    return Contact.fromJson(data);
  }

}

@freezed
abstract class ContactTabs with _$ContactTabs {
  const ContactTabs._();
  @JsonSerializable(explicitToJson: true)

  const factory ContactTabs({
    required String contactTabsId,
    required String name,
    required int sort,
    @Default(false) bool isSystem,
    @Default("") String systemName,
  }) = _ContactTabs;

  factory ContactTabs.fromJson(Map<String, dynamic> json) => _$ContactTabsFromJson(json);
}
