import 'package:json_annotation/json_annotation.dart';

part 'song.g.dart';

@JsonSerializable()
class Song {
  @JsonKey(name: "id")
  late int id;

  @JsonKey(name: "name")
  late String name;

  @JsonKey(name: "singer")
  late String singer;

  @JsonKey(name: "source")
  late String source;

  @JsonKey(name: "image")
  late String image;

  Song({
    required this.id,
    required this.name,
    required this.singer,
    required this.source,
    required this.image,
  });

  factory Song.fromJson(Map<String, dynamic> json) => _$SongFromJson(json);

  Map<String, dynamic> toJson() => _$SongToJson(this);
}
