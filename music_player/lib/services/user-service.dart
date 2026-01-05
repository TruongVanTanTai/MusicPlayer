import 'package:dio/dio.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:music_player/models/token.dart';
import 'package:music_player/models/user.dart';

class UserService {
  Future<User?> getUserById(Token token) async {
    Map<String, dynamic> tokenJson = JwtDecoder.decode(token.accessToken);
    int id = int.parse(tokenJson['sub']);

    var headers = {
      'Content-Type': 'text/plain',
      'Authorization': 'Bearer ${token.accessToken}',
    };

    var dio = Dio();
    try {
      var response = await dio.request(
        'http://localhost:3000/600/users/${id}',
        options: Options(method: 'GET', headers: headers),
      );
      if (response.statusCode == 200) {
        return User.fromJson(response.data);
      } else {
        return null;
      }
    } on DioException catch (e) {
      return null;
    }
  }
}
