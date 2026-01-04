// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'token.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Token _$TokenFromJson(Map<String, dynamic> json) => Token(
  accessToken: json['accessToken'] as String,
  user: User.fromJson(json['user'] as Map<String, dynamic>),
);

Map<String, dynamic> _$TokenToJson(Token instance) => <String, dynamic>{
  'accessToken': instance.accessToken,
  'user': instance.user,
};
