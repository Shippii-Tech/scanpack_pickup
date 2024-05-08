import 'package:dio/dio.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:scanpack_pickup/services/store.dart';

part 'stop.g.dart';

class UseStop extends Store{
  Future save (FormData payload) async {
    return await send('/stops/complete/{stop}', payload);
  }
}

@JsonSerializable()
class Stop {
  String signature;

  Stop({
    required this.signature,
  });

  factory Stop.fromJson(Map<String, dynamic> json) => _$StopFromJson(json);
  Map<String, dynamic> toJson() => _$StopToJson(this);
}