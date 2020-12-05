// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'timezone_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TimezoneModel _$TimezoneModelFromJson(Map<String, dynamic> json) {
  return TimezoneModel(
    json['status'] as String,
    json['message'] as String,
    (json['zones'] as List)
        ?.map((e) =>
            e == null ? null : ItemTimezone.fromJson(e as Map<String, dynamic>))
        ?.toList(),
  );
}

Map<String, dynamic> _$TimezoneModelToJson(TimezoneModel instance) =>
    <String, dynamic>{
      'status': instance.status,
      'message': instance.message,
      'zones': instance.listTimezones,
    };

ItemTimezone _$ItemTimezoneFromJson(Map<String, dynamic> json) {
  return ItemTimezone(
    json['countryCode'] as String,
    json['countryName'] as String,
    json['zoneName'] as String,
    json['gmtOffset'] as int,
    json['timestamp'] as int,
  );
}

Map<String, dynamic> _$ItemTimezoneToJson(ItemTimezone instance) =>
    <String, dynamic>{
      'countryCode': instance.countrCode,
      'countryName': instance.countryName,
      'zoneName': instance.zoneName,
      'gmtOffset': instance.gmtOffset,
      'timestamp': instance.timestamp,
    };
