import 'package:dio/dio.dart';
import 'package:music_player/models/token.dart';
import 'package:music_player/models/user.dart';

class Auth {
  Future<Token?> register(User user) async {
    var headers = {'Content-Type': "application/json"};
    var data = user.toJson();

    var dio = Dio();
    try {
      var response = await dio.request(
        "http://localhost:3000/register",
        options: Options(method: 'POST', headers: headers),
        data: data,
      );

      if (response.statusCode == 201) {
        return Token.fromJson(response.data);
      } else {
        return null;
      }
    } on DioException catch (e) {
      return null;
    }
  }
}
