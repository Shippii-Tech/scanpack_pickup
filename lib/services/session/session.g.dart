// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'session.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Session _$SessionFromJson(Map<String, dynamic> json) => Session(
      pallets:
          (json['pallets'] as List<dynamic>).map((e) => e as String).toList(),
      session: json['session'] as String,
    );

Map<String, dynamic> _$SessionToJson(Session instance) => <String, dynamic>{
      'pallets': instance.pallets,
      'session': instance.session,
    };
