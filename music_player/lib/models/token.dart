import 'package:json_annotation/json_annotation.dart';
import 'package:music_player/models/user.dart';

part 'token.g.dart';

@JsonSerializable()
class Token {
  @JsonKey(name: "accessToken")
  late String accessToken;

  @JsonKey(name: "user")
  late User user;

  Token({required accessToken, required user});

  factory Token.fromJson(Map<String, dynamic> json) => _$TokenFromJson(json);

  Map<String, dynamic> toJson() => _$TokenToJson(this);
}
