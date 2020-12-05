import 'package:json_annotation/json_annotation.dart';
part 'timezone_model.g.dart';

@JsonSerializable()
class TimezoneModel {
  @JsonKey(name: 'status')
  final String status;
  @JsonKey(name: 'message')
  final String message;
  @JsonKey(name: 'zones')
  final List<ItemTimezone> listTimezones;

  TimezoneModel(
    this.status,
    this.message,
    this.listTimezones,
  );

  factory TimezoneModel.fromJson(Map<String, dynamic> json) => _$TimezoneModelFromJson(json);

  Map<String, dynamic> toJson() => _$TimezoneModelToJson(this);

  @override
  String toString() {
    return 'TimezoneModel{status: $status, message: $message, listTimezones: $listTimezones}';
  }
}

@JsonSerializable()
class ItemTimezone {
  @JsonKey(name: 'countryCode')
  final String countrCode;
  @JsonKey(name: 'countryName')
  final String countryName;
  @JsonKey(name: 'zoneName')
  final String zoneName;
  @JsonKey(name: 'gmtOffset')
  final int gmtOffset;
  @JsonKey(name: 'timestamp')
  final int timestamp;

  ItemTimezone(
    this.countrCode,
    this.countryName,
    this.zoneName,
    this.gmtOffset,
    this.timestamp,
  );

  factory ItemTimezone.fromJson(Map<String, dynamic> json) => _$ItemTimezoneFromJson(json);

  Map<String, dynamic> toJson() => _$ItemTimezoneToJson(this);

  @override
  String toString() {
    return 'ItemTimezone{countrCode: $countrCode, countryName: $countryName, zoneName: $zoneName, gmtOffset: $gmtOffset, timestamp: $timestamp}';
  }
}
