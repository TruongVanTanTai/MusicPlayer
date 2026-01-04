import 'package:dio/dio.dart';
import 'package:music_player/models/request/loginRequest.dart';
import 'package:music_player/models/token.dart';
import 'package:music_player/models/user.dart';

class AuthService {
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

  Future<Token?> login(LoginRequest loginRequest) async {
    var headers = {'Content-Type': "application/json"};
    var data = {"email": loginRequest.email, "password": loginRequest.password};

    var dio = Dio();
    try {
      var response = await dio.request(
        "http://localhost:3000/login",
        options: Options(method: 'POST', headers: headers),
        data: data,
      );

      if (response.statusCode == 200) {
        return Token.fromJson(response.data);
      } else {
        return null;
      }
    } on DioException catch (e) {
      return null;
    }
  }
}
