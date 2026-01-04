// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

User _$UserFromJson(Map<String, dynamic> json) => User(
  id: (json['id'] as num?)?.toInt(),
  name: json['name'] as String,
  nickname: json['nickname'] as String,
  age: (json['age'] as num).toInt(),
  isMale: json['isMale'] as bool,
  address: json['address'] as String,
  phoneNumber: json['phoneNumber'] as String,
  email: json['email'] as String,
  password: json['password'] as String?,
);

Map<String, dynamic> _$UserToJson(User instance) => <String, dynamic>{
  'id': instance.id,
  'name': instance.name,
  'nickname': instance.nickname,
  'age': instance.age,
  'isMale': instance.isMale,
  'address': instance.address,
  'phoneNumber': instance.phoneNumber,
  'email': instance.email,
  'password': instance.password,
};
