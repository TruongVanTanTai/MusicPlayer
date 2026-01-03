import 'package:json_annotation/json_annotation.dart';

part 'user.g.dart';

@JsonSerializable()
class User {
  @JsonKey(name: "id")
  late int? id;

  @JsonKey(name: "name")
  late String name;

  @JsonKey(name: "nickname")
  late String nickname;

  @JsonKey(name: "age")
  late int age;

  @JsonKey(name: "isMale")
  late bool isMale;

  @JsonKey(name: "address")
  late String address;

  @JsonKey(name: "phoneNumber")
  late String phoneNumber;

  @JsonKey(name: "email")
  late String email;

  @JsonKey(name: "password")
  late String password;

  User({
    this.id,
    required this.name,
    required this.nickname,
    required this.age,
    required this.isMale,
    required this.address,
    required this.phoneNumber,
    required this.email,
    required this.password,
  });

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);

  Map<String, dynamic> toJson() => _$UserToJson(this);
}
