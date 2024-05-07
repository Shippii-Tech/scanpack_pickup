// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pickup.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PickupWithStops _$PickupWithStopsFromJson(Map<String, dynamic> json) =>
    PickupWithStops(
      id: json['id'] as int,
      name: json['name'] as String,
      truck_plates: json['truck_plates'] as String,
      description: json['description'] as String,
      date: json['date'] as String,
      completed: json['completed'] as bool,
      stops: Stops.fromJson(json['stops'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$PickupWithStopsToJson(PickupWithStops instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'truck_plates': instance.truck_plates,
      'description': instance.description,
      'date': instance.date,
      'completed': instance.completed,
      'stops': instance.stops,
    };

Stops _$StopsFromJson(Map<String, dynamic> json) => Stops(
      id: json['id'] as int,
      name: json['name'] as String,
      address1: json['address1'] as String,
      address2: json['address2'] as String?,
      post_code: json['post_code'] as String,
      city: json['city'] as String,
      country: json['country'] as String,
      email: json['email'] as String,
      coordinates: json['coordinates'] as String?,
      att_name: json['att_name'] as String,
      att_phone: json['att_phone'] as String,
      att_email: json['att_email'] as String,
      description: json['description'] as String?,
      completed: json['completed'] as bool?,
      order: json['order'] as int,
    );

Map<String, dynamic> _$StopsToJson(Stops instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'address1': instance.address1,
      'address2': instance.address2,
      'post_code': instance.post_code,
      'city': instance.city,
      'country': instance.country,
      'email': instance.email,
      'coordinates': instance.coordinates,
      'att_name': instance.att_name,
      'att_phone': instance.att_phone,
      'att_email': instance.att_email,
      'description': instance.description,
      'completed': instance.completed,
      'order': instance.order,
    };

Pickup _$PickupFromJson(Map<String, dynamic> json) => Pickup(
      id: json['id'] as int,
      name: json['name'] as String,
      truck_plates: json['truck_plates'] as String,
      description: json['description'] as String,
      date: json['date'] as String,
      completed: json['completed'] as bool,
    );

Map<String, dynamic> _$PickupToJson(Pickup instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'truck_plates': instance.truck_plates,
      'description': instance.description,
      'date': instance.date,
      'completed': instance.completed,
    };
