// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'contacts.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Contact _$ContactFromJson(Map<String, dynamic> json) => _Contact(
  contactId: json['contactId'] as String,
  accountId: json['accountId'] as String,
  userId: json['userId'] as String?,
  lastName: json['lastName'] as String,
  firstName: json['firstName'] as String,
  phone: (json['phone'] as num).toInt(),
  lastVisitAt: (json['lastVisitAt'] as num?)?.toInt() ?? 0,
);

Map<String, dynamic> _$ContactToJson(_Contact instance) => <String, dynamic>{
  'contactId': instance.contactId,
  'accountId': instance.accountId,
  'userId': instance.userId,
  'lastName': instance.lastName,
  'firstName': instance.firstName,
  'phone': instance.phone,
  'lastVisitAt': instance.lastVisitAt,
};

_ContactTabs _$ContactTabsFromJson(Map<String, dynamic> json) => _ContactTabs(
  contactTabsId: json['contactTabsId'] as String,
  name: json['name'] as String,
  sort: (json['sort'] as num).toInt(),
  isSystem: json['isSystem'] as bool? ?? false,
  systemName: json['systemName'] as String? ?? "",
);

Map<String, dynamic> _$ContactTabsToJson(_ContactTabs instance) =>
    <String, dynamic>{
      'contactTabsId': instance.contactTabsId,
      'name': instance.name,
      'sort': instance.sort,
      'isSystem': instance.isSystem,
      'systemName': instance.systemName,
    };
