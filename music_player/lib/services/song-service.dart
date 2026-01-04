import 'package:dio/dio.dart';
import 'package:music_player/models/song.dart';

class SongService {
  Future<List<Song>?> getSongs(String accessToken) async {
    var headers = {
      'Content-Type': 'text/plain',
      'Authorization': 'Bearer ' + accessToken,
    };

    var dio = Dio();
    try {
      var response = await dio.get(
        "http://localhost:3000/660/songs",
        options: Options(headers: headers),
      );
      if (response.statusCode == 200) {
        List songs = response.data;
        return songs.map((json) => Song.fromJson(json)).toList();
      } else {
        return null;
      }
    } on DioException catch (e) {
      return null;
    }
  }
}
