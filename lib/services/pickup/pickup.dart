import 'package:json_annotation/json_annotation.dart';
import 'package:scanpack_pickup/services/store.dart';

part 'pickup.g.dart';

class UsePickup extends Store {
  List<Pickup> _items = [];
  List<Pickup> get items => _items;

  List<Stops> _stops = [];
  List<Stops> get stops => _stops;

  Pickup? _item;
  Pickup? get item => _item;

  Future get ({Map<String, dynamic>? payload}) async {
    _items = [];
    final result = await fetch<Map<String, dynamic>>('/pick-ups/today');

    for (var i = 0; i < result.data!['data'].length; ++i) {
      var o = result.data!['data'][i];
      _items.add(Pickup.fromJson(o));
    }

    notifyListeners();
    return result;
  }

  Future getStops (int id) async {
    _stops = [];
    final result = await fetch<Map<String, dynamic>>('/pick-ups/$id');

    _item = Pickup.fromJson(result.data!['data']!);
    for (var i = 0; i < result.data!['data']!['stops'].length; ++i) {
      var o = result.data!['data']['stops'][i];
      _stops.add(Stops.fromJson(o));
    }

    notifyListeners();
    return result;
  }


}

@JsonSerializable()
class PickupWithStops {
  int id;
  String name;
  String truck_plates;
  String description;
  String date;
  bool completed;
  Stops stops;

  PickupWithStops({
    required this.id,
    required this.name,
    required this.truck_plates,
    required this.description,
    required this.date,
    required this.completed,
    required this.stops,
  });

  factory PickupWithStops.fromJson(Map<String, dynamic> json) => _$PickupWithStopsFromJson(json);
  Map<String, dynamic> toJson() => _$PickupWithStopsToJson(this);
}


@JsonSerializable()
class Stops {
  int id;
  String name;
  String address1;
  String? address2;
  String post_code;
  String city;
  String country;
  String email;
  String? coordinates;
  String att_name;
  String att_phone;
  String att_email;
  String? description;
  bool? completed;
  int order;

  Stops({
    required this.id,
    required this.name,
    required this.address1,
    required this.address2,
    required this.post_code,
    required this.city,
    required this.country,
    required this.email,
    required this.coordinates,
    required this.att_name,
    required this.att_phone,
    required this.att_email,
    required this.description,
    required this.completed,
    required this.order,
  });

  factory Stops.fromJson(Map<String, dynamic> json) => _$StopsFromJson(json);
  Map<String, dynamic> toJson() => _$StopsToJson(this);
}

@JsonSerializable()
class Pickup {
  int id;
  String name;
  String truck_plates;
  String description;
  String date;
  bool completed;

  Pickup({
    required this.id,
    required this.name,
    required this.truck_plates,
    required this.description,
    required this.date,
    required this.completed,
  });


  factory Pickup.fromJson(Map<String, dynamic> json) => _$PickupFromJson(json);
  Map<String, dynamic> toJson() => _$PickupToJson(this);
}