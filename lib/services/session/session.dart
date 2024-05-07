import 'package:json_annotation/json_annotation.dart';
import 'package:scanpack_pickup/services/store.dart';

part 'session.g.dart';

class UseSession extends Store{
  Future add (Session session) async {
    return await send('/shipments', (_$SessionToJson(session)));
  }
}

@JsonSerializable()
class Session {
  List<String> pallets;
  String session;

  Session({
    required this.pallets,
    required this.session
  });


  factory Session.fromJson(Map<String, dynamic> json) => _$SessionFromJson(json);
  Map<String, dynamic> toJson() => _$SessionToJson(this);
}