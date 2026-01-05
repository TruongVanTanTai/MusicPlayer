import 'package:flutter/material.dart';
import 'package:music_player/models/token.dart';
import 'package:music_player/models/user.dart';
import 'package:music_player/services/user-service.dart';
import 'package:music_player/views/songs-page.dart';

class UserDetailPage extends StatefulWidget {
  Token token;

  UserDetailPage({super.key, required this.token});

  @override
  State<UserDetailPage> createState() => _UserDetailPageState();
}

class _UserDetailPageState extends State<UserDetailPage> {
  late UserService userService;
  late Future<User?> user;

  @override
  void initState() {
    super.initState();
    userService = UserService();
    user = userService.getUserById(widget.token);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        drawer: Drawer(
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              const DrawerHeader(
                decoration: BoxDecoration(color: Color(0xFF1DB954)),
                child: Expanded(
                  child: Center(
                    child: Text(
                      'Umac 🎧',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 24,
                      ),
                    ),
                  ),
                ),
              ),
              ListTile(
                title: const Text('Thông tin cá nhân'),
                onTap: () {
                  Navigator.pop(context);
                },
              ),
              ListTile(
                title: const Text('Trình phát nhạc'),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => SongsPage(token: widget.token),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
        appBar: AppBar(
          title: Text(
            'Umac 🎧',
            style: TextStyle(
              color: Color(0xFF1DB954),
              fontWeight: FontWeight.bold,
            ),
          ),
          centerTitle: true,
        ),
        body: UserDetail(),
      ),
    );
  }

  Widget UserDetail() {
    return FutureBuilder(
      future: user,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          if (snapshot.hasError) {
            return Center(child: Text('Lỗi: ${snapshot.error}'));
          }
          if (snapshot.data == null) {
            return Center(child: Text('Lấy thông tin cá nhân thất bại'));
          }
          return UserInformation(snapshot.data!);
        } else {
          return Expanded(child: Center(child: CircularProgressIndicator()));
        }
      },
    );
  }

  Widget UserInformation(User user) {
    return Container(
      padding: EdgeInsets.all(24),
      child: ListView(
        children: [
          SizedBox(height: 24),
          Text(
            user.name,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18,
              color: Color(0xFF1DB954),
            ),
          ),
          SizedBox(height: 4),
          Text(
            '@nickname: ${user.nickname}',
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.grey),
          ),
          Divider(height: 100),
          Text('Id: ${user.id}'),
          SizedBox(height: 24),
          Text('Email: ${user.email}'),
          SizedBox(height: 24),
          Text('Số điện thoại: ${user.phoneNumber}'),
          SizedBox(height: 24),
          Text('Tuổi: ${user.age}'),
          SizedBox(height: 24),
          Text('Giới tính: ${user.isMale ? 'Nam' : 'Nữ'}'),
          SizedBox(height: 24),
          Text('Địa chỉ: ${user.address}'),
        ],
      ),
    );
  }
}
